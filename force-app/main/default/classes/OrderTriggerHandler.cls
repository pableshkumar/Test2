public class OrderTriggerHandler {
    //Method to update fiscal year on Purchase Order records
    public static void updateFiscalYear(List <Order__c> POList){
        List <Order__c> PORecords = New List<Order__c>();
        //Query to fetch only 'Purchase Order' records of Order object
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Order__c' AND Name = 'Purchase Order'];
        for(Order__c ord : POList){
            if(ord.RecordTypeId == rt.Id){
                system.debug('PORecordType'+ord.RecordTypeId);
                system.debug('PO Start Date'+ord.PO_Start_Date__c);
                if(FiscalYear.GetFiscalYear(ord.PO_Start_Date__c) == ''){
                    ord.adderror('Fiscal Year is not defined for this order Start Date');
                }
                   else{
                ord.Fiscal_Year__c = FiscalYear.GetFiscalYear(ord.PO_Start_Date__c);
                system.debug('Fiscal Year at PO'+ ord.Fiscal_Year__c);
                   }
                PORecords.add(ord);
            }
        }
 system.debug('PO Records'+PORecords);
    }
    //Method to update PO of current Fiscal Year on Vendor Project
    public static void updateCurrentFiscalYearPO(Set<Id> ProjId){
        List<Order__c> PRecords = New List<Order__c>();
        List<Project__c> VenProjList = New List<Project__c>();
        set<string> stDate = new set<string>();
        //Schema to fetch 'Vendor' record type of Project object
        Id Prt = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        //Schema to fetch 'Purchase Order' record type of Order object
        Id Ort = Schema.SObjectType.Order__c.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId();
        decimal year = Date.Today().Year();
        
        if(ProjId.size()>0){
         /*   for(order__c st : [select id, name,PO_Start_Date__c,Fiscal_Year__c,project__c from Order__c where project__c in:ProjId ]){
              stDate.add(st.Fiscal_Year__c);  
                system.debug('JJJJJJJJJJJJJJJJJJJJJ'+ stDate);
            } */
        VenProjList = [SELECT Id, Total_Project_Value__c, (SELECT Id, PO_Amount__c, PO_Start_Date__c FROM Sales_Orders__r where Fiscal_Year__c =:FiscalYear.GetFiscalYear(date.today()) AND recordtypeid =: Ort) FROM Project__c WHERE id IN:ProjId and Recordtypeid =: Prt];
           system.debug('Vendor Project'+ VenProjList);
            for(Project__c proj : VenProjList ){
            Decimal val = 0;
            for(Order__c sale : proj.Sales_Orders__r){
                val += sale.PO_Amount__c;
            } 
            proj.Total_PO_Amount__c = val;
        }
            update VenProjList;
        }
    }
}