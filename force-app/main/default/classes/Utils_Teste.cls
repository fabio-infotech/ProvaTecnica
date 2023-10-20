/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-19-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class Utils_Teste {
    @IsTest
    private static void testValidaCPF() {
        Boolean result;

        result = Utils.ValidaCPF('679.894.375-62');
        System.assertEquals(true, result);

        result = Utils.ValidaCPF('');
        System.assertEquals(false, result);
    }

    @IsTest
    private static void testValidaCNPJ() {
        Boolean result;

        result = Utils.ValidaCNPJ('21.549.030/0001-21');
        System.assertEquals(true, result);

        result = Utils.ValidaCNPJ('');
        System.assertEquals(false, result);
    }

    @IsTest
    private static void testRemoverFormatacaoCpfCnpj() {
        String resultCPF = Utils.RemoverFormatacaoCpfCnpj('679.894.375-62');
        String resultCNPJ = Utils.RemoverFormatacaoCpfCnpj('21.549.030/0001-21');

        System.assertEquals('67989437562', resultCPF);
        System.assertEquals('21549030000121', resultCNPJ);
    }
}