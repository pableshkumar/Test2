public with sharing class VendorOnBoardingController {
    @AuraEnabled
    public static Boolean createContact(List<Contact> ConList){
        Boolean contactCreated=false;
        try {
            System.debug('contact list'+ConList);
            Database.SaveResult[] srList = Database.insert(ConList, false);
            System.debug('srList---'+srList);
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    contactCreated=true;
                } 
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return contactCreated;
    }
}