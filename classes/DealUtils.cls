/**
 * DealUtils
 * @description Utils class for Deal-related classes (DoubleCheckReport, DealRevisions, DealHiatus, PrelogClearanceReport, etc.)
 */

public with sharing class DealUtils {

    public static List<SelectOption> ReturnCableSyndSOList() {
        List<SelectOption> CableSyndSOList = new List<SelectOption>();
        CableSyndSOList.add(new SelectOption('', 'Please Select'));
        CableSyndSOList.add(new SelectOption('Cable', 'Cable'));
        CableSyndSOList.add(new SelectOption('Syndication', 'Syndication'));
        CableSyndSOList.add(new SelectOption('PP', 'PP'));
        return CableSyndSOList;
    }

    public static List<SelectOption> ReturnDateLiteralSOList() {
        List<SelectOption> DateLiteralSOList = new List<SelectOption>();
        DateLiteralSOList.add(new SelectOption('', 'Please Select'));
        DateLiteralSOList.add(new SelectOption('Custom', 'Custom'));
        DateLiteralSOList.add(new SelectOption('Fiscal Year', 'Fiscal Year', true));
        DateLiteralSOList.add(new SelectOption('Current FY', 'Current FY'));
        DateLiteralSOList.add(new SelectOption('Previous FY', 'Previous FY'));
        DateLiteralSOList.add(new SelectOption('Previous 2 FY', 'Previous 2 FY'));
        DateLiteralSOList.add(new SelectOption('2 FY Ago', '2 FY Ago'));
        DateLiteralSOList.add(new SelectOption('Current And Previous FY', 'Current And Previous FY'));
        DateLiteralSOList.add(new SelectOption('Current And Previous 2 FY', 'Current And Previous 2 FY'));
        DateLiteralSOList.add(new SelectOption('Fiscal Quarter', 'Fiscal Quarter', true));
        DateLiteralSOList.add(new SelectOption('Current FQ', 'Current FQ'));
        DateLiteralSOList.add(new SelectOption('Current And Next FQ', 'Current And Next FQ'));
        DateLiteralSOList.add(new SelectOption('Current And Previous FQ', 'Current And Previous FQ'));
        DateLiteralSOList.add(new SelectOption('Next FQ', 'Next FQ'));
        DateLiteralSOList.add(new SelectOption('Previous FQ', 'Previous FQ'));
        DateLiteralSOList.add(new SelectOption('Current And Next 3 FQ', 'Current And Next 3 FQ'));
        DateLiteralSOList.add(new SelectOption('Fiscal Period', 'Fiscal Period', true));
        DateLiteralSOList.add(new SelectOption('Last FP', 'Last FP'));
        DateLiteralSOList.add(new SelectOption('This FP', 'This FP'));
        DateLiteralSOList.add(new SelectOption('Next FP', 'Next FP'));
        DateLiteralSOList.add(new SelectOption('Current And Previous FP', 'Current And Previous FP'));
        DateLiteralSOList.add(new SelectOption('Current And Next FP', 'Current And Next FP'));
        DateLiteralSOList.add(new SelectOption('Fiscal Week', 'Fiscal Week', true));
        DateLiteralSOList.add(new SelectOption('Last FW', 'Last FW'));
        DateLiteralSOList.add(new SelectOption('This FW', 'This FW'));
        DateLiteralSOList.add(new SelectOption('Next FW', 'Next FW'));
        DateLiteralSOList.add(new SelectOption('Calendar Year', 'Calendar Year', true));
        DateLiteralSOList.add(new SelectOption('Current CY', 'Current CY'));
        DateLiteralSOList.add(new SelectOption('Previous CY', 'Previous CY'));
        DateLiteralSOList.add(new SelectOption('Previous 2 CY', 'Previous 2 CY'));
        DateLiteralSOList.add(new SelectOption('2 CY Ago', '2 CY Ago'));
        DateLiteralSOList.add(new SelectOption('Next CY', 'Next CY'));
        DateLiteralSOList.add(new SelectOption('Current And Previous CY', 'Current And Previous CY'));
        DateLiteralSOList.add(new SelectOption('Current And Previous 2 CY', 'Current And Previous 2 CY'));
        DateLiteralSOList.add(new SelectOption('Current And Next CY', 'Current And Next CY'));
        DateLiteralSOList.add(new SelectOption('Current Quarter', 'Current Quarter', true));
        DateLiteralSOList.add(new SelectOption('Current CQ', 'Current CQ'));
        DateLiteralSOList.add(new SelectOption('Current And Next CQ', 'Current And Next CQ'));
        DateLiteralSOList.add(new SelectOption('Current And Previous CQ', 'Current And Previous CQ'));
        DateLiteralSOList.add(new SelectOption('Next CQ', 'Next CQ'));
        DateLiteralSOList.add(new SelectOption('Previous CQ', 'Previous CQ'));
        DateLiteralSOList.add(new SelectOption('Current And Next 3 CQ', 'Current And Next 3 CQ'));
        DateLiteralSOList.add(new SelectOption('Calendar Month', 'Calendar Month', true));
        DateLiteralSOList.add(new SelectOption('Last Month', 'Last Month'));
        DateLiteralSOList.add(new SelectOption('This Month', 'This Month'));
        DateLiteralSOList.add(new SelectOption('Next Month', 'Next Month'));
        DateLiteralSOList.add(new SelectOption('Current And Last Month', 'Current And Last Month'));
        DateLiteralSOList.add(new SelectOption('Current And Next Month', 'Current And Next Month'));
        DateLiteralSOList.add(new SelectOption('Calendar Week', 'Calendar Week', true));
        DateLiteralSOList.add(new SelectOption('Last Week', 'Last Week'));
        DateLiteralSOList.add(new SelectOption('This Week', 'This Week'));
        DateLiteralSOList.add(new SelectOption('Next Week', 'Next Week'));
        DateLiteralSOList.add(new SelectOption('Day', 'Day', true));
        DateLiteralSOList.add(new SelectOption('Yesterday', 'Yesterday'));
        DateLiteralSOList.add(new SelectOption('Today', 'Today'));
        DateLiteralSOList.add(new SelectOption('Tomorrow', 'Tomorrow'));
        DateLiteralSOList.add(new SelectOption('Last 7 Days', 'Last 7 Days'));
        DateLiteralSOList.add(new SelectOption('Last 30 Days', 'Last 30 Days'));
        DateLiteralSOList.add(new SelectOption('Last 60 Days', 'Last 60 Days'));
        DateLiteralSOList.add(new SelectOption('Last 90 Days', 'Last 90 Days'));
        DateLiteralSOList.add(new SelectOption('Last 120 Days', 'Last 120 Days'));
        DateLiteralSOList.add(new SelectOption('Next 7 Days', 'Next 7 Days'));
        DateLiteralSOList.add(new SelectOption('Next 30 Days', 'Next 30 Days'));
        DateLiteralSOList.add(new SelectOption('Next 60 Days', 'Next 60 Days'));
        DateLiteralSOList.add(new SelectOption('Next 90 Days', 'Next 90 Days'));
        DateLiteralSOList.add(new SelectOption('Next 120 Days', 'Next 120 Days'));
        return DateLiteralSOList;
    }

    public static List<SelectOption> ReturnTeamOptions() {
        return new List<SelectOption>{
                new SelectOption('', 'Select a Team'),
                new SelectOption('Blue', 'Blue'),
                new SelectOption('Red', 'Red'),
                new SelectOption('Yellow', 'Yellow'),
                new SelectOption('Onyx', 'Onyx')
        };
    }

    public static Integer ReturnNumber(String pMonth) {
        if (pMonth.toLowerCase() == 'jan') {
            return 1;
        } else if (pMonth.toLowerCase() == 'feb') {
            return 2;
        } else if (pMonth.toLowerCase() == 'mar') {
            return 3;
        } else if (pMonth.toLowerCase() == 'apr') {
            return 4;
        } else if (pMonth.toLowerCase() == 'may') {
            return 5;
        } else if (pMonth.toLowerCase() == 'jun') {
            return 6;
        } else if (pMonth.toLowerCase() == 'jul') {
            return 7;
        } else if (pMonth.toLowerCase() == 'aug') {
            return 8;
        } else if (pMonth.toLowerCase() == 'sep') {
            return 9;
        } else if (pMonth.toLowerCase() == 'oct') {
            return 10;
        } else if (pMonth.toLowerCase() == 'nov') {
            return 11;
        } else {
            return 12;
        }
    }

    public static String ReturnStringDate(Date pDate) {
        String pString = String.valueOf(pDate.year()) + '-';
        if (pDate.month() < 10) {
            pString += '0' + String.valueOf(pDate.month()) + '-';
        } else {
            pString += String.valueOf(pDate.month()) + '-';
        }
        if (pDate.day() < 10) {
            pString += '0' + String.valueOf(pDate.day());
        } else {
            pString += String.valueOf(pDate.day());
        }
        return pString;
    }

    public static String formatDatetime(Datetime d) {
        return d.format('yyyy-MM-dd') + 'T' + d.format('HH:mm:ssXXX');
    }

    public static List<SelectOption> createHiatusTimeSelectList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', ''));
        for (Integer i = 1; i < 12; i++) {
            String a = String.valueOf(i).leftPad(2, '0') + ':00A';
            String b = String.valueOf(i).leftPad(2, '0') + ':30A';
            options.add(new SelectOption(a, a));
            options.add(new SelectOption(b, b));
        }
        options.add(new SelectOption('12:00P', '12:00P'));
        options.add(new SelectOption('12:30P', '12:30P'));
        for (Integer i = 1; i < 12; i++) {
            String a = String.valueOf(i).leftPad(2, '0') + ':00P';
            String b = String.valueOf(i).leftPad(2, '0') + ':30P';
            options.add(new SelectOption(a, a));
            options.add(new SelectOption(b, b));
        }
        options.add(new SelectOption('12:00A', '12:00A'));
        options.add(new SelectOption('12:30A', '12:30A'));
        return options;
    }

    public static void handleException(Exception e) {
        ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR, 'Message: ' + e.getMessage()));
        ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR, 'LineNumber: ' + e.getLineNumber()));
        ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR, 'TypeName: ' + e.getTypeName()));
        ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR, 'Stack Trace: ' + e.getStackTraceString()));
    }

    public static Map<String, CalendarPeriod> getCustomCalendarPeriods(DateSelector dates) {
        return new Map<String, CalendarPeriod>{
                'Current FY' => new FiscalYear(0, 0, dates),
                'Previous FY' => new FiscalYear(-1, -1, dates),
                'Previous 2 FY' => new FiscalYear(-2, -1, dates),
                '2 FY Ago' => new FiscalYear(-2, -2, dates),
                'Current And Previous FY' => new FiscalYear(-1, 0, dates),
                'Current And Previous 2 FY' => new FiscalYear(-2, 0, dates),
                'Current FQ' => new FiscalQuarter(0, 0, dates),
                'Current And Next FQ' => new FiscalQuarter(0, 1, dates),
                'Current And Previous FQ' => new FiscalQuarter(-1, 0, dates),
                'Next FQ' => new FiscalQuarter(1, 1, dates),
                'Previous FQ' => new FiscalQuarter(-1, -1, dates),
                'Current And Next 3 FQ' => new FiscalQuarter(0, 3, dates),
                'Last FP' => new FiscalMonth(-1, -1, dates),
                'This FP' => new FiscalMonth(0, 0, dates),
                'Next FP' => new FiscalMonth(1, 1, dates),
                'Current And Previous FP' => new FiscalMonth(-1, 0, dates),
                'Current And Next FP' => new FiscalMonth(0, 1, dates),
                'Last FW' => new FiscalWeek(-1, -1, dates),
                'This FW' => new FiscalWeek(0, 0, dates),
                'Next FW' => new FiscalWeek(1, 1, dates),
                'Current CY' => new CalendarYear(0, 0, dates),
                'Previous CY' => new CalendarYear(-1, -1, dates),
                'Previous 2 CY' => new CalendarYear(-2, -1, dates),
                '2 CY Ago' => new CalendarYear(-2, -2, dates),
                'Next CY' => new CalendarYear(1, 1, dates),
                'Current And Previous CY' => new CalendarYear(-1, 0, dates),
                'Current And Previous 2 CY' => new CalendarYear(-2, 0, dates),
                'Current And Next CY' => new CalendarYear(0, 1, dates),
                'Current CQ' => new CalendarQuarter(0, 0, dates),
                'Current And Next CQ' => new CalendarQuarter(0, 1, dates),
                'Current And Previous CQ' => new CalendarQuarter(-1, 0, dates),
                'Next CQ' => new CalendarQuarter(1, 1, dates),
                'Previous CQ' => new CalendarQuarter(-1, -1, dates),
                'Current And Next 3 CQ' => new CalendarQuarter(0, 3, dates),
                'Last Month' => new CalendarMonth(-1, -1, dates),
                'This Month' => new CalendarMonth(0, 0, dates),
                'Next Month' => new CalendarMonth(1, 1, dates),
                'Current And Last Month' => new CalendarMonth(-1, 0, dates),
                'Current And Next Month' => new CalendarMonth(0, 1, dates),
                'Last Week' => new CalendarWeek(-1, -1, dates),
                'This Week' => new CalendarWeek(0, 0, dates),
                'Next Week' => new CalendarWeek(1, 1, dates),
                'Yesterday' => new CalendarDay(-1, -1, dates),
                'Today' => new CalendarDay(0, 0, dates),
                'Tomorrow' => new CalendarDay(1, 1, dates),
                'Last 7 Days' => new CalendarDay(-7, 0, dates),
                'Last 30 Days' => new CalendarDay(-30, 0, dates),
                'Last 60 Days' => new CalendarDay(-60, 0, dates),
                'Last 90 Days' => new CalendarDay(-90, 0, dates),
                'Last 120 Days' => new CalendarDay(-120, 0, dates),
                'Next 7 Days' => new CalendarDay(0, 7, dates),
                'Next 30 Days' => new CalendarDay(0, 30, dates),
                'Next 60 Days' => new CalendarDay(0, 60, dates),
                'Next 90 Days' => new CalendarDay(0, 90, dates),
                'Next 120 Days' => new CalendarDay(0, 120, dates)
        };
    }
}