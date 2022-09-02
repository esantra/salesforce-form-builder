/**
 * Created by wnardo on 9/2/2022.
 */

trigger TriggerForm on Form__c (before delete) {

	TriggerFormImpl impl = new TriggerFormImpl();
	impl.execute(Trigger.operationType);

}