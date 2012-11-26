public with sharing class OppMassEdit {

public Boolean whatIdOptionsExist {get; set;}
public Integer multipleChecked {get; set;}
  public Task task {get; set;}
  public List<Opportunity> oppList {get; set;}
  public String OpportunityUpdateName {get; set;}
  public Date OpportunityUpdateCloseDate {get; set;}
  public String OpportunityUpdateType {get; set;}
  public String OpportunityUpdateStageName{get; set;}
 public List<opportunitywrapper> OpportunityList {get; set;} //intial loaded
 public String selectedids {get; set;}
 List<Opportunity> updateList = new List<Opportunity>();
 
 public String editId{get; set;}
 
private List<SelectOption> whatIdOptions = new List<SelectOption>();
private ApexPages.StandardSetController controller;
List<Opportunity> selectedOpportunities = new List<Opportunity>(); //selected from checkbox
public OppMassEdit() {
	
}
public OppMassEdit(ApexPages.StandardSetController theController)
    {   
        this.controller = theController;
        
        //this.oppList = (List<Opportunity>)theController.getRecords();  
    } 

/*public List<SelectOption> getListViewOptions() {
	return controller.getListViewOptions();	
} */

public List<SelectOption> getListViews() {
		List<SelectOption> options = new List<SelectOption>();
		List<SelectOption> ctloptions = new List<SelectOption>();
		ctloptions = (List<SelectOption>)controller.getListViewOptions();
		for (SelectOption so : ctloptions)
		{
			options.add(new SelectOption(so.getValue(),so.getLabel()));
		}
		return options;
}
  public PageReference getSelected()
    {
    	system.debug('ENTERED GETSELECTED $$');
        selectedOpportunities.clear();
        for(opportunitywrapper oppwrapper: OpportunityList)
        {
        	if(oppwrapper.selected == true)
        	selectedOpportunities.add(oppwrapper.opp);
        }
        return null;
    }
    public List<Opportunity> getselectedOpportunities()
    {
        if(selectedOpportunities.size()>0)
        return selectedOpportunities;
        else
        return null;
    }   

  
 public void init() {
		whatIdOptionsExist = false;
		multipleChecked=0;
        task = new Task();
        OpportunityList = new List<opportunityWrapper>();
        oppList = (List<Opportunity>)controller.getRecords();
        oppList = [select Name, Type, CloseDate, StageName, Contract_Term__c, Worst_Case__c, Upside__c, commit__c from Opportunity where id in :oppList];
        for(Opportunity opp : oppList){ 
           OpportunityList.add(new opportunitywrapper(opp));
        }
       
  }
   public List<SelectOption> getStageNames() {
		List<SelectOption> options = new List<SelectOption>();
		Schema.Describefieldresult fieldresult = Opportunity.StageName.getDescribe();
		List<Schema.Picklistentry> ple = fieldResult.getPicklistValues();
		for (Schema.PickListEntry f : ple)
		{
			options.add(new SelectOption(f.getLabel(),f.getValue()));
		}
		return options;
	}
	
	 public List<SelectOption> getTypes() {
		List<SelectOption> options = new List<SelectOption>();
		Schema.Describefieldresult fieldresult = Opportunity.Type.getDescribe();
		List<Schema.Picklistentry> ple = fieldResult.getPicklistValues();
		for (Schema.PickListEntry f : ple)
		{
			options.add(new SelectOption(f.getLabel(),f.getValue()));
		}
		return options;
	}
  
  
  public class opportunitywrapper {
        public Opportunity opp {get; set;}
        public boolean selected {get; set;}
        public opportunitywrapper (opportunity o){
            opp = o;
            selected = false;
        }
    }
 
    
    // Get What Id select options
    public List<SelectOption> getWhatIdOptions()
    {
        return whatIdOptions;
    }

  public void verifyOneCheck() {        
        whatIdOptions.clear();
        multipleChecked=0;
        for(opportunitywrapper o : OpportunityList){
            system.debug('$$$$$$$$$$$:'+o.selected);
            if(o.selected == true){
                whatIdOptions.add(new SelectOption(o.opp.Id, o.opp.name));
                multipleChecked++;
                Task.whatId = o.opp.id;
            }
        }
        if (whatIdOptions.size()>0)
        {
        	whatIdOptionsExist = true;
        }
        else
        	whatIdOptionsExist = false;
    }
    
     public PageReference SaveOpportunities() {
     	//PageReference pageRef = new PageReference('/apex/My_Opportunities');
     	//update OpportunityList.opp;
     	updateList.clear();
        //oppList.clear();
        system.debug('OPPLIST$$ ' + OpportunityList);
        for(opportunitywrapper o :  OpportunityList){
            updateList.add(o.opp);
        }
        system.debug('UPDATELIST$$' + updateList);
        if (updateList.size() >0)
        	update updateList;
    	//system.debug('oppList - '+oppList);
        //if(oppList.size()>0){
            //update oppList;
        //}
        return null;
    }


  public PageReference saveLog() {
        for(opportunitywrapper o : OpportunityList){
            if(o.selected == true){
                task.whatId = o.opp.id;
                task.ownerId = UserInfo.getUserId();
                insert task;
                o.selected = false;
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
    
    public PageReference RefreshTable() {
    	//PageReference pageref = new PageReference('/apex/My_Opportunities');
    	OpportunityList.clear();
    	return null;
    }
    
     public PageReference updateModal() {
     	updateList.clear();
     	
     	for (opportunityWrapper o : OpportunityList)
     	{
     		Opportunity oppUpdate = new Opportunity();
     		if (o.selected==true)
     		{
     			oppUpdate = o.opp;
     			if (OpportunityUpdateName <> '')
     			{
     				oppUpdate.Name = OpportunityUpdateName;
     			} 
     			if (OpportunityUpdateCloseDate <> null)
     			{
     				oppUpdate.CloseDate = OpportunityUpdateCloseDate;
     			}
     			if (OpportunityUpdateType<>'')
     			{
     				oppUpdate.Type = OpportunityUpdateType;
     			}
     			if(OpportunityUpdateStageName<>'')
     			{
     				oppUpdate.StageName = OpportunityUpdateStageName;
     			}
     			updateList.add(oppUpdate);
     			o.selected=false;
     		}
     		
     	}
     	update updateList;
     	whatIdOptions.clear();
     	
    	return null;
    }
    public PageReference cancelModal() {
    	whatIdOptions.clear();
    	for (opportunityWrapper o : OpportunityList)
    	{
    		if (o.selected == true){
    			o.selected =false;
    		}
    	}
    	return null;
    }
    public PageReference editOppy() {
     	PageReference pageRef =  new PageReference('/apex/MyOpportunityEdit?id='+editId);
      //  pageRef.setRedirect(true);
        return pageRef;
     
        
    
    }
    
    
     

    
}