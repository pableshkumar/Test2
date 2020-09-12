trigger OrderTrigger on Order__c (before insert) {

    shareito.ShareITInit shareInit = new shareito.ShareITInit(shareito.ShareITType.FULL);
    shareInit.processSharing();
}