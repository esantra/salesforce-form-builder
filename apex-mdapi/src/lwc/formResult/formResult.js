/**
 * Created by wnardo on 9/2/2022.
 */

import { LightningElement, api, track } from 'lwc';
import retrieveFormResponse from '@salesforce/apex/FormViewerController.retrieveFormResponse';


export default class FormResult extends LightningElement {

	@api recordId;
	@track isLoading = true;

	responses;

	connectedCallback(){
	    retrieveFormResponse({id: this.recordId})
	    .then(res => {
			this.responses = [...res];
			this.isLoading = false;
        }).catch(error=>{
	        alert(error);
	        this.isLoading = false;
        });
    }

}