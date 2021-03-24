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
    public void msaRequired(List<Account> listAcc, Map<Id,Account> oldMapAcc){
        for(Account acc:listAcc){
            if(acc.File_Type__c == 'Due Diligence' && acc.Status__c == 'Registration' && acc.MSA_Required__c == null && acc.ParentId == null && acc.One_Time_Vendor__c == false ){
                acc.adderror('Please select MSA Required.');
            }else if(acc.File_Type__c != 'MSA' && acc.Status__c == 'Registration' && acc.MSA_Required__c == 'Yes' && acc.ParentId == null && acc.One_Time_Vendor__c == false){
                acc.adderror('Please upload MSA file');
            }else if(acc.Due_Diligence__c == null && acc.Status__c == 'Registration' && acc.MSA_Required__c == 'No' && acc.ParentId == null && acc.One_Time_Vendor__c == false){
                acc.adderror('Please create Due Diligence');
            }else if(acc.Date_of_Signature_MSA__c == null && acc.Date_of_Expiry_MSA__c == null && oldMapAcc.get(acc.Id).Status__c == 'MSA' && acc.Status__c == 'Registration' && acc.ParentId == null && acc.One_Time_Vendor__c == false){
                acc.adderror('Please select MSA Date of Signature and  Expiry');
            }
            
        }
    }
    
    
    public void requireRejectionComment(List<Account> listAcc, Map<Id,Account> oldMapAcc){
        
        Map<Id, Account> rejectedStatements = new Map<Id, Account>{};
            
            for(Account acc: listAcc )
        {
            
            Account oldacc = oldMapAcc.get(acc.Id);
            
            if (oldacc.Approval_status__c != 'Rejected' 
                && acc.Approval_status__c == 'Rejected')
            { 
                rejectedStatements.put(acc.Id, acc);  
            }
        }
        
        if (!rejectedStatements.isEmpty())  
        {
            
            List<Id> processInstanceIds = new List<Id>{};
                
                for (Account accs : [SELECT (SELECT ID
                                             FROM ProcessInstances
                                             ORDER BY CreatedDate DESC
                                             LIMIT 1)
                                     FROM Account
                                     WHERE ID IN :rejectedStatements.keySet()])
            {
                processInstanceIds.add(accs.ProcessInstances[0].Id);
            }
            
            // the most recent process steps for comments.  
            for (ProcessInstance pi : [SELECT TargetObjectId,
                                       (SELECT Id, StepStatus, Comments 
                                        FROM Steps
                                        ORDER BY CreatedDate DESC
                                        LIMIT 1 )
                                       FROM ProcessInstance
                                       WHERE Id IN :processInstanceIds
                                       ORDER BY CreatedDate DESC])   
            {                   
                if ((pi.Steps[0].Comments == null || 
                     pi.Steps[0].Comments.trim().length() == 0))
                {
                    rejectedStatements.get(pi.TargetObjectId).addError(
                        'Operation Cancelled: Please provide a rejection reason!');
                }
            }  
        }
    }
    
    public void checkFileType(List<Account> listAcc,Map<Id,Account> oldMapAcc){
         // get the record types id of vendor Account
        Id AccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Set<Id> accountId = new Set<Id>();
        for(Account acc: listAcc){
            if(acc.RecordTypeId==AccRecordTypeId){
              accountId.add(acc.Id);   
            }
            
        }
        List<String> fileType=new List<String>();
        for (Account a: [SELECT Name, (SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.ContentSize,ContentDocument.LatestPublishedVersion.Document_Type__c FROM ContentDocumentLinks) FROM Account where Id IN:accountId]) {
            for (ContentDocumentLink cdl: a.ContentDocumentLinks) {
                if(cdl.ContentDocument.LatestPublishedVersion.Document_Type__c != null){
                    fileType.add(cdl.ContentDocument.LatestPublishedVersion.Document_Type__c);
                }
            }
        }
        for(Account acc:listAcc){
            if(acc.File_Type__c == 'Due Diligence' && acc.Approval_status_head__c == 'Sent to FSM Head' && acc.MSA_Required__c == null && acc.ParentId == null && acc.One_Time_Vendor__c == false){
                acc.adderror('Please select MSA Required.');
            }else if(!AccountHandler.listContains(fileType, 'MSA') && acc.Approval_status_head__c == 'Sent to FSM Head' && acc.MSA_Required__c == 'Yes' && acc.ParentId == null && acc.One_Time_Vendor__c == false){
                acc.adderror('Please upload MSA file');
            }else if(acc.Due_Diligence__c == null && acc.Approval_status_head__c == 'Sent to FSM Head' && acc.MSA_Required__c == 'No' && acc.ParentId == null && acc.One_Time_Vendor__c == false){
                acc.adderror('Please create Due Diligence');
            }else if(acc.Date_of_Signature_MSA__c == null && oldMapAcc.get(acc.Id).Status__c == 'MSA' && acc.Approval_status_head__c == 'Sent to FSM Head' && acc.ParentId == null && acc.One_Time_Vendor__c == false){
                acc.adderror('Please select MSA Date of Signature.');
            }else if(acc.Date_of_Expiry_MSA__c == null && oldMapAcc.get(acc.Id).Status__c == 'MSA' && acc.Approval_status_head__c == 'Sent to FSM Head' && acc.ParentId == null && acc.One_Time_Vendor__c == false){
                acc.adderror('Please select MSA Date of Expiry.');
            }else if(acc.Status__c == 'Due Diligence' && !AccountHandler.listContains(fileType, 'Escalation Matrix')  && oldMapAcc.get(acc.Id).Status__c == 'VRF' && acc.ParentId == null && acc.One_Time_Vendor__c == false){
                acc.adderror('Please upload Escalation Matrix file then go to Due Diligence stage');
            }else if(acc.Status__c == 'Due Diligence' && !AccountHandler.listContains(fileType, 'Vendor Capability')  && oldMapAcc.get(acc.Id).Status__c == 'VRF' && acc.ParentId == null && acc.One_Time_Vendor__c == false){
                acc.adderror('Please upload Vendor Capability file then go to Due Diligence stage');
            }else if(acc.Status__c == 'Due Diligence' && !AccountHandler.listContains(fileType, 'Partner Presence')  && oldMapAcc.get(acc.Id).Status__c == 'VRF' && acc.ParentId == null && acc.One_Time_Vendor__c == false){
                acc.adderror('Please upload Partner Presence file then go to Due Diligence stage');
            }else if(acc.Status__c == 'Due Diligence' && !AccountHandler.listContains(fileType, 'Financial Information')  && oldMapAcc.get(acc.Id).Status__c == 'VRF' && acc.ParentId == null && acc.One_Time_Vendor__c == false){
                acc.adderror('Please upload Financial Information file then go to Due Diligence stage.');
            }else if(acc.Status__c == 'NDA' && !AccountHandler.listContains(fileType, 'MOM')  && oldMapAcc.get(acc.Id).Status__c == 'Initiation' && acc.ParentId == null && acc.One_Time_Vendor__c == false){
                acc.adderror('Before going to NDA stage, you need to upload MOM file.');
            }else if(acc.Status__c == 'VRF' && !AccountHandler.listContains(fileType, 'NDA') && oldMapAcc.get(acc.Id).Status__c == 'NDA' && acc.ParentId == null && acc.One_Time_Vendor__c == false){
                acc.adderror('Before going to VRF stage, you need to upload NDA file.');
            }
        }
    }
    
    public static Boolean listContains(Object[] source, Object target) {
        return (new Set<Object>(source)).contains(target);
    }
    
    
    public static void VendorApproval(List<Account> accountNewVersionList,Map<Id,Account> oldMapAcc )
    {
        // get the record type
        Id AccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
      //  User fsmHead=[Select Id ,UserName, UserRole.Name from user  where UserRole.Name='Field Service Management Head' AND IsActive = true LIMIT 1];
      //  User financehead=[Select Id ,UserName, UserRole.Name from user  where UserRole.Name='Finance Head' AND IsActive = true LIMIT 1];
        List<User> heads=[Select Id ,UserName, UserRole.Name from user  where UserRole.Name IN ('Finance Head','Field Service Management Head') AND IsActive = true ];
       Map<String,ID> headMap=new Map<String,ID>();
        if(heads.size()>0)
        {
        for(User u:heads)
        {
            headMap.put(u.UserRole.Name, u.Id);
        }
        }
        for(Account acc:accountNewVersionList){
            if(!headMap.containsKey('Finance Head') || !headMap.containsKey('Field Service Management Head'))
            {
                    acc.addError('active Field Service Management Head / Finance Head is not available in the org, please contact System admin');
            }
            if(acc.Approval_status_head__c=='Sent to FSM Head' && oldMapAcc.get(acc.id).Approval_status_head__c!=acc.Approval_status_head__c && acc.RecordTypeId==AccRecordTypeId){
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval');
                req1.setObjectId(acc.id);
                  req1.setNextApproverIds(new Id[] {headMap.get('Field Service Management Head')});
                requests.add(req1);
            }else if(acc.Approval_status_head__c=='Sent to Finance Head' && oldMapAcc.get(acc.id).Approval_status_head__c!=acc.Approval_status_head__c && acc.RecordTypeId==AccRecordTypeId){
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval');
                req1.setObjectId(acc.id);
                  req1.setNextApproverIds(new Id[] {headMap.get('Finance Head')});           
                requests.add(req1);
            }
        }
        if(requests.size()>0 ){
            Approval.process(requests); 
        } 
    }
}