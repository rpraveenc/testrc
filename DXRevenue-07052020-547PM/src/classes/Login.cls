public class Login {
    @AuraEnabled
    // public Team_Member_Profile__c  Team{get;set;}
        public static string getContact(String UserName,String Password){
            List<Contact> conList =new List<Contact>([select Id,User_Name__c,Password__c from Contact Where User_Name__c=:UserName]);
        system.debug('team details'+conList);
        if(conList.size()==0){
            return 'User dose not exit!';
        }       
        else{
            if(conList[0].User_Name__c == UserName && conList[0].Password__c == Password ){
                //system.debug('@@@@@TeamMemberRecordId', +TeamMemberRecordId);
                //String id = ApexPages.currentPage().getParameters().get('Team.id');
                String recordId = conList[0].Id;
                system.debug('@@@@@TeamMemberRecordId'+recordId);
                //RedirectPage(recordId);
                //return 'Login Success';
                return recordId;
            }
            else{
               return 'Invalid Password';
            }  
            
            
        }
    }
    
  
    
    public String UserName {get; set;} 
     @AuraEnabled
    public static String getforgetpassword(String UserName,String Password1,String Password2 ) {  
         String procesMsg = '';
           Contact ConObj =[select Id,User_Name__c,Password__c from Contact Where User_Name__c = :UserName limit 1];
      if(Password1 == Password2){
           ConObj.Password__c = Password2;
          update ConObj;
          procesMsg = 'SUCCESS';

      } else {
        procesMsg = 'ERROR';
      }
        
         return procesMsg;
       }
   
  
                          

}