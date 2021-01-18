import { LightningElement, api, track } from 'lwc';

export default class Vrf_form_lwc extends LightningElement {
    @api recordId;
    @track currentStep;
    @track showVendor=true;
    @track  showPartner;
    @track showFinancial;
    @track showEscalation;
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
        this.showVendor=false;
        this.showPartner=true;
   }
    
   goToStepThree() {
        this.currentStep = '3';
        this.showPartner=false;
        this.showVendor=false;
        this.showFinancial=true;
        
    } 
    goToStepFour() {
        this.currentStep = '4';
        this.showPartner=false;
        this.showVendor=false;
        this.showFinancial=false;
        this.showEscalation=true;
        
    } 
    closeComponent(){
        this.dispatchEvent(new CustomEvent('close'));
    }
        
}