public with sharing class VendorOnBoardingController {
    @AuraEnabled
    public static Boolean createContact(List<Contact> ConList){
        Boolean contactCreated=false;
        try {
            System.debug('contact list'+ConList);
            Database.SaveResult[] srList = Database.insert(ConList, false);
            System.debug('srList---'+srList);
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    contactCreated=true;
                } 
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return contactCreated;
    }

    @AuraEnabled
    public static List<Columns> getColumns(String fields,String objectName,String fieldSetName){
      System.debug('fields----'+fields+'object---------'+objectName);
      List<Columns> columnList = new List<Columns>();
      if(String.isNotBlank(fields)){
        String[] fieldsData  = fields.split(',');
        for(String data:fieldsData){
          //System.debug('Data------>'+data);
          String fieldTypeName = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(data).getDescribe().getType().name(); 
          String fieldlable = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(data).getDescribe().getlabel();
          Columns column = new Columns();
          column.apiName=data;
          column.label=fieldlable;
          column.type=fieldTypeName; 
          columnList.add(column);
        }
        
        }else{
          List<Schema.FieldSetMember> fieldSetMembers = ((SObject)Type.forName(objectName).newInstance()).getSObjectType().getDescribe().FieldSets.getMap().get(fieldSetName).getFields();
          try {
            for (Schema.FieldSetMember fieldSetMember : fieldSetMembers)
            {
              Columns column = new Columns();
              column.apiName=fieldSetMember.fieldPath;
              column.label=fieldSetMember.label;
              column.type=String.valueOf(fieldSetMember.getType());
              columnList.add(column);
            }
          }
          catch(Exception ex) {
              throw new AuraHandledException(ex.getMessage());
          }
        }
        System.debug('columnList----------->'+columnList);
        return columnList;
        //return JSON.serialize(columnList);
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
    public class Columns{
        @AuraEnabled
        public String label{get;set;}
        @AuraEnabled
        public String apiName{get;set;}
        @AuraEnabled
        public String type{get;set;}
      }
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
    public static void updateAccount(Account accData){
      try {
          system.debug('Account---<>'+accData);
              update accData;  
         
      } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
      }
    }

    @AuraEnabled(cacheable = true)
    public static Account getAccountData(String accId){
      Account accountVar=new Account();
      try {
        accountVar=[select Certificate_of_Incorporate_Registration__c,TAX_Identification_Number__c,GSTVAT_Registration_Certificate__c,Service_Tax_Registration_Number__c,Tax_Information__c,Cancel_Check_of_Bank_Account_Number__c from Account where Id=:accId];
        System.debug('accountVar--->'+accountVar);
      } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
      }
      return accountVar;
    }

    @AuraEnabled
    public static void createMultipleContact(List<Contact> ConList,String accId){
        try {
          if (!ConList.isEmpty()) {
            List<contact> newContactList= new List<contact>();
            for(Contact con:ConList){
              con.AccountId=accId;
              newContactList.add(con);
            }
            if(!newContactList.isEmpty()){
                Insert newContactList;  
            }  
            System.debug('newContactList'+newContactList);
        } 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}