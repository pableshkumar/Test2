public class DueDiligenceTriggerHandler {
    public static void updatecheckBox(List<Due_Diligence__c> dueDiligenceList){
        Set<ID> partnerId=new set<ID>(); // Set to save the id for partners
        for(Due_Diligence__c due:dueDiligenceList){
            partnerId.add(due.Partner__c);
        }
        List<Due_Diligence__c> dueDiligenceList2=[Select id,Status__c,Active__c,Partner__c from Due_Diligence__c where Partner__c In:partnerId];
        List<Due_Diligence__c> updateddueDiligenceList=new List<Due_Diligence__c>();
        for(Due_Diligence__c due:dueDiligenceList2){
            due.Status__c='Completed';
            due.Active__c=False;
            updateddueDiligenceList.add(due);
        }
        if(!updateddueDiligenceList.isempty()){
            update updateddueDiligenceList;
        } 
        
        
    }
    
}