trigger VendorEnquiryTrigger on Vendor_Enquiry__c (before insert, before update, after insert, after update) {
    VendorEnquiryHandler vendorHandler = new VendorEnquiryHandler();
    if(trigger.isInsert && trigger.isAfter){
       vendorHandler.createAccCon(trigger.new); 
    } 
}