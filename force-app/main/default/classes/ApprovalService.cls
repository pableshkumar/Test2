public class ApprovalService {
    
    
    /*@InvocableMethod
	public static void escalateToTIGDelivery(List<ID> invIds){
        List<Invoice__c> unattendetInvoice = [Select ID, status__c from Invoice__c WHERE id =: invIds[0]];
        
        if(unattendetInvoice[0].status__c == 'Send To TIG SDM'){
            ApprovalService service = new ApprovalService();
            service.rejectApprovalRecord(invIds, 'Escalated to TIG Delivery');
            Invoice__c inv = new Invoice__c();
            inv.id= invIds[0];
            inv.Status__c = 'Send To TIG Delivery';
            
            update inv;
            
            InvoiceHandler handler = new InvoiceHandler();
            
            
            service.submitforApproval('Send_To_TIG_Delivery', 'Submitting request for approval.', inv.id, new List<String>{handler.roleMap.get('Client SDM')});        
        }else if(unattendetInvoice[0].status__c == 'Sent to AP Executive/Sr. Executive'){
            ApprovalService service = new ApprovalService();
            service.approveApprovalRecord(invIds, 'Auto Approve');
        }       
     
     }*/
    
    public void rejectApprovalRecord(List<ID> invIds, string comment){
         //Class used for Approving Record
         Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
         req.setComments(comment);
         
         //Approve or Reject Record
         req.setAction('Reject');
         
         //Getting Work Item Id
         ProcessInstanceWorkitem pItem = [Select Id from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId =: invIds[0]];
        
         req.setWorkitemId(pItem.Id);
         // Submit the request for approval
         Approval.ProcessResult result = Approval.process(req);
     
     }
    
    public void approveApprovalRecord(List<ID> invIds, string comment){
         //Class used for Approving Record
         Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
         req.setComments(comment);
         
         //Approve or Reject Record
         req.setAction('Approve');
         
         //Getting Work Item Id
         ProcessInstanceWorkitem pItem = [Select Id from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId =: invIds[0]];
        
         req.setWorkitemId(pItem.Id);
         // Submit the request for approval
         Approval.ProcessResult result = Approval.process(req);
     
     }
    
    public void submitforApproval(string approvalName, string comments, string objID, List<String> nextAppIDs){
        System.debug(nextAppIDs);
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments(comments);
        req1.setObjectId(objID);
        
        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId(approvalName);
        req1.setNextApproverIds(nextAppIDs);
        
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
    }
}