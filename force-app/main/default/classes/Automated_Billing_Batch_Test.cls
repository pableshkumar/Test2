@isTest
public class Automated_Billing_Batch_Test {
    
    @TestSetup
    public static void testDataCreation()
    {
        Account acc= Test_Data_Factory.createAccount('Customer');
        insert acc;
        Contact con=Test_Data_Factory.createContact();
        insert con;
        
        Project__c projOneTime=Test_Data_Factory.createProject('One Time');
        projOneTime.Customer__c=acc.id;
        projOneTime.End_Customer__c=acc.id;
        projOneTime.Billing_Frequency__c='One Time';
        insert projOneTime;
        
        Project__c projWeekly=Test_Data_Factory.createProject('Weekly');
        projWeekly.Customer__c=acc.id;
        projWeekly.End_Customer__c=acc.id;
        projWeekly.Billing_Frequency__c='Weekly';
        insert projWeekly;
        
        Project__c projBiWeekly=Test_Data_Factory.createProject('Bi-Weekly');
        projBiWeekly.Customer__c=acc.id;
        projBiWeekly.End_Customer__c=acc.id;
        projBiWeekly.Billing_Frequency__c='Bi-Weekly';
        insert projBiWeekly;
        
        Project__c projMonthly=Test_Data_Factory.createProject('Monthly');
        projMonthly.Customer__c=acc.id;
        projMonthly.End_Customer__c=acc.id;
        projMonthly.Billing_Frequency__c='Monthly';
        insert projMonthly; 
            
        Project__c projQuarterly=Test_Data_Factory.createProject('Quarterly');
        projQuarterly.Customer__c=acc.id;
        projQuarterly.End_Customer__c=acc.id;
        projQuarterly.Billing_Frequency__c='Quarterly';
        insert projQuarterly; 
        
        Project__c projHalfYearly=Test_Data_Factory.createProject('Half-Yearly');
        projHalfYearly.Customer__c=acc.id;
        projHalfYearly.End_Customer__c=acc.id;
        projHalfYearly.Billing_Frequency__c='Half-Yearly';
        insert projHalfYearly;
        
        Project__c projYearly=Test_Data_Factory.createProject('Yearly');
        projYearly.Customer__c=acc.id;
        projYearly.End_Customer__c=acc.id;
        projYearly.Billing_Frequency__c='Yearly';
        insert projYearly;
        
        Project_Team__c pt=Test_Data_Factory.createProjectTeam('Internal',False);
        pt.Project__c=projOneTime.Id;
        insert pt;
    }

    public static TestMethod void testAutomated_Billing_Batch()
    {
        Database.executeBatch(new Automated_Billing_Batch(), 20);
       // Project_Trigger_Handler.createAutomatedBillingInfo([SELECT Name,Project_Start_Date__c,Project_End_Date__c,Payment_Term__c,Billing_Frequency__c from Project__c]);
    }
}