public class RedirecttoBillingDetail {

    public static PageReference redirectToBilling()
    {
        PageReference pg = new PageReference('/'+'a089D000002RJwJQAW');
        pg.setRedirect(true);
        return pg; 

    }
}