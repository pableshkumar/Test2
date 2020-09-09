/******************************************************
*Class Name: BillingInformationTriggerHandler
*Description
*Date
*Developer Name : Vineet Kumar
******************************************************/
public class Billing_Information_Trigger_Handler {
    
    // This method will check the conditions and will fire the approval for the billing records if conditions are meeting
    public static void submitForApproval(Map<ID,Billing_Information__c>  billingOldVersionMap, List<Billing_Information__c> BillingNewVersionList )
    {           
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        List<Approval.ProcessSubmitRequest> requests2 = new List<Approval.ProcessSubmitRequest>();
        Set<String> prjSet = new Set<String>();
        Map<String,String> InfoMap = new Map<String,String>();
        //    List<Billing_Information__c>  recordsToBeApproved=new List<Billing_Information__c>();
        //collect Client SDM Approvers for  Projects   
        Set<Id> ProjIds=new Set<Id>();
        for(Billing_Information__c info:BillingNewVersionList)
        {
            projIds.add(info.Project__c);
        }
        
        //collect primary external sdm
        List<Project_Team__c> teamPrimaryExternalSDMList=[SELECT User__c,Primary__c,Project__c,Project_Role__c FROM Project_Team__c  WHERE Project__c IN: projIds AND Primary__c=TRUE AND Project_Role__c='SDM' AND RecordType.Name='External'];
        Map<ID,ID> clientSDMApproverMap=new Map<ID,ID>();  // will hold External SDM IDs from projects (Map<Project Id,Primary External SDM Id>)
        if(teamPrimaryExternalSDMList.size()>0)
        {
            for(Project_Team__c pt:teamPrimaryExternalSDMList)
            {
                clientSDMApproverMap.put(pt.Project__c,pt.User__c);
            }
        }
        
        //collect primary internal sdm
        List<Project_Team__c> teamPrimaryInternalSDMList=[SELECT User__c,Primary__c,Project__c,Project_Role__c FROM Project_Team__c  WHERE Project__c IN: projIds AND Primary__c=TRUE AND Project_Role__c='SDM' AND RecordType.Name='Internal'];
        Map<ID,ID> internalSDMApproverMap=new Map<ID,ID>();  // will hold Primary Internal SDM IDs from projects (Map<Project Id,Primary Internal SDM Id>)
        if(teamPrimaryInternalSDMList.size()>0)
        {
            for(Project_Team__c pt:teamPrimaryInternalSDMList)
            {
                internalSDMApproverMap.put(pt.Project__c,pt.User__c);
            }
        }     
        
        for(Billing_Information__c info:BillingNewVersionList)
        {
            system.debug('Account_Type__c===>'+info.Account_Type__c);
            If(info.Account_Type__c == 'Customer' && billingOldVersionMap.get(info.id).Billing_Approval_Status__c!=info.Billing_Approval_Status__c && (info.Billing_Approval_Status__c=='Sent to SDM') )
            {
                If(internalSDMApproverMap.get(info.Project__c)!=NULL)
                {
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for billing approval');
                    req1.setObjectId(info.id);
                    req1.setNextApproverIds(new Id[] {internalSDMApproverMap.get(info.Project__c)});
                    requests.add(req1);
                }
                else
                {
                    info.addError(Label.Add_Primary_Internal_SDM_Error_Message);
                }
            }
            else If(info.Account_Type__c == 'Customer' && billingOldVersionMap.get(info.id).Billing_Approval_Status__c!=info.Billing_Approval_Status__c && (info.Billing_Approval_Status__c=='Sent to AR Manager') )
            {
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for billing approval');
                req1.setObjectId(info.id);
                requests.add(req1);
            }
            Else If(info.Account_Type__c == 'Customer' && billingOldVersionMap.get(info.id).Billing_Approval_Status__c!=info.Billing_Approval_Status__c && info.Billing_Approval_Status__c=='Sent to AR Head' )
            {
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for billing approval');
                req1.setObjectId(info.id);
                requests2.add(req1);
                approveRecords(info);
            }
            Else If(info.Account_Type__c == 'Customer' && billingOldVersionMap.get(info.id).Billing_Approval_Status__c!=info.Billing_Approval_Status__c && info.Billing_Approval_Status__c=='Sent to Client SDM' )
            {
                If(clientSDMApproverMap.get(info.Project__c)!=NULL)
                {
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for billing approval');
                    req1.setObjectId(info.id);
                    req1.setNextApproverIds(new Id[] {clientSDMApproverMap.get(info.Project__c)});
                    requests2.add(req1);
                    approveRecords(info);
                }
                else
                {
                    info.addError(Label.Add_Primary_External_SDM_Error_Message);
                }
                
            }
            else if(info.Account_Type__c == 'Vendor' && billingOldVersionMap.get(info.id).Billing_Approval_Status__c!=info.Billing_Approval_Status__c && (info.Billing_Approval_Status__c=='Sent to TIG SDM') )
            {
                prjSet.add(info.Project__c);
                InfoMap.put(info.Project__c,info.id);
            }
        }
        
        if(prjSet.size() > 0){
            for(List<Project_Team__c> roleList : [Select User__c,Project__c FROM Project_Team__c WHERE Project__c IN :prjSet AND Project_Role__c = 'Service Desk Manager' AND Primary__c =TRUE LIMIT 1]){
                for(Project_Team__c role:roleList){
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for billing approval');
                    system.debug('InfoMap=======>'+InfoMap.get(role.Project__c));
                    system.debug('role=======>'+role.User__c);
                    req1.setObjectId(InfoMap.get(role.Project__c));
                    req1.setNextApproverIds(new Id[] {role.User__c});
                    Approval.ProcessResult result = Approval.process(req1);
                    system.debug('result=======>'+result);
                }
                
            }
        }
        // Submit the approval request.
        system.debug('requests==>'+requests);
        if(requests.size()>0)
        {
            Approval.process(requests); 
        }
        if(requests2.size()>0 )
        {
            Approval.process(requests2); 
        } 
    }
    
