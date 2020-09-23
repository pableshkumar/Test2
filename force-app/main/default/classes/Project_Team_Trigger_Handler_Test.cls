@isTest
public class Project_Team_Trigger_Handler_Test {
    
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
        projOneTime.Billing_Frequency__c='One Time';
        insert projOneTime;
        
        Project__c Weekly=Test_Data_Factory.createProject('Weekly','Customer');
        Weekly.Customer__c=acc.id;
        Weekly.End_Customer__c=acc.id;
        Weekly.Billing_Frequency__c='Weekly';
        insert Weekly;        
        System.debug('projId :'+Weekly.id);
        
        List<Project_Team__c> teamList=new List<Project_Team__c>();
        Project_Team__c pt=Test_Data_Factory.createProjectTeam('Internal', False);
        pt.Project__c=projOneTime.Id;
        insert pt;
        Project_Team__c pt1=Test_Data_Factory.createProjectTeam('Internal', true);
        pt1.Project__c=projOneTime.Id;
        insert pt1;
        
    }
    
    public static TestMethod void TestFirstDefaultPrimary()
    {
        List<Project_Team__c> teamList=[Select RecordTypeId,RecordType.Name,User__c,Project_Role__c,Project__c, Primary__c FROM Project_Team__c];
        Project_Team_Trigger_Handler.firstDefaultPrimary(teamList);
    }
    
    public static TestMethod void testUpdatePrimaryProjectTeamMember()
    {
        List<Project_Team__c> teamList=[Select RecordTypeId,RecordType.Name,User__c,Project_Role__c,Project__c, Primary__c FROM Project_Team__c where primary__C=false limit 1];
        Project_Team__c pt=teamList[0];
        pt.Primary__c=true;
        update pt;
        
    }
    
    public TestMethod static void  testMethod1()
    {
        Project__c Weekly=Test_Data_Factory.createProject('Weekly','Customer');
        Weekly.Customer__c=[select id from Account limit 1].id;
        Weekly.End_Customer__c=[select id from Account limit 1].id;
        Weekly.Billing_Frequency__c='Weekly';
        insert Weekly;        
        
        System.debug('projId :'+Weekly.id);       // Project_Team_Trigger_Handler.updatePrimaryProjectTeamMember(teamList, NULL);
        Project_Team__c pt1=Test_Data_Factory.createProjectTeam('Internal', false);
        pt1.Project__c=Weekly.Id;
        insert pt1; 
        
        Project_Team__c pt2=Test_Data_Factory.createProjectTeam('Internal', false);
        pt2.Project__c=Weekly.Id;
        insert pt2; 
        Project_Team__c pt3=Test_Data_Factory.createProjectTeam('External', false);
        pt3.Project__c=Weekly.Id;
        insert pt3;  
        
        Project_Team__c pt4=Test_Data_Factory.createProjectTeam('External', false);
        pt4.Project__c=Weekly.Id;
        insert pt4;           
        List<Project_Team__c> ptList= [SELECT id from Project_Team__c where Project__c =:Weekly.id AND Primary__c=FALSE];
        List<Project_Team__c> teamList=new List<Project_Team__c>();
        for(Project_Team__c pt:ptList)
        {
            pt.Primary__c=true;
            teamList.add(pt);
            
        }
        
        update teamList;
    }
    
    public TestMethod static void  testMethod2()
    {
        Project__c Weekly=Test_Data_Factory.createProject('Weekly','Customer');
        Weekly.Customer__c=[select id from Account limit 1].id;
        Weekly.End_Customer__c=[select id from Account limit 1].id;
        Weekly.Billing_Frequency__c='Weekly';
        insert Weekly;        
        
        Project__c Weekly1=Test_Data_Factory.createProject('Weekly','Customer');
        Weekly1.Customer__c=[select id from Account limit 1].id;
        Weekly1.End_Customer__c=[select id from Account limit 1].id;
        Weekly1.Billing_Frequency__c='Weekly';
        insert Weekly1;  
        
        System.debug('projId :'+Weekly.id);       // Project_Team_Trigger_Handler.updatePrimaryProjectTeamMember(teamList, NULL);
        Project_Team__c pt1=Test_Data_Factory.createProjectTeam('Internal', false);
        pt1.Project__c=Weekly.Id;
        insert pt1; 
        
        Project_Team__c pt2=Test_Data_Factory.createProjectTeam('Internal', false);
        pt2.Project__c=Weekly.Id;
        
        Project_Team__c pt3=Test_Data_Factory.createProjectTeam('Internal', false);
        pt3.Project_Role__c='Project Manager';
        pt3.Project__c=Weekly.Id;
        
        Project_Team__c pt4=Test_Data_Factory.createProjectTeam('Internal', false);
        pt4.Project__c=Weekly1.Id;
        
        List<Project_Team__c>  teamList=new List<Project_Team__c>();
        teamList.add(pt2);
        teamList.add(pt3);
        teamList.add(pt4);
        insert teamList;
    }
    
    
}