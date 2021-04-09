trigger AccountHandlerTrigger on Account (before update, after update) {
    AccountHandler ah = new AccountHandler();
    if(Trigger.isBefore && Trigger.isUpdate){
       ah.rejectComm(Trigger.new); 
        //ah.msaRequired(Trigger.new,Trigger.oldMap);
        ah.requireRejectionComment(Trigger.new,Trigger.oldMap);
        ah.checkFileType(Trigger.new,Trigger.oldMap);
    } else if(Trigger.isAfter && Trigger.isUpdate){
     //   AccountHandler.VendorApproval(Trigger.new,Trigger.oldMap);
    }
}