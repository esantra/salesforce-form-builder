/**
 * Created by wnardo on 9/2/2022.
 */

public inherited sharing class TriggerFormFieldImpl extends AbstractTrigger {

	public override String getClassName() {
		return TriggerFormFieldImpl.class.getName();
	}

	protected override void doBeforeInsert() {
		List<FormField__c> fields = Trigger.new;
		Set<Id> formIds = new Set<Id>();

		for(FormField__c f : fields){
			if(FormConstants.VALUE_RTID == f.RecordTypeId){
				continue;
			}
			formIds.add(f.DefinitionOfForm__c);
		}

		List<FormField__c> fieldsInForm = FormDAO.retrieveFormsDefinition(formIds);

		Map<Id, Decimal> formOrderMax = new Map<Id, Decimal>();
		for(FormField__c f : fieldsInForm){
			if(!formOrderMax.containsKey(f.DefinitionOfForm__c)){
				formOrderMax.put(f.DefinitionOfForm__c, 0);
			}
			Decimal old = formOrderMax.get(f.DefinitionOfForm__c);
			if(f.Order__c > old){
				formOrderMax.put(f.DefinitionOfForm__c, f.Order__c);
			}
		}

		for(FormField__c f : fields){
			if(FormConstants.VALUE_RTID == f.RecordTypeId){
				continue;
			}
			Decimal oldMax = formOrderMax.containsKey(f.DefinitionOfForm__c) ? formOrderMax.get(f.DefinitionOfForm__c) : 0;
			f.Order__c = 1 + oldMax;
		}
	}
}