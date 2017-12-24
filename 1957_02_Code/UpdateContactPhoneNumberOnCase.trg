Trigger UpdateContactPhoneNumberOnCase on Contact (after update) {
	List<Case> affectedCases = [SELECT id, mainContactPhone__c
										FROM Case
										WHERE contactId = :trigger.new[0].id];

	if(trigger.old[0].phone != trigger.new[0].phone) {
		for(Case thisCase: affectedCases) {
		   thisCase.mainContactPhone__c = trigger.new[0].phone;
		   update thisCase;
		}
	}
}
