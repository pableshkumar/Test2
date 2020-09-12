trigger Invoice on Invoice__c (before insert,after insert, before update, after update) {
    
    if(Trigger.isUpdate && trigger.isBefore){
        InvoiceHandler.validatedDispute();
        
    }else if(Trigger.isUpdate && trigger.isafter){   
        //handler.requiredApprovalComment();
        InvoiceHandler.sendToTIGSDMOnDispute(JSON.serialize(Trigger.New));
    }else if(Trigger.isInsert && trigger.isafter){   
        InvoiceHandler.generateInvoiceNumber(Trigger.New);
    }
}