import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CONTACT_OBJECT from '@salesforce/schema/Contact.';
import JOB_FIELD from '@salesforce/schema/Contact.Job_title_Designation__c';
import FIRST_FIELD from '@salesforce/schema/Contact.FirstName';
import LAST_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import MOBILE_FIELD from '@salesforce/schema/Contact.MobilePhone';
import STREET_FIELD from '@salesforce/schema/Contact.MailingStreet';
import CITY_FIELD from '@salesforce/schema/Contact.MailingCity';
import STATE_FIELD from '@salesforce/schema/Contact.MailingState';
import POSTAL_FIELD from '@salesforce/schema/Contact.MailingPostalCode';
import COUNTRY_FIELD from '@salesforce/schema/Contact.MailingCountry';
import LINKEDIN_FIELD from '@salesforce/schema/Contact.LinkedIn_Profile__c';
import CONTACT_TYPE_FIELD from '@salesforce/schema/Contact.Contact_Types__c';
import getPickListValues from '@salesforce/apex/VendorOnBoardingController.getPickListValues';
import createMultipleContact from '@salesforce/apex/VendorOnBoardingController.createMultipleContact';

export default class Vrf_escalation_matrix extends LightningElement {
  /*  //@api contactId;
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
    } */
    // 
    @track contactList = []; 
    @track index = 0;
    @api accountId;
    isLoaded = false;
    @track pickListvalues;
    @track type=CONTACT_TYPE_FIELD;
    @track job = JOB_FIELD ;
    @track firstName = FIRST_FIELD;
    @track lastName = LAST_FIELD;
    @track mobile=MOBILE_FIELD;
    @track linkedIn=LINKEDIN_FIELD;
    @track email=EMAIL_FIELD;
    @track street=STREET_FIELD;
    @track country=COUNTRY_FIELD;
    @track zipCode=POSTAL_FIELD;
    @track state=STATE_FIELD;
    @track city=CITY_FIELD;

   
    contact = {
        AccountId:this.accountId,
        Contact_Types__c : this.type,
        Job_title_Designation__c : this.job,
        FirstName : this.firstName,
        LastName :this.lastName,
        Email :this.email,
        MobilePhone:this.mobile,
        MailingStreet:this.street,
        MailingCity:this.city,
        MailingState:this.state,
        MailingPostalCode:this.zipCode,
        MailingCountry:this.country,
        LinkedIn_Profile__c:this.linkedIn,
        key : ''
    }

    connectedCallback(){
        this.addRow();
        this.invokeApexMethods();
      
    }
    async invokeApexMethods() {
        try {
            const pickresult = await  getPickListValues({
                objApiName: 'Contact',
                fieldName: 'Contact_Types__c'
            });
            this.pickListvalues=pickresult;
        } catch(error) {
            console.log(error);
        } 
    }

    addRow(){
        this.index++;
        //var i = JSON.parse(JSON.stringify(this.index));
        var i = this.index;
        this.contact.key = i;
        this.contactList.push(JSON.parse(JSON.stringify(this.contact)));
        console.log('Enter ',this.contactList);
    }

    removeRow(event){
        this.isLoaded = true;
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        if(this.contactList.length>1){
            this.contactList.splice(key, 1);
            this.index--;
            this.isLoaded = false;
        }else if(this.contactList.length == 1){
            this.contactList = [];
            this.index = 0;
            this.isLoaded = false;
        }
    } 

    handleTypesChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.contactList[key].Contact_Types__c = event.target.value;
    }

    handleJobChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.contactList[key].Job_title_Designation__c = event.target.value;
    }
    handleFirstChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.contactList[key].FirstName = event.target.value;
    }
    handlelastChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.contactList[key].LastName = event.target.value;
    }
    handleEmailChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.contactList[key].Email = event.target.value;
    }
    handleMobileChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.contactList[key].MobilePhone = event.target.value;
    }
    handleStreetChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.contactList[key].MailingStreet = event.target.value;
    }
    handleCityChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.contactList[key].MailingCity = event.target.value;
    }
    handleStateChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.contactList[key].MailingState = event.target.value;
    }
    handleZipChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.contactList[key].MailingPostalCode = event.target.value;
    }
    handleCountryChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.contactList[key].MailingCountry = event.target.value;
    }
    handleLinkedInChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.contactList[key].LinkedIn_Profile__c = event.target.value;
    }

    saveRecord(){
        const allValid = [
            ...this.template.querySelectorAll("lightning-combobox")
          ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
          }, true);
          if(allValid){
            createMultipleContact({ConList : this.contactList,accId:this.accountId})
                .then(result => {
                    this.message = result;
                    this.error = undefined;
                    if(this.message !== undefined) {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Contact created successfully',
                                variant: 'success',
                            }),
                        );
                    }
                })
                .catch(error => {
                    this.message = undefined;
                    this.error = error;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error creating record',
                            message: error.body.message,
                            variant: 'error',
                        }),
                    );
                    console.log("error", JSON.stringify(this.error));
                });
          }
       
    }
}