import { LightningElement, api, track } from 'lwc';

export default class Vrf_status extends LightningElement {
    @api recordId;
    @track currentStep;

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
    handleSubmit(event) {
    //this.handleSuccess(event);
    }
    handleSuccess(event){
        const toastevent = new ShowToastEvent({
            variant: 'success',
            title: 'Success!',
            message: 'Tradeline has been Updated',
        });
        this.dispatchEvent(toastevent);
        //this.isEditable = false;
  }
}