    /* This method will throw an error if AR Manager Approves the record with updating the approval status. 
* for this we have a checkbox "Approved by AR Manager"  and it gets checked through approval process 
* and this method checks if that checkbox is checked and approval status is not changed to
* "Sent to AR Head" or "Sent to Client SDM" then will throw error while approving the record */
    public static void checkApprovalStatus(Map<ID,Billing_Information__c>  billingOldVersionMap, List<Billing_Information__c> BillingNewVersionList)
    {
        for(Billing_Information__c bi:BillingNewVersionList)
            if(billingOldVersionMap.get(bi.id).Approved_by_AR_Manager__c!=bi.Approved_by_AR_Manager__c && bi.Approved_by_AR_Manager__c==True && bi.Billing_Approval_Status__c=='Sent to AR Manager')
        {
            bi.addError(Label.Submit_to_AR_Head_or_Client_SDM);
        }
    }
    
    /*
* This method will Approve the Billing 
*/
    
    public static void approveRecords(Billing_Information__c record)
    {
        // List<Approval.ProcessWorkitemRequest>  pwr=new List<Approval.ProcessWorkitemRequest>();
        //  for(Billing_Information__c bi:records)
        // {
        //Class used for Approving Record
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Approving request for Billing');
        
        //Approve or Reject Record
        req.setAction('Approve');
        
        //Getting Work Item Id
        ProcessInstanceWorkitem pItem = [Select Id from ProcessInstanceWorkitem 
                                         where ProcessInstance.TargetObjectId =: record.id];
        if(pItem!=NULL)
        {
            req.setWorkitemId(pItem.Id);
            System.debug('Req :'+req);
            // pwr.add(req);
            //  }
            // Submit the request for approval
            Approval.ProcessResult result = Approval.process(req);
        }
        
    }
    
    
    // this method contains the logic for making comment mandatory on billing approval/rejection
    public static void approvalCommentRequired(List<Billing_Information__c>  billingRecords)
    {
        // Create a map that stores all the objects that require editing 
        Map<Id, Billing_Information__c> approvalStatements = 
            new Map<Id, Billing_Information__c>{};
                
                for(Billing_Information__c bi: billingRecords)
            {
                // Put all objects for update that require a comment check in a map,
                // so we only have to use 1 SOQL query to do all checks
                
                if (bi.Approval_Comment_Check__c == 'Requested')
                { 
                    approvalStatements.put(bi.Id, bi);
                    // Reset the field value to null, 
                    // so that the check is not repeated,
                    // next time the object is updated
                    bi.Approval_Comment_Check__c = null; 
                }
            }  
        
        if (!approvalStatements.isEmpty())  
        {
            // UPDATE 2/1/2014: Get the most recent process instance for the approval.
            // If there are some approvals to be reviewed for approval, then
            // get the most recent process instance for each object.
            List<Id> processInstanceIds = new List<Id>{};
                List<Billing_Information__c>  BilRecords=[SELECT (SELECT ID
                                                                  FROM ProcessInstances
                                                                  ORDER BY CreatedDate DESC
                                                                  LIMIT 1)
                                                          FROM Billing_Information__c
                                                          WHERE ID IN :approvalStatements.keySet()];
            if(BilRecords.size()>0)
            {
                for (Billing_Information__c bir : BilRecords)
                {
                    if(bir.ProcessInstances.size()>0)
                    {
                        processInstanceIds.add(bir.ProcessInstances[0].Id);
                    }
                }
                
                // Now that we have the most recent process instances, we can check
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
                    // If no comment exists, then prevent the object from saving.                 
                    if ((pi.Steps[0].Comments == null || 
                         pi.Steps[0].Comments.trim().length() == 0))
                    {
                        approvalStatements.get(pi.TargetObjectId).addError(
                            'Operation Cancelled: Please provide a reason ' + 
                            'for your approval / rejection!');
                    }
                }       
            }
        }
    } 
    
    
    /*   public static Set<Id> getApprover(ID prjId,String role)
{
system.debug('prjId'+prjId);
Set<Id> ApproverIds = new Set<Id>();
List<Project_Team__c> roleList = new List<Project_Team__c>();
if(prjId != null && role != ''){
roleList = [Select User__c from Project_Team__c where Project__c = :prjId AND Project_Role__c =:role limit 5];
//UserIds.add();
system.debug('roleList'+roleList);
for(Project_Team__c rList:roleList){
ApproverIds.add(rList.User__c);
}
}
return ApproverIds;
}  */
    /*public static void approvedRecord(String recId,Id prjId,String role){
List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();	
Set<ID> ApproverIds = new Set<ID>();
ApproverIds = getApprover(prjId,role);
Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
for(ID approverId:ApproverIds){
req.setComments('Approving request using Trigger');
req.setAction('Approve');
req.setNextApproverIds(new Id[] {approverId});
Id workItemId = getWorkItemId(recId);
req.setWorkitemId(workItemId);
requests.add(req);
}
// Submit the request for approval
Approval.ProcessResult result =  Approval.process(req);
}
public static Id getWorkItemId(Id targetObjectId)
{
Id retVal = null;
for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p
where p.ProcessInstance.TargetObjectId =: targetObjectId])
{
retVal  =  workItem.Id;
}
return retVal;
}*/
    
}