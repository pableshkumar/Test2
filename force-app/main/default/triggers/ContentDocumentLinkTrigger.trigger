trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    Set<Id> linkedEntityId = new Set<Id>();
    for(ContentDocumentLink cdl: Trigger.new){
       linkedEntityId.add(cdl.LinkedEntityId); 
    }
    List<Id> contentDocId = new List<Id>();
    List<ContentDocumentLink>  cDL= [SELECT Id, ContentDocumentId, ContentDocument.Title, ContentDocument.ContentModifiedDate, 
                                        ContentDocument.LatestPublishedVersion.Document_Type__c, ContentDocument.LatestPublishedVersionId,
                                        ContentDocument.LatestPublishedVersion.ContentModifiedBy.Name
                                        FROM ContentDocumentLink WHERE LinkedEntityId =: linkedEntityId 
                                        ];
    system.debug('cDL-->' + cDL);
    for(ContentDocumentLink cdId:cDL){
       contentDocId.add(cdId.ContentDocumentId); 
    }
    
    List<ContentDocument> cd =[Select id from ContentDocument where id=:contentDocId order by createdDate DESC limit 1];
    system.debug('cd values--->'+cd);
    List<Id> cdId= new List<Id>();
    for(ContentDocument cdrec:cd){
      cdId.add(cdrec.id);  
    } 
    system.debug('ID ---<' +cdId);
    List<ContentVersion> cv = [Select id,Document_Type__c,ContentDocumentId from ContentVersion where ContentDocumentId   =: cdId AND IsLatest = true];
    system.debug('cv ---<' +cv);
    List<Account> accList = [select Id,name from Account where id =: linkedEntityId];
    List<Account> updateRec = new List<Account>();
    for(Account accRec:accList){
        for(ContentVersion cvDocType:cv){
          if(cvDocType.Document_Type__c == 'NDA'){
               accRec.Status__c = 'VRF';
               updateRec.add(accRec);
            }  
        }
    }
    update updateRec;
}