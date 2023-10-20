import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// import agendarApexAccountBatchInativarContas from "@salesforce/apex/SchedulableAccBatchInativarContas.scheduleBatch";

export default class AccountForm extends LightningElement {
    @api recordId;
    @api objectApiName;
    
    fields = ['Name', 'AccountNumber','Type'];

    error;

    _formMode;
    get formMode() {
        return this._formMode;
    }

    set formMode(value) {
        this._formMode = value;
    }
    
    connectedCallback() {
        this.init();
    }

    async init() {
        try {
            this.formMode = 'view';

            //await agendarApexAccountBatchInativarContas().catch(error => this.error = error);
            
            // if (this.error) {
            //     this.showToast('Erro', this.error, 'error');
            // }

        } catch (e) {
            this.showToast('Erro', e.message, 'error');
        } finally {
            this.isLoaded = true;
        }
    }

    showToast(title, message, variant) {
        const toast = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(toast);
    }

    submit(event) {
        
    }

    success(event) {
        eval("$A.get('e.force:refreshView').fire();");
    }
}