/**
 * Created by wnardo on 9/2/2022.
 */

trigger TriggerFormField on FormField__c (before insert) {

	TriggerFormFieldImpl impl = new TriggerFormFieldImpl();
	impl.execute(Trigger.operationType);

}