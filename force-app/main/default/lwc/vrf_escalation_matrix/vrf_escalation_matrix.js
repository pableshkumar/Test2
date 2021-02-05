import { LightningElement, api, wire, track } from "lwc";
import getColumns from "@salesforce/apex/VendorOnBoardingController.getColumns";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";

export default class Vrf_partner_presence extends LightningElement {
  // This is jatinder kumar code 07-01-2021

  @api accountId;
  @api objectApiName = "Contact";
  @api fields = "";
  @api heading = "";
  @track fieldArray = [];
  @api fieldSetName = "Escalation";
  @track showLoadingSpinner;
  @track addMore;
  escalationResult;

  connectedCallback() {
    this.showLoadingSpinner = true;
    let fieldData = [];
    if (this.fields.length > 0) {
      console.log("field Data");
      fieldData = this.fields.split(",");
      this.handlefiledValueSet(fieldData);
    } else {
      getColumns({
        fields: this.fields,
        objectName: this.objectApiName,
        fieldSetName: this.fieldSetName
      })
        .then((result) => {
          let filedValuewithComma = "";
          result.forEach(function (obj) {
            console.log("column value--->" + obj.apiName);
            filedValuewithComma += obj.apiName + ",";
          });
          let filedSetValue = filedValuewithComma.slice(0, -1);
          fieldData = filedSetValue.split(",");
          console.log(
            "--column value--->" + fieldData + " lenght--" + fieldData.length
          );
          this.handlefiledValueSet(fieldData);
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

  // handleing record edit form submit
  handleSubmit(event) {
    var buttonName = event.target.dataset.name;
    if (buttonName == "saveAndMore") {
      this.addMore = true;
    } else {
      this.addMore = false;
    }
    this.showLoadingSpinner = true;
    // prevending default type sumbit of record edit form
    event.preventDefault();
    // querying the record edit form and submiting fields to form
    this.template
      .querySelector("lightning-record-edit-form")
      .submit(event.detail.fields);

    this.showLoadingSpinner = false;
  }
  // refreshing the datatable after record edit form success
  handleSuccess(event) {
    // showing success message
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Success!!",
        message: " Create Successfully!!.",
        variant: "success"
      })
    );
    if (!this.addMore) {
      this.dispatchEvent(new CustomEvent("saveescalation"));
    } else {
      this.refreshValues();
    }
  }
  handlefiledValueSet(fieldData) {
    if (fieldData.length > 0) {
      fieldData.forEach((data) => {
        console.log("--Data--->" + fieldData);
        this.fieldArray.push({
          Key: this.fieldArray.length + 1,
          Name: data
        });
      });
      // hide spinner
      this.showLoadingSpinner = false;
    }
  }

  refreshValues() {
    this.addMore = false;
    const inputFields = this.template.querySelectorAll("lightning-input-field");
    if (inputFields) {
      inputFields.forEach((field) => {
        field.reset();
      });
    }
  }
}