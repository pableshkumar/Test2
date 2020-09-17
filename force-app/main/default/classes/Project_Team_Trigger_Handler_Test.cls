@isTest
public class Project_Team_Trigger_Handler_Test {
    
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
        
        System.debug('projId :'+projOneTime.id);
        
        List<Project_Team__c> teamList=new List<Project_Team__c>();
        Project_Team__c pt=Test_Data_Factory.createProjectTeam('Internal', False);
        pt.Project__c=projOneTime.Id;
        insert pt;
  /*      teamList.add(pt);
        
        Project_Team__c pt1=Test_Data_Factory.createProjectTeam('Internal', True);
        pt.Project__c=projOneTime.Id;
        //insert pt;  
        teamList.add(pt1);
        
        Project_Team__c pt2=Test_Data_Factory.createProjectTeam('External', True);
        pt.Project__c=projOneTime.Id;
        //insert pt; 
        teamList.add(pt2);
        
        insert teamList;  */
    }
    
    public static TestMethod void testFirstDefaulPrimarytInternalSDM()
    {
        List<Project_Team__c> teamList=[Select RecordTypeId,RecordType.Name,User__c,Project_Role__c,Project__c, Primary__c FROM Project_Team__c];
        Project_Team_Trigger_Handler.firstDefaultPrimary(teamList);
    }
    
    public static TestMethod void testUpdatePrimaryProjectTeamMember()
    {
        List<Project_Team__c> teamList=[Select RecordTypeId,RecordType.Name,User__c,Project_Role__c,Project__c, Primary__c FROM Project_Team__c];
        Project_Team_Trigger_Handler.updatePrimaryProjectTeamMember(teamList, NULL);
    }
        
}