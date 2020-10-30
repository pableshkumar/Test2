trigger ContentDocumentLink_Trigger on ContentDocumentLink (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        Set<ID> contentDocIds = new Set<ID>();
        for(ContentDocumentLink cdl: Trigger.new){
            contentDocIds.add(cdl.ContentDocumentId);
        }
        
        Set<Id> vendorIds = new Set<Id>();
        Map<String,String> vendorMap = new Map<String,String>();
        
        for(ContentDocumentLink cdlObj: Trigger.new)
        {
            //Check if file is uploaded on Vendor object
            if(String.valueOf(cdlObj.LinkedEntityId).startsWith('a0E')){ 
                vendorIds.add(cdlObj.LinkedEntityId);
            }
            
        }
        for(Vendor_Enquiry__c e:[select id,name from Vendor_Enquiry__c where Id IN:vendorIds]){
            vendorMap.put(e.Id, e.name);
            for(Account acc:[select id,Vendor_Enquiry_Id__c from Account where Vendor_Enquiry_Id__c=:vendorMap.values()]){
               vendorMap.put(e.Id, acc.Id); 
            }
        }
        Map<String,String> parentRecMap = new Map<String,String>();
        for(ContentDocumentLink cdl: Trigger.new){
            System.debug('line 27 ' + String.valueOf(cdl.LinkedEntityId).startsWith('a0E'));
            //Check if file is uploaded on Vendor object
            if(String.valueOf(cdl.LinkedEntityId).startsWith('a0E')){ 
                //Check if event parent is Account
                if(String.valueOf(vendorMap.get(cdl.LinkedEntityId)).startsWith('001'))  
                    //Map<ContentDocumentId,AccountId>
                    parentRecMap.put(cdl.ContentDocumentId, vendorMap.get(cdl.LinkedEntityId)); 
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