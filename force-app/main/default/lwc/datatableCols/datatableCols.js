import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class DatatableCols extends NavigationMixin(LightningElement) {

    @api row;

    getURL() {
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'filePreview'
            },
            state: {
                selectedRecordId: this.row[0].fieldValue
            }
        });
    }
}