/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-19-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class Utils {
    public static Boolean ValidaCNPJ(String cnpj) {
        if (cnpj == '') {
            return false;
        } else {
            return true;
        }
    }

    public static Boolean ValidaCPF(String cpf) {
        if (cpf == '') {
            return false;
        } else {
            return true;
        }
    }

    public static String RemoverFormatacaoCpfCnpj(String cpf_cnpj) {
        return cpf_cnpj
            .replace('.', '')
            .replace('-', '')
            .replace('/', '');
    }
}