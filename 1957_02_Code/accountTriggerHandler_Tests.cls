@isTest
private class accountTriggerHandler_Tests {

	@isTest static void test_updateCasesWithNewContactPhoneIfChanged() {
		List<Account> accountsToTestWith = TestUtils.generateListOfAccounts(5);
		List<Account> newAccountsToTestWith = new List<Account>();
		for (Account a: accountsToTestWith) {
			a.phone = '555 867 5300';
		}
		// this invokes the private constructor that's only visible to tests
		AccountTriggerHandler a = new AccountTriggerHandler(newAccountsToTestWith, accountsToTestWith);
		Test.startTest();
		List<Account> results = a.updateCasesWithNewContactPhoneIfChanged();
		Test.stopTest();
		system.assertEquals(results.size(), 5, 'expected to have 5 accounts in collection');
		for (Account a : results) {
			system.assertEquals(a.mainContactPhone__c, '555 867 5309', 'expected the new phone number to be set as the mainContactPhone__c');
		}
	}

}
