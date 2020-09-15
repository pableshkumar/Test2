/******************************************************
*Class Name
*Description : This is a batch class. Purpose of this class is to get the billing created automatically.
*Date
*Developer Name
******************************************************/
public class Project_Team_Trigger_Handler {
    
    public static void updatePrimaryProjectTeamMember(List<Project_Team__c>  ptRecords, Map<Id,Project_Team__c> projOldMap)
    {
        if(ptRecords.size()>0 && projOldMap==NULL)
        {
            updatePrimaryMember(ptRecords);
        }
        else if(ptRecords.size()>0 && projOldMap.size()>0 )
        {
            System.debug('on update only');
            List<Project_Team__c> teamList=new List<Project_Team__c>();
            for(Project_Team__c pt:ptRecords)
            {
                if(projOldMap.get(pt.Id).primary__c != pt.Primary__c && pt.Primary__c==TRUE)
                {
                    teamList.add(pt);
                }
            }
            if(ptRecords.size()>0)
                updatePrimaryMember(teamList);
        }
    }
    //common logic to update  primary project team member at project record type + project role level
    //if the new primary user is added then the existing primary will be unchecked at project record type + project role level
    public static void updatePrimaryMember(List<Project_Team__c>  ptRecords)
    {
        Set<Id> projectIds = new Set<Id>();   // add project ids
        Set<Id> teamIds = new Set<Id>();      // add project team record ids
        Set<String> TeamProjectRoles = new Set<String>();      // add project team roles
        Set<String> projectTeamRecordType = new Set<String>();      // add project team record types
        
        for(Project_Team__c pt:ptRecords)
        {
            If(pt.Primary__c==TRUE)   // collect only the records which are getting updated as true
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
    
    //method contains the logic to make first project team user as primary by default regardless of user selection/not selection of primary at project team and project role level
    public static void firstDefaultPrimary(List<Project_Team__c>  ptRecords)
    {
        Set<Id> projectIds = new Set<Id>();   // add project ids
        Set<Id> teamIds = new Set<Id>();      // add project team record ids
        Set<String> teamRoles = new Set<String>();  //will hold project team roles
        Map<Id,Map<Id,Set<String>>> projteamMap=new Map<Id,Map<Id,Set<String>>>();  // will hold project team data fetch from org
        List<Project_Team__c> teamList;
        System.debug('ptRecords :'+ptRecords);
        for(Project_Team__c pt:ptRecords)
        {
            if(pt.Primary__c==FALSE)  // collect new record with the primary as false n do processing on them
            {
                projectIds.add(pt.Project__c);
                teamRoles.add(pt.Project_Role__c);
            }
            
        }
        teamList=[SELECT RecordTypeId,Primary__c,Project_Role__c,Project__c from Project_Team__c WHERE Project_Role__c IN :teamRoles AND Project__c in:projectIds];
        system.debug('teamList :'+ teamList);
        if(teamList.size()>0)
        {
            for(Project_Team__c pt:teamList){
                if(!projteamMap.containsKey(pt.Project__c))
                {
                    Map<Id,Set<String>> subMap=new Map<Id, Set<String>>();
                    subMap.put(pt.RecordTypeId, new Set<String>{pt.Project_Role__c});
                     projteamMap.put(pt.Project__c,subMap);
                }
                else if(projteamMap.containsKey(pt.Project__c))
                {
                    if(projteamMap.get(pt.Project__c).containsKey(pt.RecordTypeId))
                    {
                        Set<String> roles=projteamMap.get(pt.Project__c).get(pt.RecordTypeId);
                        roles.add(pt.Project_Role__c);
                        Map<Id,Set<String>> subMap=projteamMap.get(pt.Project__c);
                        subMap.put(pt.RecordTypeId,roles);
                        projteamMap.put(pt.Project__c,subMap);
                    }
                    else if(!projteamMap.get(pt.Project__c).containsKey(pt.RecordTypeId))
                    {
                        Set<String> roles=new Set<String>{pt.Project_Role__c};
                            Map<Id,Set<String>> subMap=projteamMap.get(pt.Project__c);
                        subMap.put(pt.RecordTypeId,roles);
                        projteamMap.put(pt.Project__c,subMap);
                    }
                    
                }
            }
            
            for(Project_Team__c pt: ptRecords)
            {
                if(!projteamMap.containsKey(pt.Project__c))
                {
                    pt.Primary__c=true;
                }
                else if(projteamMap.containsKey(pt.Project__c))
                {
                    if(!projteamMap.get(pt.Project__c).containsKey(pt.RecordTypeId))
                    {
                        pt.Primary__c=true;
                    }
                    else if(projteamMap.get(pt.Project__c).containsKey(pt.RecordTypeId))
                    {
                        if(!projteamMap.get(pt.Project__c).get(pt.RecordTypeId).contains(pt.Project_Role__c))
                        {
                            pt.Primary__c=true;
                        }
                        
                        
                    }
                }
            } 
        }else if(teamList.size()==0)
        {
            for(Project_Team__c pt:ptRecords)
            {
                pt.Primary__c=true;
            }
        }
    }
}