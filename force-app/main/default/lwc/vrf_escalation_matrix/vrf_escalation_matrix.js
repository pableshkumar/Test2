import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Vrf_escalation_matrix extends LightningElement {
    //@api contactId;
    @api recordId;
    @api accountId;
    @track fields ={};

    @api handleSubmit(){
        //this.fields.ContactId = this.contactId;
        //this.fields.AccountId = this.accountId;
        this.template.querySelector('lightning-record-edit-form').submit(this.fields);
    }
    
    handleVendorBusinessCon(event) {
        this.fields.Vendor_business_contacts__c = event.target.value;
    }
    handleEscalationDirectory(event) {
        this.fields.Escalation_directory__c = event.target.value;
    }
    handleSucess (){
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
    }
}