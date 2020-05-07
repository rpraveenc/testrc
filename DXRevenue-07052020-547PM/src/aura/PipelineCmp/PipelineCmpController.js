({
   
    doInit : function(component, event, helper) {
      
       var action = component.get("c.getOpportunities");
      
       action.setParams({ 
           "contactId": component.get('v.conId'),
           "recordType": "Pipeline"
       });
       action.setCallback(this, function(response) {           
           var state = response.getState();
           if (state === "SUCCESS") {
               var wrapdata = response.getReturnValue();
              
                component.set('v.oppProjRevWrapperList', wrapdata);
            
              
               console.log('$$$JSON='+JSON.stringify(response.getReturnValue()));
           }
       });
       $A.enqueueAction(action);
    },
   
    SessionTimeOut : function(component, event, helper) {
        var time;
        resetTimer();
        window.onmousemove = resetTimer;
        window.onkeypress = resetTimer;
        window.ontouchstart = resetTimer;
        window.onclick = resetTimer;
        window.addEventListener('scroll', resetTimer, true); // improved; see comments

        function logout() {

            alert("Oops! Your session has expired. Please login again to continue.")
            window.location = '/apex/vflight'
        }
        
        function resetTimer() {
            clearTimeout(time);
            time = setTimeout(logout,60000);  // time is in milliseconds
        }
    },
      
    handleSave : function(component, event, helper) {
        debugger;
        var param = component.get("v.oppProjRevWrapperList");
        console.log('parammmmmmmmmmmm'+JSON.stringify(param));
        
        var action = component.get('c.saveProjectionRevenues');
        action.setParams({ 
            "oppProjRevWrapperList": param
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                component.set('v.success',true);
                alert("Saved successfully");
            }
        });
        $A.enqueueAction(action)
    },
   
    logout : function(component, event, helper) {
        window.location = '/apex/vflight'
    }
   
   
})