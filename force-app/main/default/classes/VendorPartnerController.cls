public with sharing class VendorPartnerController {
    @AuraEnabled
    public static void savePartner(List<Vendor_Partner_Presence__c> partnerList,String accId){
        try {
            if (!partnerList.isEmpty()) {
                List<Vendor_Partner_Presence__c> newPartnewList= new List<Vendor_Partner_Presence__c>();
                for(Vendor_Partner_Presence__c partner:partnerList){
                    partner.Company__c=accId;
                    newPartnewList.add(partner);
                }
                if(!newPartnewList.isEmpty()){
                    Insert newPartnewList;  
                }  
                System.debug('newPartnewList'+newPartnewList);
            }
           
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List < Map < String, String >> getPickListValues(String objApiName, String fieldName) {
        List < Map < String, String >> options = new List < Map < String, String >> ();
        Map < String, Schema.SObjectType > objGlobalMap = Schema.getGlobalDescribe();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objApiName);
        if (objType == null) {
            return options;
        }
        Schema.DescribeSObjectResult sobjectDescribe = objType.getDescribe();
        Map < String, Schema.SObjectField > fieldMap = sobjectDescribe.fields.getMap();
        if (fieldMap.get(fieldName) == null) {
            return options;
        }
        List < Schema.PicklistEntry > pickListValues = fieldMap.get(fieldName).getDescribe().getPickListValues();
        for (Schema.PicklistEntry f: pickListValues) {
            Map < String, String > values = new Map < String, String > {
                'label' => f.getLabel(),
                'value' => f.getValue()
            };
            options.add(values);
        }
        return options;
    }
}