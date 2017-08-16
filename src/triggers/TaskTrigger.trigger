trigger TaskTrigger on Task (before insert) {
    try{
    if(trigger.isBefore && trigger.isInsert){
        List<Task> allTasks = trigger.new;
        Set<Id> userIdSet = new Set<Id>();
        for(Task tsk : allTasks){
           userIdSet.add(tsk.ownerId); 
        }
        Map<Id,User> userMap;
        if(userIdSet.size() > 0){
           userMap  = new Map<Id,User>([select Id, Role__c from User where id in : userIdSet]);
        }
        for(Task tsk : allTasks){
            if(tsk.Team_Role__c == null || ''.equals(tsk.Team_Role__c)){
                tsk.Team_Role__c = ((User)userMap.get(tsk.OwnerId)).Role__c;
            }
        }
        
    }
    }catch(Exception e){
       system.debug('Exception in Task Trigger : '+e.getMessage()); 
    }

}