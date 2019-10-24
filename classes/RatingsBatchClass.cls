global class RatingsBatchClass implements Database.Batchable<sObject> {

    
	public List <Ratings_Compiled__c> ratingsToInsert = new List<Ratings_Compiled__c>();

    global RatingsBatchClass(List<Ratings_Compiled__c> listOfRatings) {
        ratingsToInsert = listOfRatings;
    }

    // Start Method

    global List<Ratings_Compiled__c> start(Database.BatchableContext BC) {
		return ratingsToInsert;

    }

   // Execute method

    global void execute(Database.BatchableContext BC, List<Ratings_Compiled__c> ratingsToInsert) {

        for (Ratings_Compiled__c oneRating: ratingsToInsert){
            System.debug('my rating' + oneRating);
        }
        //insert ratingsToInsert;
        Database.SaveResult[] ratingsList = Database.insert(ratingsToInsert, false);

        
        for (Database.SaveResult rating : ratingsList) {
            if (rating.isSuccess()) {

        // Operation was successful, so get the ID of the record that was processed

        System.debug('Successfully inserted rating:  ' + rating);

    		}
            else {

        // Operation failed, so get all errors               

        for(Database.Error err : rating.getErrors()) {

            System.debug('The following error has occurred.');                   

            System.debug(err.getStatusCode() + ': ' + err.getMessage());

            System.debug('Account fields that affected this error: ' + err.getFields());

        }
	   }
      }
    }

    // Finish Method

    global void finish(Database.BatchableContext BC) {

    }
}