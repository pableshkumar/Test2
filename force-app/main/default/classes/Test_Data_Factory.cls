/******************************************************
*Class Name: Test_Data_Factory
*Description : will hold test data that will be used in test classes
*Date:  Sep 2020
*Developer Name: Vineet Kumar
******************************************************/
@isTest
public class Test_Data_Factory {
    
    public static Account createAccount(String recordTypeName)
    {
        Account acc=new Account();
        acc.Name='TaTa';
        acc.Type='Partner';
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return acc;      
    }
    
    public static Contact createContact()
    {
        Contact con=new Contact();
        con.firstName='Albert';
        con.LastName='K';
        con.Email='albert@manras.com'; 
        return con;
    }
    
    public static Project__c createProject(String billingFrequency)
    {
        List<Project__c> projList=new List<Project__c>();
        Project__c proj=new Project__c();
        proj.Name='SFDC Impl';
        proj.Project_Start_Date__c=Date.today();
        proj.Project_End_Date__c=Date.today()+5;
        proj.Payment_Term__c='NET10';
        proj.Total_IT_Billing_Entity__c='Total It Consult LLP';
        proj.Billing_Frequency__c=billingFrequency;
      //  proj.Last_Billing_Date__c=Date.today()-1;
        return proj;
    }
    
    public static Project_Team__c createProjectTeam(String recordTypeName, Boolean primary)
    {
        Project_Team__c pt=new Project_Team__c();
        pt.Project_Role__c='SDM';
        pt.User__c=UserInfo.getUserId();
        pt.Primary__c=primary;
        pt.RecordTypeId=Schema.SObjectType.Project_Team__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return pt;
        
    }
    
    public static Billing_Information__c createBillingInformation()
    {
        Billing_Information__c bi=new Billing_Information__c();
        bi.Billing_Start_Date__c=System.today();
        bi.Billing_End_Date__c=System.today()+5;
        return bi;
        
    }
    
    
}