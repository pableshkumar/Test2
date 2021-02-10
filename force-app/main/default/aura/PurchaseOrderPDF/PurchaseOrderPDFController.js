({
	save : function(component, event, helper) {
    var recordId = component.get("v.recordId");
	window.open('/apex/POPDFSave?id=' + recordId);
	},
    	
    saveAndDownload : function(component, event, helper) {
    var recordId = component.get("v.recordId");
	window.open('/apex/POPDFSaveandDownload?id=' + recordId);
	}
})