public with sharing class ListViewExtension {
	
	//private final Opportunity opp;
	 private ApexPages.StandardSetController controller {get; set;}
	public Id currentListView{
		get;
		set { currentListView = value;
				system.debug('CURRENT : ' + currentListView);
		}
	}
	
	 
	 public ListViewExtension(ApexPages.StandardSetController controller) {
        //this.opp = (Opportunity)stdController.getRecord();
        this.controller = controller;
        
    }
    
  
	public PageReference createListView() {
	//	PageReference redirect = new PageReference(/ui/FilterEditPage?ftype=o);
		PageReference redirect = new PageReference('/ui/list/FilterEditPage?ftype=o&retURL=%2F006&cancelURL=%2F006%2Fo');
		redirect.setRedirect(true); 
		return redirect;
	}
}