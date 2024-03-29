trigger Project_Team_Trigger on Project_Team__c (before insert , after Insert , after update) {
    if(trigger.isInsert && trigger.isBefore)
    {
        Project_Team_Trigger_Handler.firstDefaultPrimary(Trigger.new);
    }   
    if(trigger.isInsert && trigger.isAfter)
    {
        Project_Team_Trigger_Handler.updatePrimaryProjectTeamMember(Trigger.New, Null);
    }
    if(trigger.isUpdate && trigger.isAfter)
    {
        Project_Team_Trigger_Handler.updatePrimaryProjectTeamMember(Trigger.New,Trigger.OldMap);
    }

    if(Trigger.isAfter){
        shareito.ShareITInit shareInit = new shareito.ShareITInit(shareito.ShareITType.FULL);
        shareInit.processSharing();
    }
}