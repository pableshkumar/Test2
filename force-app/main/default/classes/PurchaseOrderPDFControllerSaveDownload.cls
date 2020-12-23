public class PurchaseOrderPDFControllerSaveDownload{
    
    
    public PurchaseOrderPDFControllerSaveDownload(ApexPages.StandardController controller){
        // saveFile();
    }
    public PurchaseOrderPDFControllerSaveDownload(){
        // saveFile();
    }
    
    
    
    public void saveFile(){
        id ids = apexpages.currentpage().getparameters().get('id');
        system.debug('id :'+ids);
        
        PageReference ref = new PageReference('/apex/PurchaseOrderPDFGenerator?id=' + ids);
        String PONumber=[SELECT Name FROM Order__c where id=:ids].Name;
        String pdfName='Purchase Order-'+PONumber;
        List<ContentVersion> listversion = [select contentDocumentId, contentDocument.title from ContentVersion where ContentDocument.title = :pdfName];                                     
        System.debug('listversion : ' + listversion);
        ContentVersion fl = new ContentVersion();
        fl.ContentLocation = 'S';
        fl.PathOnClient = 'file.pdf';
        fl.Origin = 'H';
        fl.Title = 'Purchase Order-'+PONumber;
        fl.SObjectType__c='Order__c';
        fl.Document_Type__c='Purchase Order';
        if(Test.isRunningTest()) { 
            
            fl.VersionData = blob.valueOf('Unit.Test');
        }else{
            fl.VersionData = ref.getContentAsPdf();
        }
        if (!listversion.isEmpty()){
            fl.ContentDocumentId= listversion[0].ContentDocumentId;
        }
        Savepoint sp = Database.setSavepoint();
        try{
            insert fl;
            if(listversion.isEmpty()){
                
                fl = [select ContentDocumentId from ContentVersion where id =: fl.Id];
                ContentDocumentLink cl = new ContentDocumentLink(
                    LinkedEntityId = ids,
                    ContentDocumentId = fl.ContentDocumentId,
                    ShareType = 'I'
                );
                insert cl;   
            }         
        } catch(Exception e) {
            Database.rollback(sp);
            System.debug(e.getMessage());          
            throw e;
        }
        
    }    
}