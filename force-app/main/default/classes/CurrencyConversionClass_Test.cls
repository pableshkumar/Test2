@isTest
public class CurrencyConversionClass_Test {
    
    public static TestMethod void testMethod1()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Database.executeBatch(new CurrencyConversionClass());
    }
    
}