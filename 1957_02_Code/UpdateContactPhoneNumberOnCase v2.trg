Trigger UpdateContactPhoneNumberOnCase on Contact (after update) {
	// Almost the same query as before, but we're going to process the list first
	// Note how we're using an In clause to get cases where the contactid is any
	// of the contacts that were updated.
	List<Case> affectedCases = [SELECT id, mainContactPhone__c
										FROM Case
										WHERE contactId in :trigger.newMap.keyset()];

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

	// Always wrap your DML in try/catch blocks.
	try {
		update updatedCases;
	} catch(Exception e) {
	  System.debug(e.getMessage());
	}

}
