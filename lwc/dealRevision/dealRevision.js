import {api, LightningElement, track} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import searchDeals from '@salesforce/apex/DealRevisionLightningController.searchDeals';
import getDealSchedules from '@salesforce/apex/DealRevisionLightningController.getDealSchedules';
import getSchedulePicklistOptions from '@salesforce/apex/DealRevisionLightningController.getSchedulePicklistOptions';
import updateSchedulesApex from '@salesforce/apex/DealRevisionLightningController.updateSchedules';
import getRange from '@salesforce/apex/DealRevisionLightningController.getRangeDates';
import HideHeader from '@salesforce/resourceUrl/hideHeader';
import {loadStyle} from 'lightning/platformResourceLoader';
import SelectOptions from './selectOptions';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

/**
 * @typedef Deal__c
 * @property {String} Id
 * @property {ScheduleGroup[]} [groups]
 */

/**
 * The API name is misleading, this is ONE schedule
 * @typedef Schedules__c
 * @property {String} Id
 * @property {String} DaysAllowedFormula__c
 * @property {String} Start_End_Time__c
 * @property {Number} Units_Available__c
 * @property {Number} Rate__c
 * @property {String} Week__c
 */

/**
 * @typedef ScheduleGroup
 * @property {Schedules__c[]} schedules
 * @property {String} index
 * @property {{label: string, selected: boolean}[]} days
 * @property {String} startEndTime
 * @property {Number} rate
 * @property {Date} week
 * @property {Number} unitsAvailable
 * @property {String} cap
 * @property {String} networks
 * @property {String} daypart
 * @property {String} startTime
 * @property {String} endTime
 * @property {String} daysAllowed
 * @property {Number} maxPerDay
 */

export default class DealRevision extends NavigationMixin(LightningElement) {

    @track loading = false;
    /**
     * @type Deal__c[]
     */
    @track deals;
    @track SelectOptions = SelectOptions;
    @track page = 0;
    @track totalDealCount;
    @track lastQuery;
    @api readonly;
    /**
     * @type Deal__c
     */
    @track _selectedDeal;
    @track schedulesLoading;
    @track scheduleWeeks = [];
    @track selectedScheduleGroup;

    @track rangeSelected = false;

    @track scheduleTabs = [
        {label: 'LTC', color: 'red', massEditDates: true},
        {label: 'Rate', color: '#FFFF66', foreground: 'black', rate: true},
        {label: 'Extend', color: '#7B68EE', massEditDates: true},
        {label: 'Frequency', color: '#66CCCC', massEditDates: true,  units: true, column: {label: 'Units Available', field: 'unitsAvailable', type: 'number'}},
        {label: 'Test', color: '#0099FF', massEditDates: true, test: true, column: {label: 'Test', field: 'test', type: 'checkbox'}},
        {label: 'Cap', color: '#AAAAAA', massEditDates: true, cap: true, column: {label: 'Cap', field: 'cap'}},
        {label: 'Daypart', color: '#FF851B'},
        {label: 'Hiatus', color: '#FF0000', hiatus: true},
        {label: 'Max Per Day', color: '#AAAAAA', massEditDates: true, maxperday: true, column: {label: 'Max Per Day', field: 'maxPerDay', type: 'number'}}
    ];

    @track capOptions;
    @track startOptions;
    @track endOptions;

    @track hiatusStartTime;
    @track hiatusEndTime;

    @track activeScheduleTab = this.scheduleTabs[0];

    @track fields = [
        {value: 'Name', link: 'Id', label: 'Deal Link', class: 'nowrap'},
        {value: 'ContactAccount__c', link: 'Contact__r.Account.Id', label: 'Agency'},
        {value: 'Program__r.Name', link: 'Program__r.Id', label: 'Program'},
        {value: 'Brands__r.Name', link: 'Brands__c', label: 'Brand'},
        {value: 'Contact__r.Name', link: 'Contact__r.Id', label: 'Contact'},
        {value: 'Campaign__c', label: 'Campaign'},
        {value: 'Network_Deal_Number__c', label: 'Network Deal', class: 'nowrap'},
        {value: 'Week_MIN_Field__c', label: 'Week Min', class: 'nowrap'},
        {value: 'Agency_Deal_Number__c', label: 'Agency Deal #', class: 'nowrap'},
        {value: 'Sum_of_Units_Available__c', label: 'Units Available', class: 'nowrap'},
        {value: 'Sum_of_Total_Dollars__c', label: 'Total Cost', class: 'nowrap', formatter: (value) => parseFloat(value).toLocaleString('us-US', { style: 'currency', currency: 'USD' })}
    ];

