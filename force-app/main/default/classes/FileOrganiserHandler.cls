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

        return filesLst;                    
    }

    @AuraEnabled
    public static void updateFile(Id recordId, String objType, String documentType){
        
        ContentVersion file = [SELECT Id, Title, SObjectType__c, Document_Type__c 
                                FROM ContentVersion 
                                WHERE ContentDocumentId =: recordId
                                AND IsLatest = true];

        file.SObjectType__c = objType;
        file.Document_Type__c = documentType;

        update file;
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
