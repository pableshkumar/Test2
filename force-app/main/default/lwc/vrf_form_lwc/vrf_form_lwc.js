import { LightningElement, api, track } from 'lwc';

export default class Vrf_form_lwc extends LightningElement {
    @api recordId;
    @track currentStep;
    @track accountId;
    //@track contactId;
    isloading = false;
    goBackToStepOne() {
        this.currentStep = '1';
        this.template.querySelector('div.stepTwo').classList.add('slds-hide');
        this.template
            .querySelector('div.stepOne')
            .classList.remove('slds-hide');
    }
   goToStepTwo() {
        this.currentStep = '2';
        this.template.querySelector('div.stepOne').classList.add('slds-hide');
        this.template
            .querySelector('div.stepTwo')
            .classList.remove('slds-hide');
   }
    goBackToStepTwo() {
        this.currentStep = '2';
        this.template.querySelector('div.stepThree').classList.add('slds-hide');
        this.template
            .querySelector('div.stepTwo')
            .classList.remove('slds-hide');
    }
   goToStepThree() {
        this.currentStep = '3';
        this.template.querySelector('div.stepTwo').classList.add('slds-hide');
        this.template
            .querySelector('div.stepThree')
            .classList.remove('slds-hide');
    } 
    goBackToStepThree() {
        this.currentStep = '3';
        this.template.querySelector('div.stepFour').classList.add('slds-hide');
        this.template
            .querySelector('div.stepThree')
            .classList.remove('slds-hide');
    }
    goToStepFour() {
        this.currentStep = '4';
        this.template.querySelector('div.stepThree').classList.add('slds-hide');
        this.template
            .querySelector('div.stepFour')
            .classList.remove('slds-hide');
    } 
    
    handleSave() {
        console.log('hi');
        this.isloading = true;
        this.template.querySelector("c-vrf_vendor_capability").handleSubmit();
    }
  
    
}