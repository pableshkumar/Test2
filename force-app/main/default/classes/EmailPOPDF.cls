public with sharing class EmailPOPDF{ 
    @InvocableMethod(label='Send PO PDF to Vendor Contact' description='Send PO PDF to Vendor Contact' category='Purchase Order')
public static void sendPdf(List<Id> orderIds){   
    order__c ord=[Select id,Vendor_Contact__r.email from order__c where id=:orderIds[0] limit 1];
     PageReference pdf = new PageReference('/apex/InvoicePDFGenerator?id=' + ord.Id);//mail_pdf is the name of vf page
     //pdf.getParameters().put('email',email);
     // goToNextPage('email');
     Blob body;                
     try{
        body = pdf.getContent();
     }catch(VisualforceException e){
            body=Blob.valueOf(e.getMessage());
     }            
    try{
      Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
      attach.setContentType('application/pdf');
      attach.setFileName('PO PDF.pdf');
      attach.setInline(false);
      attach.Body = body;
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setUseSignature(false);
      mail.setToAddresses(new String[] { ord.Vendor_Contact__r.email });
      mail.setSubject('PO PDF');
      mail.setHtmlBody('Please ignore this email, this is just for testing, please once recieved!');
      mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
      // Send the email    
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email with PDF sent to '+email));
    }catch(Exception e)
    {
        System.debug(e.getMessage());
    }
}
}