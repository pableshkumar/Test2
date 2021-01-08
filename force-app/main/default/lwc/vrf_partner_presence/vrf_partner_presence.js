import { LightningElement, api, track } from 'lwc';

export default class Vrf_partner_presence extends LightningElement {
    @api accountId;
    @track fields = {};

    @api handleSubmit() {
        //this.fields.AccountId = this.accountId;
        this.template.querySelector('lightning-record-edit-form').submit(this.fields);
    }
    //getting field value
    handleCountriesSupport(event) {
        this.fields.Countries_Supported_by_Vendor__c = event.target.value;
    }
    handleTypeOfSupport(event) {
        this.fields.Type_of_Support__c = event.target.value;
    }
    //sucess event
    handleSucess(event) {
        const accountId = event.detail.id;
        const selectEvent = new CustomEvent('accountid', {
            detail: accountId
        });
        this.dispatchEvent(selectEvent);
    }

    
}