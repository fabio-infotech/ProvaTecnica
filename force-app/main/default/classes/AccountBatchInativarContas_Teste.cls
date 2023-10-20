/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-20-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class AccountBatchInativarContas_Teste {
    private static final Id RECORD_TYPE_ID_ACC_PARCEIRO = Schema.SObjectType.Account
        .getRecordTypeInfosByDeveloperName()
        .get('Parceiro')
        .getRecordTypeId();
    private static final String CNPJ = 'CNPJ';

    @TestSetup
    static void makeData(){
        List<Account> acctsToInsert = new List<Account>();
        Account acct;
        
        acct = new Account();
        acct.RecordTypeId = RECORD_TYPE_ID_ACC_PARCEIRO;
        acct.Name = 'Conta CNPJ 1';
        acct.AccountNumber = '21.549.030/0001-21';
        acct.Type = CNPJ;

        acctsToInsert.add(acct);

        acct = new Account();
        acct.RecordTypeId = RECORD_TYPE_ID_ACC_PARCEIRO;
        acct.Name = 'Conta CNPJ 2';
        acct.AccountNumber = '21.549.030/0001-22';
        acct.Type = CNPJ;

        acctsToInsert.add(acct);

        insert acctsToInsert;
    }

    @IsTest
    private static void successTest() {
        Account acct = [SELECT Id, Name, AccountNumber, Type FROM Account WHERE AccountNumber = '21.549.030/0001-21' LIMIT 1];

        acct.Name = 'Conta CNPJ 3';
        update acct;

        Opportunity oppt = [SELECT Id, Name, StageName FROM Opportunity LIMIT 1];
        oppt.StageName = 'Negotiation/Review';
        update oppt;

        String cronExp = '0 0 0,6,12,18 ? * MON-FRI';

        Test.startTest();

        AccountBatchInativarContas j = new AccountBatchInativarContas();
        System.schedule('Scheduled Test', cronExp, j);
        ID batchId = Database.executeBatch(j, 200);

        Test.stopTest();

        Account acctAtivo = [SELECT Id, Name, Inativa__c, Type FROM Account WHERE AccountNumber = '21.549.030/0001-21' LIMIT 1];
        System.assertEquals(false, acctAtivo.Inativa__c);

        Account acctInativo = [SELECT Id, Name, Inativa__c, Type FROM Account WHERE AccountNumber = '21.549.030/0001-22' LIMIT 1];
        System.assertEquals(true, acctInativo.Inativa__c);
    }
}