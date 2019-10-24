public class TennisScheduleController {
	public Schedules__c scheduleObj{set;get;} 
    public Schedules__c oldScheduleObj;
    String sDtY,sDtM,sDtD,eDtY,eDtM,eDtD;
    String fYear,fMonth;
    String activeFilter;
    public List<Deal__c> lstDealAccount{set;get;}
    
    public TennisScheduleController(){
    	sDtY = ApexPages.currentPage().getParameters().get('sDtY');
        sDtM = ApexPages.currentPage().getParameters().get('sDtM');
        sDtD = ApexPages.currentPage().getParameters().get('sDtD');
        
        eDtY = ApexPages.currentPage().getParameters().get('eDtY');
        eDtM = ApexPages.currentPage().getParameters().get('eDtM');
        eDtD = ApexPages.currentPage().getParameters().get('eDtD');
        
        fYear = ApexPages.currentPage().getParameters().get('fYear');
        fMonth = ApexPages.currentPage().getParameters().get('fMonth');
    
        activeFilter = ApexPages.currentPage().getParameters().get('activeFilter');
        
    
        String scheduleId = ApexPages.currentPage().getParameters().get('id');
        oldScheduleObj=null;
        
        scheduleObj = new Schedules__c();
        
        if(scheduleId!=null && scheduleId.trim().equals('')==false){
            oldScheduleObj = [select dealprogram__c,Deal_Parent__c,Units_Available__c,Rate__c,Week__c,Long_Form__c,status__c
                                    from Schedules__c where id=:scheduleId];
            scheduleObj = oldScheduleObj.clone(false,true);
        }else{
            String wY = ApexPages.currentPage().getParameters().get('wY');
            String wM = ApexPages.currentPage().getParameters().get('wM');
            String wD = ApexPages.currentPage().getParameters().get('wD');
            if(wY!=null && wM!=null && wD!=null){
            
        
                scheduleObj.Week__c =Date.newInstance(
                    Integer.valueOf(ApexPages.currentPage().getParameters().get('wy')),
                    Integer.valueOf(ApexPages.currentPage().getParameters().get('wm')),
                    Integer.valueOf(ApexPages.currentPage().getParameters().get('wd'))
                );
            }
            scheduleObj.Long_Form__c =ApexPages.currentPage().getParameters().get('lf');
            
            //scheduleObj.deal_Parent__c = 'a0A80000007Vy3E';
            scheduleObj.Units_Available__c =1;
            scheduleObj.status__c='Sold';
            scheduleObj.rate__c=0;
        }
        createList();
    }
    
    public void createList(){        
		try{
	        String wY = ApexPages.currentPage().getParameters().get('wY');
	        String wM = ApexPages.currentPage().getParameters().get('wM');
	        
	        integer iMonth = Integer.valueOf(wM);
	        integer iYear = Integer.valueOf(wY);
	        
	        Programs__c pg = [select id from Programs__c where name=:'Tennis PP'].get(0);
	        
	        lstDealAccount = [select id,ContactAccount__c, name,program__c,createdDate 
	                            from Deal__c 
	                            Where program__c =:pg.id
	                            and week_min_Field__c >=:Date.newInstance(iYear,iMonth,1)
	                            and week_min_Field__c <:Date.newInstance(iYear,iMonth+1,1)
	                            limit 1000
	                        ];    
	   	}
	   	catch(Exception e){}
    }
    //-----
    public PageReference replace(){
    	System.debug('*****'+scheduleObj.Deal_Parent__c);        
      //try{
        if(oldScheduleObj!=null){
            oldScheduleObj.status__c = 'Canceled';
            oldScheduleObj.recordTypeID = getRecodType(oldScheduleObj);
            update oldScheduleObj;
        }else{
            
        }
        //
        scheduleObj.recordTypeId = getRecodType(scheduleObj);
        insert scheduleObj;
        
        
        if(Integer.valueOf(sDtY)!=0){
            return new PageReference('/apex/TennisChanges?sDtY='+sDtY +'&sDtM='+sDtM+'&sDtD='+sDtD+'&eDtY='+eDtY +'&eDtM='+eDtM+'&eDtD='+eDtD+'&fYear='+fYear+'&fMonth='+fMonth+'&activeFilter='+activeFilter);
        }else{
            return new PageReference('/apex/TennisChanges?fYear='+fYear+'&fMonth='+fMonth+'&activeFilter='+activeFilter);
        } 
      //}catch(Exception e){return null;}
    }
    
    public void setDealAccount(){
        string dealAcc = ApexPages.currentPage().getParameters().get('accName');
        scheduleObj.Deal_Parent__c = dealAcc;
    }
    
    //Method getting RecordTypeId of Schedule
    private Id getRecordTypeId(String recordTypeName){
        List<RecordType> schRecType = [select id from RecordType where name=:recordTypeName and SObjectType = 'Schedules__c'];
        if(schRecType.size() > 0) {
            return schRecType.get(0).id;
        }
        return null;
    }

    //Method adds new Schedule
    public ID getRecodType(Schedules__c schObj) {
        try {
            List<Deal__c> deals = [select RecordTypeId, RecordType.Name from Deal__c where id =: schObj.Deal_Parent__c ];
            return getRecordTypeId(deals.get(0).RecordType.Name);
        }
        catch (Exception exp){}
        return null;
    }
}