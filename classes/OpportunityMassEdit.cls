public class OpportunityMassEdit {

    List<Opportunity> oppList;
    public List<opportunitywrapper> oppWrapperList {get; set;}
    public Task task {get; set;}
    public String statusMessage { get; set; }
    public String statusMessage1 {get; set; }
    public integer counter {get; set;}    
    private ApexPages.StandardSetController controller;
    public integer amountfield {get; set;}
    public List<String> approvals {get; set;}
    public Boolean whatIdOptionsExist {get; set;}
    public String opptyIdToEdit {get; set;}
    /* Constructors */
    public OpportunityMassEdit(){} 
        
 
    public OpportunityMassEdit(ApexPages.StandardSetController theController)
    {   
        controller = theController;
    }      

	public void init() {
		whatIdOptionsExist = false;
        task = new Task();
        oppList = new List<Opportunity>();
        approvals = new List<String>();
        oppWrapperList = new List<opportunitywrapper>();
        oppList = (List<Opportunity>)controller.getSelected();
        oppList = [select Name, Type, CloseDate, StageName, Contract_Term__c, Worst_Case__c, Upside__c, commit__c from Opportunity where id in :oppList];
        for(Opportunity opp : oppList){ 
            oppWrapperList.add(new opportunitywrapper(opp));
        }
        }
        
    public PageReference SaveOpportunities() {
        oppList.clear();
        for(opportunitywrapper o : oppWrapperList){
            oppList.add(o.opp);
        }
    	system.debug('oppList - '+oppList);
        if(oppList.size()>0){
            update oppList;
        }
        return null;
    }

    public PageReference saveLog() {
        for(opportunitywrapper o : oppWrapperList){
           // system.debug('$$$$$$$$$$$:'+o.selected);
            if(o.selected == true){
                Task.whatId = o.opp.id; //should be task.WhatId
                insert task;
                o.selected = false;
                statusMessage = 'Last save at ' + DateTime.now();                
                break;
            }
        }
        return null;
    }
    
    public PageReference saveLogAndNew() {
        saveLog();
        task = new Task();
        
        
        return null;
    } 
    public PageReference updateModal() {
    	counter = 0;
    	for(opportunitywrapper o : oppWrapperList) {
    		if (o.selected == true) {
    			counter++;
    			//o.opp.DemoAmount__c = amountField;
    			o.opp.Upside__c = amountField;
    			//o.selected = false;
    			
    		}
    	}
    	statusMessage1 = counter + ' records have been updated.';
    	return null;
    }
    public PageReference ApprovalListModal() {
    	approvals.clear();
    	for(opportunitywrapper o : oppWrapperList) {
    		
    		 system.debug('$$$$$$$$$$$:'+o.selected);
    		if (o.selected == true) {
    			
    			approvals.add(o.opp.name);
    			
    			
    		}
    	}
    	system.debug('%%%%%%%%%%%%%: ' +approvals);
    	
    	return null;
    }
    
    public PageReference cancelModal() {
    	return null;
    }
    
    public PageReference editOppty() {
    	PageReference pageRef =  new PageReference('/apex/OpportunityWizard?id='+opptyIdToEdit);
        pageRef.setRedirect(true);
        return pageRef;                   
    }
    
    public class opportunitywrapper {
        public Opportunity opp {get; set;}
        public boolean selected {get; set;}
        public opportunitywrapper (opportunity o){
            opp = o;
            selected = false;
        }
    }
    
    public void NewOpp(){
        
    }
    
    public void SubmitApproval(){
        
    }
    
    private List<SelectOption> whatIdOptions = new List<SelectOption>();
    
    // Get What Id select options
    public List<SelectOption> getWhatIdOptions()
    {
        return whatIdOptions;
    }
    
    
    public void verifyOneCheck() {        
        whatIdOptions.clear();
        System.debug('oppWrapperList - '+oppWrapperList); 
        for(opportunitywrapper o : oppWrapperList)
        {
            system.debug('$$$$$$$$$$$:'+o.selected);
            if(o.selected == true)
            {
                whatIdOptions.add(new SelectOption(o.opp.Id, o.opp.name));
               // Task.whatId = o.opp.id;
            }
        }
        if (whatIdOptions.size()>0)
        {
        	whatIdOptionsExist = true;
        }
    }
}