/******************************************************
*Class Name
*Description : 
*Date
*Developer Name
******************************************************/
public class Project_Team_Trigger_Handler {
    
    public static void updatePrimaryProjectTeamMember(List<Project_Team__c>  ptRecords, Map<Id,Project_Team__c> projOldMap)
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
    public static void primaryLogic(List<Project_Team__c>  ptRecords)
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
        Set<String> teamRoles = new Set<String>();
        Map<Id,Map<String,Map<String,List<Project_Team__c>>>> projteamMap=new Map<Id,Map<String,Map<String,List<Project_Team__c>>>>();
        // Map<Id,Project__c>  projectWithTeam;
        List<Project_Team__c> teamList;
        for(Project_Team__c pt:ptRecords)
        {
            if(pt.Primary__c==FALSE)
            {
                projectIds.add(pt.Project__c);
                teamRoles.add(pt.Project__c);
            }
            
            teamList=[SELECT RecordType.Name,Primary__c,Project_Role__c,Project__c from Project_Team__c WHERE Project_Role__c IN :teamRoles AND Project__c in:projectIds];
        }
        
        for(Project_Team__c pt:teamList){
            if(!projteamMap.containsKey(pt.Project__c))
            {
                projteamMap.put(pt.Project__c,new Map<String,Map<String,List<Project_Team__c>>>().put(pt.RecordType.Name,new Map<String,List<pt.Project_Team__c>>().put(pt.project_role__c,new List<Project_Team__c>(){pt})));
            }
            else if(projteamMap.containsKey(pt.Project__c))
            {
              Map<String,Map<String,List<Project_team__c>>>  map1=projteamMap.get(pt.Project__c);
               if(!map1.containsKey(pt.RecordType.Name))
                 {
                  map1.put(pt.RecordType.Name,new Map<String,List<Project_team__c>>().put(pt.project_role__c,new List<project_Team>(){pt}));
                  projteamMap.get(pt.Project__c).put(map1);
                 }
               else if(map1.containsKey(pt.RecordType.Name))
                 {
                   Map<String,List<Project_Team__c>> Map2=map1.get(pt.RecordType.Name);
                    if(!map2.containsKey(pt.Project_Role__c))
                       {
                        Map<String,List<Project_Team__c>> map3=new Map<String,List<Project_Team__c>>();
                         map3.put(pt.Project_Role__c,new List<Project_Team__c>(){pt});
                           projteamMap.get(pt.Project__c).get(pt.RecordType.Name).put(pt.Project_Role__c,new List<project_Team__c>(){pt});
                         
                         }
                     else if(map2.containsKey(pt.Project_Role__c))
                        {
                           List<Project_Team__c>  ptTeam= map2.get(pt.Project_Role__c);
                           ptTeam.add(pt);
                         //map2.put(pt.Project_Role__c,ptTeam);
                           projteamMap.get(pt.Project__c).get(pt.RecordType.Name).put(pt.Project_Role__c,ptTeam);
                            
                         }
                  }
             }
        }
        
    }
}