public class oppProjectionRevenuesWrapper{
    
         @AuraEnabled public Opportunity opp {get;set;}
         @AuraEnabled public List<Projection_Revenue__c> projRevList{get;set;}
         @AuraEnabled public List<String> months{get;set;}
        //public Map<String,Projection_Revenue__c> mapOfMonToProjectionRevenues {get; set;}
    
        public oppProjectionRevenuesWrapper(){
        }
        
        public oppProjectionRevenuesWrapper( Opportunity opp, List<Projection_Revenue__c> projRevList, List<String> months){
            this.opp = opp;
            this.projRevList = projRevList;
            this.months = months;
        }
    }