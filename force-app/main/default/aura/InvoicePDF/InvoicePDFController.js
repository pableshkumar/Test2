({
	save : function(component, event, helper) {
    var recordId = component.get("v.recordId");
	window.open('/apex/InvoicePDFSave?id=' + recordId);
	},
    	
    saveAndDownload : function(component, event, helper) {
    var recordId = component.get("v.recordId");
	window.open('/apex/InvoicePDFSaveandDownload?id=' + recordId);
	}
})