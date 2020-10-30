public class VendorEnquiryHandler {
    public void createAccCon(List<Vendor_Enquiry__c> lstNewVE){
        list<sobject> sObjList = new list<sObject>();
        Id vendorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        system.debug('recordType Id --> ' + vendorRecordTypeId);
        for(Vendor_Enquiry__c vendorRec: lstNewVE){
            if(vendorRec.Status__c == 'Selected for Onboarding'){
                Account acc = new Account();
                acc.name = vendorRec.Name_of_the_Organization__c;
                acc.Status__c ='Inactive';
                acc.RecordTypeId = vendorRecordTypeId;
                acc.Vendor_Enquiry_Id__c = vendorRec.Name;
                sObjList.add(acc);
                Contact con = new Contact();
                con.LastName = vendorRec.Last_Name__c;
                con.FirstName = vendorRec.First_Name__c;
                con.AccountId = acc.Id;
                con.Email = vendorRec.Official_Email_id__c;
                con.MobilePhone = vendorRec.Contact_number__c;
                con.MailingCountry = vendorRec.Country__c;
                sObjList.add(con); 
            }
        }
        system.debug('list data --> ' +sObjList);
        insert sObjList;
        System.debug('inserted');
    }
}