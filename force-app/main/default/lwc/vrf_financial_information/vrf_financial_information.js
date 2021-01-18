import { LightningElement, api, wire, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getColumns from "@salesforce/apex/VendorOnBoardingController.getColumns";
import getPickListValues from "@salesforce/apex/VendorOnBoardingController.getPickListValues";
import getAccountData from "@salesforce/apex/VendorOnBoardingController.getAccountData";
import updateAccount from "@salesforce/apex/VendorOnBoardingController.updateAccount";
export default class Vrf_financial_information extends LightningElement {
  @api currentRecordId = "";
  @api heading = "";
  @api fields = "";
  @api fieldSetName = "";
  @api objectApiName = "";
  @track fieldArray = [];
  @track acountFieldarray = [];
  @track accountList = [];
  @api bShowModal = false;
  @track showLoadingSpinner;
  @track pickListvalues;
  @track taxValue = "";
  @track certificatesofIncorporationAndRegistration = "";
  @track gstAndVAT = "";
  @track servicetax = "";
  @track taxIdetification = "";
  @track cancelCheck = "";
  @track accountData = "";
  @track fieldData = [];

  connectedCallback() {
    if (this.fields.length > 0) {
      console.log("field Data");
      fieldData = this.fields.split(",");
      this.handlefiledValueSet(fieldData);
    } else {
      this.invokeApexMethods();
    }
  }
  async invokeApexMethods() {
    try {
      const fieldResult = await getColumns({
        fields: this.fields,
        objectName: this.objectApiName,
        fieldSetName: this.fieldSetName
      });
      this.convertFieldresult(fieldResult);
      const pickresult = await getPickListValues({
        objApiName: "Account",
        fieldName: "Tax_Information__c"
      });
      this.pickListvalues = pickresult;
      const getAccount = await getAccountData({
        accId: this.currentRecordId
      });
      this.setAccountData(getAccount);
    } catch (error) {
      console.log(error);
    }
  }
  setAccountData(data) {
    this.certificatesofIncorporationAndRegistration =
      data.Certificate_of_Incorporate_Registration__c;
      this.gstAndVAT =data.GSTVAT_Registration_Certificate__c ;
     this.servicetax = data.Service_Tax_Registration_Number__c;
     this.taxIdetification = data.TAX_Identification_Number__c;
     this.cancelCheck = data.Cancel_Check_of_Bank_Account_Number__c;
     this.taxValue=data.Tax_Information__c;
    
  }
  convertFieldresult(result) {
    let filedValuewithComma = "";
    result.forEach(function (obj) {
      console.log("column value--->" + obj.apiName);
      filedValuewithComma += obj.apiName + ",";
    });
    let filedSetValue = filedValuewithComma.slice(0, -1);
    this.fieldData = filedSetValue.split(",");
    console.log(
      "--column value--->" +
        this.fieldData +
        " lenght--" +
        this.fieldData.length
    );
    this.handlefiledValueSet(this.fieldData);
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
    }
  }

  // handleing record edit form submit
  handleSubmit(event) {
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
  handleSuccess() {
    // showing success message
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Success!!",
        message: " Successfully!!.",
        variant: "success"
      })
    );
    this.dispatchEvent(new CustomEvent("savefinancial"));
  }

  updateAccountData(event) {
    const allValid = [
      ...this.template.querySelectorAll("lightning-input")
    ].reduce((validSoFar, inputCmp) => {
      inputCmp.reportValidity();
      return validSoFar && inputCmp.checkValidity();
    }, true);
    if (allValid) {
      this.showLoadingSpinner = true;
      var inputAccount = this.template.querySelectorAll("lightning-input");
      inputAccount.forEach(function (element) {
        if (element.name == "Certificates of Incorporation / Registration") {
          this.certificatesofIncorporationAndRegistration = element.value;
        } else if (element.name == "GST/VAT Registration Certificate") {
          this.gstAndVAT = element.value;
        } else if (element.name == "Service Tax Registartion Number") {
          this.servicetax = element.value;
        } else if (element.name == "Tax Identification Number") {
          this.taxIdetification = element.value;
        } else if (element.name == "Cancel Check of Bank Account Number") {
          this.cancelCheck = element.value;
        }
      }, this);
      let account = {
        Id:this.currentRecordId,
        Certificate_of_Incorporate_Registration__c: this.certificatesofIncorporationAndRegistration,
        Tax_Information__c: this.taxValue,
        GSTVAT_Registration_Certificate__c: this.gstAndVAT,
        Service_Tax_Registration_Number__c: this.servicetax,
        TAX_Identification_Number__c: this.taxIdetification,
        Cancel_Check_of_Bank_Account_Number__c: this.cancelCheck
      };
      updateAccount({ accData: JSON.parse(JSON.stringify(account))})
        .then((result) => {
            this.handleSubmit(event);
        })
        .catch((error) => {
          let dataError = error.getMessage();
          this.dispatchEvent(
            new ShowToastEvent({
              title: 'Error',
              message: dataError,
              variant: 'error',
              mode: 'dismissable'
          })
          );
          
        })
        .finally(() => {
          // hide spinner
          this.showLoadingSpinner = false;
        });
    }
  }

  handleTaxChange(event) {
    this.taxValue = event.detail.value;
  }
}