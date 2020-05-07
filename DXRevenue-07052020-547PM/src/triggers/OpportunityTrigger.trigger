trigger OpportunityTrigger on Opportunity (before insert, after insert, after update) {   
    
    if(Trigger.isBefore ){
        if(Trigger.isInsert){
            OpportunityTriggerHandler.validateEndDate(Trigger.new);
        }
    }
    if(Trigger.isAfter ){
        if(Trigger.isInsert){
            OpportunityTriggerHandler.processAfterInsert(Trigger.new,null);
        }
         if(Trigger.isUpdate){
            OpportunityTriggerHandler.processAfterUpdate(Trigger.new,Trigger.oldMap);
        }
    }
}