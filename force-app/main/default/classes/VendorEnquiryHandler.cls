public class VendorEnquiryHandler {
    public void createAccCon(List<Vendor_Enquiry__c> lstNewVE){
        //Account and Contact Insertion 
        Boolean isAccountCreate=false;
        list<sobject> sObjList = new list<sObject>();
        Id vendorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        system.debug('recordType Id --> ' + vendorRecordTypeId);
        for(Vendor_Enquiry__c vendorRec: lstNewVE){
            if(vendorRec.Status__c == 'Selected for Onboarding'){
                Account acc = new Account();
                acc.name = vendorRec.Name_of_the_Organization__c;
                acc.Status__c ='Initiation';
                acc.RecordTypeId = vendorRecordTypeId;
                acc.Vendor_Enquiry_Id__c = vendorRec.Name;
                acc.Captured_through_Vendor_Enquiry__c=TRUE;
                acc.Vendor_Enquiry__c=vendorRec.Id;
                acc.One_Time_Vendor__c=vendorRec.One_Time_Vendor__c;
                sObjList.add(acc);
            }
            if(!sObjList.isEmpty()){
                insert sObjList;
                isAccountCreate=true;
            }
            
        }
        list<sobject> sObjListCon = new list<sObject>();
        for(Vendor_Enquiry__c vendorRec1: lstNewVE){
            if(vendorRec1.Status__c == 'Selected for Onboarding'){
                for(sObject accList:sObjList){
                    Contact con = new Contact();
                    con.LastName = vendorRec1.Last_Name__c;
                    con.FirstName = vendorRec1.First_Name__c;
                    con.AccountId = accList.Id;
                    con.Email = vendorRec1.Official_Email_id__c;
                    con.MobilePhone = vendorRec1.Contact_number__c;
                    con.MailingCountry = vendorRec1.Country__c;
                    sObjListCon.add(con);
                    
                }
            }
            if(!sObjListCon.isEmpty()){
                insert sObjListCon;
            }
            
        }
        
        List<String> conIds = new List<String>();
        for(sObject conRecId:sObjListCon){
            conIds.add(conRecId.Id);
            system.debug('ContactIds--->'+conIds);
        }
        //get the AccountContact Role
        // List<AccountContactRole> acr = [Select Id, accountId, ContactId, Role from AccountContactRole where contactId IN:conIds];
        //system.debug('acr--->' +acr);
        
        /*
list<sobject> sObjListRole = new list<sObject>();
for(Vendor_Enquiry__c vendorRec1: lstNewVE){
system.debug('vendorRec1--->'+vendorRec1);
if(vendorRec1.Status__c == 'Selected for Onboarding'){
for(sObject accList:sObjList){
system.debug('accList--->'+accList);
for(sObject conList:sObjListCon){
system.debug('conList--->'+conList);
AccountContactRole acr = new AccountContactRole();
acr.AccountId = accList.Id;
acr.ContactId = conList.Id;
acr.Role = 'Other';
sObjListRole.add(acr);
}
}
}
system.debug('sObjListRole---->'+sObjListRole);
update sObjListRole;
}*/
        //Fiels Transer 
        if(isAccountCreate)
        {
            Set<ID> VendorRecIds = new Set<ID>();
            List<String> VendorName = new List<String>();
            for(Vendor_Enquiry__c vendorRec: lstNewVE){
                VendorRecIds.add(vendorRec.Id);
                VendorName.add(vendorRec.Name);
            }
            Account accList = [SELECT Id, name, Vendor_Enquiry_Id__c FROM Account WHERE Vendor_Enquiry_Id__c=:VendorName limit 1];
            system.debug('accList------->'+accList);
            List<ContentDocumentLink> cDL= [SELECT Id, ContentDocumentId, ContentDocument.Title, ContentDocument.ContentModifiedDate, 
                                            ContentDocument.LatestPublishedVersion.Document_Type__c, ContentDocument.LatestPublishedVersionId,
                                            ContentDocument.LatestPublishedVersion.ContentModifiedBy.Name
                                            FROM ContentDocumentLink WHERE LinkedEntityId =: VendorRecIds];
            List<ContentDocumentLink> filesLst = new List<ContentDocumentLink>();
            for(ContentDocumentLink cDList:cDL){
                ContentDocumentLink cDLRec = new ContentDocumentLink();
                cDLRec.ContentDocumentId = cDList.ContentDocumentId;
                cDLRec.LinkedEntityId = accList.Id;
                
                filesLst.add(cDLRec);   
            } 
            insert filesLst;   
            
            //Tasks
            List<Task> ts_List = new List<Task>();
            List<Task> ts_List1 = new List<Task>();
            List<Task> taskList = [SELECT Id, whatId, Subject, ActivityDate FROM Task where whatId =: VendorRecIds LIMIT 1];
            for(Task taskRecIntro: taskList){
                Task newTaskRec = new Task();
                //newTaskRec.Id = taskRecIntro.Id;
                newTaskRec.whatId = accList.Id;
                newTaskRec.Subject = 'Introduction call';
                newTaskRec.ActivityDate = system.Today()+7;
                //newTaskRec.ActivityDate = system.Today()+7;
                ts_List.add(newTaskRec);
            }
            insert ts_List;
            List<Task> taskList1 = [SELECT Id, whatId, Subject, ActivityDate FROM Task where whatId =: VendorRecIds];
            for(Task taskRec: taskList1){
                Task newTaskRec = new Task();
                newTaskRec.Id = taskRec.Id;
                newTaskRec.whatId = accList.Id;
                newTaskRec.Subject = taskRec.subject;
                newTaskRec.ActivityDate = taskRec.ActivityDate;
                //newTaskRec.ActivityDate = system.Today()+7;
                ts_List1.add(newTaskRec);
            }
            upsert ts_List1;
        }
        
    }
}