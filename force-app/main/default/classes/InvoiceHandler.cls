public class InvoiceHandler {
    public static Map<String, String> roleMap = new Map<String, String>();
    public static Map<String, String> roleMapEmail = new Map<String, String>();
    
    public InvoiceHandler(){
       /*List<String> roles = new List<String>{'Client SDM', 'SDM','TIG SDM', 'RDH', 'Account Manager'};
        
        for(Project_Team__C currentTeams : [SELECT ID, User__c, user__r.email, Project_Role__c, RecordType.Name FROM Project_Team__c WHERE Project_Role__c IN: roles AND Primary__c = TRUE]){
            roleMapEmail.put(currentTeams.Project_Role__c + RecordType.Name, currentTeams.user__r.email );
            roleMap.put(currentTeams.Project_Role__c + RecordType.Name, currentTeams.user__c );
        }*/
    }
    
    public void generateAutoNumber(){
        
        /*list<Invoice__c> collectrecords= new list<Invoice__c>();
        collectrecords=[select Count__c from Invoice__c ORDER BY Count__c DESC NULLS LAST limit 1];
        System.debug('1' + collectrecords);
        
        
        integer collectvarrec=collectrecords[0].Count__c == null ? 0 :integer.valueof(collectrecords[0].Count__c);
        
        List<ID> accountIDs = new List<ID>();
        
        for(Invoice__c ff:(List<Invoice__c>)trigger.new){
            accountIDs.add(ff.Customer__c);
        }
        
        Map<ID, Account> accountMap = new Map<ID, Account>([Select ID, Name FROM Account WHERE ID IN: accountIDs]);
        System.debug('2' + accountMap);
        
        for(Invoice__c ff:(List<Invoice__c>)trigger.new){
            collectvarrec = collectvarrec+1;
            ff.Count__c=collectvarrec; 
            ff.status__c = 'Draft';
            ff.Invoice_Status__c = 'Draft';
            
            System.debug('3' + collectvarrec);
            if(ff.TIG_Billing_Entity__c=='TIG India'){
                String count = String.valueOf(collectvarrec);
                
                if(count.length() < 3){
                    if(count.length() == 1){
                        count='00'+count;
                    }else if(count.length() == 2){
                        count='0'+count;
                    }
                }
                System.debug('4' + count);
                ff.Name='TICL/2017-18/' + count; 
            }else if(ff.TIG_Billing_Entity__c=='TIG UK'){
                String count = String.valueOf(collectvarrec);
                
                if(count.length() < 4){
                    if(count.length() == 1){
                        count='000'+count;
                    }else if(count.length() == 2){
                        count='00'+count;
                    }else if(count.length() == 3){
                        count='0'+count;
                    }
                }
                
                ff.Name='HCT' + count;
                System.debug('5' + count);
            }else if(ff.TIG_Billing_Entity__c=='TIG Malaysia'){
                String count = String.valueOf(collectvarrec);
                
                if(count.length() < 4){
                    if(count.length() == 1){
                        count='000'+count;
                    }else if(count.length() == 2){
                        count='00'+count;
                    }else if(count.length() == 3){
                        count='0'+count;
                    }
                }
                
                ff.Name=count;
                System.debug('6' + count);
            }else if(ff.TIG_Billing_Entity__c=='TIG Australia'){
                String customerName = accountMap.get(ff.Customer__c).Name;
                String count = String.valueOf(collectvarrec);
                
                if(count.length() < 4){
                    if(count.length() == 1){
                        count='000'+count;
                    }else if(count.length() == 2){
                        count='00'+count;
                    }else if(count.length() == 3){
                        count='0'+count;
                    }
                }
                
                if(customerName.containsIgnoreCase('wipro')){
                    
                    ff.Name='INV-WPL'+count;
                    System.debug('7' + count);
                }else if(customerName.containsIgnoreCase('hcl')){
                    ff.Name='INV-HCL'+count;
                    System.debug('8' + count);
                }else if(customerName.containsIgnoreCase('cognizant')){
                    ff.Name='INV-CTS'+count;
                    System.debug('9' + count);
                }
                System.debug('10' + count);
                
            }
            
        }*/
    }
    
    public void sendEmail(){
        
        for(Invoice__c ff:(List<Invoice__c>)trigger.new){
            
            if(ff.status__c == 'Payment Tracking' && roleMapEmail != null && roleMapEmail.size() > 0 && roleMapEmail.get('Client SDM') != null && roleMapEmail.get('RDH') != null && roleMapEmail.get('Account Manager') != null && roleMapEmail.get('TIG SDM') != null){
                Messaging.reserveSingleEmailCapacity(2);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                String[] toAddresses = new String[] {roleMapEmail.get('SDMExternal')}; 
                String[] ccAddresses = new String[] {roleMapEmail.get('SDMInternal'), roleMapEmail.get('RDH'), roleMapEmail.get('Account Manager')};
                        
                mail.setToAddresses(toAddresses);
                mail.setCcAddresses(ccAddresses);
                
                // Specify the address used when the recipients reply to the email. 
                mail.setReplyTo('support@acme.com');
                
                // Specify the name used as the display name.
                mail.setSenderDisplayName('Salesforce Support');
                
                // Specify the subject line for your email address.
                mail.setSubject('Approved by Client');
                
                // Set to True if you want to BCC yourself on the email.
                mail.setBccSender(false);
                
                // Optionally append the salesforce.com email signature to the email.
                // The email address of the user executing the Apex Code will be used.
                mail.setUseSignature(false);
                
                // Specify the text content of the email.
                mail.setPlainTextBody('Approved By Client');
                
                mail.setHtmlBody('Approved By Client');
                
                // Send the email you have created.
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            
            
        }
    }
    
    public void requiredApprovalComment(){
        Map<ID, Invoice__c> mapOfInvoice = new Map<ID, Invoice__c>();
        
        List<Invoice__c> invToBeUpdated = new List<Invoice__c>();
        Map<Id,Invoice__c> oldMapOfINV = (Map<Id,Invoice__c>)trigger.oldMap;
        
        for(Invoice__c ff:(List<Invoice__c>)trigger.new){
            if(ff.status__c.containsIgnoreCase('rejected') /*&& oldMapOfINV != null && ff.status__c != oldMapOfINV.get(ff.Id).status__c*/){
                mapOfInvoice.put(ff.Id,ff);
            }
        }
        
        system.debug('1 ' + mapOfInvoice);
        List<Id> processInstanceIds = new List<Id>{};
        
        for (Invoice__c invs : [SELECT (SELECT ID FROM ProcessInstances ORDER BY CreatedDate DESC LIMIT 1) FROM Invoice__c WHERE ID IN :mapOfInvoice.keySet()])
        {
            processInstanceIds.add(invs.ProcessInstances[0].Id);
        }
        system.debug('2 ' + processInstanceIds);
        //Check for size
        if(mapOfInvoice.size()>0){
            for (ProcessInstance pi : [SELECT TargetObjectId, (SELECT Id, StepStatus, Comments  FROM Steps WHERE StepStatus='Rejected' ORDER BY CreatedDate DESC
                                            LIMIT 1 )
                                       FROM ProcessInstance
                                       WHERE Id IN :processInstanceIds
                                       ORDER BY CreatedDate DESC]) {     
              system.debug('2 ' + JSON.serialize(pi));
              system.debug('2 ' + JSON.serialize(pi.Steps));
              if (pi.Steps.size() > 0 && (pi.Steps[0].Comments == null || 
                   pi.Steps[0].Comments.trim().length() == 0)) {
                    mapOfInvoice.get(pi.TargetObjectId).addError(
                  'Operation Cancelled: Please provide a rejection reason!');
              }
            }  
                    
            /*List<ProcessInstanceStep> proSteps = [Select id, comments, stepstatus, ProcessInstanceId,ProcessInstance.TargetObjectId from processinstancestep where processinstance.targetobjectid in: mapOfInvoice.keySet() Order By CreatedDate DESC];
            
            
            //Check for list size and populate RFQ with Reason for Lost accordingly
            if(proSteps.size()>0){
                
                for(ID currStep:mapOfInvoice.keySet()){    
                    if(proSteps[0].Comments == null && mapOfInvoice.get(proSteps[0].ProcessInstance.TargetObjectId) != null){
                        
                        mapOfInvoice.get(proSteps[0].ProcessInstance.TargetObjectId).addError('Please enter the Rejection Reason in the Comment Section');
                    }
                    
                }
            }*/
        }
    }
    public void validatedDispute(){
        for(Invoice__c invoice:(List<Invoice__c>)trigger.new){
            if(invoice.Status__c == 'Disputed' && invoice.Disputed_Amount__c == null ){
            	//invoice.addError('Please enter disputed amount before rejection.');
                invoice.addError(System.Label.Dispute_Amount_Error);
        	}
        }    
	}
    @future
    public static void sendToTIGSDMOnDispute(String inv){
        List<Invoice__c> invList =   (List<Invoice__c>)System.JSON.deserialize(inv, List<Invoice__c>.class);
        List<String> roles = new List<String>{'Client SDM', 'SDM','TIG SDM', 'RDH', 'Account Manager'};
        
        for(Project_Team__C currentTeams : [SELECT ID, User__c,Project__c, user__r.email, Project_Role__c, RecordType.Name FROM Project_Team__c WHERE Project_Role__c IN: roles AND Primary__c = TRUE AND RecordType.Name = 'Internal']){
            roleMapEmail.put(currentTeams.Project_Role__c + RecordType.Name, currentTeams.user__r.email );
            roleMap.put(currentTeams.Project__c, currentTeams.user__c );
        }
        for(Invoice__c invoice: invList){
            //Invoice__c oldInvoice = (Invoice__c)Trigger.oldMap.get(invoice.Id);
            //if(invoice.Status__c == 'Disputed' && invoice.Stage__c == 'On Hold' && oldInvoice.Status__c != invoice.Status__c){
            if(invoice.Status__c == 'Disputed' && invoice.Stage__c == 'On Hold'){
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Dispute Resolution');
                req1.setObjectId(invoice.id);
                req1.setNextApproverIds(new List<Id>{roleMap.get(invoice.Project__c)});  
                Approval.ProcessResult result = Approval.process(req1);
            }
        }
        
    }
}