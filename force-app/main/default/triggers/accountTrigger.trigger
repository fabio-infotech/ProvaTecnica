/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-19-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger accountTrigger on Account (after update) {
    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            AccountTriggerHandler.afterUpdate();
        }
    }
}