Trigger OrderLineNumber on Schedules__c (before insert, before update) 
{
    string starttime;
    list<string> startsplit = new list<string>();
    string endtime;
    list<string> endsplit = new list<string>();
    string daysallowed;
    list<string> ratesplit = new list<string>();   
    Map<Id,string > oldschlist = new Map<Id, string >();
    
    Set<String> StartEndTimeSet = new Set<String>();
    for (integer i = 1; i <=12 ; i++)
    {
        for (integer j = 1; j <= 12; j++ )
        {
            StartEndTimeSet.add( string.valueOf(i) + 'A' + '-' + String.valueOf(j) + 'A');
            StartEndTimeSet.add( string.valueOf(i) + ':30A' + '-' + String.valueOf(j) + 'A');
            StartEndTimeSet.add( string.valueOf(i) + 'A' + '-' + String.valueOf(j) + ':30A');
            StartEndTimeSet.add( string.valueOf(i) + ':30A' + '-' + String.valueOf(j) + ':30A');
            
            StartEndTimeSet.add( string.valueOf(i) + 'A' + '-' + String.valueOf(j) + 'P');
            StartEndTimeSet.add( string.valueOf(i) + ':30A' + '-' + String.valueOf(j) + 'P');
            StartEndTimeSet.add( string.valueOf(i) + 'A' + '-' + String.valueOf(j) + ':30P');
            StartEndTimeSet.add( string.valueOf(i) + ':30A' + '-' + String.valueOf(j) + ':30P');
            
            StartEndTimeSet.add( string.valueOf(i) + 'P' + '-' + String.valueOf(j) + 'A');
            StartEndTimeSet.add( string.valueOf(i) + ':30P' + '-' + String.valueOf(j) + 'A');
            StartEndTimeSet.add( string.valueOf(i) + 'P' + '-' + String.valueOf(j) + ':30A');
            StartEndTimeSet.add( string.valueOf(i) + ':30P' + '-' + String.valueOf(j) + ':30A');
            
            StartEndTimeSet.add( string.valueOf(i) + 'P' + '-' + String.valueOf(j) + 'P');
            StartEndTimeSet.add( string.valueOf(i) + ':30P' + '-' + String.valueOf(j) + 'P');
            StartEndTimeSet.add( string.valueOf(i) + 'P' + '-' + String.valueOf(j) + ':30P');
            StartEndTimeSet.add( string.valueOf(i) + ':30p' + '-' + String.valueOf(j) + ':30P');
            
        }
    }
    
    Map<Id, String> ProgramStartTimeClockMap = new Map<Id, String>();
    Set<Id> DealIdSet = new Set<Id>();
    for (Schedules__c sch : Trigger.New)
    {
        if (sch.Deal_Parent__c != null)
        {
            DealIdSet.add(sch.Deal_Parent__c);
        }
    }
    if (DealIdSet.size() > 0)
    {
        for (Deal__c DealRecord : [select Id, Name, Program__c, Program__r.Clock_Start_Time__c from Deal__c where Id in: DealIdSet])
        {
            if (DealRecord.Program__r.Clock_Start_Time__c != null)
            {
                ProgramStartTimeClockMap.put(DealRecord.Id, DealRecord.Program__r.Clock_Start_Time__c);
            }
        }
    }
    
    for(Schedules__c sch: Trigger.new)
    {
        if(Trigger.isUpdate)
        {
            Schedules__c oldRecord = trigger.oldmap.get(sch.id);
            system.debug('Start Values - ' + sch.Start_Time__c + ' - ' + sch.End_Time__c + ' - ' + sch.Days_Allowed__c);
            if (sch.MGM_HD_Daypart__c != OldRecord.MGM_HD_Daypart__c && sch.MGM_HD_Daypart__c != null)
            {
                //Populate the StartTime, EndTime, and DaysAllowed fields using the CableDayParts field
                String CDP = sch.MGM_HD_DayPart__c.toUpperCase();
                if (CDP == 'ROS-')
                {
                    if (sch.Deal_Parent__c != null)
                    {
                        if (ProgramStartTimeClockMap.containsKey(sch.Deal_Parent__c))
                        {
                            if (ProgramStartTimeClockMap.get(sch.Deal_Parent__c) == '5AM')
                            {
                                sch.Start_Time__c = '05:00A';
                                sch.End_Time__c = '05:00A';
                            }
                        }
                    }
                    if (sch.Start_Time__c == null)
                    {
                        sch.Start_Time__c = '06:00A';
                    }
                    if (sch.End_Time__c == null)
                    {
                        sch.End_Time__c = '06:00A';
                    }
                    if (sch.Days_Allowed__c == null)
                    {
                        sch.Days_Allowed__c = 'Mon;Tue;Wed;Thu;Fri;Sat;Sun';
                    }
                }
                else
                {
                    for (string TimeCompare : StartEndTimeSet)
                    {
                        if (CDP.replace(' ','').contains(TimeCompare) && !CDP.replace(' ','').replace(TimeCompare,'').contains('1'))
                        {
                            String StartHour = TimeCompare.split('-')[0].replace('A','').replace('P','').replace(':30','');
                            if (StartHour.length() == 1)
                            {
                                StartHour = '0' + StartHour;
                            }
                            String StartMinute = (TimeCompare.split('-')[0].contains(':30')?':30' : ':00');
                            String StartMeridian = (TimeCompare.split('-')[0].contains('P')? 'P' : 'A');
                            
                            String EndHour = TimeCompare.split('-')[1].replace('A','').replace('P','').replace(':30','');
                            if (EndHour.length() == 1)
                            {
                                EndHour = '0' + EndHour;
                            }
                            String EndMinute = (TimeCompare.split('-')[1].contains(':30')?':30' : ':00');
                            String EndMeridian = (TimeCompare.split('-')[1].contains('P')? 'P' : 'A');
                            
                            if (sch.Start_time__c == null)
                            {
                                sch.Start_Time__c = StartHour + StartMinute + StartMeridian;
                            }
                            if (sch.End_Time__c == null)
                            {
                                sch.End_Time__c = EndHour + EndMinute + EndMeridian;
                            }
                        }
                    }
                    if (CDP.contains('SS'))
                    {
                        if (sch.Days_Allowed__c == null)
                        {
                            sch.Days_Allowed__c = 'Sat;Sun';
                        }
                    }
                    else if (CDP.contains('MS'))
                    {
                        if (sch.Days_Allowed__c == null)
                        {
                            sch.Days_Allowed__c = 'Mon;Tue;Wed;Thu;Fri;Sat;Sun';
                        }
                    }
                    else if (CDP.contains('MF'))
                    {
                        if (sch.Days_Allowed__c == null)
                        {
                            sch.Days_Allowed__c = 'Mon;Tue;Wed;Thu;Fri';
                        }
                    }
                }
                system.debug('All Cable Day Parts Values - ' + sch.Start_Time__c + ' - ' + sch.End_Time__c + ' - ' + sch.Days_Allowed__c);
            }
            
            if(sch.Start_Time__c == oldRecord.Start_Time__c && sch.End_Time__c == oldRecord.End_Time__c && sch.Days_Allowed__c == oldRecord.Days_Allowed__c && sch.Rate__c == oldRecord.Rate__c )
            {
                system.debug('Nothing has changed: '+sch); 
            } 
            else
            {
                if(sch.Start_Time__c !=null && sch.End_Time__c!=null && sch.Days_Allowed__c!=null && sch.Rate__c !=null)
                { 
                    startsplit = sch.Start_Time__c.split(':', 2); 
                    system.debug('START TIME SPLIT: ' + startsplit);
                    endsplit = sch.End_Time__c.split(':', 2); 
                    system.debug('END TIME SPLIT: ' + endsplit );
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
                    system.debug('FIRST PART: ' +starttime);
                    if(sch.End_Time__c.contains('P'))
                    {
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
                    system.debug('SECOND PART: ' +endtime );
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
                
                    system.debug('THIRD PART: ' +daysallowed );
                    
                    string rating='';
                    string spaceholders='';
                    integer spacedifference =0;
            
                    rating = string.valueof(integer.valueof(sch.Rate__c * 100)); 
                    spacedifference = 9 - rating.length();
                    //for(integer i = 0; i < spacedifference; i++)
                    //{
                      //  spaceholders += '0';    
                    //}   
                
                    string  newrating = spaceholders + rating;
                    system.debug('FOURTH PART: ' +rating );
                    
                    sch.OrderLineNumber__c = starttime + endtime + daysallowed + newrating ; 
                    system.debug('Schedule Order Line Number: ' +sch.OrderLineNumber__c); 
                }
                else
                {
                    system.debug('A field was null: '+ Sch);
                }             
            }
        }
        else
        {    
            //Populate the StartTime, EndTime, and DaysAllowed fields using the CableDayParts field
            system.debug('Start Values - ' + sch.Start_Time__c + ' - ' + sch.End_Time__c + ' - ' + sch.Days_Allowed__c);
            if (sch.MGM_HD_Daypart__c != null)
            {
                //if (sch.Start_Time__c == null || sch.End_Time__c == null)
                //{
                    String CDP = sch.MGM_HD_DayPart__c.toUpperCase();
                    if (CDP == 'ROS-')
                    {
                        if (sch.Deal_Parent__c != null)
                        {
                            if (ProgramStartTimeClockMap.containsKey(sch.Deal_Parent__c))
                            {
                                if (ProgramStartTimeClockMap.get(sch.Deal_Parent__c) == '5AM')
                                {
                                    sch.Start_Time__c = '05:00A';
                                    sch.End_Time__c = '05:00A';
                                }
                                
                                if (ProgramStartTimeClockMap.get(sch.Deal_Parent__c) == '4AM')
                                {
                                    sch.Start_Time__c = '04:00A';
                                    sch.End_Time__c = '04:00A';
                                }
                            }
                        }
                        if (sch.Start_time__c == null)
                        {
                            sch.Start_Time__c = '06:00A';
                        }
                        if (sch.End_Time__c == null)
                        {
                            sch.End_Time__c = '06:00A';
                        }
                        if (sch.Days_Allowed__c == null)
                        {
                            sch.Days_Allowed__c = 'Mon;Tue;Wed;Thu;Fri;Sat;Sun';
                        }
                    }
                    else
                    {
                        for (string TimeCompare : StartEndTimeSet)
                        {
                            system.debug('TimeCompare - ' + TimeCompare);
                            if (CDP.replace(' ','').contains(TimeCompare) && !CDP.replace(' ','').replace(TimeCompare,'').contains('1'))
                            {
                                system.debug('Matches - ' + TimeCompare + ' - ' + CDP.replace(' ',''));
                                String StartHour = TimeCompare.split('-')[0].replace('A','').replace('P','').replace(':30','');
                                if (StartHour.length() == 1)
                                {
                                    StartHour = '0' + StartHour;
                                }
                                String StartMinute = (TimeCompare.split('-')[0].contains(':30')?':30' : ':00');
                                String StartMeridian = (TimeCompare.split('-')[0].contains('P')? 'P' : 'A');
                                
                                String EndHour = TimeCompare.split('-')[1].replace('A','').replace('P','').replace(':30','');
                                if (EndHour.length() == 1)
                                {
                                    EndHour = '0' + EndHour;
                                }
                                String EndMinute = (TimeCompare.split('-')[1].contains(':30')?':30' : ':00');
                                String EndMeridian = (TimeCompare.split('-')[1].contains('P')? 'P' : 'A');
                                
                                if (sch.Start_Time__c == null)
                                {
                                    sch.Start_Time__c = StartHour + StartMinute + StartMeridian;
                                }
                                if (sch.End_time__c == null)
                                {
                                    sch.End_Time__c = EndHour + EndMinute + EndMeridian;
                                }
                            }
                        }
                        if (CDP.contains('SS'))
                        {
                            if (sch.Days_Allowed__c == null)
                            {
                                sch.Days_Allowed__c = 'Sat;Sun';
                            }
                        }
                        else if (CDP.contains('MS'))
                        {
                            if (sch.Days_Allowed__c == null)
                            {
                                sch.Days_Allowed__c = 'Mon;Tue;Wed;Thu;Fri;Sat;Sun';
                            }
                        }
                        else if (CDP.contains('MF'))
                        {
                            if (sch.Days_Allowed__c == null)
                            {
                                sch.Days_Allowed__c = 'Mon;Tue;Wed;Thu;Fri';
                            }
                        }
                    }
                //}
            }
        
            if(sch.Start_Time__c !=null && sch.End_Time__c!=null && sch.Days_Allowed__c!=null && sch.Rate__c !=null)
            { 
                startsplit = sch.Start_Time__c.split(':', 2); 
                system.debug('START TIME SPLIT: ' + startsplit);
                endsplit = sch.End_Time__c.split(':', 2); 
                system.debug('END TIME SPLIT: ' + endsplit );
                    
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
                system.debug('SECOND PART: ' +endtime );
            
                //Find Days Allowed 3 digit
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
            
                system.debug('THIRD PART: ' +daysallowed );
                
                string rating='';
                string spaceholders='';
                integer spacedifference =0;
        
                rating = string.valueof(integer.valueof(sch.Rate__c *  100));  
                spacedifference = 9 - rating.length();
                //for(integer i = 0; i < spacedifference; i++)
                //{
                    //spaceholders += '0';    
                //}   
           
                string  newrating = spaceholders + rating;
                system.debug('FOURTH PART: ' +rating );
                sch.OrderLineNumber__c = starttime + endtime + daysallowed + newrating ;
                
                
                system.debug('Schedule Order Line Number: ' +sch.OrderLineNumber__c); 
         
            }
            else
            {
                system.debug('A field was null: '+ Sch);
            }
        }
    }
}