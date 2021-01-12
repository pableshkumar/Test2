import { LightningElement,api, wire, track } from 'lwc';
import VENDOR_PARTNER_OBJECT from '@salesforce/schema/Vendor_Partner_Presence__c';
import COMPNAY_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Company__c';
import CAPABILITY_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Capability__c';
import COUNTRY_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Name_of_Country_Directly_Supported__c';
import DESKTOP_SPARE_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.DesktopLaptop_Spares__c';
import DESKTOP_SUPPORT_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.DesktopLaptop_Support__c';
import PRINTER_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Printer_MFD_Support__c';
import NW_EUIPMENT_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.NW_Equipment_Support__c';
import DATA_CENTER_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Data_Center_H_F_Support__c';
import TAPE_MANAGEMENT_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Tape_Management_Support__c';
import AUDIO_VIDEO_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Audio_Video_Support__c';
import VOICE_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Voice_Telephony_Support__c';
import DC_BF_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.DC_BF_Support_for_Server_Equipment__c';
import TELECOM_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Telecom_Equipment__c';
import WAREHOUSE_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.WarehouseSpare_Management__c';
import savePartner from '@salesforce/apex/VendorOnBoardingController.savePartner';
import getPickListValues from '@salesforce/apex/VendorOnBoardingController.getPickListValues';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Vrf_partner_presence extends LightningElement {
 /*   @api accountId;
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
    } */
// This is jatinder kumar code 07-01-2021
    @track partnerList = []; 
    @track index = 0;
    @api accountId;
    isLoaded = false;
    @track pickListvalues;
    @track countryListvalues;
    @track objectName=VENDOR_PARTNER_OBJECT;
    @track compnay = COMPNAY_FIELD ;
    @track capability = CAPABILITY_FIELD;
    @track nameofCountryDirectly = COUNTRY_FIELD;
    @track desktopLaptopSupport=DESKTOP_SUPPORT_FIELD;
    @track desktopLaptopSpares=DESKTOP_SPARE_FIELD;
    @track printerMFDSupport=PRINTER_FIELD;
    @track nWEquipmentSupport=NW_EUIPMENT_FIELD;
    @track dataCenter=DATA_CENTER_FIELD;
    @track tapeManagement=TAPE_MANAGEMENT_FIELD;
    @track voiceTelephony=VOICE_FIELD;
    @track audioVideo=AUDIO_VIDEO_FIELD;
    @track dCBFSupport=DC_BF_FIELD;
    @track telecomEquipment=TELECOM_FIELD;
    @track warehouseSpare=WAREHOUSE_FIELD;
    partner = {
        Company__c:this.accountId,
        Capability__c : this.capability,
        Name_of_Country_Directly_Supported__c : this.nameofCountryDirectly,
        DesktopLaptop_Support__c : this.desktopLaptopSupport,
        DesktopLaptop_Spares__c :this.desktopLaptopSpares,
        Printer_MFD_Support__c :this.printerMFDSupport,
        NW_Equipment_Support__c:this.nWEquipmentSupport,
        Data_Center_H_F_Support__c:this.dataCenter,
        Tape_Management_Support__c:this.tapeManagement,
        Voice_Telephony_Support__c:this.voiceTelephony,
        Audio_Video_Support__c:this.audioVideo,
        DC_BF_Support_for_Server_Equipment__c:this.dCBFSupport,
        Telecom_Equipment__c:this.telecomEquipment,
        WarehouseSpare_Management__c:this.warehouseSpare,
        key : ''
    }

    connectedCallback(){
        this.addRow();
        this.invokeApexMethods();
      
    }
    async invokeApexMethods() {
        try {
            const pickresult = await  getPickListValues({
                objApiName: 'Vendor_Partner_Presence__c',
                fieldName: 'DesktopLaptop_Spares__c'
            });
            this.pickListvalues=pickresult;
            const countryResult = await getPickListValues({
                objApiName: 'Vendor_Partner_Presence__c',
                fieldName: 'Name_of_Country_Directly_Supported__c'
            });
           this.countryListvalues=countryResult;
        } catch(error) {
            console.log(error);
        } 
    }

    addRow(){
        this.index++;
        //var i = JSON.parse(JSON.stringify(this.index));
        var i = this.index;
        this.partner.key = i;
        this.partnerList.push(JSON.parse(JSON.stringify(this.partner)));
        console.log('Enter ',this.partnerList);
    }

    removeRow(event){
        this.isLoaded = true;
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        if(this.partnerList.length>1){
            this.partnerList.splice(key, 1);
            this.index--;
            this.isLoaded = false;
        }else if(this.partnerList.length == 1){
            this.partnerList = [];
            this.index = 0;
            this.isLoaded = false;
        }
    } 
    
    handleCapabilityChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.partnerList[key].Capability__c = event.target.checked;
    }
    handleCountryChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.partnerList[key].Name_of_Country_Directly_Supported__c = event.target.value;
    }
    handleSupportChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.partnerList[key].DesktopLaptop_Support__c = event.target.value;
    }
    handleSparesChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.partnerList[key].DesktopLaptop_Spares__c = event.target.value;
    }
    handlePrinterChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.partnerList[key].Printer_MFD_Support__c  = event.target.value;
    }
    handleEquipmentChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.partnerList[key].NW_Equipment_Support__c = event.target.value;
    }
    handleDataChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.partnerList[key].Data_Center_H_F_Support__c = event.target.value;
    }
    handleTapeChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.partnerList[key].Tape_Management_Support__c = event.target.value;
    }
    handleVoiceChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.partnerList[key].Voice_Telephony_Support__c = event.target.value;
    }
    handleAudioChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.partnerList[key].Audio_Video_Support__c = event.target.value;
    }
    handleDCChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.partnerList[key].DC_BF_Support_for_Server_Equipment__c = event.target.value;
    }
    handleTelecomChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.partnerList[key].Telecom_Equipment__c = event.target.value;
    }
    handleWarehouseChange(event){
        var selectedRow = event.currentTarget;
        var key = selectedRow.dataset.id;
        this.partnerList[key].WarehouseSpare_Management__c = event.target.value;
    }

    saveRecord(){
        const allValid = [
            ...this.template.querySelectorAll("lightning-combobox")
          ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
          }, true);
          if(allValid){
            console.log('Partner List---<>'+JSON.stringify(this.partnerList));
            savePartner({partnerList : this.partnerList,accId:this.accountId})
                .then(result => {
                    this.message = result;
                    this.error = undefined;
                    if(this.message !== undefined) {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Vendor Partner created successfully',
                                variant: 'success',
                            }),
                        );
                    }
                    console.log(JSON.stringify(result));
                    console.log("result", this.message);
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