import { LightningElement, api } from 'lwc';

export default class DatatableColHeader extends LightningElement {

    sortDirection = 'asc';
    isSorted = false;

    @api col;
    @api isFirst;

    get isSortable() {
        return this.isFirst ? '' : 'slds-is-sortable';
    }

    sort() {

        this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
        this.isSorted = true;

        this.dispatchEvent(new CustomEvent('sort', {
            detail: {
                sortedBy: this.col,
                sortDirection: this.sortDirection
            }
        }));

        if (this.isSorted && this.sortDirection === 'asc') {
            this.template.querySelector('div').classList.add('slds-is-sorted');
            this.template.querySelector('div').classList.add('slds-is-sorted_asc');
        }
        else if (this.isSorted && this.sortDirection === 'desc') {
            this.template.querySelector('div').classList.add('slds-is-sorted');
            this.template.querySelector('div').classList.add('slds-is-sorted_desc');
        }
    }
}