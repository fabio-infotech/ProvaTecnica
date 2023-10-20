/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-20-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class SchAccBatchInativarContas_Teste {
    @IsTest
    private static void test() {
        Boolean expectedExceptionThrown;

        try {
            SchedulableAccBatchInativarContas.scheduleBatch();
        } catch (Exception e) {
            expectedExceptionThrown =  e.getMessage().contains('Script-thrown exception') ? true : false;
            System.assertEquals(true, expectedExceptionThrown);
        }
    }
}