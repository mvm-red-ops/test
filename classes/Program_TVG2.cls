/**
 */

public with sharing class Program_TVG2 extends Program_TVG {

    public Program_TVG2(Programs__c program) {
        super(program);
    }

    public override void setPrelog(Contact c, Date d) {
        c.TVG2PreLogWeek__c = d;
    }

    public override void setPostlog(Contact c, Date d) {
        c.TVG2PostLogWeek__c = d;
    }
}