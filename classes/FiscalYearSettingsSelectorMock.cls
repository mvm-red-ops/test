/**
 * FiscalYearSettingsSelectorMock
 * @description
 */

public with sharing virtual class FiscalYearSettingsSelectorMock {
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