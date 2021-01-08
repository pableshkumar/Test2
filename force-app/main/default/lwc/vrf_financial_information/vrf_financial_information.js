import { LightningElement, api, track } from 'lwc';


export default class Vrf_financial_information extends LightningElement {
    //@api contactId;
    @api accountId;
    @track fields ={};

    @api handleSubmit(){
        //this.fields.ContactId = this.contactId;
        //this.fields.AccountId = this.accountId;
        this.template.querySelector('lightning-record-edit-form').submit(this.fields);
    }

    /*handleSubjectChange(event){
     this.fields.Subject =event.target.value;
    }
    handleDescriptionChange(event){
        this.fields.Description =event.target.value;
    }
    handleOriginChange(event){
    this.fields.Origin =event.target.value;
    }*/
    
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
    }
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
}