trigger DueDiligence on Due_Diligence__c (before insert,after insert,after update) {
    if(Trigger.isInsert && Trigger.isBefore)
    {
    DueDiligenceTriggerHandler.updatecheckBox(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isafter)
    {
      DueDiligenceTriggerHandler.updateRAGCount(Trigger.NewMap);        
    }
    
        else if(Trigger.isUpdate && Trigger.isafter)
    {
       if(DueDiligenceTriggerHandler.isFirstTime==true)
       {
           DueDiligenceTriggerHandler.isFirstTime=false;
     // DueDiligenceTriggerHandler.updateRAGCount(Trigger.NewMap);     
       }
    }
    
    

}