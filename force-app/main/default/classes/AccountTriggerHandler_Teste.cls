/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-20-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class AccountTriggerHandler_Teste {
    private static final Id RECORD_TYPE_ID_ACC_PARCEIRO = Schema.SObjectType.Account
        .getRecordTypeInfosByDeveloperName()
        .get('Parceiro')
        .getRecordTypeId();
    private static final Id RECORD_TYPE_ID_ACC_CONSUMIDOR_FINAL = Schema.SObjectType.Account
        .getRecordTypeInfosByDeveloperName()
        .get('ConsumidorFinal')
        .getRecordTypeId();
    private static final String CPF = 'CPF'; 
    private static final String CNPJ = 'CNPJ';
    private static final String MENSAGEM_ERRO_VALIDACAO_CPF_CNPJ = 'Número do cliente é inválido';
    private static final Integer TRINTA_DIAS = 30;

    @TestSetup
    static void makeData(){
        List<Account> acctsToInsert = new List<Account>();
        Account acct;
        
        acct = new Account();
        acct.RecordTypeId = RECORD_TYPE_ID_ACC_CONSUMIDOR_FINAL;
        acct.Name = 'Conta CPF 1';
        acct.AccountNumber = '679.894.375-62';
        acct.Type = CPF;
        
        acctsToInsert.add(acct);

        acct = new Account();
        acct.RecordTypeId = RECORD_TYPE_ID_ACC_CONSUMIDOR_FINAL;
        acct.Name = 'Conta CPF 2';
        acct.AccountNumber = '679.894.375-63';
        acct.Type = CPF;
        
        acctsToInsert.add(acct);

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

        acct = new Account();
        acct.RecordTypeId = RECORD_TYPE_ID_ACC_PARCEIRO;
        acct.Name = 'Conta Teste 1';
        acct.AccountNumber = '21.549.030/0001-23';
        acct.Type = CNPJ;

        acctsToInsert.add(acct);

        acct = new Account();
        acct.RecordTypeId = RECORD_TYPE_ID_ACC_PARCEIRO;
        acct.Name = 'Conta Teste 2';
        acct.AccountNumber = '21.549.030/0001-24';
        acct.Type = '';

        acctsToInsert.add(acct);

        insert acctsToInsert;
    }

    @IsTest
    private static void successTestUpdateAccParceiro() {
        List<Account> acctsToUpdate = new List<Account>();
        List<String> cnpjs = new List<String>();
        
        cnpjs.add('21.549.030/0001-21');
        cnpjs.add('21.549.030/0001-22');

        List<Account> accts = [SELECT Id, Name, AccountNumber, Type FROM Account WHERE Type = :CNPJ AND AccountNumber IN :cnpjs];

        for (Account acct : accts) {
            acct.AccountNumber = '21.549.030/0001-01';
            acctsToUpdate.add(acct);
        }

        update acctsToUpdate;

        List<Account> acctsUpdated = [SELECT Id, Name, AccountNumber, Type FROM Account WHERE AccountNumber = '21.549.030/0001-01'];
        System.assert(acctsUpdated.size() == 2);

        List<Opportunity> opptsAdded = [SELECT Id, Name, AccountId, CloseDate, StageName FROM Opportunity WHERE Account.AccountNumber = '21.549.030/0001-01' ORDER BY Account.Name];
        System.assert(opptsAdded.size() == 2);
        System.assertEquals('Conta CNPJ 1 - opp Parceiro', opptsAdded[0].Name);
        System.assertEquals(System.today().addDays(TRINTA_DIAS), opptsAdded[0].CloseDate);
        System.assertEquals('Qualification', opptsAdded[0].StageName);
    }

    @IsTest
    private static void successTestUpdateAccConsumidorFinal() {
        List<Account> acctsToUpdate = new List<Account>();

        List<Account> accts = [SELECT Id, Name, AccountNumber, Type FROM Account WHERE Type = :CPF];

        for (Account acct : accts) {
            acct.AccountNumber = '679.894.375-01';
            acctsToUpdate.add(acct);
        }

        update acctsToUpdate;

        List<Account> acctsUpdated = [SELECT Id, Name, AccountNumber, Type FROM Account WHERE AccountNumber = '679.894.375-01'];
        System.assert(acctsUpdated.size() == 2);

        List<Task> tasksAdded = [SELECT Id, Subject, WhatId, Status, Priority FROM Task WHERE Account.AccountNumber = '679.894.375-01'];
        System.assert(tasksAdded.size() == 2);
        System.assertEquals('Consumidor Final', tasksAdded[0].Subject);
        System.assertNotEquals(null, tasksAdded[0].WhatId);
        System.assertEquals('Not Started', tasksAdded[0].Status);
        System.assertEquals('Normal', tasksAdded[0].Priority);
    }

    @IsTest
    private static void successTestUpdateAccOutrosTipos() {
        List<Account> acctsToUpdate = new List<Account>();

        List<Account> accts = [SELECT Id, Name, AccountNumber, Type FROM Account WHERE Type = ''];

        for (Account acct : accts) {
            acct.AccountNumber = '21.549.030/0001-01';
            acctsToUpdate.add(acct);
        }

        update acctsToUpdate;

        List<Account> acctsUpdated = [SELECT Id, Name, AccountNumber, Type FROM Account WHERE AccountNumber = '21.549.030/0001-01'];
        System.assert(acctsUpdated.size() == 1);

        List<Opportunity> opptsAdded = [SELECT Id, Name, AccountId, CloseDate, StageName FROM Opportunity WHERE Account.AccountNumber = '21.549.030/0001-01'];
        System.assert(opptsAdded.size() == 0);
    }

    @IsTest
    private static void failTestUpdateAccInvalidCpfCnpj() {
        List<Account> acctsToUpdate = new List<Account>();
        List<String> cnpjs = new List<String>();
        
        cnpjs.add('21.549.030/0001-21'); // Sucesso
        cnpjs.add('21.549.030/0001-23'); // Erro

        List<Account> accts = [SELECT Id, Name, AccountNumber, Type FROM Account WHERE AccountNumber IN :cnpjs];

        for (Account acct : accts) {
            if (acct.AccountNumber == '21.549.030/0001-23') {
                acct.AccountNumber = '';
            } else {
                acct.AccountNumber = '21.549.030/0001-01';
            }            
            acctsToUpdate.add(acct);
        }

        Database.SaveResult[] srList = Database.update(acctsToUpdate, false);

        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess() == false) {
                System.assert(sr.isSuccess() == false, MENSAGEM_ERRO_VALIDACAO_CPF_CNPJ);
            }
        }

        List<Account> acctsUpdated = [SELECT Id, Name, AccountNumber, Type FROM Account WHERE AccountNumber = '21.549.030/0001-01'];
        System.assert(acctsUpdated.size() == 1);

        List<Opportunity> opptsAdded = [SELECT Id, Name, AccountId, CloseDate, StageName FROM Opportunity WHERE Account.AccountNumber = '21.549.030/0001-01'];
        System.assert(opptsAdded.size() == 1);
    }
}