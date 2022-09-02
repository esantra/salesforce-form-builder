/**
 * Created by wnardo on 9/2/2022.
 */

import { LightningElement, api, track } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import retrieveFormDefinition from '@salesforce/apex/FormViewerController.retrieveFormDefinition';
import saveFormResponse from '@salesforce/apex/FormViewerController.saveFormResponse';

export default class FormViewer extends LightningElement {

	@api recordId;

	@track isLoading = true;
	@track submitted = false;
	@track exist = true;
	@track title = '';
	@track successMessage = '';
	@track submitLabel = '';

	definitions;
	responses = {};

	connectedCallback(){
	    retrieveFormDefinition({id: this.recordId})
	    .then(res => {
	        debugger;
	        this.exist = res.exist;
	        if(!this.exist){
	            this.isLoading = false;
	            return;
            }
			this.title = res.title;
			this.submitted = res.submitted;
			this.successMessage = res.successMessage;
			this.submitLabel = res.submitLabel;
			this.definitions = res.definitions.map(def => this.mapDefinition(def));
			this.isLoading = false;
        }).catch(error=>{
	        alert(error);
	        this.isLoading = false;
        });
    }

    mapDefinition(def){
        let mappedDef = {...def};
        mappedDef.isText = mappedDef.Type__c === 'text';
        mappedDef.isNumber = mappedDef.Type__c === 'number';
        mappedDef.isEmail = mappedDef.Type__c === 'email';
        mappedDef.isDate = mappedDef.Type__c === 'date';
        mappedDef.isCheckbox = mappedDef.Type__c === 'checkbox';
        return mappedDef;
    }

    handleInputChange(event){
		const id = event.target.dataset.id;
        const selectedValue = event.target.value;
        const selectedChecked = event.currentTarget.checked;
        const type = event.currentTarget.type;
		const res = type === 'checkbox' ? selectedChecked : selectedValue;
		if(res){
		    this.responses[id] = '' + res;
		}

    }

    handleSubmit(event){
        debugger;
        for(const def of this.definitions){
            const val = this.responses[def.Id];
            if(!val && def.Required__c){
                return;
            }
        }


        const resMapped = Object.getOwnPropertyNames(this.responses).map(keyId =>{
            return {
                identifier: keyId,
                value: this.responses[keyId]
            };
        });

		this.isLoading = true;
        saveFormResponse({formId: this.recordId, response: resMapped})
        .then(res => {
            if(!res){
                throw 'Something went wrong';
            }

            this.submitted = true;
            this.isLoading = false;

            try{
                eval("$A.get('e.force:refreshView').fire();");
            } catch(e){
                //not to do
            }

        }).catch(error=>{
			this.isLoading = false;
        	alert(error);
        });
    }
}