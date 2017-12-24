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
}
