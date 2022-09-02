/**
 * Created by wnardo on 9/2/2022.
 */

public inherited sharing class TriggerFormImpl extends AbstractTrigger  {

	public override String getClassName() {
		return TriggerFormFieldImpl.class.getName();
	}

	protected override void doBeforeDelete() {
		List<Form__c> forms = Trigger.old;
		deleteRelatedFormField(forms);
	}

	private void deleteRelatedFormField(List<Form__c> forms) {
		Set<Id> formId = new Set<Id>();
		for(Form__c f : forms) {
			formId.add(f.Id);
		}

		delete [
			SELECT Id
			FROM FormField__c
			WHERE DefinitionOfForm__c IN :formId OR ResponseOf__c IN :formId
		];
	}
}