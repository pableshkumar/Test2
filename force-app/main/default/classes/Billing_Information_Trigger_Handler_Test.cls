@isTest
public class Billing_Information_Trigger_Handler_Test {

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
        
        
        Project_Team__c pt=Test_Data_Factory.createProjectTeam('Internal',False);
        pt.Project__c=projOneTime.Id;
        insert pt;
        
    }
    
    public TestMethod static void testBillingApproval()
    {
                Billing_Information__c bi=[Select id from Billing_Information__c];

       // bi.Billing_Approval_Status__c='Sent to AR Manager';
        //update bi;

    }
}