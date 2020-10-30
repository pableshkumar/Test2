trigger ContentDocumentLink_Trigger on ContentDocumentLink (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        Set<ID> contentDocIds = new Set<ID>();
        for(ContentDocumentLink cdl: Trigger.new){
            contentDocIds.add(cdl.ContentDocumentId);
        }
        
        Set<Id> eventIds = new Set<Id>();
        Map<String,String> eventMap = new Map<String,String>();
        
        for(ContentDocumentLink cdlObj: Trigger.new)
        {
            System.debug('checking vendor obj-14->'+String.valueOf(cdlObj.LinkedEntityId).startsWith('a0E'));
            if(String.valueOf(cdlObj.LinkedEntityId).startsWith('a0E')){ //Check if file is uploaded on event object
                eventIds.add(cdlObj.LinkedEntityId);
                system.debug('event ids--17-->' +eventIds);
            }
            
        }
        for(Vendor_Enquiry__c e:[select id,name from Vendor_Enquiry__c where Id IN:eventIds]){
            eventMap.put(e.Id, e.name);
            system.debug('eventMap--23-->'+ eventMap);
            for(Account acc:[select id,Vendor_Enquiry_Id__c from Account where Vendor_Enquiry_Id__c=:eventMap.values()]){
               eventMap.put(e.Id, acc.Id); 
            }
        }
        Map<String,String> parentRecMap = new Map<String,String>();
        for(ContentDocumentLink cdl: Trigger.new){
            System.debug('line 27 ' + String.valueOf(cdl.LinkedEntityId).startsWith('a0E'));
            if(String.valueOf(cdl.LinkedEntityId).startsWith('a0E')){ //Check if file is uploaded on event object
                system.debug('Line 29 -->' +String.valueOf(eventMap.get(cdl.LinkedEntityId)).startsWith('001'));
                if(String.valueOf(eventMap.get(cdl.LinkedEntityId)).startsWith('001')) //Check if event parent is Account 
                    parentRecMap.put(cdl.ContentDocumentId, eventMap.get(cdl.LinkedEntityId)); //Map<ContentDocumentId,AccountId>
                    system.debug('parentRecMap' + parentRecMap);
            }
            
        }
        List<ContentDocumentLink> cdl_List = new List<ContentDocumentLink>();
        //if(ContentDocumentLink_TriggerHelper.Flag == true){
            //ContentDocumentLink_TriggerHelper.Flag = false;
            for(String str: parentRecMap.keySet()){
                system.debug('str values--->' + str);
                ContentDocumentLink cdl = new ContentDocumentLink(); // Content Document Link to share the file with Account(Parent) record
                system.debug('parent rec' +parentRecMap.get(str));
                cdl.LinkedEntityId = parentRecMap.get(str); // Account ID
                cdl.ContentDocumentId = str; //Content Dcoument ID
                cdl.ShareType = 'V';
                //cdl.Visibility = 'InternalUsers';
                cdl_List.add(cdl);
                
            }
        //}
        system.debug('Size : '+ cdl_List);
        if(cdl_List.size()>0)
            ContentDocumentLink_TriggerHelper.shareFile(cdl_List);// Insert Content Document Link to share the file with Account 
        
    }
}