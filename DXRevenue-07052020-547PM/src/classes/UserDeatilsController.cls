public class UserDeatilsController {
    public String contactId {get;set;}
    public UserDeatilsController(){
        contactId = ApexPages.currentPage().getParameters().get('Id');
        System.debug('---contactID---'+contactId);
    }
}