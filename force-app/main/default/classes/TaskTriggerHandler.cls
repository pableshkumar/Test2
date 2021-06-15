public class TaskTriggerHandler {
    public static void updateFieldOnPO(List <task> taskList){
        Set <Id> taskId = New Set<Id>();
        // Fetch the prefix of Order record
        String OrderPrefix  = Schema.SObjectType.Order__c.getKeyPrefix();
        for(Task tsk: taskList){
            //Checking if WhatId on task is not empty & not null
            if((String.ValueOf(tsk.WhatId)) != null && (String.ValueOf(tsk.WhatId)) != ''){
                system.debug('WhatId' +tsk.WhatId);
                if(tsk.Status == 'Completed' && tsk.Subject == 'PO Closure request by Finance Team' && ((String)tsk.WhatId).startsWith(OrderPrefix)){
                    taskId.add(tsk.WhatId);
                } 
            }
        }
        if(taskList.size()>0){
            Map<string,Order__c> mapOrderIdToOrder = new Map<string,Order__c>();
            Id Ort = Schema.SObjectType.Order__c.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId();
            List<Order__c> OrderList = [Select Id, Name, Ready_to_Close__c From Order__c Where Id IN : taskId AND recordtypeid =: Ort];
            for(Order__c objOrder : OrderList){
                mapOrderIdToOrder.put(objOrder.Id,objOrder);             
            }
            for(Task tsk1 : taskList){
                if(mapOrderIdToOrder.get(tsk1.WhatId) !=null)
                {
                    Order__c objOrder = mapOrderIdToOrder.get(tsk1.WhatId);
                    system.debug('objOrder after Tasksize is more than zero' +objOrder);
                    if(objOrder.Ready_to_Close__c == False){
                        tsk1.addError('Please mark Ready to Close as checked on PO related to this task: '+objOrder.Name);
                    }
                }
            }
            Update OrderList;
        }
    }
}