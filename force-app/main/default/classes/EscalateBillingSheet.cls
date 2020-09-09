public class EscalateBillingSheet {
     @InvocableMethod
    public static void escalateBillingSheet(List<ID> invIds){
        List<ProcessInstanceWorkitem> pItem = [Select Id,ActorID from ProcessInstanceWorkitem where ProcessInstance.TargetObjectId =: invIds[0]];
        
        if(pItem != null && pItem.size() > 0){
            
            ApprovalService service=new ApprovalService();
            service.rejectApprovalRecord(invIds, 'Escalating to Manager');
            
            list<Billing_Information__c> collectids=[select id,Current_Approval__c from Billing_Information__c where id=:invIds[0]];
            
            string approvalsct=collectids[0].Current_Approval__c;
            
            if(approvalsct=='AR Executive'){
                list<UserRole> roles=new list<UserRole>();
                roles=[select id,Name from UserRole where Name=:'AR Manager'];
                
                list<User> users=new list<User>();
                users=[select id from User where UserRoleid=:roles[0].id];
                
                //Escalate by submitting approval
                ApprovalService newServices=new ApprovalService(); 
                newServices.submitforApproval('Escalate_Billing_Information', 'Escalate to Manager', invIds[0], new list<string>{users[0].id});
                
                Billing_Information__c billInfo = new Billing_Information__c();
                billInfo.id= invIds[0];
                billInfo.Current_Approval__c ='AR Manager';
                
                update billInfo;
                
            }
            
            if(approvalsct=='AR Manager'){
                list<UserRole> roles=new list<UserRole>();
                roles=[select id,Name from UserRole where Name=:'AR Head'];
                
                list<User> users=new list<User>();
                users=[select id from User where UserRoleid=:roles[0].id];
                
                //Escalate by submitting approval
                ApprovalService newServices=new ApprovalService(); 
                newServices.submitforApproval('Escalate_Billing_Information', 'Escalate to Head', invIds[0], new list<string>{users[0].id});
                
                Billing_Information__c billInfo = new Billing_Information__c();
                billInfo.id= invIds[0];
                billInfo.Current_Approval__c ='AR Head';
                
                update billInfo;
            }
            
  		}
    }
}