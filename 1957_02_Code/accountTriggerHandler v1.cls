public class AccountTriggerHandler extends triggerHandler {
	public override void beforeInsert() {
		AccountLib.sanitizeDataForAccounts(Trigger.new);
		ContactLib.createContacts(Trigger.new);
		OpportunityLib.createOpps(Trigger.new);
	}
}
