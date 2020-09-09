trigger Invoice on Invoice__c (before insert, before update, after update) {
    InvoiceHandler handler = new InvoiceHandler();
    if(trigger.isInsert && trigger.isBefore){
        //handler.generateAutoNumber();
    }else if(Trigger.isUpdate && trigger.isBefore){
        handler.sendEmail();
        handler.validatedDispute();
        
    }else if(Trigger.isUpdate && trigger.isafter){   
        //handler.requiredApprovalComment();
        InvoiceHandler.sendToTIGSDMOnDispute(JSON.serialize(Trigger.New));
    }
}