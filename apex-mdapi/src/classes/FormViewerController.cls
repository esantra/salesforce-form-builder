/**
 * Created by wnardo on 9/2/2022.
 */

public with sharing class FormViewerController {

	@AuraEnabled
	public static FormContext retrieveFormDefinition(String id){
		List<Form__c> forms = FormDAO.retrieveForm(id);
		if(forms.isEmpty()){
			return FormContext.inexistent();
		}
		Form__c form = forms[0];
		if(!form.Active__c){
			return FormContext.inexistent();
		}

		FormContext context = new FormContext();
		context.title = form.Name;
		context.successMessage = form.SuccessMessage__c;
		context.submitLabel = form.SubmitLabel__c;
		context.submitted = !FormDAO.retrieveFormResponseByFormAndUser(id).isEmpty();
		context.definitions = FormDAO.retrieveFormDefinition(id);
		return context;
	}

	@AuraEnabled
	public static List<FormField__c> retrieveFormResponse(String id){
		return FormDAO.retrieveFormResponse(id);
	}

	@AuraEnabled
	public static Boolean saveFormResponse(String formId, List<FormEntry> response){
		try{
			Map<Id,FormField__c> definitions = new Map<Id,FormField__c>(FormDAO.retrieveFormDefinition(formId));

			FormResponse__c formResponse = createFormResponse(formId);

			List<FormField__c> fieldRes = new List<FormField__c>();
			for(FormEntry e : response){
				FormField__c def = definitions.get(e.identifier);
				fieldRes.add(createFieldRes(def, e, formResponse));
			}

			insert fieldRes;
			return true;
		} catch(Exception e){
			System.debug(e.getMessage());
			return false;
		}
	}

	private static FormField__c createFieldRes(FormField__c def, FormEntry e, FormResponse__c formResponse) {
		FormField__c res = def.clone();
		res.RecordTypeId = FormConstants.VALUE_RTID;
		res.Response__c = e.value;
		res.ResponseOf__c = formResponse.Id;
		return res;
	}

	private static FormResponse__c createFormResponse(String formId) {
		User usr = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId()];
		FormResponse__c formResponse = new FormResponse__c();
		formResponse.Name = 'Response Of ' + usr.Name;
		formResponse.ResponseOfForm__c = formId;
		formResponse.User__c = usr.Id;

		insert formResponse;

		return formResponse;
	}

}