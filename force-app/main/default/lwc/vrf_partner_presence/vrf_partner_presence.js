import { LightningElement, api, wire, track } from 'lwc';
import getColumns from "@salesforce/apex/VendorOnBoardingController.getColumns";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class Vrf_partner_presence extends LightningElement {
    // This is jatinder kumar code 07-01-2021

    @api accountId;
    @api objectApiName = "Vendor_Partner_Presence__c";
    @api fields = "";
    @api heading = "";
    @track fieldArray = [];
    @api bShowModal = false;
    @api fieldSetName = "Partner";
    @track showLoadingSpinner;
    @track addMore;
    partnerResults;

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
    handleSuccess(event) {
        // showing success message
        this.dispatchEvent(
            new ShowToastEvent({
                title: "Success!!",
                message: " Updated Successfully!!.",
                variant: "success"
            })
        );
        if (!this.addMore) {
            this.dispatchEvent(new CustomEvent('savepartner'));
        } else {
            this.refreshValues();
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
    handleAddMore(event) {
        this.addMore = true;
        this.handleSubmit(event);
    }

    handleSaveAndNext(event){
        this.addMore = false;
        this.handleSubmit(event);
    }

    refreshValues() {
        this.addMore = false;
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        if (inputFields) {
            inputFields.forEach((field) => {
                field.reset();
            });
        }
    }


}