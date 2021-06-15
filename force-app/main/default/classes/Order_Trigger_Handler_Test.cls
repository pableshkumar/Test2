@isTest
public class Order_Trigger_Handler_Test {
    
    @TestSetup
   public static void testDataCreation(){
       	list<order__c> orderList = new list<order__c>();
        Account venAcc= Test_Data_Factory.createAccount('Vendor');
      	venAcc.Type_of_Partner__c = 'Contractor';
       	venAcc.Status__c = 'Active';
        venAcc.BillingStreet = 'Old';
        venAcc.BillingCity = 'Kaithal';
        venAcc.BillingState = 'Haryana';
        venAcc.BillingPostalCode = '136027';
        venAcc.BillingCountry = 'India';
        venAcc.ShippingStreet = 'Test';
        venAcc.ShippingCity = 'Siwan';
        venAcc.ShippingState = 'Haryana';
        venAcc.ShippingPostalCode = '136027';
        venAcc.ShippingCountry = 'India';
        insert venAcc;
        
        Account cusAcc= Test_Data_Factory.createAccount('Customer');
        insert cusAcc;
        
        Contact con=Test_Data_Factory.createContact();
        con.AccountId = venAcc.Id;
        con.MobilePhone = '9090909889';
        insert con;
        
        TIG_Entity__c tig = Test_Data_Factory.createTIGEntity();
        insert tig;
        
        Project__c cusProjMonthly=Test_Data_Factory.createProject('Monthly','Customer');
        cusProjMonthly.Customer__c=cusAcc.Id;
        cusProjMonthly.End_Customer__c=cusAcc.Id;
        cusProjMonthly.Total_Vendor_Projects_Amount__c = 100;
        cusProjMonthly.TIG_Entity_Name__c = tig.Id;
        cusProjMonthly.Billing_Frequency__c='Monthly';
        insert cusProjMonthly;
        
        Project__c venProjMonthly=Test_Data_Factory.createProject('Monthly','Vendor');
        venProjMonthly.Customer__c = venAcc.Id;
        venProjMonthly.Customer_Project__c = cusProjMonthly.Id;
        venProjMonthly.TIG_Entity_Name__c = tig.Id;
        venProjMonthly.Total_PO_Amount__c = 100;
        venProjMonthly.Billing_Frequency__c='Monthly';
        insert venProjMonthly; 
        
        Order__c sOr = Test_Data_Factory.createOrder('Sales Order');
        sOr.Customer__c = cusAcc.Id;
        sOr.Project__c = cusProjMonthly.Id;
       	sOr.PO_Start_Date__c=system.today();
        sOr.PO_End_Date__c=system.today()+4;
       	sOr.PO_Amount__c = 200;
        sOr.Bill_to_Address__c = 'Address';
        sOr.Ship_to_Address__c = 'shipTo';
        insert sOr;
        
        Order__c pOr = Test_Data_Factory.createOrder('Purchase Order');
        pOr.Customer__c =venAcc.Id;
        pOr.Vendor_Contact__c = con.Id;
        pOr.Project__c =venProjMonthly.Id;
       	pOr.PO_Start_Date__c=system.today()+1;
        pOr.PO_End_Date__c=system.today()+2;
       	pOr.PO_Amount__c = 100;
       // pOr.Fiscal_Year__c = Date.Today().Year();
        pOr.Customer_Purchase_Order__c = sOr.Id;
        pOr.Delivery_Instructions__c = 'Delivery';
        pOr.Ship_to_Address__c = 'Shipping';
            insert pOr;
        orderList.add(pOr);
    }
    public static TestMethod void testOrderTriggerHandler(){
        OrderTriggerHandler.updateFiscalYear([Select Name, PO_Status__c, Customer__c, Project__c, Vendor_Contact__c, Customer_Purchase_Order__c, PO_Start_Date__c, PO_End_Date__c, PO_Amount__c, Tax_Included__c, Delivery_Instructions__c, Ship_to_Address__c, Order__c.RecordTypeId From Order__c]);
        
    }
}