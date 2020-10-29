import { LightningElement, api, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import updateFile from '@salesforce/apex/FileOrganiserHandler.updateFile';
import { createMessageContext, publish } from 'lightning/messageService';
import refresh from '@salesforce/messageChannel/Refresh__c';

export default class UploadFile extends LightningElement {

    messageContext;
    subscription;

    @api recordId;

    @track disabled = true;
    @track docTypeValue;
    @track objType;

    constructor() {
        super();

        this.messageContext = createMessageContext();
    }

    @wire(getRecord, { recordId: '$recordId', layoutTypes: 'Compact' })
    linkedObject({ error, data }) {
        if (data) {
            this.objType = data.apiName;
        }
    }

    handlePicklistValue(event) {
        this.docTypeValue = event.detail.value;

        if (this.docTypeValue) {
            this.disabled = false;
        }
    }

    handleUploadFinished(event) {
        let uploadedFiles = event.detail.files;

        updateFile({
            recordId: uploadedFiles[0].documentId,
            objType: this.objType,
            documentType: this.docTypeValue
        }).then(() => {
            this.docTypeValue = '';
            this.disabled = false;

            publish(this.messageContext, refresh, {});
        });
    }
}