trigger ProjectTrigger on Project__c (after insert, after update, after delete) {
    Id rId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
    list<project__c> projectList = new list<project__c>();
    list<project__c> proList = new list<project__c>();
    Set<id> setid = new Set<id>();
    if(trigger.isInsert && trigger.isAfter){
        ProjectTriggerHandler.createAutomatedBillingInfo(Trigger.New);
    }
    
    if(Trigger.isAfter){
        shareito.ShareITInit shareInit = new shareito.ShareITInit(shareito.ShareITType.FULL);
        shareInit.processSharing();
    }
    if((trigger.isInsert && trigger.isAfter)||(trigger.isUpdate && trigger.isAfter)){
        for(project__c pro : trigger.new){
            if(pro.recordtypeid == rId){
                projectList.add(pro);
            }
        }
        if(trigger.isUpdate && trigger.isAfter){
            for(project__c pro : trigger.new){
                if(pro.RecordTypeId == rId){
                  proList.add(pro);  
                }
            }
            
            if(prolist.size() > 0){
                for(project__c pro: prolist){
                    if(pro.Customer_Project__c != null){
                        if(trigger.oldmap.get(pro.Id).Customer_Project__c != pro.Customer_Project__c){
                         setID.add(pro.Customer_Project__c);   
                        }
                    }
                  setID.add(trigger.oldmap.get(pro.Id).Customer_Project__c);  
                }
            }
            
            if(setID.size() > 0){
                ProjectTriggerHandler.updateCurrentFiscalYearVendorProjectsAmountOnCustomerProject(setId);
            }
        }
        
        if(projectList.size() > 0 ){              
            ProjectTriggerHandler.UpdateTotalSumOfVendorProjects(projectList);
		//	ProjectTriggerHandler.UpdateTotalAmountOfVendorProjects(projectList);
        }
    }
    if(trigger.isdelete && trigger.isAfter){
        for(project__c pro : trigger.old){
            if(pro.recordtypeid == rId){
                projectList.add(pro);
            }
        }
        if(projectList.size() > 0 ){              
            ProjectTriggerHandler.UpdateTotalSumOfVendorProjects(projectList);
         //   ProjectTriggerHandler.UpdateTotalAmountOfVendorProjects(projectList);
        }
    }
}