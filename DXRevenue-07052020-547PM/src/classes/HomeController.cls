public class HomeController {
    
    @AuraEnabled
    public static Contact fetchUser (String conId){
        system.debug([Select FirstName,LastName from Contact  where id=:conId]);
        return [Select FirstName,LastName from Contact  where id=:conId limit 1];
        
    }  
 
    
/*      @AuraEnabled 
    public static List<Account> getAccounts(String contactId){
        List<Account> accountList= new List<Account>();
        //List<String> months = new List<String>{'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar'};
        Contact c = new Contact();
        c = [SELECT Id, FirstName FROM Contact WHERE Id=:contactId];
        String fNameLike = '%' + c.FirstName + '%';
        List<Opportunity> oppList = new List<Opportunity>();
        oppList = [SELECT Id, Name, AccountID, Account.Name, DM__c  FROM Opportunity WHERE DM__c LIKE: fNameLike];
        Map<String,String> accountMap = new Map<String,String>();
        for(Opportunity opp: oppList){
        	 accountMap.put(opp.AccountId,opp.Account.Name);
             accountList.add(opp.Account.Name);
        }
        
        system.debug('----oppProjRevWrapperList---');
        return accountList;
    }
    */
    
    @AuraEnabled
    public static List<oppProjectionRevenuesWrapper> getOpportunities(String contactId, String recordType){
        Id oppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordType).getRecordTypeId();

        List<oppProjectionRevenuesWrapper> oppProjRevWrapperList= new List<oppProjectionRevenuesWrapper>();
        List<String> months = new List<String>{'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar'};
        Contact c = new Contact();
        c = [SELECT Id, FirstName, Name FROM Contact WHERE Id=:contactId];
        String fNameLike = '%' + c.FirstName + '%';
        List<Opportunity> oppList = new List<Opportunity>();
        oppList = [SELECT Id, Name, Account.Name, CurrencyIsoCode,DM__c, (SELECT Id, CurrencyIsoCode,Month_Year__c,Month_of_Projection__c, Revenue__c, Team_Head_Count__c FROM Projection_Revenues__r) 
        	 FROM Opportunity WHERE DM__c LIKE: fNameLike AND isDeleted=false AND RecordTypeId =: oppRecTypeId];
        
        for(Opportunity opp: oppList){
            List<Projection_Revenue__c> projRevList = new List<Projection_Revenue__c>();
            for(Projection_Revenue__c prObj:opp.Projection_Revenues__r){
            	if(prObj.Revenue__c == null){
            		prObj.Revenue__c=0.00;
            	}
            	if(prObj.Team_Head_Count__c == null){
            		prObj.Team_Head_Count__c=0;
            	}
            	
                projRevList.add(prObj);
            }
            
            oppProjRevWrapperList.add(new oppProjectionRevenuesWrapper(opp, projRevList, months ));
            
        }
        
        system.debug('----oppProjRevWrapperList---');
        return oppProjRevWrapperList;
    }
    
  
    @AuraEnabled
    public static void saveProjectionRevenues(List<oppProjectionRevenuesWrapper> oppProjRevWrapperList){
        System.debug('------oppProjRevWrapperList----'+oppProjRevWrapperList);
        List<Projection_Revenue__c> projRevListToBeUpdated = new List<Projection_Revenue__c>();
        for(oppProjectionRevenuesWrapper oPrRWrap: oppProjRevWrapperList){
            if(oPrRWrap.projRevList != null){
                projRevListToBeUpdated.addAll(oPrRWrap.projRevList);
            }
        }
        if(!projRevListToBeUpdated.isEmpty()){
            Database.Update(projRevListToBeUpdated,true);
        }
    }
    
    
    
}