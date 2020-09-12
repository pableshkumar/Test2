trigger ProjectTrigger on Project__c (after insert) {
    
    if(trigger.isInsert && trigger.isAfter){
        ProjectTriggerHandler.createAutomatedBillingInfo(Trigger.New);
    }
    
    shareito.ShareITInit shareInit = new shareito.ShareITInit(shareito.ShareITType.FULL);
    shareInit.processSharing();
}