/******************************************************
*Trigger Name
*Description
*Date
*Developer Name
******************************************************/
trigger Billing_Information_Trigger on Billing_Information__c (before update, after update, before insert,after insert) {
    if(Trigger.isUpdate && Trigger.isAfter)
    {  
        if(Billing_Information_Trigger_Handler.isFirstTime==true)
        {
          //  Billing_Information_Trigger_Handler.isFirstTime=false;
            Billing_Information_Trigger_Handler.submitForApproval(Trigger.OldMap,Trigger.New);
        }
    }
    if(Trigger.isUpdate && Trigger.isBefore)
    {  
        if(Billing_Information_Trigger_Handler.isFirstTime==true)
        {
           // Billing_Information_Trigger_Handler.isFirstTime=false;
            //  BillingInformationTriggerHandler.approvalCommentRequired(Trigger.New);
            Billing_Information_Trigger_Handler.checkApprovalStatus(Trigger.OldMap,Trigger.New);
        }
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        shareito.ShareITInit shareInit = new shareito.ShareITInit(shareito.ShareITType.FULL);
        shareInit.processSharing();
    }
}