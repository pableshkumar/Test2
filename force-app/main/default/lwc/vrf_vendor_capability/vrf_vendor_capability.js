import { LightningElement, track, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import createContact from "@salesforce/apex/VendorOnBoardingController.createContact";
export default class Vrf_vendor_capability extends LightningElement {
  // this code is written by jatinder kumar 08-01-2020
  @api currentRecordId = "";
  @api objectApiName = "";
  @track showLoadingSpinner;
  @track NameofOwnersOrDirector = "";
  @track firstName = "";
  @track lastname = "";
  @track title = "";
  @track phone = "";
  @track email = "";
  @track salesDepartmentEmail = "";
  @track salesDepartmentPhone = "";
  @track dispatchHelpDeskEmail = "";
  @track dispatchHelpDeskPhone = "";
  @track contactList = [];

  // handleing record edit form submit
  handleSubmit(event) {
    const allValid = [
      ...this.template.querySelectorAll("lightning-input")
    ].reduce((validSoFar, inputCmp) => {
      inputCmp.reportValidity();
      return validSoFar && inputCmp.checkValidity();
    }, true);
    if (allValid) {
      this.showLoadingSpinner = true;
      // prevending default type sumbit of record edit form
      event.preventDefault();
      // querying the record edit form and submiting fields to form
      this.template
        .querySelector("lightning-record-edit-form")
        .submit(event.detail.fields);

      this.showLoadingSpinner = false;
    }
  }
  // refreshing the datatable after record edit form success
  handleSuccess() {
   /* this.showLoadingSpinner = true;
    this.getContactData(); */
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Success!!",
        message: " Updated Successfully!!.",
        variant: "success"
      })
    );
    this.dispatchEvent(new CustomEvent("savevendor"));
  }

  getContactData() {
    var inputContact = this.template.querySelectorAll("lightning-input");
    inputContact.forEach(function (element) {
      if (element.name == "Name of Owners/Director of the Company") {
        this.NameofOwnersOrDirector = element.value;
      } else if (element.name == "First Name") {
        this.firstName = element.value;
      } else if (element.name == "Last Name") {
        this.lastname = element.value;
      } else if (element.name == "Title") {
        this.title = element.value;
      } else if (element.name == "Email") {
        this.email = element.value;
      } else if (element.name == "Phone") {
        this.phone = element.value;
      } else if (element.name == "Sales Department Email") {
        this.salesDepartmentEmail = element.value;
      } else if (element.name == "Sales Department Phone") {
        this.salesDepartmentPhone = element.value;
      } else if (element.name == "Dispatch Help Desk Email") {
        this.dispatchHelpDeskEmail = element.value;
      } else if (element.name == "Dispatch Help Desk Phone") {
        this.dispatchHelpDeskPhone = element.value;
      }
    }, this);
    let Con = {
      AccountId: this.currentRecordId,
      Name_of_OwnersDirector_of_the_Company__c: this.NameofOwnersOrDirector,
      FirstName: this.firstName,
      LastName: this.lastname,
      MobilePhone: this.phone,
      Email: this.email,
      Title: this.title ? this.title : "",
      Sales_Department_Email__c: this.salesDepartmentEmail,
      Sales_Department_Phone_No__c: this.salesDepartmentPhone,
      Dispatch_Help_Desk_Department_Email__c: this.dispatchHelpDeskEmail,
      Dispatch_Help_Desk_Department_Phone_No__c: this.dispatchHelpDeskPhone
    };
    this.contactList.push(JSON.parse(JSON.stringify(Con)));
    createContact({ ConList: this.contactList })
      .then((result) => {
        let reusltdata = result;
        if (reusltdata) {
          // showing success message
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Success!!",
              message: " Updated Successfully!!.",
              variant: "success"
            })
          );
          this.dispatchEvent(new CustomEvent("savevendor"));
        }
      })
      .catch((error) => {
        let errorMessage = "Unknown error";
        if (Array.isArray(error.body)) {
          errorMessage = error.body.map((e) => e.message).join(", ");
        } else if (typeof error.body.message === "string") {
          errorMessage = error.body.message;
        }
        console.log("errorMessage---" + errorMessage);
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error",
            message: errorMessage,
            variant: "error",
            mode: "dismissable"
          })
        );
      })
      .finally(() => {
        // hide spinner
        this.showLoadingSpinner = false;
      });
  }
}