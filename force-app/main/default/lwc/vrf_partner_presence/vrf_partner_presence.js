import { LightningElement, api, track } from 'lwc';
import VENDOR_PARTNER_Object from '@salesforce/schema/Vendor_Partner_Presence__c';
import COMPNAY_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Company__c';
import CAPABILITY_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Capability__c';
import COUNTRY_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Name_of_Country_Directly_Supported__c';
import DESKTOP_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.DesktopLaptop_Spares__c';
import PRINTER_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Printer_MFD_Support__c';
import NW_EUIPMENT_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.NW_Equipment_Support__c';
import DATA_CENTER_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Data_Center_H_F_Support__c';
import TAPE_MANAGEMENT_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Tape_Management_Support__c';
import AUDIO_VIDEO_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Audio_Video_Support__c';
import VOICE_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Voice_Telephony_Support__c';
import DC_BF_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.DC_BF_Support_for_Server_Equipment__c';
import TELECOM_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.Telecom_Equipment__c';
import WAREHOUSE_FIELD from '@salesforce/schema/Vendor_Partner_Presence__c.WarehouseSpare_Management__c';

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
// This is jatinder kumar code 07-01-2021
    @track partnerList = []; 
    @track index = 0;
    @api recordId;
    @track compnay = COMPNAY_FIELD ;
    @track capability = CAPABILITY_FIELD;
    @track nameofCountryDirectly = COUNTRY_FIELD;
    desktopLaptopSupport=DESKTOP_FIELD;
    desktopLaptopSpares='';
    printerMFDSupport=PRINTER_FIELD;
    nWEquipmentSupport=NW_EUIPMENT_FIELD;
    dataCenter=DATA_CENTER_FIELD;
    tapeManagement=TAPE_MANAGEMENT_FIELD;
    voiceTelephony=VOICE_FIELD;
    audioVideo=AUDIO_VIDEO_FIELD;
    dCBFSupport=DC_BF_FIELD;
    telecomEquipment=TELECOM_FIELD;
    warehouseSpare=WAREHOUSE_FIELD;
    partner = {
        Name : this.name,
        AccountNumber : this.accNumber,
        Phone : this.phone ? this.phone : "",
        key : ''
    }
    
}