/**
 *
 */

public with sharing abstract class CalendarPeriod {

    public DateSelector dates {get;set;}

    public Integer min {get;set;}
    public Integer max {get;set;}

    public Date weekStart {get;set;}
    public Date weekEnd {get;set;}

    public Integer thisYear;
    public Integer thisMonth;

    public CalendarPeriod(Integer mi, Integer ma, DateSelector da) {
        this.min = mi;
        this.max = ma;
        this.dates = da;
        this.thisYear = dates.today().year();
        this.thisMonth = dates.today().month();
    }

    public abstract Boolean setDates();
}