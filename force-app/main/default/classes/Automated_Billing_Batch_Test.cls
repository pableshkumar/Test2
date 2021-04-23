@isTest
public class Automated_Billing_Batch_Test {
    
    @TestSetup
    public static void testDataCreation()
    {
        Account acc= Test_Data_Factory.createAccount('Customer');
        insert acc;
        Contact con=Test_Data_Factory.createContact();
        insert con;
        
        Project__c projOneTime=Test_Data_Factory.createProject('One Time','Customer');
        projOneTime.Customer__c=acc.id;
        projOneTime.End_Customer__c=acc.id;
        projOneTime.Last_Billing_Date__c=Date.Today().addDays(-1);
        insert projOneTime;
        
        Project__c projWeekly=Test_Data_Factory.createProject('Weekly','Customer');
        projWeekly.Customer__c=acc.id;
        projWeekly.End_Customer__c=acc.id;
        insert projWeekly;
        
        Project__c projBiWeekly=Test_Data_Factory.createProject('Bi-Weekly','Customer');
        projBiWeekly.Customer__c=acc.id;
        projBiWeekly.End_Customer__c=acc.id;
        insert projBiWeekly;
        
        Project__c projMonthly=Test_Data_Factory.createProject('Monthly','Customer');
        projMonthly.Customer__c=acc.id;
        projMonthly.End_Customer__c=acc.id;
        insert projMonthly; 
        
        Project__c projQuarterly=Test_Data_Factory.createProject('Quarterly','Customer');
        projQuarterly.Customer__c=acc.id;
        projQuarterly.End_Customer__c=acc.id;
        insert projQuarterly; 
        
        Project__c projHalfYearly=Test_Data_Factory.createProject('Half-Yearly','Customer');
        projHalfYearly.Customer__c=acc.id;
        projHalfYearly.End_Customer__c=acc.id;
        insert projHalfYearly;
        
        Project__c projYearly=Test_Data_Factory.createProject('Yearly','Customer');
        projYearly.Customer__c=acc.id;
        projYearly.End_Customer__c=acc.id;
        insert projYearly;
        
        Project_Team__c pt=Test_Data_Factory.createProjectTeam('Internal',False);
        pt.Project__c=projOneTime.Id;
        insert pt;
    }
    
    public static TestMethod void testAutomated_Billing_Batch()
    {
        Automated_Billing_Batch ABB = New Automated_Billing_Batch();
        
        Database.QueryLocator ql = ABB.start(null);
        ABB.execute(null,[select OwnerId,Billing_Frequency__c, Project_Start_Date__c, Project_End_Date__c,Last_Billing_Date__c from Project__c]);
        ABB.Finish(null);
        
        ABB.execute(null);
    }
}