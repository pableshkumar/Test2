({
    upload: function (component, event, helper) {

        var modalBody;
        var modalFooter;

        $A.createComponents([
            ["c:uploadFile", { 'recordId': component.get('v.recordId') }],
            ["c:uploadFileFooter", {}]
        ],
            function (components, status) {
                if (status === "SUCCESS") {
                    modalBody = components[0];
                    modalFooter = components[1];
                    component.find('overlayLib').showCustomModal({
                        header: "Upload File",
                        body: modalBody,
                        footer: modalFooter,
                        showCloseButton: true
                    })
                }
            }
        );
    }
})