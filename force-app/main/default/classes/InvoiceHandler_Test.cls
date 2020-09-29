@isTest
public class InvoiceHandler_Test {
    
    @TestSetup
    public static void testDataCreation()
    {
        Account Customer= Test_Data_Factory.createAccount('Customer');
        insert Customer;
        
        Account vendor= Test_Data_Factory.createAccount('Vendor');
        insert vendor;
        
        Contact con=Test_Data_Factory.createContact();
        insert con;
        
        TIG_Entity__c tigEntity=Test_Data_Factory.createTIGEntity();
        insert tigEntity;
        
        Project__c projOneTimeCustomer=Test_Data_Factory.createProject('One Time','Customer');
        projOneTimeCustomer.Customer__c=Customer.id;
        projOneTimeCustomer.End_Customer__c=Customer.id;
        projOneTimeCustomer.TIG_Entity_Name__c=tigEntity.id;
        insert projOneTimeCustomer;
        
        Project__c projOneTimeVendor=Test_Data_Factory.createProject('One Time','Vendor');
        projOneTimeVendor.Customer__c=Vendor.id;
        projOneTimeVendor.End_Customer__c=Customer.id;
        projOneTimeVendor.Customer_Project__c=projOneTimeCustomer.id;
        projOneTimeVendor.TIG_Entity_Name__c=tigEntity.id;
        insert projOneTimeVendor;
        
        Project__c Weekly=Test_Data_Factory.createProject('Weekly','Customer');
        Weekly.Customer__c=Customer.id;
        Weekly.End_Customer__c=Customer.id;
        Weekly.Billing_Frequency__c='Weekly';
        insert Weekly;        
        System.debug('projId :'+Weekly.id);
        
        List<Project_Team__c> teamList=new List<Project_Team__c>();
        Project_Team__c pt=Test_Data_Factory.createProjectTeam('Internal', False);
        pt.Project__c=projOneTimeCustomer.Id;
        insert pt;
        
        Project_Team__c pt1=Test_Data_Factory.createProjectTeam('Internal', true);
        pt1.Project__c=projOneTimeCustomer.Id;
        insert pt1;
        
        Project_Team__c pt2=Test_Data_Factory.createProjectTeam('External', true);
        pt2.Project__c=projOneTimeCustomer.Id;
        insert pt2;
        
        Order__c salesOrder=Test_Data_Factory.createOrder('Sales Order');
        salesOrder.Customer__c=Customer.id;
        salesOrder.Project__c=projOneTimeCustomer.id;
        insert salesOrder;
        
        Order__c purchaseOrder=Test_Data_Factory.createOrder('Purchase Order');
        purchaseOrder.Customer__c=Vendor.id;
        purchaseOrder.Project__c=projOneTimeVendor.id;
        purchaseOrder.Customer_Purchase_Order__c=salesOrder.Id;
        insert purchaseOrder;   
        
        Project_Sites__c site=Test_Data_Factory.createSite();
        site.Project__c=projOneTimeCustomer.id;
        insert site;
        
        Project_Services__c service=Test_Data_Factory.createService('FTE');
        service.Project__c=projOneTimeCustomer.id;
        service.Project_Site__c=site.id;
        service.Vendor__c=vendor.id;
        service.Vendor_Purchase_Order__c=purchaseOrder.id;
        service.Purchase_Order__c=salesOrder.id;
        service.Vendor_Project__c=projOneTimeVendor.id;
        insert service;
        
        Invoice__c salesInvoice=Test_Data_Factory.createInvoice('Sales Invoice');
        salesInvoice.Customer__c=Customer.id;
        salesInvoice.Project__c=projOneTimeCustomer.id;
        salesInvoice.Purchase_Order__c=salesOrder.id;
        insert salesInvoice;
        
        Invoice__c purchaseInvoice=Test_Data_Factory.createInvoice('Purchase Invoice');
        purchaseInvoice.Customer__c=Vendor.id;
        purchaseInvoice.Project__c=projOneTimeVendor.id;
        purchaseInvoice.Purchase_Order__c=purchaseOrder.id;
        purchaseInvoice.Customer_Project__c=projOneTimeCustomer.id;
        insert purchaseInvoice;
        
        Invoice__c purchaseInvoice2=Test_Data_Factory.createInvoice('Purchase Invoice');
        purchaseInvoice2.Customer__c=Vendor.id;
        purchaseInvoice2.Project__c=projOneTimeVendor.id;
        purchaseInvoice2.Purchase_Order__c=purchaseOrder.id;
        purchaseInvoice2.Customer_Project__c=projOneTimeCustomer.id;
        insert purchaseInvoice2;
        
        Invoice__c inv1=Test_Data_Factory.createInvoice('Sales Invoice');
        inv1.Customer__c=Customer.id;
        inv1.Project__c=projOneTimeCustomer.id;
        inv1.Purchase_Order__c=salesOrder.id;
        insert inv1;  
        
        
        Invoice_Line_Item__c ilt=Test_Data_Factory.createInvoiceLineItem();
        ilt.Invoice__c=purchaseInvoice.id;
        insert ilt;
    }
    
    
    public static TestMethod void testMethodGenerateInvoiceNumber()
    {
        
        Order__c po=[select id,PO_Status__c from Order__c  where RecordType.Name='Purchase Order' limit 1];
        po.PO_Status__c='Released';
        update po;
        try{
            Invoice__c inv=[select id,status__c from Invoice__c  where RecordType.Name='Purchase Invoice' limit 1];
            inv.Disputed_Amount__c=5;
            inv.Status__c='Disputed';
            inv.Stage__c='On Hold';
            update inv;
            inv.Disputed_Amount__c=null;
            update inv;
        }Catch(Exception ex)
        {
            System.Assert(ex.getMessage().contains(System.Label.Dispute_Amount_Error));
            
        }
        
        
        //If no of invoice line item is zero
        try{
            Invoice__c inv=[select id,status__c from Invoice__c  where RecordType.Name='Purchase Invoice' AND Number_of_Invoice_Line_Items__c=0 limit 1  ];
            inv.Status__c='Validate Invoice';
            inv.Stage__c='Submitted';
            update inv;
        }Catch(Exception ex)
        {
            System.Assert(ex.getMessage().contains('Please add line items to the invoice before proceeding.'));
            
        }
        
        try{
            Invoice__c inv=[select id,status__c from Invoice__c  where RecordType.Name='Purchase Invoice' AND Number_of_Invoice_Line_Items__c=0 limit 1  ];
            inv.Status__c='Validate Invoice';
           // update inv;
        }Catch(Exception ex)
        {
            // System.Assert(ex.getMessage());
            
        }
        
        Invoice__c inv1=[select id,status__c from Invoice__c  where RecordType.Name='Purchase Invoice' limit 1];
        inv1.Status__c='Validate Invoice';
        //update inv1;
    }  
    
}