public  class OpportunityTriggerHandler {
    public static Map<Integer,String> mapOfMonNumberToMonName = new Map<Integer,String>{1=>'Jan',2=>'Feb',3=>'Mar',4=>'Apr',5=>'May',6=>'Jun',7=>'Jul',8=>'Aug',9=>'Sep',10=>'Oct',11=>'Nov',12=>'Dec'};
    
    public static Map<String,String> mapMonthNumber = new Map<String,String>{'Jan'=>'01','Feb'=>'02','Mar'=> '03','Apr'=> '04','May'=> '05','Jun'=> '06','Jul'=> '07','Aug'=> '08','Sep'=> '09','Oct'=> '10','Nov'=> '11','Dec'=> '12'};

 
    public static void processAfterInsert(List<Opportunity> oppList, Map<ID, Opportunity> oldValuesMap) {
        try{
            createProjectionRevenue(oppList,null);
        }catch(Exception exc){
            throw exc; 
        }
    }
    
    public static void processAfterUpdate(List<Opportunity> oppList, Map<ID, Opportunity> oldValuesMap) {
        try{
            UpdateRevenueProjectionNames(oppList,oldValuesMap);
        }catch(Exception exc){
            throw exc; 
        }
    }
    
    public static void UpdateRevenueProjectionNames(List<Opportunity> oppList, Map<ID,Opportunity> oldValuesMap){
    	Map<String, String> newOPIDOpp = new Map<String,String>();
    	for(Opportunity oppRec : oppList){
    		if(oppRec.OP_Project_Id__C != (oldValuesMap.get(oppRec.Id)).OP_Project_Id__C){
    			newOPIDOpp.put(oppRec.Id, oppRec.OP_Project_Id__C);
    		}
    	}
    	if(newOPIDOpp.size() > 0){
	    	List<Projection_Revenue__c> revenueProj = [select Id, Name,Opportunity__c from Projection_Revenue__c where Opportunity__c =: newOPIDOpp.keyset() for update];
	    	List<Projection_Revenue__c> revenueProjUpdate = new List<Projection_Revenue__c>();
	    	if(revenueProj != null){
	    		for(Projection_Revenue__c revenueProjRec : revenueProj){
	    			String newName = revenueProjRec.Name;
	    			System.debug('OLD - '+newName);
	    			if(newName.contains('PRJID')){
	    				newName = newName.replace('PRJID',newOPIDOpp.get(revenueProjRec.Opportunity__c));
	    			}else{
	    				String oldOPID = newName.substringBefore('-');
	    				System.debug('OLD PID - '+oldOPID);
	    				newName = newName.replace(oldOPID,newOPIDOpp.get(revenueProjRec.Opportunity__c));
	    			}
	    			System.debug('NEW - '+newName);
	    			revenueProjRec.Name = newName;
	    			revenueProjUpdate.add(revenueProjRec);
	    		}
	    		System.debug('REVENU PROJ ----'+revenueProjUpdate);
	    		if(revenueProjUpdate.size() > 0){
	    			update revenueProjUpdate;
	    		}
	    	}
    	}
    }
    
    
    public static void createProjectionRevenue(List<Opportunity> oppList, Map<ID, Opportunity> oldValuesMap){
        
        List<Projection_Revenue__c> projRevToBeCreated = new List<Projection_Revenue__c>();
        for(Opportunity opp: oppList){
            if(opp.Start_Date__c != null && opp.End_Date__c != null){
                for(String month: getMonthsForOpportunity(opp)){
                    System.debug('OPP ID--'+ opp.Id);
                    String oppProjectId = 'PRJID';
                    if(opp.OP_Project_Id__C != null){
                    	oppProjectId = opp.OP_Project_Id__C;
                    }
                    String monthIs = mapMonthNumber.get(month.substringBefore('-'));
                    String yearIs = month.substringAfterLast('-');
                    Date dateYear = Date.parse(monthIs+'/01/'+yearIs);
                    projRevToBeCreated.add(new Projection_Revenue__c(name = oppProjectId+'-'+month, 
                            opportunity__c = opp.Id,
                            Month_of_Projection__c = month.substringBefore('-'),
                            CurrencyIsoCode = opp.CurrencyIsoCode,
                                Month_Year__c = month,
                                Month_Date__c = dateYear));
                }
            }
        } 
        System.debug('---------------'+projRevToBeCreated);
        if(projRevToBeCreated.Size() > 0){
            insert(projRevToBeCreated);
        }
    }
    
    public static List<String> getMonthsForOpportunity(Opportunity opp){
        List<String> months = new List<String>();
        Date currentDate = opp.Start_Date__c;
        Date endDate = opp.end_Date__c.addMonths(1).toStartOfMonth().addDays(-1);
        While(currentDate <= endDate){
            String month = mapOfMonNumberToMonName.get(currentDate.Month());
            months.add(month +'-'+ currentDate.year());
            currentDate = currentDate.addMonths(1);
        }
        return months;
    }
    
    public static void validateEndDate(List<Opportunity> oppList){
        for(Opportunity opp: oppList){
        	if(opp.RecordType.Name == 'Project Delivery'){
	            Date endDateToValidate;
	            if(opp.Start_Date__c.month() <= 3){
	                endDateToValidate = Date.newInstance(opp.start_Date__c.year(),3,31);
	            }else{
	                endDateToValidate = Date.newInstance((opp.start_Date__c.addYears(1)).year(),3,31);
	            }
	            System.debug('Start Date - '+opp.Start_Date__c+'-------End Date --'+opp.End_Date__c+'---valiate with --'+endDateToValidate);
	            if( opp.start_Date__c > opp.End_Date__c){
	                opp.addError(' Start Date cannot be greater than the End date');
	            }else if(opp.End_Date__c > endDateToValidate){
	                opp.addError(' End Date cannot be greater than the current Financial year end date');
	            }
        	}
        }
    }
}