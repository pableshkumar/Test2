@isTest
public class Billing_Information_Trigger_Handler_Test {
    
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
        insert projOneTime;
        
        Project__c weekly=Test_Data_Factory.createProject('Weekly','Customer');
        weekly.Customer__c=acc.id;
        weekly.End_Customer__c=acc.id;
        insert weekly;
        
        /*   Billing_Information__c bill=Test_Data_Factory.createBillingInformation();
bill.Project__c=projOneTime.id;
insert bill;  */
        
        Project_Team__c pt=Test_Data_Factory.createProjectTeam('Internal',True);
        pt.Project__c=projOneTime.Id;
        insert pt;
        
        Project_Team__c pt1=Test_Data_Factory.createProjectTeam('External',True);
        pt1.Project__c=projOneTime.Id;
        insert pt1;    
        
        /*  Project_Team__c pt2=Test_Data_Factory.createProjectTeam('External',True);
pt2.Project__c=weekly.Id;
insert pt2; */
    }
    
    public TestMethod static void testBillingApproval1()
    {
        try{
            Billing_Information__c bi=[Select id from Billing_Information__c where Project__r.Billing_Frequency__c='One Time'];
            bi.Billing_Approval_Status__c='Sent to AR Manager';
            bi.Approved_by_AR_Manager__c=true;
            update bi;
        }Catch(Exception ex)
        {
            System.Assert(ex.getMessage().contains(Label.Submit_to_AR_Head_or_Client_SDM));
            
        }
        
        Billing_Information__c bi=[Select id from Billing_Information__c where Project__r.Billing_Frequency__c='One Time'];
        bi.Billing_Approval_Status__c='Sent to AR Manager';
        update bi;
        
        Billing_Information__c bi1=[Select id from Billing_Information__c where Project__r.Billing_Frequency__c='One Time'];
        bi1.Billing_Approval_Status__c='Sent to AR Head';
        update bi1;
        
        Billing_Information__c bi2=[Select id from Billing_Information__c where Project__r.Billing_Frequency__c='One Time'];
        bi2.Billing_Approval_Status__c='Sent to Client SDM';
        update bi2;
        
    }
    
    public TestMethod static void testBillingApproval2()
    {      
        Try{
            Billing_Information__c weeklyBilling1=[Select id from Billing_Information__c where Project__r.Billing_Frequency__c='Weekly'];
            weeklyBilling1.Billing_Approval_Status__c='Sent to AR Manager';
            update weeklyBilling1; 
            
            Billing_Information__c weeklyBilling2=[Select id from Billing_Information__c where Project__r.Billing_Frequency__c='Weekly'];
            weeklyBilling2.Billing_Approval_Status__c='Sent to Client SDM';
            update weeklyBilling2;
        }Catch(Exception ex)
        {
            System.Assert(ex.getMessage().contains(Label.Add_Primary_Internal_SDM_Error_Message));
            
        }
    }
}