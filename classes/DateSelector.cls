/**
 *
 */

public with sharing class DateSelector {

    public Date fakeToday {get;set;}

    public DateSelector() {}

    public DateSelector(Date fake) {
        this.fakeToday = fake;
    }

    public DateSelector setFakeToday(Date fake) {
        this.fakeToday = fake;
        return this;
    }

    public Date today() {
        if (fakeToday != null) {
            return fakeToday;
        }
        return Date.today();
    }

}