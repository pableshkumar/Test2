({
    cancel: function (component, event, helper) {
        //closes the modal or popover from the component
        component.find("overlayLib").notifyClose();
        $A.get('e.force:refreshView').fire();
    }
})