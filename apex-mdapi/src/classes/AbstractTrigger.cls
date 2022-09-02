/**
 * Created by wnardo on 2/21/2022.
 * Test_UserDetailsTrigger
 */

public abstract class AbstractTrigger {

	public abstract String getClassName();

	public void execute(TriggerOperation operationType){

		if(isByPassed()){
			System.debug('AbstractTrigger::' + getClassName() + '::is BYPASSED. Execution stopped');
			return;
		}

		if(bypassFrameworkEnabled()){
			bypass(true);
		}

		switch on operationType {
			when AFTER_DELETE {
				System.debug('AbstractTrigger::' + getClassName() + '::AFTER_DELETE');
				doAfterDelete();
			}
			when AFTER_INSERT {
				System.debug('AbstractTrigger::' + getClassName() + '::AFTER_INSERT');
				doAfterInsert();
			}
			when AFTER_UPDATE {
				System.debug('AbstractTrigger::' + getClassName() + '::AFTER_UPDATE');
				doAfterUpdate();
			}
			when BEFORE_DELETE {
				System.debug('AbstractTrigger::' + getClassName() + '::BEFORE_DELETE');
				doBeforeDelete();
			}
			when BEFORE_INSERT {
				System.debug('AbstractTrigger::' + getClassName() + '::BEFORE_INSERT');
				doBeforeInsert();
			}
			when BEFORE_UPDATE {
				System.debug('AbstractTrigger::' + getClassName() + '::BEFORE_UPDATE');
				doBeforeUpdate();
			}
		}

		if(bypassFrameworkEnabled()){
			bypass(false);
		}
	}

	protected virtual void doAfterDelete(){
		throw new TriggerNotImplementedException(getClassName() + '::doAfterDelete not implemented');
	}

	protected virtual void doAfterInsert(){
		throw new TriggerNotImplementedException(getClassName() + '::doAfterInsert not implemented');
	}

	protected virtual void doAfterUpdate(){
		throw new TriggerNotImplementedException(getClassName() + '::doAfterUpdate not implemented');
	}

	protected virtual void doBeforeDelete(){
		throw new TriggerNotImplementedException(getClassName() + '::doBeforeDelete not implemented');
	}

	protected virtual void doBeforeInsert(){
		throw new TriggerNotImplementedException(getClassName() + '::doBeforeInsert not implemented');
	}

	protected virtual void doBeforeUpdate(){
		throw new TriggerNotImplementedException(getClassName() + '::doBeforeUpdate not implemented');
	}

	protected virtual Boolean bypassFrameworkEnabled(){
		return false;
	}

	public void bypass(Boolean enable){
		AbstractTrigger.internalByPass(getClassName(), enable);
	}

	public Boolean isByPassed(){
		return AbstractTrigger.intenralIsByPassed(getClassName());
	}

	private static Map<String,Boolean> bypassed = new Map<String,Boolean>();
	private static void internalByPass(String triggerName, Boolean enable){
		bypassed.put(triggerName, enable);
	}

	private static Boolean intenralIsByPassed(String triggerName){
		return bypassed.containsKey(triggerName) && bypassed.get(triggerName);
	}

	public class TriggerNotImplementedException extends Exception {}

}