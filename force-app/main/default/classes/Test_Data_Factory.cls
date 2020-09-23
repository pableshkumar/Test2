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
        acc.Customer_Code__c='ABC';
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
    
    
    public static Project__c createProject(String billingFrequency, String recordTypeName)
    {
        List<Project__c> projList=new List<Project__c>();
        Project__c proj=new Project__c();
        proj.Name='SFDC Impl';
        proj.Project_Start_Date__c=Date.today();
        proj.Project_End_Date__c=Date.today().addDays(5);
        proj.Payment_Term__c='NET10';
        proj.Total_IT_Billing_Entity__c='Total It Consult LLP';
        proj.Billing_Frequency__c=billingFrequency;
        proj.RecordTypeId=Schema.SObjectType.Project__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
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
    
    public static TIG_Entity__c createTIGEntity()
    {
        TIG_Entity__c tigEntity=new TIG_Entity__c();
        tigEntity.Name='TIG India LLC';
        tigEntity.TIG_Entity_Code__c='TIL';
        tigEntity.Bank_Name__c='PNB';
        tigEntity.Bank_Account_Number__c='20385798654854';
        tigEntity.Account_Name__c='TotalITIndia';
        tigEntity.BSB__c='BSB';
        tigEntity.Email_Address_for_Remittance__c='tig@gmail.com';
        tigEntity.Email_for_Contact__c='tig@gmail.com';
        // tigEntity.Last_Generated_Invoice_Number__c
        tigEntity.Notes__c='notes';
        tigEntity.Street_Address__c='street0';
        tigEntity.Zip_Postal_Code__c='897584';
        tigEntity.City__c='Banaras';
        tigEntity.State1__c='Delhi';
        tigEntity.Country1__c='India';
        tigEntity.Swift__c='swt';
        tigEntity.Tax_Code__c='secret';
        tigEntity.Tax_Name__c='confidential';
        return tigEntity;
        
    }    
    public static Order__c createOrder(String recordTypeName)
    {
        Order__c ord=new Order__C();
        ord.Name='Sales Order';
        ord.PO_Status__c='Draft';
        ord.PO_Start_Date__c=system.today();
        ord.PO_End_Date__c=system.today()+1;
        ord.PO_Amount__c=100;
        ord.RecordTypeId=Schema.SObjectType.Order__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return ord;
    }
    
    public static Invoice__c createInvoice(String recordTypeName)
    {
        Invoice__c inv=new Invoice__c();
        inv.Invoice_Date__c=System.today();
        inv.RecordTypeId=Schema.SObjectType.Invoice__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return inv;
    }
    
    public static Project_Sites__c createSite()
    {
        Project_Sites__c site=new Project_Sites__c();
        site.Name='Delhi';
        site.Address__c='ABC';
        site.City__c='Delhi';
        site.Country1__c='India';
        site.State1__c='Delhi';
        site.ZIP_Postal_Code__c='898574';
        site.Site_Classification__c='Metro';
        return site;
    }
    
    public static Project_Services__c createService(String recordTypeName)
    {
        Project_Services__c service=new Project_Services__c();
        service.Name='FTE';
        service.Service_Start_Date__c=System.today();
        service.Service_End_Date__c=System.today()+1;
        service.Category__c='Storage';
        service.Skill_Level__c='L2';
        service.RecordTypeId=Schema.SObjectType.Project_Services__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return service;
    }
    
    public static Invoice_Line_Item__c createInvoiceLineItem()
    {
        Invoice_Line_Item__c invLineItem=new Invoice_Line_Item__c();
        invLineItem.Amount__c=20;
        return invLineItem;
    }
}