public class TargetWeeklyController {
    public list<selectoption> team{get;set;}
    public string selectedTeam {get;set;}
    public Schedules__c schedule {get;set;}
    public Deal__c deal {get;set;}
    Date fromDate;
    Date toDate;
    public List<Deal__c> dealList {get;set;}
    public List<Deal__c> dealList2 {get;set;}
    public List<Deal__c> dealList3 {get;set;}
    String programId;
    String agencyName;
    String conId;
    String brandId;
    String ownerId;
    
    /**public TargetWeeklyController (){
        team = new list<selectoption>();
        team.add(new selectoption('None','None'));
        team.add(new selectoption('Red','Red'));
        team.add(new selectoption('Blue','Blue'));
        team.add(new selectoption('Green','Green'));
        team.add(new selectoption('Orange','Orange'));
        deal = new Deal__c();
        deal.OwnerId = userInfo.getUserId();
        schedule = new Schedules__c();
        schedule.Day__c = system.today();
        schedule.Week__c = schedule.Day__c.addDays(-7);
        showReport();
    }
    public pagereference showReport(){
        if(schedule.Week__c != null){
            fromDate = schedule.Week__c;
        }
        if(schedule.Day__c != null){
            toDate = schedule.Day__c;
        }
        String dealQuery ='SELECT id, Name, ';
		        dealQuery += 'Week_MIN_Field__c,Sum_of_Total_Dollars__c, Status__c, Program__c, Brands__c, ';
		        dealQuery += 'Contact__c, Sum_of_Units_Available__c,ContactAccount__c, CreatedDate, Length__c, ';
		        dealQuery += 'Target__r.Status__c, Target__r.Name, Target__r.Comments__c, Target__r.To_Do__c, ';
		        dealQuery += 'Target__r.AE_LC__c, Target__r.AE_Status__c, Target__r.Status_Detail__c, ';
		        dealQuery += 'Target__r.LastModifiedDate, Target__r.LastModifiedById ';
		        dealQuery += 'FROM Deal__c WHERE Brands__r.Name != \'Budget\' AND Brands__r.Name != \'Availability\' ';
        
        system.debug('#### Dates:From '+fromDate+ 'TO '+toDate);
        
        if(selectedTeam != 'None' && selectedTeam != null){
            dealQuery += 'AND Program__r.Team__c like \'%' + selectedTeam + '%\' ';
        }
        if(deal.Program__c != null){
            programId = deal.Program__c;
            dealQuery += 'AND Program__c =: programId ';
        }
        if(deal.Client_Account__c != null){
            List<Account> acc = [SELECT id, Name from Account WHERE id =: deal.Client_Account__c];
            if(acc != null){
            	agencyName = acc.get(0).Name;
            	dealQuery += 'AND ContactAccount__c =: agencyName ';
            }
        }
        if(deal.Contact__c != null){
            conId = deal.Contact__c;
            dealQuery += 'AND Deal_Parent__r.Contact__c =: conId ';
        }
        if(deal.Brands__c != null){
            brandId = deal.Brands__c;
            dealQuery += 'AND Brands__c =: brandId ';
        }
        if(deal.OwnerId != null){
            ownerId = deal.OwnerId;
            dealQuery += 'AND OwnerId =: ownerId ';
        }
        if(schedule.TEST__c == true){
            dealQuery += 'AND Target__r.Status__c = \'Test\' ';
        }
        dealQuery += 'AND CreatedDate >: fromDate AND CreatedDate <: toDate ';
        getNewDealSection(dealQuery);
        getCanceledSection(dealQuery);
        getFollowUpSection(dealQuery);
        return null;
    }
    private void getNewDealSection(String q){        
        q += ' LIMIT 500';
        system.debug('### Query 1 : '+ q);
        dealList = Database.Query(q);
        system.debug('### Section 1 Records Found : '+dealList.size());
    }
    
    private void getCanceledSection(String q){
        q += 'AND  Status__c = \'Canceled\' ';
        //   AND LastModifiedDate >:fromDate AND LastModifiedDate <:toDate
        q += 'LIMIT 500 ';
        system.debug('### Query 2 : '+ q);
        dealList2 = Database.Query(q);
        system.debug('### Section 2 Records Found : '+dealList2.size());
    }
    private void getFollowUpSection(String q){
        q += 'AND Test_PP__c = true ';
        q += 'AND (Target__r.Status__c = \'Test\' OR Status__c = null) ';
        q += 'LIMIT 500 ';
        system.debug('### Query 3 : '+ q);
        dealList3 = Database.Query(q);
        system.debug('### Section 3 Records Found : '+dealList3.size());
    }
    public void save(){
        Set<Targets__c> targetSet = new Set<Targets__c>();
        for(Deal__c d : dealList){
            if(d.Target__r != null){
                Targets__c t = d.Target__r;
                targetSet.add(t);
            }
        }
        for(Deal__c d : dealList2){
            if(d.Target__r != null){
                Targets__c t = d.Target__r;
                targetSet.add(t);
            }
        }
        for(Deal__c d : dealList3){
            if(d.Target__r != null){
                Targets__c t = d.Target__r;
                targetSet.add(t);
            }
        }
        List<Targets__c> targets = new List<Targets__c>();
        targets.addAll(targetSet);
        if(targets.size()>0){
            update targets;
        }
        showReport();
    }**/
}