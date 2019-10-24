public class AgingReportMapper {

    public static void tMethod(){
  
      //define the static resources
      
      //res 1 
       //list of account numbers
      	StaticResource orderNumData = [ Select body From StaticResource Where name='sampleOrderNumbers' ];
       	String orderNumString = orderNumData.Body.toString();
		List<String> orderNums = orderNumString.split(','); 
        
      //res 2 = invoice dates  
       // list of invoice dates
      	StaticResource paymentDateData = [Select body From StaticResource Where name='samplePaymentDates' ];
        String paymentDateString = paymentDateData.Body.toString();
		List<String> paymentDates = paymentDateString.split(','); 

     //res 3 = invoice numbers 
  	  //list of invoice numbers
        StaticResource invoiceNumData = [Select body From StaticResource Where name='sampleInvoiceNums' ];
        String invoiceNumString = invoiceNumData.Body.toString();
		List<String> invoiceNums = invoiceNumString.split(','); 
        
        
     //define variables that will hold references to individual data in static resources during for loop
        String currentOrderNum;
		Date currentAirDate; 
        String currentInvoiceNum;
      
     //create master list for update, this list is added to during every iteration of for loop, it holds the spot data with update invoice numbers
     //used for mass updating the spot data records
        List<Spot_Data__c> masterList = new List<Spot_Data__c>();
    
     //iterate for the length of static resource list
        for(Integer i = 0; i < 10; i++){
            //assign order num
            currentOrderNum = orderNums[i];
            //assign air date 
            currentAirDate = date.parse(paymentDates[i]);
            //assign invoice num
            currentInvoiceNum = invoiceNums[i];
            
            //get date range from BroadcastDateRange method which accepts a date and returns the related broadcast month date start and date end
            List<Date> broadcastStartEndDates = BroadcastDateRange.returnDateRange(currentAirDate);
            Date broadcastStartDate = broadcastStartEndDates[0];
            Date broadcastEndDate = broadcastStartEndDates[1];
	
        
    		//run soql query for spot data
            List<Spot_Data__c> spotMatches = [
                Select id from spot_data__c where 
                Raycom_Order_Number__c = :currentOrderNum and
                Air_Date__c >= :broadcastStartDate and
                Air_Date__c <= :broadcastEndDate 
            ];
            
            //iterate through spot data results and update the invoice number for each record
            for(Spot_Data__c spot : spotMatches){
              spot.Raycom_Invoice_Number__c = currentInvoiceNum;
            }
            
			//add the updated spot data matches to the master list
            masterList.addall(spotMatches);
        }
        
        //run update
        try{
           update masterList;
        } catch( DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage()); 
        }
    }

    
}