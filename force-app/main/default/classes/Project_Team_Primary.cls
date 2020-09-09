/*******************************************
*Class name :Project_Team_Primary
*Description : This class contains the logic to maintain only One Primary user at a time on Project_Team__c at Project ( Projec_Role__c level ) 
*and being called from Process Builder.
*Date :
*Developer Name : Vineet Kumar
********************************************/
public class Project_Team_Primary {
    
    // this method will update Project Team records, will be called from process builder
    @InvocableMethod
    Public static void updatePrimaryProjectTeamMember(List<Project_Team__c>  ptRecords)
    {
        Set<Id> projectIds = new Set<Id>();   // add project ids
        Set<Id> teamIds = new Set<Id>();      // add project team record ids
        
        for(Project_Team__c pt:ptRecords)
        {
            projectIds.add(pt.Project__c);
            teamIds.add(pt.id);
        }
        
        List<Project_Team__c> ptList=new List<Project_Team__c>();
        for(Project_Team__c pt:[SELECT Id,Primary__c FROM Project_Team__c WHERE Project__c IN :projectIds AND id NOT IN : teamIds AND Primary__c=TRUE ])
        {
            pt.Primary__c=false;
            ptList.add(pt);
        }
        if(!ptList.isEmpty())
        {
            update ptList;
        }
    }
    
}