trigger OpportunityTrigger on Opportunity (before insert, after insert, after update) {   
    
    if(Trigger.isBefore ){
        if(Trigger.isInsert){
            OpportunityTriggerHandler.processBeforeInsert(Trigger.new,null);
        }
        if(Trigger.isUpdate){
            OpportunityTriggerHandler.processBeforeUpdate(Trigger.new,Trigger.oldMap);
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