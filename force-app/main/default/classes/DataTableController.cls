public with sharing class DataTableController {
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
   
    public class Columns{
      @AuraEnabled
      public String label{get;set;}
      @AuraEnabled
      public String apiName{get;set;}
      @AuraEnabled
      public String type{get;set;}
    }

}