    renderedCallback() {
        if (!this.hasRendered) {
            this.hasRendered = true;
            loadStyle(this, HideHeader);
            this.createStyle();
            this.getSchedulePicklistOptions();
        }

        this.setScheduleTabColors();
    }

    createStyle() {
        const style = document.createElement('style');
        // language=css
        style.innerText = `
            .selected button {
                background-color: #47be47;
                color: white;
            }

            .selected button:hover {
                background-color: #3da43d;
                color: white;
            }

            .oneFlexipage {
                padding-bottom: 0;
            }

            .slds-input-has-icon .slds-input__icon {
                z-index: 0 !important;
            }

            .slds-datepicker.slds-dropdown.slds-dropdown_left {
                min-width: min-content;
            }
            
            c-modal .slds-modal__footer lightning-button .slds-button__icon {
                transform: translateY(-2px);
                margin-right: 0.35rem;
            }
            
            c-modal .slds-modal__footer lightning-button button {
                padding-left: 0.75rem;
                padding-right: 0.75rem;
            }
        `;
        this.template.querySelector('.container').appendChild(style);
    }
    
    @track hiatusTimeOptions = [
      {label: '', value: ''},
      {label: '01:00A', value: '01:00A'},
      {label: '01:30A', value: '01:30A'},
      {label: '02:00A', value: '02:00A'},
      {label: '02:30A', value: '02:30A'},
      {label: '03:00A', value: '03:00A'},
      {label: '03:30A', value: '03:30A'},
      {label: '04:00A', value: '04:00A'},
      {label: '04:30A', value: '04:30A'},
      {label: '05:00A', value: '05:00A'},
      {label: '05:30A', value: '05:30A'},
      {label: '06:00A', value: '06:00A'},
      {label: '06:30A', value: '06:30A'},
      {label: '07:00A', value: '07:00A'},
      {label: '07:30A', value: '07:30A'},
      {label: '08:00A', value: '08:00A'},
      {label: '08:30A', value: '08:30A'},
      {label: '09:00A', value: '09:00A'},
      {label: '09:30A', value: '09:30A'},
      {label: '10:00A', value: '10:00A'},
      {label: '10:30A', value: '10:30A'},
      {label: '11:00A', value: '11:00A'},
      {label: '11:30A', value: '11:30A'},
      {label: '12:00P', value: '12:00P'},
      {label: '12:30P', value: '12:30P'},
      {label: '01:00P', value: '01:00P'},
      {label: '01:30P', value: '01:30P'},
      {label: '02:00P', value: '02:00P'},
      {label: '02:30P', value: '02:30P'},
      {label: '03:00P', value: '03:00P'},
      {label: '03:30P', value: '03:30P'},
      {label: '04:00P', value: '04:00P'},
      {label: '04:30P', value: '04:30P'},
      {label: '05:00P', value: '05:00P'},
      {label: '05:30P', value: '05:30P'},
      {label: '06:00P', value: '06:00P'},
      {label: '06:30P', value: '06:30P'},
      {label: '07:00P', value: '07:00P'},
      {label: '07:30P', value: '07:30P'},
      {label: '08:00P', value: '08:00P'},
      {label: '08:30P', value: '08:30P'},
      {label: '09:00P', value: '09:00P'},
      {label: '09:30P', value: '09:30P'},
      {label: '10:00P', value: '10:00P'},
      {label: '10:30P', value: '10:30P'},
      {label: '11:00P', value: '11:00P'},
      {label: '11:30P', value: '11:30P'},
      {label: '12:00A', value: '12:00A'},
      {label: '12:30A', value: '12:30A'}
    ];

