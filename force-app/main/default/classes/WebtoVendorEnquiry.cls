/*******************
 * Class Name
 * Description: It's a Rest Web Service. which is used to create vendor inqueries into system coming from web.
 * 
 * 
 * ********************/


@RestResource(urlMapping='/VendorEnquiry/*')
global class WebtoVendorEnquiry {

    /*public VendorEnquiry_WebtoLeadClass() {

    }*/
   @HttpPost
    global static responseWrapper VendorEnquiryCreation(){
        RestRequest req = RestContext.request; //the RestRequest for the Apex REST method
        responseWrapper responseJSON = new responseWrapper();
        Map<String, Object> body = new Map<String, Object>();
        List<Vendor_Enquiry__c> LstvEnq = new List<Vendor_Enquiry__c>();
        String jsonBody = req.requestBody.toString();
        if (!String.isBlank(jsonBody)) { 
			body = (Map<String, Object>)JSON.deserializeUntyped(jsonBody); //deserializes the JSON string into collections of primitive data types
            system.debug('body========>'+body.get(responseJSON.contactNumber));
            Vendor_Enquiry__c vEnq = new Vendor_Enquiry__c();
            vEnq.Contact_number__c = String.valueof(body.get(responseJSON.contactNumber));
            vEnq.First_Name__c = String.valueof(body.get(responseJSON.firstName));
            vEnq.Last_Name__c = String.valueof(body.get(responseJSON.lastName));
            vEnq.Official_Email_id__c = String.valueof(body.get(responseJSON.officialEmailId));
            vEnq.Name_of_the_Organization__c = String.valueof(body.get(responseJSON.nameOfTheOrganisation));
            vEnq.How_did_you_hear_about_TIG__c = String.valueof(body.get(responseJSON.howDidYouHearAboutTIG));
            vEnq.Query__c = String.valueof(body.get(responseJSON.query));
            vEnq.Designation__c = String.valueof(body.get(responseJSON.designation));
            vEnq.Country__c = String.valueof(body.get(responseJSON.country));
            vEnq.Source__c='Web';
                LstvEnq.add(vEnq);
        }   
        if(LstvEnq.size() > 0){
            insert LstvEnq; // inserting vendor enquiries  into database
        }
        return responseJSON;
    }
    global class responseWrapper{

        global string contactNumber {get;set;}
        global string firstName {get;set;}
        global string lastName {get;set;}
        global string officialEmailId {get;set;}
        global string nameOfTheOrganisation {get;set;}
        global string howDidYouHearAboutTIG {get;set;}
        global string query {get;set;}
        global string designation {get;set;}
        global string country {get;set;}
        global string source {get;set;}
        
        //constructor
		global responseWrapper() {
			//default all values
			this.contactNumber = 'contactNumber';
			this.firstName = 'firstName';
			this.lastName = 'lastName';
            this.officialEmailId='officialEmailId';
            this.nameOfTheOrganisation='nameOfTheOrganisation';
            this.howDidYouHearAboutTIG='howDidYouHearAboutTIG';
            this.query='query';
            this.designation='designation';
            this.country='country';
            this.source='source';
			
        }
    }  
}