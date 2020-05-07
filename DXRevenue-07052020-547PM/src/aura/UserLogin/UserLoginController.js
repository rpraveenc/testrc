({
	loginPage : function(component, event, helper) {
        //var recordId = component.get("recordId");
        var action = component.get("c.getContact");
        var UserName = component.get("v.UserName"); 
        var Password= component.get("v.Password");
        
        var State;
        
        action.setParams({ UserName:component.get("v.UserName"), Password:component.get("v.Password") });
        console.log("The value of a is " +UserName);
        console.log("The value of a is " +Password);
        
        if($A.util.isEmpty(UserName) || $A.util.isUndefined(UserName )){
            alert('Please Enter User Name!');
            return;
        }   
        if($A.util.isEmpty(Password) || $A.util.isUndefined(Password)){
            alert('Please Enter Password!');
            return;	
        } 
        
        action.setCallback(this,function(a){
            var recordId = component.get("v.recordId");
            var url = '/apex/UserDetails?Id =' + recordId;
            component.set("v.DisplayError",'');  
            
            State = a.getState();   
            console.log(a.getState());
            if(State == "SUCCESS") {
                var rtnValue = a.getReturnValue();
                if(rtnValue != "Invalid Password" && rtnValue != "User dose not exit!"){
                    console.log('rtnvalue is'+rtnValue);
                    // component.set("v.DisplayError",'Success login');
                   // window.open('www.google.com',"_self");
				   window.open('/apex/UserDetails?Id='+a.getReturnValue(),"_self");
                  

                }else{
                    component.set("v.DisplayError",'User Name or Password is incorrect');
                }
            }
            else{
                console.log('Unsuccessful');
                
            }
        });
        $A.enqueueAction(action);
        component.set("v.UserName",'');
        component.set("v.Password",'');
    },
    forgotpassword : function(component, event, helper){
        var cmpTarget = component.find('loginsection');
        
        console.log('hey');
        $A.util.addClass(cmpTarget,'displaynone');
        $A.util.removeClass(component.find('forgotpassword'), 'displaynone');
        var EnterPassword = component.get("v.EnterPassword"); 
        var ConfirmPassword= component.get("v.ConfirmPassword");
        
    },
    
    
    save : function(component,event,helper){
        
        var cmpTarget = component.find('forgotpassword');
        
        
        var action = component.get("c.getforgetpassword");
        var State;
        var UserName = component.get("v.UserName"); 
        var EnterPassword = component.get("v.EnterPassword"); 
        var ConfirmPassword= component.get("v.ConfirmPassword");
        if($A.util.isEmpty(UserName) || $A.util.isUndefined(UserName )){
            alert('Please Enter User Name!');
            return;
        }
        
        if($A.util.isEmpty(EnterPassword) || $A.util.isUndefined(EnterPassword)){
            alert('Please Enter Password!');
            return;
        }
        
        if($A.util.isEmpty(ConfirmPassword) || $A.util.isUndefined(ConfirmPassword)){
            alert('Please Enter Confirm Password!');
            return;
        }
        
        if(EnterPassword != ConfirmPassword){
            alert('OOPS mismatch password!');
            return;
        }
        
        $A.util.removeClass(component.find('loginsection'), 'displaynone');
        $A.util.addClass(component.find('forgotpassword'), 'displaynone');
        action.setParams({ UserName:component.get("v.UserName"), Password1:component.get("v.EnterPassword"), Password2:component.get("v.ConfirmPassword") });
        console.log("The value of a is " +UserName);
        console.log("The value of a is " +Password1);
        console.log("The value of a is " +Password2);
        action.setCallback(this,function(a){ 
            
            
            console.log('successful');
            State = a.getState();   
            
            if(State == "SUCCESS") {
                var result= a.getReturnValue();
                if(result =='SUCCESS'){
                    console.log('rtnvalue is'+result);
                    component.set("v.DisplayError",'Password changed Successfully, please relogin');
                    // component.set("v.DisplayError",'Success login');
                    // window.open('/apex/UpdateDetails?Id='+a.getReturnValue(),"_self");
                }
            }else{
                component.set("v.DisplayError",'OOPS mismatch password!');
            }
            
            
        });
        
        $A.enqueueAction(action);
        component.set("v.UserName",'');
        component.set("v.Password1",'');
        component.set("v.Password2",'');
    },
    
    doInit : function(component, event, helper) {
        
        
        $A.util.addClass(component.find('forgotpassword'), 'displaynone');
    },
     Cancel : function(component, event, helper) {
    
         var cmpTarget = component.find('forgotpassword');
         var action = component.get("c.getforgetpassword");
        $A.util.removeClass(component.find('loginsection'), 'displaynone');
        $A.util.addClass(component.find('forgotpassword'), 'displaynone');
    
     }
})