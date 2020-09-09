/******************************************************
*Trigger Name
*Description
*Date
*Developer Name
******************************************************/
trigger Billing_Information_Trigger on Billing_Information__c (Before Update, After Update, before insert,after insert) {
    If(Trigger.isUpdate && Trigger.isAfter)
    {
        Billing_Information_Trigger_Handler.submitForApproval(Trigger.OldMap,Trigger.New);
    }
        If(Trigger.isUpdate && Trigger.isBefore)
    {
      //  BillingInformationTriggerHandler.approvalCommentRequired(Trigger.New);
        Billing_Information_Trigger_Handler.checkApprovalStatus(Trigger.OldMap,Trigger.New);
    }
    
 /*   if(Trigger.isbefore && Trigger.isinsert){
        for(Billing_Information__c rec:trigger.new){
            rec.Current_Approval__c='AR Executive';
        }
    }
    
    if(Trigger.isafter && Trigger.isinsert){
        list<UserRole> roles=new list<UserRole>();
        roles=[select Id, Name from UserRole where Name=:'AR Executive'];
        system.debug(roles);
        
        list<User> users=new list<User>();
        users=[select id from User where UserRoleid=:roles[0].id];
        system.debug(users);
        
        list<string> Nuser=new list<string>();
        for(User currentUser:users){
            Nuser.add(currentUser.id);
        }
        system.debug(Nuser);
        
        ApprovalService newServices=new ApprovalService();
        for(Billing_Information__c rec:trigger.new){
            newservices.submitforApproval('Escalate_Billing_Information', 'Escalate to AP Executive', rec.id, new list<string>{Nuser[0]});
        }
    }  */
}