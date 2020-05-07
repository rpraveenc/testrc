public with sharing class projectionRevenueUpdateController {
    @AuraEnabled
    public static List<Projection_Revenue__c> getProjectionRevenueList(string oppId){
    List<Projection_Revenue__c> projectionRevList= [select id,Month_of_Projection__c, Team_Head_Count__c, Revenue__c from Projection_Revenue__c where Opportunity__c=:oppId];
    return projectionRevList;
    }
    @AuraEnabled
    public static void saveProjectionRevenueList(List<Projection_Revenue__c> projectionRevList){       
     upsert projectionRevList;
    }
}