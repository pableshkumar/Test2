@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
       // System.assertEquals('https://api.exchangeratesapi.io/latest', req.getEndpoint());
       // System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"rates":{"CAD":1.5601,"HKD":9.1707,"ISK":160.8,"PHP":57.306,"DKK":7.4403,"HUF":360.78,"CZK":26.727,"AUD":1.6242,"RON":4.858,"SEK":10.399,"IDR":17435.93,"INR":87.014,"BRL":6.2176,"RUB":89.1439,"HRK":7.5415,"JPY":123.49,"THB":36.889,"CHF":1.0776,"SGD":1.6082,"PLN":4.4602,"BGN":1.9558,"TRY":8.96,"CNY":8.0146,"NOK":10.7538,"NZD":1.7489,"ZAR":19.152,"USD":1.1833,"MXN":24.7344,"ILS":4.0511,"KRW":1375.96,"MYR":4.8687},"base":"EUR","date":"2020-09-18"}');
        res.setStatusCode(200);
        return res;
    }
}