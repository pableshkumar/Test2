trigger TaskTrigger on Task (after insert) {
   if(Trigger.isAfter && Trigger.isInsert){
        Set <String> taskIDs = new Set <String> ();
        for(Task tList: Trigger.new){
            string ids = tList.WhatId;
            string trids = ids.substring(0,ids.length()-3);
            system.debug('trimed ids--->'+trids);
            taskIDs.add(trids);
            //taskIDs.add(tList.whatId);
            system.debug('taskIds---->' + taskIDs);
        }
        Map<String,String> vendorMap = new Map<String,String>();
        /*for(Task cdlObj: Trigger.new){
            if(String.valueOf(cdlObj.WhatId).startsWith('a02')){ //Check if file is uploaded on vendor object
                vendorIds.add(cdlObj.WhatId);
                system.debug('vendorIds-13-->' +vendorIds);
            }	
            
        }*/
        
        for(Vendor_Enquiry__c e:[select id,name from Vendor_Enquiry__c where Id =:taskIDs]){
            vendorMap.put(e.Id, e.name);
            for(Account acc:[select id,Vendor_Enquiry_Id__c from Account where Vendor_Enquiry_Id__c=:vendorMap.values()]){
               vendorMap.put(e.Id, acc.Id); 
               system.debug('vendorMap ----> '+vendorMap); 
            }
        }
        Map<String,String> parentRecMap = new Map<String,String>();
        for(Task rltTasks: Trigger.new){
            System.debug('line 27 ' + String.valueOf(rltTasks.WhatID).startsWith('a0E'));
            if(String.valueOf(rltTasks.WhatID).startsWith('a0E')){ //Check if file is uploaded on Vendor Enquiry object
                system.debug('Line 29 -->' +String.valueOf(vendorMap.get(rltTasks.WhatID)).startsWith('001'));
                if(String.valueOf(vendorMap.get(rltTasks.WhatID)).startsWith('001')) //Check if vendor parent is Account 
                    parentRecMap.put(rltTasks.Id, vendorMap.get(rltTasks.WhatID)); //Map<ContentDocumentId,AccountId>
                    system.debug('parentRecMap' + parentRecMap);
            }
            
        }
        List<Task> ts_List = new List<Task>();
        for(String str: parentRecMap.keySet()){
                system.debug('str values--->' + str);
                Task t = new Task(); // Content Document Link to share the file with Account(Parent) record
                system.debug('parent rec---43-->' +parentRecMap.get(str));
                t.WhatId = parentRecMap.get(str); // Account ID
                t.Id = str; //Task ID
                ts_List.add(t); 
            system.debug('ts_List-47-->'+ts_List);
            }
        
        Task_TriggerHelper.shareTask(ts_List);
        //	upsert ts_List;
    }  
}