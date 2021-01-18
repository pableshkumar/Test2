public class AccountHandler {
    public void rejectComm(List<Account> lstAcc){
        
        List<Account> Leads = New List <Account>();
        List<Id> Ids = New List <Id>();
        for (Account l:lstAcc){
            Ids.add (l.Id);
        }
        
        List<ProcessInstance> instances = [select Id, TargetObjectId from ProcessInstance where TargetObjectId in :Ids];
        Map<Id,Id> LeadProcessMap = new Map<Id,Id>();
        Ids = New List <Id>();
        for(ProcessInstance pi:instances){
            LeadProcessMap.put (pi.TargetObjectId,pi.Id); 
            Ids.add (pi.Id);
        }
        System.Debug ('** mapa1: '+LeadProcessMap);
        
        List<ProcessInstanceStep> instancesSteps = [select Comments,ProcessInstanceId 
                                                    from ProcessInstanceStep 
                                                    where ProcessInstanceId in :Ids];
        
        Map<Id,String> LeadProcessStepMap = new Map<Id,String>(); 
        for(ProcessInstanceStep pis:instancesSteps){
            LeadProcessStepMap.put (pis.ProcessInstanceId, pis.Comments); 
        }
        
        System.Debug ('** mapa2: '+LeadProcessStepMap);
        for (Account l:lstAcc){
            
            System.debug ('** razon2: '+LeadProcessStepMap.get(LeadProcessMap.get(l.Id)));
            l.Rejection_Reason__c = LeadProcessStepMap.get(LeadProcessMap.get(l.Id));
            System.debug ('** razon: '+l.Rejection_Reason__c);
            
        }     
        
    }
}