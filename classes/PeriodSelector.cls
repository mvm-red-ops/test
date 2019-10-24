/**
 * PeriodSelector
 * @description Selector for Period objects
 */

public with sharing virtual class PeriodSelector {

    public virtual List<Period> getWeekPeriods() {
        return [
                SELECT Id,
                       FiscalYearSettings.Name,
                       StartDate,
                       EndDate,
                       Number
                  FROM Period
                 WHERE Type = 'Week'
        ];
    }

    public virtual List<Period> getMonthPeriods() {
        return [
                SELECT Id,
                       FiscalYearSettings.Name,
                       StartDate,
                       EndDate,
                       Number,
                       PeriodLabel
                  FROM Period
                 WHERE Type = 'Month'
        ];
    }

    public virtual List<Period> getQuarterPeriods() {
        return [
                SELECT Id,
                       FiscalYearSettings.Name,
                       StartDate,
                       EndDate,
                       Number
                  FROM Period
                 WHERE Type = 'Quarter'
        ];
    }

    public virtual Period getQuarterPeriodFromDate(Date AnchorDate) {
        return [
                SELECT Id,
                       EndDate,
                       StartDate,
                       Type
                  FROM Period
                 WHERE Type = 'Quarter'
                   AND StartDate <= :AnchorDate
                   AND EndDate >= :AnchorDate
                 LIMIT 1
        ];
    }
}