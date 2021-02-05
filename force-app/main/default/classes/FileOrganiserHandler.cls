public with sharing class FileOrganiserHandler {
    
    @AuraEnabled(cacheable=true)
    public static List<FileWrap> getFiles(Id recordId){
        
        List<FileWrap> filesLst = new List<FileWrap>();
        
        for(ContentDocumentLink cDL: [SELECT Id, ContentDocumentId, ContentDocument.Title, ContentDocument.ContentModifiedDate, 
                                      ContentDocument.LatestPublishedVersion.Document_Type__c, ContentDocument.LatestPublishedVersionId,
                                      ContentDocument.LatestPublishedVersion.ContentModifiedBy.Name
                                      FROM ContentDocumentLink WHERE LinkedEntityId =: recordId]){
                                          
                                          FileWrap fWrap = new FileWrap();
                                          
                                          fWrap.id = cDL.ContentDocumentId;
                                          fWrap.title = cDL.ContentDocument.Title;
                                          fWrap.documentType = cDL.ContentDocument.LatestPublishedVersion.Document_Type__c;
                                          fWrap.uploadedBy = cDL.ContentDocument.LatestPublishedVersion.ContentModifiedBy.Name;
                                          fWrap.uploadedDate = cDL.ContentDocument.ContentModifiedDate;
                                          
                                          filesLst.add(fWrap);
                                      }
        //system.debug('file ---<' +filesLst);
        return filesLst;                    
    }
    
    @AuraEnabled
    public static void updateFile(Id recordId, String objType, String documentType,string accId){
        //create a content version list
        
        ContentVersion file = [SELECT Id, Title, SObjectType__c, Document_Type__c 
                               FROM ContentVersion 
                               WHERE ContentDocumentId =: recordId
                               AND IsLatest = true];
        
        file.SObjectType__c = objType;
        file.Document_Type__c = documentType;
        update file;
        try{
            String checkId = accId.substring(0, Math.min(accId.length(), 3));
            if(checkId =='001'){
                Account acc=[select Id,Status__c,File_Type__c from Account where Id =: accId LIMIT 1];
                
                acc.File_Type__c=documentType;
                system.debug('file type--->'+acc.File_Type__c);
                if(documentType =='Vendor Capability' ){
                    acc.Vendor_capability__c=true;
                }else if(documentType =='Partner Presence' ){
                    acc.partner_presence__c=true;
                }
                else if(documentType =='Financial Information'){
                    acc.Financial_Informatio__c=true;
                }
                else if(documentType =='Escalation Matrix'){
                    acc.Escalation_Matrix__c=true;
                }
                update acc;
                system.debug('acc data---->'+acc);
            }else{
                Vendor_Enquiry__c vendor=[select Id,File_Type__c from Vendor_Enquiry__c where Id =: accId LIMIT 1];
                vendor.File_Type__c=documentType;
                update vendor;
                system.debug('file type--->'+vendor);
            }
            
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
  
    public class FileWrap{
        
        @AuraEnabled
        public String id;
        
        @AuraEnabled
        public String title;
        
        @AuraEnabled
        public String documentType;
        
        @AuraEnabled
        public Datetime uploadedDate;
        
        @AuraEnabled
        public String uploadedBy;
    }
}