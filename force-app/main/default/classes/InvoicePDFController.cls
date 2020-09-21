public with sharing class InvoicePDFController{

    public Invoice__c invoiceDetails{get; set;}
    public Invoice_Line_Item__c invoiceLineDetails{get; set;}
    public Integer noOfDays{get; set;}
    public Date dueDate{get; set;}
    public string purchaseMonth{get; set;}
    public string projectService{get;set;}
    
    public InvoicePDFController(ApexPages.StandardController controller) {
        string net='';
        Date dateCreated;
        Id id = apexpages.currentpage().getparameters().get('id');
         invoiceDetails=[select Invoice_Date__c,Name,Due_Date__c,Project__r.Name ,Project__r.TIG_Entity_Name__r.Tax_Name__c,Project__r.Payment_Term__c, 
         Project__r.TIG_Entity_Name__r.Tax_Code__c, Project__r.TIG_Entity_Name__r.Name,Project__r.TIG_Entity_Name__r.Street_Address__c,Customer__r.Name,
         Project__r.TIG_Entity_Name__r.City__c,Project__r.TIG_Entity_Name__r.Zip_Postal_Code__c,Project__r.TIG_Entity_Name__r.Country__c,
         Project__r.TIG_Entity_Name__r.State__c,Purchase_Order__r.Name,Project__r.TIG_Entity_Name__r.Bank_Name__c,Project__r.TIG_Entity_Name__r.Account_Name__c,
         Project__r.TIG_Entity_Name__r.Swift__c,Project__r.TIG_Entity_Name__r.BSB__c,Project__r.TIG_Entity_Name__r.Bank_Account_Number__c,
         Project__r.TIG_Entity_Name__r.Email_Address_for_Remittance__c, Purchase_Order__r.Bill_to_Address__c, Purchase_Order__r.PO_Start_Date__c, CreatedDate  from Invoice__c where Id =:id];
         
         net=invoiceDetails.Project__r.Payment_Term__c;
         
         string S1=net.remove('NET');
         noOfDays=integer.valueof(S1);
        
         
         dateCreated=Date.valueof(invoiceDetails.CreatedDate);
         dateCreated.addDays(noOfDays);
         
         DateTime dt = DateTime.newInstance(invoiceDetails.Purchase_Order__r.PO_Start_Date__c, Time.newInstance(0, 0, 0, 0));
         
         purchaseMonth = dt.format('MMM-yy');
         
         invoiceLineDetails = [select Amount__c,Tax_Type_1__c,Total_Amount__c,Tax_Type_2__c,Tax_Type_3__c from Invoice_Line_Item__c where Invoice__c=:id];
         
         List<Project_Services__c> projectServiceObj = [SELECT RecordType.Name FROM Project_Services__c WHERE Project__c =: invoiceDetails.Project__c];
         
         if(projectServiceObj != null && projectServiceObj.size() > 0){
             projectService = projectServiceObj[0].RecordType.Name;
         }

    }
    
        
}