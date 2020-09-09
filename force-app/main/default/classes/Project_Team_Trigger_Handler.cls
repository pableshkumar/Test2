/******************************************************
*Class Name
*Description : This is a batch class. Purpose of this class is to get the billing created automatically.
*Date
*Developer Name
******************************************************/
public class Project_Team_Trigger_Handler {
    Public static void updatePrimaryProjectTeamMember(List<Project_Team__c>  ptRecords, Map<Id,Project_Team__c> projOldMap)
    {
        if(ptRecords.size()>0 && projOldMap==NULL)
        {
            primaryLogic(ptRecords);
        }
        else if(ptRecords.size()>0 && projOldMap.size()>0 )
        {
            List<Project_Team__c> teamList=new List<Project_Team__c>();
            for(Project_Team__c pt:ptRecords)
            {
                if(projOldMap.get(pt.Id).primary__c != pt.Primary__c && pt.Primary__c==TRUE)
                {
                    teamList.add(pt);
                }
            }
            if(ptRecords.size()>0)
                primaryLogic(teamList);
        }
    }
    //common logic to update  primary project team member at project role 
    Public static void primaryLogic(List<Project_Team__c>  ptRecords)
    {
        Set<Id> projectIds = new Set<Id>();   // add project ids
        Set<Id> teamIds = new Set<Id>();      // add project team record ids
        Set<String> TeamProjectRoles = new Set<String>();      // add project team record ids
        Set<String> projectTeamRecordType = new Set<String>();      // add project team record ids
        
        for(Project_Team__c pt:ptRecords)
        {
            If(pt.Primary__c==TRUE)
            {
                projectIds.add(pt.Project__c);
                teamIds.add(pt.id);
                TeamProjectRoles.add(pt.Project_Role__c);
                projectTeamRecordType.add(pt.RecordTypeId) ;
            }   
        }
        
        List<Project_Team__c> ptList=new List<Project_Team__c>();
        Map<ID,List<Project_Team__c>> projTeamMap=new Map<ID,List<Project_Team__c>>();
        List<Project_Team__c> teamRecords=[SELECT Id,Primary__c,Project__c,Project_Role__c,recordTypeId FROM Project_Team__c WHERE Project__c IN :projectIds AND id NOT IN : teamIds AND Project_Role__c  IN : TeamProjectRoles AND Primary__c=TRUE ];
        if(teamRecords.size()>0)
        {
            for(Project_Team__c pt:teamRecords)
            {
                if(!projTeamMap.containsKey(pt.Project__c))
                {
                    projTeamMap.put(pt.Project__c,new List<Project_team__c>{pt});
                }
                else if(projTeamMap.containsKey(pt.Project__c))
                {
                    List<Project_Team__c> ptList1=  projTeamMap.get(pt.Project__c);
                    ptList1.add(pt);
                    projTeamMap.put(pt.Project__c,ptList1);
                }
            }
        }
        System.debug('ProjectTeamMap :'+projTeamMap);
        List<Project_Team__c> ptListToUpdate=new List<Project_Team__c>();
        for(Project_Team__c pt:ptRecords)
        {
            if(projTeamMap.ContainsKey(pt.Project__c))
            {
                for(Project_Team__c pt1:projTeamMap.get(pt.Project__c))
                {
                    if(pt.RecordTypeId==pt1.RecordTypeId && pt.Project_Role__c== pt1.Project_Role__c)
                    {
                        pt1.Primary__c=false;
                        ptListToUpdate.add(pt1);
                    }
                }
            }
        }
        
        
        // pt.Primary__c=false;
        //   ptList.add(pt);
        if(!ptListToUpdate.isEmpty())
        {
            update ptListToUpdate;
        }
    }
    
    //mmethod will make first Internal SDM as primary by default regardless of user selection/not selection of primary
    public static void firstDefaulPrimarytInternalSDM(List<Project_Team__c>  ptRecords)
    {
        Set<Id> projectIds = new Set<Id>();   // add project ids
        Set<Id> teamIds = new Set<Id>();      // add project team record ids
        Map<Id,Project__c>  projectWithTeam;
        for(Project_Team__c pt:ptRecords)
        {
            if(pt.RecordType.Name=='Internal' && pt.Primary__c==FALSE && pt.Project_Role__c=='SDM')
            {
                projectIds.add(pt.Project__c);
            }
            
            projectWithTeam=new Map<Id,Project__c>([Select id, (SELECT RecordType.Name,Primary__c,Project_Role__c from Project_Teams__r WHERE RecordType.Name='Internal' AND Project_Role__c='SDM' ) FROM Project__c]);
        }
        
        if(projectWithTeam.size()>0 && ptRecords.size()>0)
           {
        for(Project_Team__c pt:ptRecords)
        {
            if(projectWithTeam.get(pt.Project__c)!=NULL)
            {
            if(projectWithTeam.get(pt.Project__c).Project_Teams__r.size()==0)
            {
                pt.Primary__c=TRUE;
            }
            }
        }
           }
        
    }
}