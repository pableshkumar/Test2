public with sharing class PurchaseOrderPDF {
    public Order__c poDetails {Get;Set;}  // will hold purchase order details fetched from database
    private String orderId;  // will hold Order Id 
    //public String services {Get;Set;}  // will hold project services linked with vendor PO
    public Integer totalServiceAmount   {Get;Set;}  // will hold total amount of all the services linked to PO
    public Map<String,list<String>> serviceData {Get;Set;}
    public Map<String,Integer> serviceCount {Get;Set;}
    
    
    
    
    
    //  public Set<String> siteData {Get;Set;} // will hold site names associated to all the services that are associted to PO
 //   public Map<String,List<Project_Services__c>>  siteServices {Get;Set;} 
    public PurchaseOrderPDF(ApexPages.StandardController controller)
    {
        orderId = apexpages.currentpage().getparameters().get('id');
        serviceData=new map<string,list<String>>();
        serviceCount=new map<string,Integer>();
   poDetails=[SELECT Id,Name,Bill_to_Address__c,Delivery_Instructions__c,Customer__r.BillingCity,Customer__r.BillingStreet,Customer__r.BillingState,Customer__r.BillingCountry,Customer__r.BillingPostalCode,Customer__r.ShippingCity,Customer__r.ShippingStreet,Customer__r.ShippingState,Customer__r.ShippingCountry,Customer__r.ShippingPostalCode,Customer__r.Name,Customer__c,Ship_to_Address__c,PO_Amount__c,PO_Start_Date__c,Project__r.Name,Project__r.TIG_Entity_Name__r.Name,Project__r.TIG_Entity_Name__r.Tax_Name__c,Project__r.TIG_Entity_Name__r.Tax_Code__c,Project__r.TIG_Entity_Name__r.Street_Address__c,Project__r.TIG_Entity_Name__r.City__c,Project__r.TIG_Entity_Name__r.Country1__c,Project__r.TIG_Entity_Name__r.State1__c,Project__r.TIG_Entity_Name__r.Zip_Postal_Code__c,Payment_Terms__c,CurrencyIsoCode FROM Order__c WHERE Id=:orderId];
        list<AggregateResult> AggregateResultList1= [select recordtype.name recordtype,Project_Site__r.Country1__c cntry, COUNT(id)cnt from project_services__c WHERE Vendor_Purchase_Order__c=:orderId GROUP BY recordtype.name,Project_Site__r.Country1__c]; 
        if(AggregateResultList1!= null && AggregateResultList1.size() > 0){ 
        for(AggregateResult agg:AggregateResultList1){ 
           if(!serviceData.containsKey((String)agg.get('recordtype')))
            {
                String s=(String)agg.get('cntry')+'-'+(Integer)agg.get('cnt');
                serviceData.put((String)agg.get('recordtype'),new List<String>{s});
                serviceCount.put((String)agg.get('recordtype'),(Integer)agg.get('cnt'));
            }
            else
            {
                String s=','+(String)agg.get('cntry')+'-'+(Integer)agg.get('cnt');
                List<String> addIntoList=serviceData.get((String)agg.get('recordtype'));
                addIntoList.add(s);
                serviceData.put((String)agg.get('recordtype'),addIntoList);
               Integer count= serviceCount.get((String)agg.get('recordtype'));
                count=count+(Integer)agg.get('cnt');
                serviceCount.put((String)agg.get('recordtype'),count);
            }

        }
    } 
        
        // orderId='a06N000000S9h1vIAB';
     /*   poDetails=[SELECT Id,Name,Bill_to_Address__c,Delivery_Instructions__c,Customer__r.BillingCity,Customer__r.BillingStreet,Customer__r.BillingState,Customer__r.BillingCountry,Customer__r.BillingPostalCode,Customer__r.ShippingCity,Customer__r.ShippingStreet,Customer__r.ShippingState,Customer__r.ShippingCountry,Customer__r.ShippingPostalCode,Customer__r.Name,Customer__c,Ship_to_Address__c,PO_Amount__c,PO_Start_Date__c,Project__r.Name,Project__r.TIG_Entity_Name__r.Name,Project__r.TIG_Entity_Name__r.Tax_Name__c,Project__r.TIG_Entity_Name__r.Tax_Code__c,Project__r.TIG_Entity_Name__r.Street_Address__c,Project__r.TIG_Entity_Name__r.City__c,Project__r.TIG_Entity_Name__r.Country1__c,Project__r.TIG_Entity_Name__r.State1__c,Project__r.TIG_Entity_Name__r.Zip_Postal_Code__c,Payment_Terms__c,(SELECT Name, RecordType.Name,Service_Start_Date__c,Service_End_Date__c,Total_Price__c,Project_Site__r.Name from Projects_Services1__r) FROM Order__c WHERE Id=:orderId];
       
        AggregateResult  objAgr= [SELECT  SUM(total_price__c) totalprice  from project_Services__c 
                                  where  Vendor_Purchase_Order__c=:orderId];
        system.debug('objAgr'+ objAgr);
        totalServiceAmount=  (Decimal)objAgr.get('totalprice');
        if(poDetails.Projects_Services1__r.size()>0)
        {
            //site wise services data preparation for PO
            siteData=new Set<String>();
            siteServices=new Map<String, List<Project_Services__c>>();
            for(Project_Services__c ps:poDetails.Projects_Services1__r)
            {
                siteData.add(ps.Project_Site__r.Name);
                if(!siteServices.containsKey(ps.Project_Site__r.Name))
                {
                    siteServices.put(ps.Project_Site__r.Name, new List<Project_Services__c>{ps});
                }
                else
                {
                    List<Project_Services__C> ps1=siteServices.get(ps.Project_Site__r.Name);
                    ps1.add(ps);
                    siteServices.put(ps.Project_Site__r.Name,ps1);
                    
                }
            }
            System.debug('siteServicesMap: '+siteServices); */
            
            
            
            /*  List<String> serviceList=new List<String>();
for(Project_Services__C service:poDetails.Projects_Services1__r)
{
serviceList.add(service.name); 
}
services = serviceList.toString().replace('(', '').replace(')', '');  */
            
      //  }  
    }
}