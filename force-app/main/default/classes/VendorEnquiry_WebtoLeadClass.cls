@RestResource(urlMapping='/Enquiry/*')
global class VendorEnquiry_WebtoLeadClass {

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
            LstvEnq.add(vEnq);
        }   
        if(LstvEnq.size() > 0){
            insert LstvEnq;
        }
        return responseJSON;
    }
    global class responseWrapper{

        global string contactNumber {get;set;}
        global string firstName {get;set;}
        global string lastName {get;set;}
        
        //constructor
		global responseWrapper() {
			//default all values
			this.contactNumber = 'contactNumber';
			this.firstName = 'firstName';
			this.lastName = 'lastName';
			
        }
    }
}