    async getSchedulePicklistOptions() {
        const values = JSON.parse(await getSchedulePicklistOptions({}));
        this.capOptions = values['Cap__c'];
        this.startOptions = values['Start_Time__c'];
        this.endOptions = values['End_Time__c'];
    }

    /**
     * @param {Deal__c[]} value
     * @returns {Promise<void>}
     */
    async setDeals(value) {
        if (!value) {
            this.deals = value;
            return;
        }
        this.deals = await Promise.all(value.map(async deal => {
            const existingDeal = (this.deals || []).find(d => d.Id === deal.Id) || {};
            let fields = [];
            for (let field of this.fields) {
                let value;
                let link;
                try {
                    value = this.getField(deal, field.value);
                    if (field.formatter && value !== undefined) value = field.formatter(value);
                    if (field.link) {
                        link = await this.generateLink(this.getField(deal, field.link));
                    }
                } catch (err) {
                    fields.push({});
                    continue;
                }
                const newField = {};
                Object.assign(newField, field);
                newField.value = value;
                newField.link = link;
                fields.push(newField);
            }
            return Object.assign({
                fields,
                link: await this.generateLink(deal.Id)
            }, deal);
        }));
    }

    getField(obj, fieldString) {
        let splitFields = fieldString.split('.');
        let invalid = false;
        while (splitFields.length > 0) {
            if (!obj[splitFields[0]] && splitFields.length > 1) {
                invalid = true;
                break;
            }
            obj = obj[splitFields[0]];
            splitFields.splice(0, 1);
        }
        if (invalid) throw 'not found';
        return obj;
    }

