({
   openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
   },
  
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
  
	saveProjectionRevenueComments : function(component, event, helper) {
		
        var currentRecordObj = component.get("v.ProjRevObj");
		alert(JSON.stringify(currentRecordObj));
        var action = component.get('c.saveProjectionRevenuesComments');
        action.setParams({ 
            "pr": currentRecordObj
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                //component.set('v.success',true);
                alert("Saved successfully");
				component.set("v.isModalOpen", false);
            }
            else if(state !== "SUCCESS"){
                component.set('v.success',false);
                var toastEvent = $A.get("e.force:showToast");
                alert('toastEvent'+toastEvent);
                toastEvent.setParams({
                    title : 'Error',
                    message:'This is an error message',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action)
	},
})