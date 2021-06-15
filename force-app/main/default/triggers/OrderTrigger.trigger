trigger OrderTrigger on Order__c (before insert, before update, after insert, after update, after delete, after undelete){
    Set<id> SetId = new Set<id>();
    list<order__c> orList = new List<order__c>();
    Id Ort = Schema.SObjectType.Order__c.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId();
    if((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate)) {
        if(Trigger.New.Size()>0){
        for(Order__c ord : trigger.new){
                if((ord.RecordTypeId == Ort && ord.Fiscal_Year__c == null) || (ord.RecordTypeId == Ort && ord.Fiscal_Year__c != null)){
                    system.debug('------ in the Before loop -----');
                  orList.add(ord);  
                }
            }   
            system.debug('code in trigger');
        OrderTriggerHandler.updateFiscalYear(orList);
        }
    }
    if(trigger.isAfter){
    if(trigger.isInsert || trigger.isundelete){  
         for(Order__c ord : trigger.new){
                if(ord.RecordTypeId == Ort && ord.Fiscal_Year__c != null){
                    system.debug('>>>>> in the After loop <<<<<');
                  orList.add(ord);  
                }
            }
        for(Order__c or1 : orList){   
            SetId.add(or1.Project__c);
        }
     }
       else if(trigger.isDelete){
           for(Order__c ord : trigger.old){
                if(ord.RecordTypeId == Ort && ord.Fiscal_Year__c != null){
                  orList.add(ord);  
                }
               }
         for(Order__c or2 : orList){   
            SetId.add(or2.Project__c);
        }   
        }
        else if(trigger.isupdate){
               for(Order__c ord : trigger.new){
                if(ord.RecordTypeId == Ort && ord.Fiscal_Year__c != null){
                  orList.add(ord);  
                }
               }
         for(Order__c or3 : orList){
            if(or3.Project__c != null){
                if(trigger.oldmap.get(or3.id).Project__c != or3.Project__c){
                    SetId.add(or3.Project__c);     
                }
            } 
            SetId.add(trigger.oldmap.get(or3.id).Project__c);
    }
    }
    }
    
    if(SetId.size() > 0){
        OrderTriggerHandler.updateCurrentFiscalYearPO(SetId);
    }
}