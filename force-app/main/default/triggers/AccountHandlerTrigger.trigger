trigger AccountHandlerTrigger on Account (before update, after update) {
    AccountHandler ah = new AccountHandler();
    if(Trigger.isUpdate && Trigger.isbefore){
       ah.vendorStages(trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
       ah.rejectComm(Trigger.new); 
    }    
}