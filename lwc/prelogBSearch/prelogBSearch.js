import { LightningElement, track, wire } from 'lwc';
import getPrelogs from '@salesforce/apex/PrelogBSearch.getPrelogs';

const columns = [
    { label: 'Program Name', fieldName: 'Program_Name__c' },
    { label: 'Air Date', fieldName: 'AirDate__c', type: 'datetime' },
    { label: 'Schedule Id', fieldName: 'Schedule__c' }
];

export default class prelogBSearch extends LightningElement {
    @track prelogs = [];
    @track columns = columns;
    @track searchFields = [];

    connectedCallback() {
        let params = {payload: 'Test'};
        this.prelogs = this.getRecords(params);

        this.searchFields.push({});
    }

    handleFieldChange(event) {
        this.searchFields[0][event.target.name] = event.target.value;
    }

    search(){
        let paramsString = JSON.stringify(this.searchFields[0]);
        let params = {payload: paramsString};
        this.prelogs = this.getRecords(params);
    }

    async getRecords(params){
        console.log(params);
        let data = await getPrelogs(params);
        this.prelogs = data;
        console.log(this.prelogs);
    }
}