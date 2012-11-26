public with sharing class MyOpportunityEditController {
	
	public String editId {get; set;}
	public Opportunity oppty {get; set;}
	public List<String> stringToSplit_1 {get; set;}
	public Boolean accountHasData {get; set;}
    public Boolean activityHistoryExist {get; set;}
    public Boolean similarOpptyExist {get; set;}
    public String recType {get; set;}
    public String accountTitle {get; set;}
    public String stageName {get; set;} 
    public String contactId {get; set;}
 
	 public MyOpportunityEditController(){}    
        
	
	  public MyOpportunityEditController(ApexPages.StandardController theController) {
     	
     	editId = ApexPages.currentPage().getParameters().get('id');
		if (editId == null) {
                oppty = new Opportunity();
                stringToSplit_1 = new List<String>();
            }
            else {
		    	oppty = [Select commit__c, Worst_Case__c, Upside__c, Type, TrackingNumber__c, TotalOpportunityQuantity, Timeframe__c, StageName, Sales_Channel__c, Recruiting_Team_Size__c, Project_Sponsor__c, Probability, Pricebook2Id, Payment_Period__c, 
		    	Payment_Method__c, PO_Required__c, OwnerId, Order_Shipping_State__c, Order_Shipping_Postal_Zip__c, Order_Shipping_Country__c, Order_Shipping_City__c, Order_Shipping_Address_2__c, Order_Shipping_Address_1__c, Order_Billing_Zip_Code__c, 
		    	Order_Billing_State_Province__c, Order_Billing_Email__c, Order_Billing_Country__c, Order_Billing_Contact__c, Order_Billing_City__c, Order_Billing_Address_2__c, Order_Billing_Address_1__c, OrderNumber__c, NextStep, Name, MainCompetitors__c, Lead_Grade__c, LeadSource, 
		    	LastModifiedDate, LastModifiedById, LastActivityDate, Jobs_on_Website__c, IsWon, IsPrivate, IsDeleted, IsClosed, Interest__c, Id, HasOpportunityLineItem, ForecastCategoryName, ForecastCategory, FiscalYear, FiscalQuarter,
		    	Fiscal, ExpectedRevenue, Description, DeliveryInstallationStatus__c, Current_Tools__c, CurrentGenerators__c,CurrencyIsoCode, Contract_Term__c, Contract_Term_Months__c, Company_Type__c, CloseDate, CampaignId, Amount, 
		    	Agency_of_Record_AOR__c, Agency_Percentage__c, AccountId, AOR__c From Opportunity where Id = :editId]; 
            	
            	stageName = oppty.StageName;//stage name for bar
            	stringToSplit_1 = new List<String>();
            	
            	
            	/*Account[] accts = [Select Name, a.Owner.Name,Industry, (SELECT Name, Phone FROM Contact where accountId = :oppty.AccountId ) From Account a WHERE Id =: oppty.AccountId];
                if (accts!=null && accts.IsEmpty() == false)
                {
                	//system.debug('ACCTS $$' + accts);
                	if (accts[0].Contacts.size()>0)
                    {
                        stringToSplit_1.add('1_Contact_'+ accts[0].Contact[0].Name+'_TEXT');
                        stringToSplit_1.add('1_Contact Phone Number_'+accts[0].Contacts[0].Phone+'_TEXT');
                    }
                    stringToSplit_1.add('1_Industry_'+accts[0].Industry+'_TEXT');
                    stringToSplit_1.add('1_Account Owner_'+accts[0].Owner.Name+'_TEXT');
                  
                    
                    accountHasData = true;
                    accountTitle = accts[0].Name;
                }*/
                List<Contact> contacts = [select Name, id, Phone, Account.Name, Account.Industry, Account.Owner.Name from Contact where accountId = :oppty.AccountId];
                system.debug('contacts$$' + contacts);
                
            	for (integer i=0; i<1; i++ )
            	{
            		system.debug('Contact$ ' + contacts[i].Name);
            		system.debug('Phone$ ' + contacts[i].Phone);
            		system.debug('Industry$ ' + contacts[i].Account.Industry);
            		system.debug('Owner$ ' + contacts[i].Account.Owner.Name);
            		
            		 stringToSplit_1.add('1_Contact_'+ contacts[i].Name+'_LINK');
                     stringToSplit_1.add('1_Contact Phone Number_'+ contacts[i].Phone+'_TEXT');
                     stringToSplit_1.add('1_Industry_'+ contacts[i].Account.Industry+'_TEXT');
                     stringToSplit_1.add('1_Account Owner_'+ contacts[i].Account.Owner.Name+'_TEXT');
            		accountHasData = true;
            		accountTitle= contacts[i].Account.Name;
            		contactId = contacts[i].id;
            	}	
            	
            
            
            }
             
	
			
    }
	

	public PageReference save() {
		
		 try
                {
                  upsert oppty;
					PageReference pageRef = new PageReference('/apex/MyOpportunityEdit?id='+ oppty.Id);
				pageRef.setRedirect(true);
                return pageRef;
                }
        catch(Exception ex)
        {
            System.debug('Error - ' + ex);
            ApexPages.Message msgError = new ApexPages.Message(ApexPages.Severity.Error, 'Error Upserting opportunity - error message - ' + ex.getMessage());  
            ApexPages.addMessage(msgError);
            return null;
        }
        return null;          
	}
	 public PageReference cancelOpportunity()
    {
        PageReference pageRef;
        try
        {
			pageRef = new PageReference('/apex/My_Opportunities');
            pageRef.setRedirect(true);
        }
        catch(Exception ex)
        {
            System.debug('Error - ' + ex);
        }
        return pageRef;
    }
        



}