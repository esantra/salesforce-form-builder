/**
 * Created by wnardo on 9/2/2022.
 */

public inherited sharing class FormDAO {

	public static List<FormField__c> retrieveFormDefinition(String formId){
		return [
			SELECT Id, Name, Type__c, Required__c, Order__c, Readonly__c, DefaultValue__c
			FROM FormField__c
			WHERE DefinitionOfForm__c = :formId ORDER BY Order__c
		];
	}

	public static List<Form__c> retrieveForm(String formId){
		return  [
			SELECT Id, Name, SuccessMessage__c, Active__c, SubmitLabel__c
			FROM Form__c
			WHERE Active__c = TRUE AND Id = :formId
		];
	}

	public static List<FormField__c> retrieveFormsDefinition(Set<Id> formIds){
		return [
			SELECT Id, Name, Type__c, Required__c, Order__c, DefinitionOfForm__c, Readonly__c, DefaultValue__c
			FROM FormField__c
			WHERE DefinitionOfForm__c IN :formIds
		];
	}

	public static List<FormField__c> retrieveFormResponse(String resId){
		return [
			SELECT Id, Name, Response__c
			FROM FormField__c
			WHERE ResponseOf__c = :resId ORDER BY Order__c
		];
	}

	public static List<FormResponse__c> retrieveFormResponseByFormAndUser(String formId){
		return [
			SELECT Id
			FROM FormResponse__c
			WHERE User__c = :UserInfo.getUserId() AND ResponseOfForm__c = :formId
		];
	}

}