public class AccountTriggerHandler extends triggerHandler {

	List<Account> triggerNew;
	List<Account> triggerOld;
	Map<id, Account> triggerNewMap;
	Map<id, Account> triggerOldMap;

	public AccountTriggerHandler(){
		this.triggerNew = (List<Account>) trigger.new;
		this.triggerOld = (List<Account>) trigger.old;

		if(trigger.oldMap != null) {
			this.triggerOldMap = (Map<Id, Account>) trigger.oldMap;
		}
		if(trigger.newMap != null) {
			this.triggerNewMap = (Map<Id, Account>) trigger.NewMap;
		}
	}

	@testVisible
	Private AccountTriggerHandler(list<Account> newMockAccountsForTesting, list<Account> oldMockAccountsForTesting){
		this.triggerNew = newMockAccountsForTesting;
		this.triggerOld = oldMockAccountsForTesting;
	}

	public override void afterUpdate() {
		doUpdate(updateCasesWithNewContactPhoneIfChanged());
	}

	private void doUpdate(List<Account> toInsert){
		// Always wrap your DML in try/catch blocks.
		try {
			update toInsert;
		} catch(Exception e) {
		  System.debug(e.getMessage());
		}
	}

	@testVisible
	private List<Case> updateCasesWithNewContactPhoneIfChanged(){
		List<Case> affectedCases = [SELECT id, mainContactPhone__c
																FROM Case
																WHERE contactId in :triggerNewMap.keyset()];

		// This is the primary data structure we'll use to access our data.
		// A map of contact id's -> to list of cases.
		Map<id, List<Case>> affectedCasesByContactId = new Map<Id, List<Case>>();
		// Now to populate our map
		for(Case c: affectedCases) {
		  if(affectedCasesByContactId.keyset().containsKey(c.contactId)){
		  	affectedCasesByContactId.get(c.contactId).add(c);
		  } else {
		  	affectedCasesByContactId.put(c.contactId, new List<Case>{c});
		  }
		}

		// create a new list to hold our newly updated cases
		// this way we can insert them all at once at the end.
		List<Case> updatedCases = new List<Case>();
		for(Id contactId: trigger.newMap.keyset()) {
			// Trap to make sure that the contact id we're working with actually
			// changed information we care about ie: the phone number.
		  if(trigger.old.get(contactId).phone != trigger.new.get(contactId).phone) {
		  	for(Case thisCase: affectedCasesByContactId.get(contactId)) {
		  		// Update all the cases to with the new phone number
		  	  thisCase.mainContactPhone__c = trigger.new.get(contactId).phone;
		  	  // add them to our list that we'll update.
		  	  updatedCases.add(thisCase);
		  	}
		  }
		}

		return updatedCases;

	}
}