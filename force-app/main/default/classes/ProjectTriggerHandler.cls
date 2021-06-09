public with sharing class ProjectTriggerHandler {
    public static void createAutomatedBillingInfo(List<Project__c> projList){
        
        List<Billing_Information__c>  bilRecords=new List<Billing_Information__c>();
        List<Project__c> projRecords=new List<Project__c>();
        
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Project__c' AND Name = 'Customer'];
        
        for(Project__c proj:projList){
            if(proj.RecordTypeId == rt.Id && proj.Project_End_Date__c>=Date.Today()){
                if(Proj.Billing_Frequency__c=='One Time')
                {
                    Billing_Information__c bi=new Billing_Information__c();
                    bi.Billing_Start_Date__c=proj.Project_Start_Date__c;
                    bi.Billing_End_Date__c=proj.Project_End_Date__c;
                    bi.Project__c=proj.id;
                    bi.OwnerId=proj.OwnerId;
                    bilRecords.add(bi);
                    Project__c p=new Project__c();
                    p.id=proj.Id;
                    p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                    projRecords.add(p);
                    
                }
                else if(Proj.Billing_Frequency__c=='Weekly')
                {
                    Billing_Information__c bi=new Billing_Information__c();
                    if(Proj.Project_Start_Date__c.toStartofWeek()<System.today().toStartofWeek())
                    {
                        bi.Billing_Start_Date__c=System.today().toStartofWeek();
                    }else
                    {
                        bi.Billing_Start_Date__c=proj.Project_Start_Date__c;
                    }
                    bi.Billing_End_Date__c=bi.Billing_Start_Date__c.toStartofWeek().addDays(6)>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.toStartofWeek().addDays(6);
                    bi.Project__c=proj.id;
                    bi.OwnerId=proj.OwnerId;
                    bilRecords.add(bi);
                    Project__c p=new Project__c();
                    p.id=proj.Id;
                    p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                    projRecords.add(p);
                    
                }
                else if(Proj.Billing_Frequency__c=='Bi-Weekly'){
                    Billing_Information__c bi=new Billing_Information__c();
                    if(Proj.Project_Start_Date__c.toStartofWeek()<System.today().toStartofWeek())
                    {
                        bi.Billing_Start_Date__c=System.today().toStartofWeek();
                    }else
                    {
                        bi.Billing_Start_Date__c=proj.Project_Start_Date__c;
                    }
                    bi.Billing_End_Date__c=bi.Billing_Start_Date__c.toStartofWeek().addDays(13)>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.toStartofWeek().addDays(13);
                    bi.Project__c=proj.id;
                    bi.OwnerId=proj.OwnerId;
                    bilRecords.add(bi);       
                    Project__c p=new Project__c();
                    p.id=proj.Id;
                    p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                    projRecords.add(p);          
                }
                else if(Proj.Billing_Frequency__c=='Monthly'){
                    Billing_Information__c bi=new Billing_Information__c();
                    if(Proj.Project_Start_Date__c<System.today() && (Proj.Project_Start_Date__c.Month()<System.today().Month() ||  Proj.Project_Start_Date__c.Year()<System.today().Year() ))
                    {
                        bi.Billing_Start_Date__c=System.today().toStartOfMonth();
                    }else
                    {
                        bi.Billing_Start_Date__c=proj.Project_Start_Date__c;
                    }          
                    bi.Billing_End_Date__c=bi.Billing_Start_Date__c.toStartofMonth().addDays(Date.daysInMonth(bi.Billing_Start_Date__c.year(), bi.Billing_Start_Date__c.month())-1)>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.toStartofMonth().addDays(Date.daysInMonth(bi.Billing_Start_Date__c.year(), bi.Billing_Start_Date__c.month())-1);
                    bi.Project__c=proj.id;
                    bi.OwnerId=proj.OwnerId;
                    bilRecords.add(bi); 
                    Project__c p=new Project__c();
                    p.id=proj.Id;
                    p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                    projRecords.add(p);         
                }
                else if(Proj.Billing_Frequency__c=='Quarterly'){
                    Billing_Information__c bi=new Billing_Information__c();
                    if(Proj.Project_Start_Date__c<System.today() && (Proj.Project_Start_Date__c.Month()<System.today().Month() ||  Proj.Project_Start_Date__c.Year()<System.today().Year() ))
                    {
                        bi.Billing_Start_Date__c=System.today().toStartOfMonth();
                    }else
                    {
                        bi.Billing_Start_Date__c=proj.Project_Start_Date__c;
                    }  
                    bi.Billing_End_Date__c=bi.Billing_Start_Date__c.toStartofMonth().addMonths(3)-1>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.toStartofMonth().addMonths(3)-1;
                    bi.Project__c=proj.id;
                    bi.OwnerId=proj.OwnerId;
                    bilRecords.add(bi);   
                    Project__c p=new Project__c();
                    p.id=proj.Id;
                    p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                    projRecords.add(p);       
                }    
                else if(Proj.Billing_Frequency__c=='Half-Yearly'){
                    Billing_Information__c bi=new Billing_Information__c();
                    if(Proj.Project_Start_Date__c<System.today() && (Proj.Project_Start_Date__c.Month()<System.today().Month() ||  Proj.Project_Start_Date__c.Year()<System.today().Year() ))
                    {
                        bi.Billing_Start_Date__c=System.today().toStartOfMonth();
                    }else
                    {
                        bi.Billing_Start_Date__c=proj.Project_Start_Date__c;
                    }  
                    bi.Billing_End_Date__c=bi.Billing_Start_Date__c.toStartofMonth().addMonths(6)-1>=proj.Project_End_Date__c?proj.Project_End_Date__c:bi.Billing_Start_Date__c.toStartofMonth().addMonths(6)-1;
                    bi.Project__c=proj.id;
                    bi.OwnerId=proj.OwnerId;
                    bilRecords.add(bi); 
                    Project__c p=new Project__c();
                    p.id=proj.Id;
                    p.Last_Billing_Date__c=bi.Billing_End_Date__c;
                    projRecords.add(p);
                }  
                else if(Proj.Billing_Frequency__c=='Yearly'){
                    Billing_Information__c bi=new Billing_Information__c();
                    if(Proj.Project_Start_Date__c<System.today() && (Proj.Project_Start_Date__c.Month()<System.today().Month() ||  Proj.Project_Start_Date__c.Year()<System.today().Year() ))
                    {
                        bi.Billing_Start_Date__c=System.today().toStartOfMonth();
                    }else
                    {
                        bi.Billing_Start_Date__c=proj.Project_Start_Date__c;
                    }  
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
        }
        
        if(bilRecords.size()>0){
            insert bilRecords;
        }
        if(projRecords.size()>0){
            update projRecords;
        }
    }
    //Method to update Sum of Total_Project_Value__c of Vendor Projects on Total_Sum_Of_Vendor_Project__c of Customer record page
    public static void UpdateTotalSumOfVendorProjects (List<Project__c> projectList){
        set<Id>customerId = new set<Id>();
        for(project__c pro : projectList){
            if(pro.Customer_Project__c != null){
                customerId.add(pro.Customer_Project__c);
            }
        }
        List<Project__c> customerList = [select id, name,Total_Project_Value__c,Total_Sum_of_Vendor_Projects__c from project__c where id IN : customerId]; 
        list<Project__c> vendorList = [select id, name, Total_Project_Value__c,Customer_Project__c from project__c where Customer_Project__c IN : customerId]; 
        for(project__c cus : customerList){
            Decimal amount = 0;
            for(project__c vend : vendorList){
                if(vend.Customer_Project__c == cus.Id){
                    amount += vend.Total_Project_Value__c;    
                }
            }
            cus.Total_Sum_of_Vendor_Projects__c = amount;
        }
        update customerList;
    }
    //Method to update Sum of Total_Project_Value__c of Vendor Projects on Total_Amount_Of_Vendor_Project__c of Vendor Account record page
  /******************* Last Updated 19-May-2021; 
   * Not updating Vendor Project Amount on Vendor Account
    public static void UpdateTotalAmountOfVendorProjects (List<Project__c> PaccList){
        Set<Id>VendorId = New Set<Id>() ;
        for(Project__c Pacc : PaccList){
            if(Pacc.Customer__c != null){
                VendorId.add(Pacc.Customer__c);
            }
        }
        List<Account> VendorsList = [Select id, Name, Total_Amount_of_Vendor_Projects__c from Account Where Id in : VendorId];
       	List<Project__c> VenList = [Select id, Name, Total_Project_Value__c,Customer__c from project__c where Customer__c in : VendorId];
        for(Account ven : VendorsList){
            Decimal amount = 0;
            for(Project__c ven1 : VenList){
                if(ven1.Customer__c == ven.id){
                    amount += ven1.Total_Project_Value__c;
                }
            }
            ven.Total_Amount_of_Vendor_Projects__c = amount;
        }
        update VendorsList;
    } *****/
    
    // Method to Update Amount of only those Vendor Projects on Customer Project whose Start & End date is in current Fiscal Year
    public static void updateCurrentFiscalYearVendorProjectsAmountOnCustomerProject(Set<Id> ProjId){
        list<project__c> prolist = new list<project__c>();
        Id venRt = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Id cusRt = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
    list<project__c> custList = [select id, Total_Vendor_Projects_Amount__c from project__c where recordtypeid =: cusRt AND id IN: projId];    
    list<project__c> venList = [select id, Customer_Project__c, Total_PO_Amount__c from project__c where recordtypeid =: venRt and Total_PO_Amount__c != null];
        for(project__c cus : custList){
            decimal val = 0;
            for(project__c ven : venList){
                if(ven.Customer_Project__c == cus.Id){
                val += ven.Total_PO_Amount__c;
                }
            }
            cus.Total_Vendor_Projects_Amount__c = val;
            prolist.add(cus);
        }
        update prolist;
    }
}