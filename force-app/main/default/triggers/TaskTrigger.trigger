trigger TaskTrigger on Task (Before Update){
    if(trigger.isBefore && trigger.isUpdate){
        TaskTriggerHandler.updateFieldOnPO(Trigger.New);
    }
}