    generateLink(recordId) {
        return this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'view'
            }
        });
    }

    @api set colcount(value) {}
    get colcount() {
        return this.fields.length + 1;
    }

    get input() {
        return this.template.querySelector('input');
    }

    formatDateApex(date) {
        if (!date) return;
        date = new Date(date.replace(/-/g, '\/'));
        return [
            date.getFullYear(),
            (date.getMonth() + 1).toString().padStart(2, '0'),
            date.getDate().toString().padStart(2, '0')
        ].join('-');
    }

    async search(event, isPaginationSearch = false) {
        const value = this.input.value;
        if (value.length <= 2) {
            this.clearResults();
            this.loading = false;
            return;
        }

        let id = setTimeout(() => {}, 0);
        this.currentSearchId = id;
        this.loading = true;

        const getFieldValue = (field) => this.template.querySelector(`.filters [data-name="${field}"]`).value;
        const parseBoolean = (value) => value === undefined ? value : value === 'true';

        const params = {
            searchString: value,
            range: getFieldValue('range'),
            startString: this.formatDateApex(getFieldValue('from')),
            endString: this.formatDateApex(getFieldValue('to')),
            team: getFieldValue('team'),
            cableSyndication: getFieldValue('syndication'),
            barter: parseBoolean(getFieldValue('barter')),
            hideReconciled: parseBoolean(getFieldValue('reconciled')),
            page: isPaginationSearch ? this.page : 0
        };

        let error;
        const result = await searchDeals(params).catch(err => error = err);
        if (this.currentSearchId !== id) return;
        if (!isPaginationSearch) this.page = 0;
        this.loading = false;

        if (error) {
            console.error(error);
        }

        const { deals, count } = JSON.parse(result);

        this.setDeals(deals);
        this.totalDealCount = count;
    }

    updateRange(event) {
        const getFieldValue = (field) => this.template.querySelector(`.filters [data-name="${field}"]`).value;
        const range = getFieldValue('range');

        getRange({range: range}).then((data) => {
            if (data) {
                const setFieldValue = (field, value) => this.template.querySelector(`.filters [data-name="${field}"]`).value = value;
                setFieldValue('from', this.formatDateApex(data.from));
                setFieldValue('to', this.formatDateApex(data.to));
                this.rangeSelected = true;
            } else {
                this.rangeSelected = false;
            }
        });

        this.search(event);
    }

    clear() {
        this.input.value = '';
        this.clearResults();
    }

    clearResults() {
        this.setDeals(undefined);
        this.allSelected = false;
        clearTimeout(this.currentSearchId);
        this.currentSearchId = null;
    }

    @api set paginationText(value) {}
    get paginationText() {
        if (!this.deals) return '';
        const start = (this.page * 50) + 1;
        if (this.noNextPage && this.page === 0) {
            return `Showing ${this.totalDealCount} results`;
        }
        const end = this.noNextPage ? this.totalDealCount : start + 49;
        return `Showing ${start} - ${end} of ${this.totalDealCount} results`;
    }

    selectRow(event) {
        this.selectedDeal = this.deals.find(deal => deal.Id === event.currentTarget.parentElement.dataset.id);
        this.template.querySelector('c-modal').open();
    }

    deselectRow() {
        this.selectedDeal = undefined;
    }

    nextPage() {
        this.page++;
        this.search(null, true);
    }

    previousPage() {
        this.page--;
        this.search(null, true);
    }

    @api set noPreviousPage(value) {}
    get noPreviousPage() {
        return this.page === 0;
    }

    @api set noNextPage(value) {}
    get noNextPage() {
        return this.page === Math.floor(this.totalDealCount / 50);
    }

    @api set selectedDeal(value) {
        const find = (id) => this.template.querySelector(`td[data-id="${id}"] lightning-button-icon-stateful`);
        if (this.selectedDeal) find(this.selectedDeal.Id).selected = false;
        this._selectedDeal = value;
        if (value) {
            find(value.Id).selected = true;
            if (!value.groups) {
                this.schedulesLoading = true;
                this.getRelatedSchedules();
            }
        }
    }

    get selectedDeal() {
        return this._selectedDeal;
    }

    @api set rowIconName(value) {}
    get rowIconName() {
        return this.readonly ? 'utility:preview' : 'utility:edit';
    }

    setScheduleTabColors() {
      const tabs = this.template.querySelectorAll('.schedule-tab');
      tabs.forEach(tab => {
        tab.querySelector('.color').style.backgroundColor = tab.dataset.color;
      });
      if (tabs.length > 0 && !this.template.querySelector('.schedule-tab.active')) {
        this.selectScheduleTab({
          currentTarget: this.template.querySelector('.schedule-tab:first-child')
        });
      }

      this.template.querySelectorAll('.schedules-card td')
        .forEach(el => el.style.borderLeft = '0');

      this.template.querySelectorAll('.schedules-card td:first-child')
        .forEach(el => el.style.borderLeft = `3px solid ${this.activeScheduleTab.color}`);

      this.template.querySelectorAll('.schedules-card .day.selected')
        .forEach(el => {
          el.style.backgroundColor = this.activeScheduleTab.color;
          if (this.activeScheduleTab.foreground) {
            el.style.color = this.activeScheduleTab.foreground;
          } else {
            el.style.color = 'white';
          }
        });
    }

    selectScheduleTab(event) {
      this.template.querySelectorAll('.schedule-tab')
        .forEach(tab => tab.classList.remove('active'));
      event.currentTarget.classList.add('active');
      this.activeScheduleTab = this.scheduleTabs
        .find(tab => tab.label === event.currentTarget.dataset.label);
    }

    selectAllGroups(event) {
      this.template.querySelectorAll('input[name="select"]')
        .forEach(el => el.checked = event.currentTarget.checked);
    }

    updateAllDateInputs(event) {
      this.template.querySelectorAll('td.date-cell lightning-input')
        .forEach(el => el.value = event.currentTarget.value);
    }

    async getRelatedSchedules() {
        let { groups, dates } = await this.parseSchedules(
            await getDealSchedules({dealId: this.selectedDeal.Id})
                .catch(console.error)
        );
        this.selectedDeal = {... JSON.parse(JSON.stringify(this.selectedDeal)), groups};
        this.scheduleWeeks = dates;
        this.schedulesLoading = false;
    }

    /**
     * @param {Schedules__c[]} schedules
     * @return {Promise<{groups: ScheduleGroup[], dates: String[]}>}
     */
    async parseSchedules(schedules) {

        schedules = await Promise.all(
            schedules.map(async schedule => {
                schedule.link = await this.generateLink(schedule.Id);
                return schedule;
            })
        );

        let weeks = [];
        for (let schedule of schedules) {
            if (!weeks.includes(schedule.Week__c)) {
                weeks.push(schedule.Week__c);
            }
        }

        weeks = weeks.sort((a, b) => {
            return new Date(b) - new Date(a);
        }).reverse();

        const key = (schedule) => [schedule.DaysAllowedFormula__c, schedule.Start_End_Time__c, schedule.Rate__c].join(',');

        /**
         * Maps a key of days allowed, start/end times, and rate to maps of
         * week start date to schedule
         * @type {Map<String, Map<String, Schedules__c>>}
         */
        const rows = new Map();
        /**
         * @type {String[]}
         */
        const dates = [];
        for (let schedule of schedules) {
            /**
             * When creating a new row, set every week to empty string
             * so that they're displayed properly as empty <td>s in the UI
             * @type {Map<String, Schedules__c>}
             */
            let row = rows.get(key(schedule)) || new Map(weeks.map(week => [week, '']));
            row.set(schedule.Week__c, schedule);
            rows.set(key(schedule), row);

            if (!dates.includes(schedule.Week__c)) dates.push(schedule.Week__c);
        }

        return {
            dates,
            /**
             * Flatten the map out into a 2D array of schedules
             * @type ScheduleGroup[]
             */
            groups: Array.from(rows.keys()).map((rowKey, index) => {
                const row = rows.get(rowKey);
                const schedules = Array.from(row.values()).filter(schedule => schedule);
                if (!row || schedules.length === 0) return {
                    schedules: [],
                    Id: index
                };

                // All of the schedules should have the same values for
                // days allowed/rate/start-end time, so pick the first one
                const schedule = schedules[0];

                const days = this.parseDaysAllowed(schedule.DaysAllowedFormula__c);

                for (let key of row.keys()) {
                    if (row.get(key)) continue;
                    row.set(key, {
                        Id: key,
                        empty: true
                    });
                }

                return {
                    schedules: Array.from(row.values()),
                    rate: schedule.Rate__c,
                    startEndTime: schedule.Start_End_Time__c,
                    startTime: schedule.Start_Time__c,
                    endTime: schedule.End_Time__c,
                    units: schedule.Units_Available__c,
                    test: schedule.TEST__c,
                    cap: schedule.Cap__c,
                    maxPerDay: schedule.Max_Per_Day__c,
                    days,
                    fields: [
                        {label: 'Days Allowed', value: days, days: true},
                        {label: 'Start - End', value: schedule.Start_End_Time__c},
                        {label: 'Rate', value: schedule.Rate__c}
                    ]
                }
            }).sort((a, b) => b.Rate__c - a.Rate__c)
                .map((row, index) => {
                    row.index = index + 1;
                    return row;
                })
        };
    }

    parseDaysAllowed(daysAllowed) {
        daysAllowed = daysAllowed.split('');
        const get = (amount) => daysAllowed.splice(0, amount).join('');
        return [
            {label: 'M', selected: get(1) === 'M'},
            {label: 'Tu', selected: get(1) === 'T'},
            {label: 'W', selected: get(1) === 'W'},
            {label: 'Th', selected: get(1) === 'T'},
            {label: 'F', selected: get(1) === 'F'},
            {label: 'Sa', selected: get(2) === 'Sa'},
            {label: 'Su', selected: get(2) === 'Su'}
        ];
    }

    stringifyDaysAllowed(days) {
        const dayMap = {
            "M": "Mon",
            "Tu": "Tue",
            "W": "Wed",
            "Th": "Thu",
            "F": "Fri",
            "Sa": "Sat",
            "Su": "Sun"
        };
        let daysAllowed = [];
        for (let day of days) {
            if (day.selected) {
                daysAllowed.push(dayMap[day.label]);
            }
        }
        return daysAllowed.join(';');
    }

    updateDaysAllowed(event) {
        const groupIndex = event.currentTarget.dataset.index;
        const dayLabel = event.currentTarget.dataset.day;

        // TODO: no seriously, why does it be like it do
        this._selectedDeal = Object.assign({}, this._selectedDeal);
        this._selectedDeal.groups = this._selectedDeal.groups.map((group) => {
            let newGroup = Object.assign({}, group);
            if (Number(newGroup.index) === Number(groupIndex)) {
                newGroup.days = Object.assign([], newGroup.days).map((day) => {
                    let newDay = Object.assign({}, day);
                    if (newDay.label === dayLabel) {
                        newDay.selected = !newDay.selected;
                    }
                    return newDay;
                });
                newGroup.daysAllowed = this.stringifyDaysAllowed(newGroup.days);
            }
            return newGroup;
        });
    }

    updateField(event) {
      const groupIndex = event.currentTarget.dataset.index;
      const field = event.currentTarget.dataset.field;

      // TODO: no seriously, why does it be like it do
      this._selectedDeal = Object.assign({}, this._selectedDeal);
      this._selectedDeal.groups = this._selectedDeal.groups.map((group) => {
        let newGroup = Object.assign({}, group);
        if (Number(newGroup.index) === Number(groupIndex)) {
          newGroup[field] = event.target.value;
        }
        return newGroup;
      });
    }
    
    async updateSchedules() {
        const selectedRows = Array.from(this.template.querySelectorAll('.schedule-editor tr'))
            .map((el) => { return {
                    selected: el.querySelector('input[type="checkbox"]:checked') !== null,
                    element: el,
                    index: parseInt(el.dataset.index)
            }}).filter(row => row.selected);

        const indices = selectedRows.map(row => row.index);

        const scheduleGroups = JSON.parse(JSON.stringify(this.selectedDeal.groups))
            .filter(group => indices.includes(group.index))
            .map(group => {
                const element = selectedRows.find(row => row.index === group.index).element;
                if (this.activeScheduleTab.label !== 'Hiatus') {
                    group.week = this.formatDateApex(element.querySelector('.date-cell lightning-input').value);
                } else {
                    group.hiatusStartDate = this.formatDateApex(this.template.querySelector('.hiatus-start lightning-input').value);
                    group.hiatusEndDate = this.formatDateApex(this.template.querySelector('.hiatus-end lightning-input').value);
                    group.hiatusStartTime = this.hiatusStartTime;
                    group.hiatusEndTime = this.hiatusEndTime;
                }
                let column = this.activeScheduleTab.column;
                if (column) {
                    const cell = element.querySelector(`td[data-field="${column.field}"]`);
                    const columnElement = cell.querySelector('.input');
                    if (cell.dataset.type === 'checkbox') {
                        group[column.field] = columnElement.checked;
                    } else {
                        group[column.field] = columnElement.value;
                        if (column.type === 'number') {
                            group[column.field] = parseFloat(group[column.field]);
                        }
                    }
                }
                return group;
            });

        const selectedDeal = JSON.parse(JSON.stringify(this.selectedDeal));
        delete selectedDeal.groups;
        delete selectedDeal.link;
        delete selectedDeal.fields;
        scheduleGroups.forEach(group => {
            delete group.days;
            //delete group.index;
            delete group.fields;
        });
        
        console.log('groups', JSON.parse(JSON.stringify(scheduleGroups || {})));

        const doError = (e) => {
            console.error("An error occurred: " + e);
            const evt = new ShowToastEvent({
                title: "Updated Schedules",
                message: "Failed to update schedules. Errors: " + e,
                variant: 'error',
            });
            this.dispatchEvent(evt);
        };

        updateSchedulesApex({
            selectedDealId: this.selectedDeal.Id,
            groupsJSON: JSON.stringify(scheduleGroups),
            selectedTab: this.activeScheduleTab.label
        }).then((result) => {
            let res = JSON.parse(result);
            if (res.success) {
                console.log('result', JSON.stringify(res));
                let amt = JSON.parse(result).schedules.length + JSON.parse(result).inserted.length;
                const evt = new ShowToastEvent({
                    title: "Changed Schedules",
                    message: amt + " schedule(s) inserted/updated.",
                    variant: 'success',
                });
                this.dispatchEvent(evt);

                if (amt > 0) {
                    this.schedulesLoading = true;
                    this.getRelatedSchedules();
                }
            } else {
                doError(Object.values(res.errors));
            }
        }).catch((e) => {
            doError(e.body.message + " " + e.body.stackTrace);
        });
    }
}