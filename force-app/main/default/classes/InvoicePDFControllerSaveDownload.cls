public class InvoicePDFControllerSaveDownload{
    
    
    public InvoicePDFControllerSaveDownload(ApexPages.StandardController controller){
        // SaveFile();
    }
        public InvoicePDFControllerSaveDownload(){
        // SaveFile();
    }
    
    
    
    public void SaveFile(){
        id ids = apexpages.currentpage().getparameters().get('id');
        system.debug('id :'+ids);
        
        PageReference ref = new PageReference('/apex/InvoicePDFGenerator?id=' + ids);
        
        
        ContentVersion cont = new ContentVersion();
        
        cont.Title = 'Invoice-'+ids;
        cont.PathOnClient = 'file.pdf';
        if(Test.isRunningTest()) { 
            
            cont.VersionData = blob.valueOf('Unit.Test');
        }
        else{
            cont.VersionData = ref.getContentAsPdf();
        }
        cont.Origin = 'H';
        
        insert cont;  
        system.debug('>>>'+cont);  
        
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cont.Id].ContentDocumentId;
        //create ContentDocumentLink  record 
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = ids; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        insert conDocLink;
    }    
}