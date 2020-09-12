public class InvoiceHandler {
    
    public static void validatedDispute(){
        for(Invoice__c invoice:(List<Invoice__c>)trigger.new){
            if(invoice.Status__c == 'Disputed' && invoice.Disputed_Amount__c == null ){
                //invoice.addError('Please enter disputed amount before rejection.');
                invoice.addError(System.Label.Dispute_Amount_Error);
            }
            else if(invoice.Number_of_Invoice_Line_Items__c == 0 && invoice.Stage__c != 'Draft'){
                //invoice.addError('Please enter disputed amount before rejection.');
                invoice.addError('Please add line items to the invoice before proceeding.');
            }
        }    
    }

    @future
    public static void sendToTIGSDMOnDispute(String inv){
        List<Invoice__c> invList =   (List<Invoice__c>)System.JSON.deserialize(inv, List<Invoice__c>.class);
        List<String> roles = new List<String>{'Client SDM', 'SDM','TIG SDM', 'RDH', 'Account Manager'};
        Map<String, String> roleMap = new Map<String, String>();

        for(Project_Team__C currentTeams : [SELECT ID, User__c,Project__c, user__r.email, Project_Role__c, RecordType.Name FROM Project_Team__c WHERE Project_Role__c IN: roles AND Primary__c = TRUE AND RecordType.Name = 'Internal']){
            roleMap.put(currentTeams.Project__c, currentTeams.user__c );
        }
        for(Invoice__c invoice: invList){
            //Invoice__c oldInvoice = (Invoice__c)Trigger.oldMap.get(invoice.Id);
            //if(invoice.Status__c == 'Disputed' && invoice.Stage__c == 'On Hold' && oldInvoice.Status__c != invoice.Status__c){
            if(invoice.Status__c == 'Disputed' && invoice.Stage__c == 'On Hold'){
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Dispute Resolution');
                req1.setObjectId(invoice.id);
                req1.setNextApproverIds(new List<Id>{roleMap.get(invoice.Project__c)});  
                Approval.ProcessResult result = Approval.process(req1);
            }
            else if(invoice.Status__c == 'Validate Invoice' || invoice.Status__c == 'Escalated' || invoice.Status__c == 'Exception Approval Needed'){
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();

                req1.setObjectId(invoice.id);

                Approval.ProcessResult result = Approval.process(req1);
            }
        }
        
    }
    
    // This method is used to generate sales invoice number automatically
    public static void generateInvoiceNumber(List<Invoice__c>  invoices) 
    {
        System.debug('Inside generateInvoiceNumber');
        System.debug('invoices : '+invoices);
        Set<Id> salesInvoiceIds=new Set<Id>();
        for(Invoice__c inv:invoices)
        {
            if(inv.RecordTypeId==Schema.SObjectType.Invoice__c.getRecordTypeInfosByName().get('Sales Invoice').getRecordTypeId())
            {
                salesInvoiceIds.add(inv.id);
            }
        }
        System.debug('salesInvoiceIds :'+salesInvoiceIds);
        List<Invoice__c>  invoiceList=[SELECT Id,Project__r.TIG_Entity_Name__r.id,Project__r.TIG_Entity_Name__r.TIG_Entity_Code__c,Project__r.TIG_Entity_Name__r.Last_Generated_Invoice_Number__c,Project__r.Customer__r.Customer_Code__c, RecordType.Name FROM Invoice__c WHERE id IN:salesInvoiceIds ];
        System.debug('invoiceList:'+invoiceList);
        Map<String,String> entityMap=new Map<String,String>();
        for(Invoice__c inv:invoiceList)
        {
            entityMap.put(inv.Project__r.TIG_Entity_Name__r.id,inv.Project__r.TIG_Entity_Name__r.Last_Generated_Invoice_Number__c);
        }
        List<Invoice__c> invoiceListToUpdate=new List<Invoice__c>();
        
        for(Invoice__c inv:invoiceList)
        {
            if(inv.RecordTypeId==Schema.SObjectType.Invoice__c.getRecordTypeInfosByName().get('Sales Invoice').getRecordTypeId())
            {
                String series='INV';
                series=series+inv.Project__r.TIG_Entity_Name__r.TIG_Entity_Code__c;
                series=series+inv.Project__r.Customer__r.Customer_Code__c;
                String monthDigits=Date.Today().Month()<10?'0'+Date.Today().Month():String.valueOf(Date.Today().Month());
                series=series+monthDigits;
                series=series+string.valueof(Date.Today().year()).right(2);
                series=series+'-';
                if(entityMap.containsKey(inv.Project__r.TIG_Entity_Name__r.id) && entityMap.get(inv.Project__r.TIG_Entity_Name__r.id)==NULL)
                {
                    
                    series=series+'000001';
                    inv.Name= series;
                }
                else if(entityMap.containsKey(inv.Project__r.TIG_Entity_Name__r.id) && entityMap.get(inv.Project__r.TIG_Entity_Name__r.id)!=NULL)
                {
                    String str=entityMap.get(inv.Project__r.TIG_Entity_Name__r.id);
                    Integer lastSixDigits=Integer.valueof(str.right(6));
                    series=series+String.valueOf(Integer.valueOf(lastSixDigits)+1).leftPad(6, '0');
                    inv.Name=series;
                }
                invoiceListToUpdate.add(inv);
                entityMap.put(inv.Project__r.TIG_Entity_Name__r.id,series);
            }
            
        }
        List<TIG_Entity__c> entityList=new List<TIG_Entity__c>();
        if(entityMap.size()>0)
        {
        for(String str:entityMap.keySet())
        {
            TIG_Entity__c te=new TIG_Entity__c();
            te.id=str;
            te.Last_Generated_Invoice_Number__c=entityMap.get(str);
            entityList.add(te);
        }
        }
        System.debug('invoiceListToUpdate :'+invoiceListToUpdate);
        System.debug('entityList :'+entityList);
        if(invoiceListToUpdate.size()>0)
            update invoiceListToUpdate;
        if(entityList.size()>0)
            update entityList;        
    }
    
}