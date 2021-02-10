public with sharing class InvoicePDFController{
    
    public Invoice__c invoiceDetails{get; set;}
    public List<Invoice_Line_Item__c> invoiceLineDetails{get; set;}
    public Set<String> InvoiceLineItemTaxes {get; set;}
    public Integer InvoiceLineItemTaxesSize {get; set;}
    public Integer noOfDays{get; set;}
    public Date dueDate{get; set;}
    public string purchaseMonth{get; set;}
    public string projectService{get;set;}
    public Id id{get;set;}
    public boolean Mainflag{get;set;}
    
    
    public InvoicePDFController(ApexPages.StandardController controller) {
        InvoiceLineItemTaxes=new Set<String>();     
        
        string net='';
        Date dateCreated;
        Try{ 
            id = apexpages.currentpage().getparameters().get('id');
            invoiceDetails=[select Invoice_Date__c,Name,Due_Date__c,Project__r.Name ,Project__r.TIG_Entity_Name__r.Tax_Name__c,Project__r.Payment_Term__c, 
                            Project__r.TIG_Entity_Name__r.Tax_Code__c, Project__r.TIG_Entity_Name__r.Name,Project__r.TIG_Entity_Name__r.Street_Address__c,Customer__r.Name,
                            Project__r.TIG_Entity_Name__r.City__c,Project__r.TIG_Entity_Name__r.Zip_Postal_Code__c,Project__r.TIG_Entity_Name__r.Country1__c,
                            Project__r.TIG_Entity_Name__r.State1__c,Project__r.TIG_Entity_Name__r.CurrencyIsoCode,Purchase_Order__r.Name,Purchase_Order__r.CurrencyIsoCode,TIG_Entity_Bank_Information__r.Bank_Name__c,TIG_Entity_Bank_Information__r.Name,
                            TIG_Entity_Bank_Information__r.Swift__c,TIG_Entity_Bank_Information__r.BSB__c,TIG_Entity_Bank_Information__r.Bank_Account_Number__c,
                            Project__r.TIG_Entity_Name__r.Email_Address_for_Remittance__c, Purchase_Order__r.Bill_to_Address__c, Purchase_Order__r.PO_Start_Date__c, 
                            CreatedDate,TIG_Entity__c,Service_Month__c,Total_Tax__c,Amount__c,Total_Amount__c,Project__r.TIG_Entity_Name__r.LUT_Bond_No__c,Project__r.TIG_Entity_Name__r.Start_Date__c,
                            Project__r.TIG_Entity_Name__r.End_Date__c,TIG_Total_Amount__c,Project__r.TIG_Entity_Name__r.HSN_Code__c,Exchange_Rate__c,TIG_Total_Tax__c ,TIG_Amount__c  from Invoice__c where Id =:id];
            
            net=invoiceDetails.Project__r.Payment_Term__c;
            
            string S1=net.remove('NET');
            noOfDays=integer.valueof(S1);
            
            
            dateCreated=Date.valueof(invoiceDetails.CreatedDate);
            dateCreated.addDays(noOfDays);
            
            DateTime dt = DateTime.newInstance(invoiceDetails.Purchase_Order__r.PO_Start_Date__c, Time.newInstance(0, 0, 0, 0));
            
            purchaseMonth = dt.format('MMM-yy');
            
            
            invoiceLineDetails = [select Amount__c,Tax_Type_1__c,Total_Amount__c,Tax_Type_2__c,Tax_Type_3__c,Total_Tax__c,Tax_1__c,Tax_2__c,Tax_3__c,Services__r.Name,Services__r.RecordType.Name from Invoice_Line_Item__c where Invoice__c=:id];
            system.debug('invoiceLineDetails: '+invoiceLineDetails);
            for(Invoice_Line_Item__c ilv:invoiceLineDetails)
            {
                InvoiceLineItemTaxes.add(ilv.Tax_Type_1__c);
                InvoiceLineItemTaxes.add(ilv.Tax_Type_2__c);
                InvoiceLineItemTaxes.add(ilv.Tax_Type_3__c);
                
                
            }
            InvoiceLineItemTaxesSize=InvoiceLineItemTaxes.size();
            List<Project_Services__c> projectServiceObj = [SELECT RecordType.Name FROM Project_Services__c WHERE Project__c =: invoiceDetails.Project__c];
            
            if(projectServiceObj != null && projectServiceObj.size() > 0){
                projectService = projectServiceObj[0].RecordType.Name;
            }
            Mainflag=true;
        }
        catch(exception e){
            // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please add the Invoice Line Item'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.Invoice_Line_Item_Error_Message));
        }
        
    }
    
    
}