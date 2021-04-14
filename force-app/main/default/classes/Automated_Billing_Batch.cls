/******************************************************
*Class Name
*Description : This is a batch class. Purpose of this class is to get the billing created automatically and also getting scheduled.
*Date
*Developer Name
******************************************************/
global class Automated_Billing_Batch implements  Schedulable,Database.Batchable<sObject>
{
    global void execute(SchedulableContext sc) {
        Database.executeBatch(this);
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Date lastBillingDate=Date.Today().addDays(-1);
        Date projectEndDate= Date.Today();  
        
        String query='SELECT Project_Start_Date__c, Project_End_Date__c,Billing_Frequency__c,Last_Billing_Date__c, RecordType.Name FROM Project__c WHERE Last_Billing_Date__c=:lastBillingDate AND Project_End_Date__c>=:projectEndDate AND RecordType.Name=\'Customer\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Project__c> projList){
        // process each batch of records
        List<Billing_Information__c>  bilRecords=new List<Billing_Information__c>();
        List<Project__c> projRecords=new List<Project__c>();
        for(Project__c proj:projList)
        {
            If(Proj.Billing_Frequency__c=='Weekly')
            {
                Billing_Information__c bi=new Billing_Information__c();
                bi.Billing_Start_Date__c=proj.Last_Billing_Date__c+1;
                bi.Billing_End_Date__c=bi.Billing_Start_Date__c.addDays(6)>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.addDays(6);
                bi.Project__c=proj.id;
                bi.OwnerId=proj.OwnerId;
                bilRecords.add(bi);
                Project__c p=new Project__c();
                p.id=proj.Id;
                p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                projRecords.add(p);
            }
            else if(Proj.Billing_Frequency__c=='Bi-Weekly')
            {
                Billing_Information__c bi=new Billing_Information__c();
                bi.Billing_Start_Date__c=proj.Last_Billing_Date__c+1;
                bi.Billing_End_Date__c=bi.Billing_Start_Date__c.addDays(13)>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.addDays(13);
                bi.Project__c=proj.id;
                bi.OwnerId=proj.OwnerId;
                bilRecords.add(bi);       
                Project__c p=new Project__c();
                p.id=proj.Id;
                p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                projRecords.add(p);          
            }
            else if(Proj.Billing_Frequency__c=='Monthly')
            {
                Billing_Information__c bi=new Billing_Information__c();
                bi.Billing_Start_Date__c=proj.Last_Billing_Date__c+1;
                bi.Billing_End_Date__c=bi.Billing_Start_Date__c.toStartofMonth().addDays(Date.daysInMonth(bi.Billing_Start_Date__c.year(), bi.Billing_Start_Date__c.month())-1)>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.toStartofMonth().addDays(Date.daysInMonth(bi.Billing_Start_Date__c.year(), bi.Billing_Start_Date__c.month())-1);
                bi.Project__c=proj.id;
                bi.OwnerId=proj.OwnerId;
                bilRecords.add(bi); 
                Project__c p=new Project__c();
                p.id=proj.Id;
                p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                projRecords.add(p);         
            }
            else if(Proj.Billing_Frequency__c=='Quarterly')
            {
                Billing_Information__c bi=new Billing_Information__c();
                bi.Billing_Start_Date__c=proj.Last_Billing_Date__c+1;
                bi.Billing_End_Date__c=bi.Billing_Start_Date__c.toStartofMonth().addMonths(3)-1>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.toStartofMonth().addMonths(3)-1;
                bi.Project__c=proj.id;
                bi.OwnerId=proj.OwnerId;
                bilRecords.add(bi);   
                Project__c p=new Project__c();
                p.id=proj.Id;
                p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                projRecords.add(p);       
            }    
            else if(Proj.Billing_Frequency__c=='Half-Yearly')
            {
                Billing_Information__c bi=new Billing_Information__c();
                bi.Billing_Start_Date__c=proj.Last_Billing_Date__c+1;
                bi.Billing_End_Date__c=bi.Billing_Start_Date__c.toStartofMonth().addMonths(6)-1>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.toStartofMonth().addMonths(6)-1;
                bi.Project__c=proj.id;
                bi.OwnerId=proj.OwnerId;
                bilRecords.add(bi); 
                Project__c p=new Project__c();
                p.id=proj.Id;
                p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                projRecords.add(p);
            }  
            else if(Proj.Billing_Frequency__c=='Yearly')
            {
                Billing_Information__c bi=new Billing_Information__c();
                bi.Billing_Start_Date__c=proj.Last_Billing_Date__c+1;
                bi.Billing_End_Date__c=bi.Billing_Start_Date__c.toStartofMonth().addMonths(12)-1>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.toStartofMonth().addMonths(12)-1;
                bi.Project__c=proj.id;
                bi.OwnerId=proj.OwnerId;
                bilRecords.add(bi); 
                Project__c p=new Project__c();
                p.id=proj.Id;
                p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                projRecords.add(p);
            }  
            
        }
        
        if(bilRecords.size()>0)
        {
            insert bilRecords;
        }
        if(projRecords.size()>0)
        {
            update projRecords;
        }
    }    
    
    global void finish(Database.BatchableContext bc){
    }   
}