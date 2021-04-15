trigger ProjectTrigger on Project__c (after insert, after update, after delete) {
    Id rId = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
    list<project__c> projectList = new list<project__c>();
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
        
        if(projectList.size() > 0 ){              
            ProjectTriggerHandler.UpdateTotalSumOfVendorProjects(projectList);
			ProjectTriggerHandler.UpdateTotalAmountOfVendorProjects(projectList);
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
            ProjectTriggerHandler.UpdateTotalAmountOfVendorProjects(projectList);

        }
    }
    
}