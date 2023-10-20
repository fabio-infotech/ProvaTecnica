/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-19-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AccountTriggerHandler {
    private static final String CPF = 'CPF'; 
    private static final String CNPJ = 'CNPJ';
    private static final String MENSAGEM_ERRO_VALIDACAO_CPF_CNPJ = 'Número do cliente é inválido';
    private static final Integer TRINTA_DIAS = 30;

    public static void afterUpdate() {
        List<Account> accts = Trigger.new;
        List<Opportunity> opptsToInsert = new List<Opportunity>();
        List<Task> tasksToInsert = new List<Task>();
        String recordTypeName = '';

        for (Account acct : accts) {
            if (acct.RecordTypeId != null) {
                recordTypeName = Schema.getGlobalDescribe()
                    .get('Account')
                    .getDescribe()
                    .getRecordTypeInfosById()
                    .get(acct.RecordTypeId)
                    .getName();
            }

            if (!validarCpfCnpj(acct)) {
                acct.AccountNumber.addError(MENSAGEM_ERRO_VALIDACAO_CPF_CNPJ);
                continue;
            }

            if (acct.Type != CPF && acct.Type != CNPJ) {
                continue;
            }

            switch on recordTypeName {
                when 'Parceiro' {
                    opptsToInsert.add(novaOportunidade(acct));
                }
                when 'Consumidor final' {
                    tasksToInsert.add(novaTarefa(acct));
                }
            }
        }

        if (opptsToInsert.size() > 0) {
            insert opptsToInsert;
        }

        if (tasksToInsert.size() > 0) {
            insert tasksToInsert;
        }
    }

    private static Boolean validarCpfCnpj(Account acct) {
        string accountNumber = acct.AccountNumber != null ? acct.AccountNumber : '';

        if (acct.Type == CPF) {
            return Utils.ValidaCPF(Utils.RemoverFormatacaoCpfCnpj(accountNumber));
        } else if (acct.Type == CNPJ) {
            return Utils.ValidaCNPJ(Utils.RemoverFormatacaoCpfCnpj(accountNumber));
        } else {
            return true;
        }
    }

    private static Opportunity novaOportunidade(Account acct) {
        Opportunity oppt = new Opportunity();
        oppt.AccountId = acct.Id;
        oppt.Name = acct.Name + ' - opp Parceiro';
        oppt.CloseDate = System.today().addDays(TRINTA_DIAS);
        oppt.StageName = 'Qualification';

        return oppt;
    }

    private static Task novaTarefa(Account acct) {
        Task tsk = new Task();
        tsk.Subject  = 'Consumidor Final';
        tsk.WhatId = acct.Id;
        tsk.Status = 'Not Started';
        tsk.Priority = 'Normal';

        return tsk;
    }
}