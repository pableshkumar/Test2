trigger DueDiligence on Due_Diligence__c (before insert) {
    DueDiligenceTriggerHandler.updatecheckBox(Trigger.new);

}