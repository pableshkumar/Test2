trigger Project_Trigger on Project__c (After insert) {
    
    If(trigger.isInsert && trigger.isAfter)
    {
        Project_Trigger_Handler.createAutomatedBillingInfo(Trigger.New);
    }

}