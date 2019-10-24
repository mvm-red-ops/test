public class OrderLineNumberAssignment
{
    public string ScheduleId {get;set;}   
    
    public OrderLineNumberAssignment()
    {
    
    
    }
    
    public void AssignOLNumber()
    {
        try
        {
            string starttime;
            list<string> startsplit = new list<string>();
            string endtime;
            list<string> endsplit = new list<string>();
            string daysallowed;
            
            list<string> ratesplit = new list<string>();
            
            
            List<Schedules__c> ScheduleToUpdate = new List<Schedules__c>();

            for(Schedules__c sch: [SELECT id, OrderLineNumber__c, Days_Allowed__c, Start_Time__c, End_Time__c, Rate__c 
                                   FROM Schedules__c 
                                   WHERE id =:'a08C000000GT9Gw' AND Start_Time__c!=NULL AND  End_Time__c!=NULL AND Days_Allowed__c !=NULL AND Rate__c !=NULL ])
            {
            
            
                startsplit = sch.Start_Time__c.split(':', 2); 
                endsplit = sch.End_Time__c.split(':', 2); 
    
                //Find start 3 digit  
                if(sch.Start_Time__c.contains('P'))
                {
                    starttime = string.valueof(integer.valueof(startsplit[0]) + 12);
                    if(startsplit[1].contains('3'))
                    {
                        starttime += '3';
                    }
                    else
                    {
                        starttime += '0';    
                    } 
                }
                else
                {
                    starttime = startsplit[0];  
                    if(startsplit[1].contains('3'))
                    {
                        starttime += '3';
                    }
                    else
                    {
                        starttime += '0';    
                    }   
                }  
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.info,'START TIME: ' +starttime));
                system.debug('FIRST PART: ' +starttime);
                
                //Find end 3 digit   
                if(sch.End_Time__c.contains('P'))
                {
                    //integer intend = integer.valueof(endsplit[0]) + 12 ;
                    endtime = string.valueof(integer.valueof(endsplit[0]) + 12);
                    if(endsplit[1].contains('3'))
                    {
                        endtime += '3';
                    }
                    else
                    {
                        endtime += '0';    
                    } 
                }
                else
                {
                    endtime = endsplit[0];  
                    if(endsplit[1].contains('3'))
                    {
                        endtime += '3';
                    }
                    else
                    {
                        endtime += '0';    
                    }   
                }    
                ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.info,'END TIME: ' +endtime  ));
           
                //First digit 
                if(sch.Days_Allowed__c.contains('Mon') && sch.Days_Allowed__c.contains('Tue') && sch.Days_Allowed__c.contains('Wed') )
                {
                    daysallowed = '7';
                }
                else if(sch.Days_Allowed__c.contains('Mon') && sch.Days_Allowed__c.contains('Wed') )
                {
                    daysallowed = '6';    
                }
                else if(sch.Days_Allowed__c.contains('Tue') && sch.Days_Allowed__c.contains('Wed') )
                {
                    daysallowed = '5';    
                }  
                else if(sch.Days_Allowed__c.contains('Mon') && sch.Days_Allowed__c.contains('Tue') )
                {
                    daysallowed = '4';    
                } 
                else if(sch.Days_Allowed__c.contains('Wed') )
                {
                    daysallowed = '3';    
                }  
                else if(sch.Days_Allowed__c.contains('Tue') )
                {
                    daysallowed = '2';    
                }  
                else if(sch.Days_Allowed__c.contains('Mon') )
                {
                    daysallowed = '1';    
                }   
                else
                {
                    daysallowed = '0';    
                }
                //Second digt
                if(sch.Days_Allowed__c.contains('Thu') && sch.Days_Allowed__c.contains('Fri') )
                {
                    daysallowed += '3';
                }
                else if(sch.Days_Allowed__c.contains('Fri') )
                {
                    daysallowed += '2';    
                }
                else if(sch.Days_Allowed__c.contains('Thu') )
                {
                    daysallowed += '1';    
                }  
                else
                {
                    daysallowed += '0';    
                }
                //Third digit
                if(sch.Days_Allowed__c.contains('Sat') && sch.Days_Allowed__c.contains('Sun') )
                {
                    daysallowed += '3';
                }
                else if(sch.Days_Allowed__c.contains('Sat') )
                {
                    daysallowed += '2';    
                }
                else if(sch.Days_Allowed__c.contains('Sun') )
                {
                    daysallowed += '1';    
                }  
                else
                {
                    daysallowed += '0';    
                }
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.info,'DAYS ALLOWED: ' +daysallowed ));
                //system.debug('THIRD PART: ' +daysallowed );
                
			    string rating='';
				string spaceholders='';
				integer spacedifference =0;
    
                rating = string.valueof(integer.valueof(sch.Rate__c * 100)); 
                spacedifference = 9 - rating.length();
                for(integer i = 0; i < spacedifference; i++)
                {
                    spaceholders += '0';    
                }   
                
                string  newrating = spaceholders + rating;
    
                ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.info,'RATING: ' + newrating ));
       
                String TempNumber = starttime + endtime + daysallowed + newrating ; 
    
                ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.info,'Schedule Order Line Number: ' + TempNumber  ));
         
                ScheduleToUpdate.add(sch);
    
            }
            //update ScheduleToUpdate;
        } 
        catch(exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));          
        }               
    }    
}