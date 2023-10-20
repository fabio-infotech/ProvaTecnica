/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-20-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class SchedulableAccBatchInativarContas {
    @AuraEnabled
    public static void scheduleBatch() {
        try {
            AccountBatchInativarContas j = new AccountBatchInativarContas();
            String cronExp = '0 0 0,6,12,18 ? * MON-FRI';
            System.schedule('Inativar contas', cronExp, j);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}