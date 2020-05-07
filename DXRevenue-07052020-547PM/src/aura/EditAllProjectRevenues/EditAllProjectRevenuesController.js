({
    // function call on component Load
    doInit: function(component, event, helper) {
        helper.fetchProjectionRevenues(component,event);
        action.setParams({ 
            "oppId": component.get('v.oppId'),
            "conId": component.get('v.conId')
        });
    },
    // function for save the Records
    Save: function(component, event, helper) {                   
            var action = component.get("c.saveProjectionRevenueList");       
            action.setParams({
                "projectionRevList": component.get("v.projectionRevList")
            });
            // set call back
            var recId = component.get("v.recordId");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var conId = component.get("v.conId");
                    window.open('/apex/UserDetails?Id='+conId);
                   /*var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                      "recordId": recId                     
                    });
                navEvt.fire();*/
                }
                else{
                    console.log('eerrr');
                }
            });
            // enqueue the server side action
            $A.enqueueAction(action);       
    },
    
})