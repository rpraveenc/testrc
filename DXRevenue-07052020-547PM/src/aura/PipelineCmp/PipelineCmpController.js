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
                var dmName = wrapdata[0].dm.Name;
                //alert(dmName);
                component.set('v.oppProjRevWrapperList', wrapdata);
                component.set('v.dmName', dmName);
                component.set('v.errorMessage',"");
                //alert(JSON.stringify(response.getReturnValue()));
                console.log('$$$JSON='+JSON.stringify(response.getReturnValue()));
            }
            else{
                component.set('v.failure',true);
                let errors = response.getError();
                var errorMessage = "";
                if (errors) {
                    var i =0;
                    for(i=0;i<errors.length;i++) {
                        if (errors[i] && errors[i].message)
                            errorMessage = errorMessage+" "+errors[i].message;
                    }
                }
                alert(errorMessage);
                component.set('v.errorMessage',errorMessage);
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
            time = setTimeout(logout,180000);  // time is in milliseconds
        }
    },
    
    handleSave : function(component, event, helper) {
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
                component.set('v.failure',false);
                component.set('v.errorMessage',"");
                alert("Saved successfully");
            }
            else{
                component.set('v.success',false);
                component.set('v.failure',true);
                let errors = a.getError();
                var errorMessage = "";
                if (errors) {
                    var i =0;
                    for(i=0;i<errors.length;i++) {
                        if (errors[i] && errors[i].message)
                            errorMessage = errorMessage+" "+errors[i].message;
                    }
                }
                alert(errorMessage);
                component.set('v.errorMessage',errorMessage);
            }
        });
        $A.enqueueAction(action)
    },
    
    logout : function(component, event, helper) {
        window.location = '/apex/vflight'
    },
    
    navigateToProjectDeliveryPage:function(component, event, helper) {
        var contactId = component.get("v.conId");
        //alert(contactId);
        var url = '/apex/UserDetails?Id=' + contactId;
        console.log(url);
        window.open('/apex/UserDetails?Id='+contactId,"_self");
    },
    
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
    
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
    
    handleCloseSuccess : function(component, event, helper) {
        component.set('v.success',false);
    },
    
    handleCloseFailure : function(component, event, helper) {
        component.set('v.failure',false);
    },
})