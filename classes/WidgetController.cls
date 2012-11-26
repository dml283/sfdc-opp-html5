public with sharing class WidgetController {

    public List<GenericPayload> checkbox_data {get; private set;}
    public List<GenericPayload> similar_ops_data {get; private set;}
    public List<GenericPayload> actions_data {get; private set;}
    public List<GenericPayload> account_data {get; private set;}    
    public List<GenericPayload> histories_data {get; private set;}      
    
    public WidgetController() {
        
    }
    
    public String[] stringToSplit {
        get; 
        set {
            if(value != null)
            {
                stringToSplit = value;
                account_data = new List<GenericPayload>();
                checkbox_data = new List<GenericPayload>();
                similar_ops_data = new List<GenericPayload>();
                actions_data = new List<GenericPayload>();
                histories_data = new List<GenericPayload>();
                for (String stringValue : stringToSplit)
                {
                    String[] values = stringValue.Split('_');
                    System.debug('String to Split values - '+ values);
                    
                    if (values != null)
                    {
                        if (values[0] == '1')
                        {
                            account_data.add(new GenericPayload(values[1], values[2], values[3]));
                        }
                        if (values[0] == '2')
                        {
                            checkbox_data.add(new GenericPayload(values[1], values[2], values[3]));
                        }
                                    
                        if (values[0] == '3')
                        {
                            similar_ops_data.add(new GenericPayload(values[1], values[2], values[3]));
                        }
                    
                        if (values[0] == '4')
                        {
                            actions_data.add(new GenericPayload(values[1], values[2], values[3]));
                        }
                    
                        if (values[0] == '5')
                        {
                            histories_data.add(new GenericPayload(values[1], values[2], values[3]));
                        }
                    }
                }           
                System.debug('tmobile_data - '+ account_data);
               // System.debug('checkbox_data - '+ checkbox_data);
               // System.debug('similar_ops_data - '+ similar_ops_data);
               // System.debug('actions_data - '+ actions_data);
               // System.debug('histories_data - '+ histories_data);
            }
        }
    }
       
}