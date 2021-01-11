import { LightningElement, api, wire, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getColumns from "@salesforce/apex/VendorOnBoardingController.getColumns";


export default class Vrf_financial_information extends LightningElement {
   /* //@api contactId;
    @api accountId;
    @track fields ={};

    @api handleSubmit(){
        //this.fields.ContactId = this.contactId;
        //this.fields.AccountId = this.accountId;
        this.template.querySelector('lightning-record-edit-form').submit(this.fields);
    } */

    /*handleSubjectChange(event){
     this.fields.Subject =event.target.value;
    }
    handleDescriptionChange(event){
        this.fields.Description =event.target.value;
    }
    handleOriginChange(event){
    this.fields.Origin =event.target.value;
    }*/
    /*
    handleDocList(event) {
        this.fields.Documents_List__c = event.target.value;
    }
    handleBankDetails(event) {
        this.fields.Bank_details__c = event.target.value;
    }
    handlePaymentTerms(event) {
        this.fields.Payment_terms__c = event.target.value;
    }
    handleInvoicingProcess(event) {
        this.fields.Invoicing_process__c = event.target.value;
    }

    handleSucess(event) {
        const accountId = event.detail.id;
        const selectEvent = new CustomEvent('accountid', {
            detail: accountId
        });
        this.dispatchEvent(selectEvent);
    } */
    /*handleSucess (){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.accountId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
        const evt = new ShowToastEvent({
            message: "Account,Contact & Case has been created sucessfully",
            variant: "success",
        });
        this.dispatchEvent(evt);
    }*/


  @api currentRecordId = "";
  @api heading="";
  @api fields='';
  @api objectApiName = "";
  @track fieldArray = [];
  @track acountFieldarray=[];
  @api bShowModal = false;
  @track showLoadingSpinner;

  connectedCallback() {
    let fieldData = [];
    if (this.fields.length > 0) {
      console.log('field Data');
      fieldData = this.fields.split(",");
      this.handlefiledValueSet(fieldData);
    } else {
      getColumns({ fields: this.fields, objectName: this.objectApiName, fieldSetName: this.fieldSetName })
        .then((result) => {
          let filedValuewithComma = '';
          result.forEach(function (obj) {
            console.log('column value--->' + obj.apiName);
            filedValuewithComma += obj.apiName + ',';
          });
          let filedSetValue = filedValuewithComma.slice(0, -1);
          fieldData = filedSetValue.split(",");
          console.log('--column value--->' + fieldData + ' lenght--' + fieldData.length);
          this.handlefiledValueSet(fieldData);
        })
        .catch((error) => {
          this.error = error;
        });
    }

  }
  handlefiledValueSet(fieldData) {
    if (fieldData.length > 0) {
      fieldData.forEach((data) => {
        console.log('--Data--->' + fieldData);
        this.fieldArray.push({
          Key: this.fieldArray.length + 1,
          Name: data
        });
      });
    }
  }
}