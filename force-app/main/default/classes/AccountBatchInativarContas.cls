/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-20-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class AccountBatchInativarContas implements Database.Batchable<sObject>, Schedulable {
    public Database.QueryLocator start(DataBase.BatchableContext BC) {
        String oppStageNegociacao = 'Negotiation/Review';
        String oppStageFechouGanhou = 'Closed Won';

        String query = 'SELECT Id, ' +
            'Name, ' +
            '(SELECT Id FROM Opportunities ' +
                'WHERE (StageName = :oppStageNegociacao) ' +
                'OR (StageName = :oppStageFechouGanhou AND CloseDate >= LAST_N_DAYS:120)), ' +
            '(SELECT Id FROM Tasks ' +
                'WHERE CreatedDate >= LAST_90_DAYS) ' +
            'FROM Account ORDER BY Name';

        return Database.getQueryLocator(query);
    }

    public void execute(SchedulableContext scon){
		System.Database.executeBatch(new AccountBatchInativarContas(), 200);
	}

    public void execute(Database.BatchableContext BC, List<Account> scope) {
        List<Account> listAccToInative = new List<Account>();
        Account acctToUpdate;
        
        for (Account acct : scope) {
            if (acct.Opportunities.isEmpty() && acct.Tasks.isEmpty()) {
                acctToUpdate = new Account();
                acctToUpdate.Id = acct.Id;
                acctToUpdate.Inativa__c = true;

                listAccToInative.add(acctToUpdate);
            }
        }

        if (listAccToInative.size() > 0) {
            update listAccToInative;
        }
    }

    public void finish(Database.BatchableContext BC) {
    }
}