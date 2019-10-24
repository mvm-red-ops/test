/**
 * FiscalYearSettingsSelector
 * @description
 */

public with sharing virtual class FiscalYearSettingsSelector {
    public virtual List<FiscalYearSettings> getFiscalYearSettings() {
        return [
                SELECT Id,
                       Name,
                       StartDate,
                       EndDate
                  FROM FiscalYearSettings
        ];
    }
}