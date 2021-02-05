import { LightningElement, api, wire, track } from "lwc";

export default class Vrf_form_lwc extends LightningElement {
  @api recordId;
  @track currentStep;
  @track showVendor = true;
  @track showPartner;
  @track showFinancial;
  @track showEscalation;
  @track VRF_stages;
  @track focusIndex;
  partnerVariant;
  financialVariant;
  escalationVariant;
  vendorVariant;
  //@track contactId;
  isloading = false;
  goToStepOne() {
    this.currentStep = "1";
    this.showVendor = true;
    this.showPartner = false;
    this.showFinancial = false;
    this.showEscalation =false ;
  }
  goToStepTwo() {
    this.currentStep = "2";
    this.showVendor = false;
    this.showPartner = true;
    this.showFinancial = false;
    this.showEscalation =false ;
  }

  goToStepThree() {
    this.currentStep = "3";
    this.showVendor = false;
    this.showPartner = false;
    this.showFinancial = true;
    this.showEscalation =false ;
  }
  goToStepFour() {
    this.currentStep = "4";
    this.showPartner = false;
    this.showVendor = false;
    this.showFinancial = false;
    this.showEscalation = true;
  }
  closeComponent() {
    this.dispatchEvent(new CustomEvent("close"));
  }
  handleClick(event) {
    let value = event.target.value;
    if (value == "1") {
      this.goToStepOne();
    } else if (value == "2") {
      this.goToStepTwo();
    } else if (value == "3") {
        this.goToStepThree();
    } else if (value == "4") {
        this.goToStepFour();
    }
  }
}