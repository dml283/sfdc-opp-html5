public with sharing class OpportunityWidgetController {

        public Opportunity oppty {get; private set;}
        public String id {get; private set;}
        public List<String> stringToSplit_1 {get; private set;}
        public List<String> stringToSplit_2 {get; private set;}
        public List<String> stringToSplit_3 {get; private set;}
        public List<String> stringToSplit_4 {get; private set;}
        public List<String> stringToSplit_5 {get; private set;}
        public Boolean accountHasData {get; set;}
        public Boolean activityHistoryExist {get; set;}
        public Boolean similarOpptyExist {get; set;}
        public String recType {get; set;}
        public String accountTitle {get; set;}
        public String stageName {get; set;}
        
        public OpportunityWidgetController() {}
        /* Controller */
        public OpportunityWidgetController(ApexPages.StandardController theController)
        {
            id = ApexPages.currentPage().getParameters().get('id');
            String recordType = ApexPages.currentPage().getParameters().get('RecordType');
            stageName = null;
            stringToSplit_1 = new List<String>();
            accountHasData = false;
            similarOpptyExist = false;
            activityHistoryExist = false;
            recType = '';
            accountTitle = '';
            if (id == null) {
                oppty = new Opportunity();
            }
            else {
                oppty = [SELECT Id, Name, AccountId, Type, Sales_Channel__c, CloseDate, StageName, Contract_Term_Months__c, Agency_Percentage__c, RecordTypeId, Payment_Period__c, 
                            Order_Billing_Email__c , Order_Billing_Contact__c , Lead_Grade__c, Agency_of_Record_AOR__c, Company_Type__c, AOR__c, Recruiting_Team_Size__c, Jobs_on_Website__c, 
                            Interest__c, Current_Tools__c, description, Order_Billing_Address_1__c, Order_Shipping_Address_1__c, Order_Billing_Address_2__c, PO_Required__c, 
                            Order_Shipping_Address_2__c, Order_Billing_City__c, Order_Shipping_City__c, Order_Billing_State_Province__c, Order_Shipping_State__c, Payment_Method__c,
                            Order_Billing_Country__c, Order_Shipping_Country__c, Order_Billing_Zip_Code__c, RecordType.Name, Order_Shipping_Postal_Zip__c,
                            (SELECT ActivityDate, Owner.Name, ActivityType, Description, LastModifiedDate From ActivityHistories) 
                         FROM Opportunity WHERE id = :id];
                recordType = oppty.RecordTypeId;
                stageName = oppty.StageName;
                
                Account[] accts = [Select Name, a.Owner.Name,RecordTypeId, NumberOfEmployees, (SELECT Name, Phone FROM Contacts ) From Account a WHERE Id =: oppty.AccountId];
                if (accts!=null && accts.IsEmpty() == false)
                {
                    System.debug('Account - '+ (String)accts[0].RecordTypeId);
                    stringToSplit_1.add('1_Account Owner_'+accts[0].Owner.Name+'_TEXT');
                    stringToSplit_1.add('1_Status_'+(('0126000000016JT'.contains(accts[0].RecordTypeId))?'Not Verified':'Verified')+'_TEXT');
                    stringToSplit_1.add('1_Employee Count_' + accts[0].NumberOfEmployees + '_TEXT');
                    if (accts[0].Contacts.size()>0)
                    {
                        stringToSplit_1.add('1_Contact_'+ accts[0].Contacts[0].Name+ '_LINK');
                        stringToSplit_1.add('1_Contact Phone Number_'+accts[0].Contacts[0].Phone+'_TEXT');
                    }
                    accountHasData = true;
                    accountTitle = accts[0].Name;
                
                }
                
                stringToSplit_3 = new List<String>();
                stringToSplit_3.add('3_Cerner_2000, Closed Won, 5/30/12, Aron_!');
                stringToSplit_3.add('3_Acclorie_3000, Closed Won, 6/30/12, Deer_!');
                stringToSplit_3.add('3_Adobe_4000, Closed Won, 7/30/12, Jack_!');
                similarOpptyExist = true;
            }
            if (recordType != null)
            {
                recordType = recordType.substring(0, 15);
                RecordType recTypeById = [SELECT Name FROM RecordType WHERE Id =: recordType];
                recType = recTypeById.Name;
            }
            System.debug('Record Type - '+ recordType);
            System.debug('stageName - '+ stageName);
            List<ActiveBasedNextStage__c> activitiesBasedNextStages;
            
            if (stageName != null){
                activitiesBasedNextStages = [SELECT DisplayText__c 
                                                FROM ActiveBasedNextStage__c 
                                                WHERE RecordTypeId__c =:recordType AND StageName__c =:stageName];
            }
            else
            {
                activitiesBasedNextStages = [SELECT DisplayText__c 
                                                FROM ActiveBasedNextStage__c 
                                                WHERE RecordTypeId__c =:recordType AND StageName__c = NULL];
            }
                
            stringToSplit_2 = new List<String>();
            integer i = 1;
            for (ActiveBasedNextStage__c activitiesBasedNextStage : activitiesBasedNextStages) {
                    stringToSplit_2.add('2_'+activitiesBasedNextStage.DisplayText__c + '_' + i+ '_!');
                    i++;
            }
                    
            stringToSplit_4 = new List<String>();
            stringToSplit_4.add('4_Submit for Approval_!_!');
            stringToSplit_4.add('4_Generate Contract_!_!');
            stringToSplit_4.add('4_Log a Call_!_!');
            
            if (oppty.ActivityHistories!=null && oppty.ActivityHistories.size()>0)
            {
                stringToSplit_5 = new List<String>();
                for(ActivityHistory activityHist : oppty.ActivityHistories)
                {                   
                    Datetime activityDate = Datetime.newInstance(activityHist.ActivityDate.year(), activityHist.ActivityDate.month(),activityHist.ActivityDate.day());
                    stringToSplit_5.add('5_'+activityHist.Owner.Name + ' made a '+activityHist.ActivityType+' - ' + 
                                        activityHist.Description+'_ ' + activityDate.format('MMM dd, yyyy')+ '_!');
                }
                activityHistoryExist = true;
            }                                        
        }
                
        public PageReference saveAndAddProduct()
        {
                try
                {
                    upsert oppty;
                    
                    PageReference pageRef = new PageReference('/p/opp/SelectSearch?addTo='+ oppty.Id + '&retURL=/006/e');
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
                
        public PageReference save()
        {
                try
                {
                        upsert oppty;
                        
                        PageReference pageRef = new PageReference('/'+ oppty.Id);
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
                        if (id!=null){
                                pageRef = new PageReference('/'+ id);
                        }
                        else
                        {
                                pageRef = new PageReference('/006/e');
                        }
                        pageRef.setRedirect(true);
                }
        catch(Exception ex)
        {
            System.debug('Error - ' + ex);
        }
        return pageRef;
        }
        
}