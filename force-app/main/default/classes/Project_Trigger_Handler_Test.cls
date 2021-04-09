@isTest
public class Project_Trigger_Handler_Test {
    
    @TestSetup
    public static void testDataCreation()
    {
    //    List<Project__c> projectList = new List<Project__c>();
        Account acc= Test_Data_Factory.createAccount('Customer');
        insert acc;
        Contact con=Test_Data_Factory.createContact();
        insert con;
        
        Project__c projOneTime=Test_Data_Factory.createProject('One Time','Customer');
        projOneTime.Customer__c=acc.id;
        projOneTime.End_Customer__c=acc.id;
        projOneTime.Billing_Frequency__c='One Time';
        insert projOneTime;
        
        Project__c projWeekly=Test_Data_Factory.createProject('Weekly','Customer');
        projWeekly.Customer__c=acc.id;
        projWeekly.End_Customer__c=acc.id;
        projWeekly.Billing_Frequency__c='Weekly';
        insert projWeekly;
        
        Project__c projBiWeekly=Test_Data_Factory.createProject('Bi-Weekly','Customer');
        projBiWeekly.Customer__c=acc.id;
        projBiWeekly.End_Customer__c=acc.id;
        projBiWeekly.Billing_Frequency__c='Bi-Weekly';
        insert projBiWeekly;
        
        Project__c projMonthly=Test_Data_Factory.createProject('Monthly','Customer');
        projMonthly.Customer__c=acc.id;
        projMonthly.End_Customer__c=acc.id;
        projMonthly.Billing_Frequency__c='Monthly';
        insert projMonthly; 
        
        Project__c projQuarterly=Test_Data_Factory.createProject('Quarterly','Customer');
        projQuarterly.Customer__c=acc.id;
        projQuarterly.End_Customer__c=acc.id;
        projQuarterly.Billing_Frequency__c='Quarterly';
        insert projQuarterly; 
        
        Project__c projHalfYearly=Test_Data_Factory.createProject('Half-Yearly','Customer');
        projHalfYearly.Customer__c=acc.id;
        projHalfYearly.End_Customer__c=acc.id;
        projHalfYearly.Billing_Frequency__c='Half-Yearly';
        insert projHalfYearly;
        
        Project__c projYearly=Test_Data_Factory.createProject('Yearly','Customer');
        projYearly.Customer__c=acc.id;
        projYearly.End_Customer__c=acc.id;
        projYearly.Billing_Frequency__c='Yearly';
        insert projYearly;
        
        Project_Team__c pt=Test_Data_Factory.createProjectTeam('Internal', False);
        pt.Project__c=projOneTime.Id;
        insert pt;
    //done by Sahil Madan
     /*   Account CustomerAcc = Test_Data_Factory.createAccount('Customer');
        CustomerAcc.BillingStreet = 'Old';
        CustomerAcc.BillingCity = 'Kaithal';
        CustomerAcc.BillingState = 'Haryana';
        CustomerAcc.BillingPostalCode = '136027';
        CustomerAcc.BillingCountry = 'India';
        CustomerAcc.ShippingStreet = 'Test';
        CustomerAcc.ShippingCity = 'Siwan';
        CustomerAcc.ShippingState = 'Haryana';
        CustomerAcc.ShippingPostalCode = '136027';
        CustomerAcc.ShippingCountry = 'India';
        insert CustomerAcc;
        
		Account VendorAcc = Test_Data_Factory.createAccount('Vendor');
        VendorAcc.Name='TaTa';
        VendorAcc.Type='Partner';
        VendorAcc.Type_of_Partner__c = 'Indirect';
        VendorAcc.BillingStreet = 'Old';
        VendorAcc.BillingCity = 'Kaithal';
        VendorAcc.BillingState = 'Haryana';
        VendorAcc.BillingPostalCode = '136027';
        VendorAcc.BillingCountry = 'India';
        VendorAcc.ShippingStreet = 'Test';
        VendorAcc.ShippingCity = 'Siwan';
        VendorAcc.ShippingState = 'Haryana';
        VendorAcc.ShippingPostalCode = '136027';
        VendorAcc.ShippingCountry = 'India';
        insert VendorAcc;
        
        TIG_Entity__c tigEntity1 = Test_Data_Factory.createTIGEntity();
        tigEntity1.Name='TIG Kaithal';
        tigEntity1.TIG_Entity_Code__c='KTL';
        tigEntity1.Tax_Name__c = 'test';
        tigEntity1.Tax_Code__c = '908';
        tigEntity1.Street_Address__c = 'Kaithal';
        tigEntity1.City__c = 'Kaithal';
        tigEntity1.Zip_Postal_Code__c = '136027';
        tigEntity1.State1__c = 'Haryana';
        tigEntity1.Country1__c = 'India';
        tigEntity1.Email_Address_for_Remittance__c='ktl@gmail.com';
        tigEntity1.Email_for_Contact__c='ktl@gmail.com';
        tigEntity1.OwnerId = UserInfo.getUserId();
        insert tigEntity1;
        
        Project__c CusProject = Test_Data_Factory.createProject('Monthly', 'Customer');
        CusProject.Name = 'KaithalCustomerProject';
        CusProject.Project_Start_Date__c = Date.today();
        CusProject.Project_End_Date__c = Date.today().addDays(5);
        CusProject.Customer__c = CustomerAcc.id;
        CusProject.End_Customer__c = CustomerAcc.id;
        CusProject.TIG_Entity_Name__c = tigEntity1.id;
        CusProject.Payment_Term__c = 'NET30';
        CusProject.Billing_Frequency__c ='Monthly';
        insert CusProject;
        
        Order__c SalesOrder = Test_Data_Factory.createOrder('Sales Order');
        SalesOrder.Name = 'KaithalSalesOrder';
        SalesOrder.PO_Status__c = 'Draft';
        SalesOrder.Customer__c = CustomerAcc.id;
        SalesOrder.Project__c = CusProject.id;
        SalesOrder.PO_Start_Date__c = Date.today();
        SalesOrder.PO_End_Date__c = Date.today().addDays(5);
        SalesOrder.PO_Amount__c = 1100;
        SalesOrder.Tax_Included__c = 'Yes';
        SalesOrder.Bill_to_Address__c = 'Test';
        SalesOrder.Ship_to_Address__c = 'Test';
        insert SalesOrder;
        
               
		Project__c proj1 = Test_Data_Factory.createProject('Monthly', 'Vendor');
        proj1.Name = 'KaithalVendorProject';
        proj1.Project_Start_Date__c = Date.today();
        proj1.Project_End_Date__c = Date.today().addDays(5);
        proj1.Customer__c = VendorAcc.id;
        proj1.Customer_Project__c = CusProject.Id;
        proj1.TIG_Entity_Name__c = tigEntity1.id;
        proj1.Payment_Term__c = 'NET30';
        proj1.Billing_Frequency__c ='Monthly'; 
        insert proj1;
        
        Order__c ord1 = Test_Data_Factory.createOrder('Purchase Order');
        ord1.name = 'KaithalPO1';
        ord1.PO_Status__c = 'Draft';
        ord1.Customer__c = VendorAcc.id;
        ord1.Customer_Purchase_Order__c = SalesOrder.id;
        ord1.Project__c = proj1.id;
        ord1.PO_Start_Date__c = Date.today();
        ord1.PO_End_Date__c = Date.today().addDays(5);
        ord1.PO_Amount__c = 1000;
        ord1.Tax_Included__c = 'Yes';
        ord1.Delivery_Instructions__c = 'Test';
        ord1.Ship_to_Address__c = 'Test';
        projectList.add(proj1);
        
       	Order__c ord2 = Test_Data_Factory.createOrder('Purchase Order');
        ord2.name = 'KaithalPO2';
        ord2.PO_Status__c = 'Draft';
        ord2.Customer__c = VendorAcc.id;
        ord2.Customer_Purchase_Order__c = SalesOrder.id;
        ord2.Project__c = proj1.id;
        ord2.PO_Start_Date__c = Date.today();
        ord2.PO_End_Date__c = Date.today().addDays(5);
        ord2.PO_Amount__c = 1000;
        ord2.Tax_Included__c = 'Yes';
        ord2.Delivery_Instructions__c = 'Test';
        ord2.Ship_to_Address__c = 'Test';
        projectList.add(proj1);
        
projectList = [Select id, name from project__c where Customer_Project__c != null];
        system.debug('############'+projectList.size());
        ProjectTriggerHandler.UpdateTotalSumOfVendorProjects(projectList);
        */
    }
    
    public static TestMethod void testProjectTriggerHandler()
    {
        ProjectTriggerHandler.createAutomatedBillingInfo([SELECT Name,Project_Start_Date__c,Project_End_Date__c,Payment_Term__c,Billing_Frequency__c,Project__c.RecordTypeId from Project__c]);
    }
    
}