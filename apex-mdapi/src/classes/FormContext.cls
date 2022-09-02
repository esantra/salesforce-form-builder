/**
 * Created by wnardo on 9/2/2022.
 */

public inherited sharing class FormContext {

	@AuraEnabled
	public Boolean submitted { get; set; }
	@AuraEnabled
	public Boolean exist { get; set; }
	@AuraEnabled
	public String successMessage { get; set; }
	@AuraEnabled
	public String submitLabel { get; set; }
	@AuraEnabled
	public String title { get; set; }
	@AuraEnabled
	public List<FormField__c> definitions{ get; set; }

	public FormContext(){
		this.exist = true;
	}
	public FormContext(Boolean exist){
		this.exist = exist;
	}

	private static FormContext NOT_EXIST_OR_INACTIVE = new FormContext(false);
	public static FormContext inexistent(){
		return NOT_EXIST_OR_INACTIVE;
	}
}