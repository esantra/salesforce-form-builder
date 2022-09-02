/**
 * Created by wnardo on 9/2/2022.
 */

public inherited sharing class FormEntry {

	@AuraEnabled
	public String identifier { get; set; }
	@AuraEnabled
	public String value { get; set; }

}