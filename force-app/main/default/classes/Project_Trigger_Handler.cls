/******************************************************
*Class Name : Project_Trigger_Handler
*Description : This is a batch class. Purpose of this class is to get the billing created automatically.
*Date:
*Developer Name: Vineet Kumar
******************************************************/
public class Project_Trigger_Handler {
    
    
    // This method will create Billing Information record automatically a project creation based on Project Start and Project End Date
    public static void createAutomatedBillingInfo(List<Project__c> projList)
    {
        List<Billing_Information__c>  bilRecords=new List<Billing_Information__c>();
        List<Project__c> projRecords=new List<Project__c>();
        for(Project__c proj:projList)
        {
            If(Proj.Billing_Frequency__c=='One Time')
            {
                Billing_Information__c bi=new Billing_Information__c();
                bi.Billing_Start_Date__c=proj.Project_Start_Date__c;
                bi.Billing_End_Date__c=proj.Project_End_Date__c;
                bi.Project__c=proj.id;
                bilRecords.add(bi);
                Project__c p=new Project__c();
                p.id=proj.Id;
                p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                projRecords.add(p);
                
            }
            else If(Proj.Billing_Frequency__c=='Weekly')
            {
                Billing_Information__c bi=new Billing_Information__c();
                bi.Billing_Start_Date__c=proj.Project_Start_Date__c;
                bi.Billing_End_Date__c=bi.Billing_Start_Date__c.toStartofWeek().addDays(6)>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.toStartofWeek().addDays(6);
                bi.Billing_Status__c='Draft';
                bi.Project__c=proj.id;
                bilRecords.add(bi);
                Project__c p=new Project__c();
                p.id=proj.Id;
                p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                projRecords.add(p);
                
            }
            else if(Proj.Billing_Frequency__c=='Bi-Weekly')
            {
                Billing_Information__c bi=new Billing_Information__c();
                bi.Billing_Start_Date__c=proj.Project_Start_Date__c;
                bi.Billing_End_Date__c=bi.Billing_Start_Date__c.toStartofWeek().addDays(13)>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.toStartofWeek().addDays(13);
                bi.Project__c=proj.id;
                bilRecords.add(bi);       
                Project__c p=new Project__c();
                p.id=proj.Id;
                p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                projRecords.add(p);          
            }
            else if(Proj.Billing_Frequency__c=='Monthly')
            {
                Billing_Information__c bi=new Billing_Information__c();
                bi.Billing_Start_Date__c=proj.Project_Start_Date__c;
                bi.Billing_End_Date__c=bi.Billing_Start_Date__c.toStartofMonth().addDays(Date.daysInMonth(bi.Billing_Start_Date__c.year(), bi.Billing_Start_Date__c.month())-1)>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.toStartofMonth().addDays(Date.daysInMonth(bi.Billing_Start_Date__c.year(), bi.Billing_Start_Date__c.month())-1);
                bi.Project__c=proj.id;
                bilRecords.add(bi); 
                Project__c p=new Project__c();
                p.id=proj.Id;
                p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                projRecords.add(p);         
            }
            else if(Proj.Billing_Frequency__c=='Quarterly')
            {
                Billing_Information__c bi=new Billing_Information__c();
                bi.Billing_Start_Date__c=proj.Project_Start_Date__c;
                bi.Billing_End_Date__c=bi.Billing_Start_Date__c.toStartofMonth().addMonths(3)-1>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.toStartofMonth().addMonths(3)-1;
                bi.Project__c=proj.id;
                bilRecords.add(bi);   
                Project__c p=new Project__c();
                p.id=proj.Id;
                p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                projRecords.add(p);       
            }    
            else if(Proj.Billing_Frequency__c=='Half-Yearly')
            {
                Billing_Information__c bi=new Billing_Information__c();
                bi.Billing_Start_Date__c=proj.Project_Start_Date__c;
                bi.Billing_End_Date__c=bi.Billing_Start_Date__c.toStartofMonth().addMonths(6)-1>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.toStartofMonth().addMonths(6)-1;
                bi.Project__c=proj.id;
                bilRecords.add(bi); 
                Project__c p=new Project__c();
                p.id=proj.Id;
                p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                projRecords.add(p);
            }  
            else if(Proj.Billing_Frequency__c=='Yearly')
            {
                Billing_Information__c bi=new Billing_Information__c();
                bi.Billing_Start_Date__c=proj.Project_Start_Date__c;
                bi.Billing_End_Date__c=bi.Billing_Start_Date__c.toStartofMonth().addMonths(12)-1>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.toStartofMonth().addMonths(12)-1;
                bi.Project__c=proj.id;
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
}