global class CurrencyConversionClass implements Database.Batchable<sObject>, Database.AllowsCallouts {
	global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        String query = 'select Id,IsoCode,ConversionRate,IsCorporate from CurrencyType';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<CurrencyType> currencyList) {
        // process each batch of records default size is 200
         try {  
             string corpCurrency = 'INR';
             Map<String,Object> currencyRequest = New Map<String,Object>();
             HttpRequest req = new HttpRequest();
             HttpResponse res = new HttpResponse();
             Http http = new Http();
             String endpoint = 'https://api.exchangeratesapi.io/latest';
             req.setHeader('Content-Type', 'application/json');
             req.setEndpoint(endpoint);
             req.setMethod('GET');
             req.setCompressed(true); // This is imp according to SF, but please check if
             res = http.send(req);
             String sJson = res.getBody();
             Map<String,Object> rawObj = (Map<String,Object>) JSON.deserializeUntyped(sJson);
             currencyRequest = (Map<String,Object>)rawObj.get('rates');
             for(CurrencyType curtype : currencyList){
                 if(curtype.IsCorporate){
                    corpCurrency = curtype.IsoCode;
                 }
             }
             for(CurrencyType ctype : currencyList){
                 if(currencyRequest.containskey(ctype.IsoCode)){
                     //Decimal eurCurrencyRate = 1 / (Decimal)currencyRequest.get('INR');
                     Decimal eurCurrencyRate = 1 / (Decimal)currencyRequest.get(corpCurrency);
                     Decimal finalCurrRate = eurCurrencyRate * (Decimal)currencyRequest.get(ctype.IsoCode);
                     Http h = new Http();
                     HttpRequest updateCurrencyReq = new HttpRequest();
                     updateCurrencyReq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v45.0/sobjects/currencytype/' + ctype.Id + '?_HttpMethod=PATCH');
                     updateCurrencyReq.setBody('{ "ConversionRate" : '+ finalCurrRate +' }');
                     updateCurrencyReq.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
                     updateCurrencyReq.setHeader('Content-Type', 'application/json');
                     updateCurrencyReq.setMethod('POST');
                     HttpResponse updateCurrencyRes = h.send(updateCurrencyReq);
                 }else{
                     //Decimal eurCurrencyRate = 1 / (Decimal)currencyRequest.get('INR');
                     Decimal eurCurrencyRate = 1 / (Decimal)currencyRequest.get(corpCurrency);
                     Http h = new Http();
                     HttpRequest updateCurrencyReq = new HttpRequest();
                     updateCurrencyReq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v45.0/sobjects/currencytype/' + ctype.Id + '?_HttpMethod=PATCH');
                     updateCurrencyReq.setBody('{ "ConversionRate" : '+ eurCurrencyRate +' }');
                     updateCurrencyReq.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
                     updateCurrencyReq.setHeader('Content-Type', 'application/json');
                     updateCurrencyReq.setMethod('POST');
                     HttpResponse updateCurrencyRes = h.send(updateCurrencyReq);
                 }
                 
             }
         }
        catch (Exception e) {         
            System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber() );           
        }
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
}