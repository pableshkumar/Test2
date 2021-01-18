trigger AccountHandlerTrigger on Account (before update, after update) {
    AccountHandler ah = new AccountHandler();
    if(Trigger.isBefore && Trigger.isUpdate){
       ah.rejectComm(Trigger.new); 
    }    
}