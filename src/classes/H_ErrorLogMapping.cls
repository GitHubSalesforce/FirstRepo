/**
*   @author       : Piyush Rathor(Deloitte)
*   @date         : 18/08/2015
    @description  : For parsing error and inserting the error logs
    Modification Log:
    ------------------------------------------------------------------------------------------
    Developer               User story            Date                Description
    ------------------------------------------------------------------------------------------
    Piyush (Deloitte)                           18/08/2015          Original Version
    Piyush (Deloitte)                           24/08/2015          Modified to store DWLError as XML in Message Field
    Piyush (Deloitte)                           10/12/2015          Modified to change type
*/
@RestResource(urlMapping='/ErrorMapping/*')
global with sharing class H_ErrorLogMapping{ 
    static map<string,string>mapFieldMapping;
    static Map<string,Error_Structure__c>mapErrorMapping;
    static string errorString;
    
/*
    *  @author       Piyush Rathor (Deloitte) 
    *  @description  For inserting error in the Error Log object.
    *  @param        none                    
    *  @return       none
    
*/  
    @HttpPost  
    global static String insertError(){
        //Returns the RestRequest object for our Apex REST method.  
        RestRequest request = RestContext.request;

        //Returns the RestResponse for our Apex REST method.  
        RestResponse response = RestContext.response;  
        string responseString = '';
        try{
            String xmlContent = request.requestBody.toString().trim(); 
            Dom.Document doc = new Dom.Document();
            doc.load(xmlContent);  
            
            //retrieve the root element for this xml
            Dom.XMLNode tcrmNotification = doc.getRootElement();        
            mapFieldMapping = new map<string,string>();
            mapErrorMapping = Error_Structure__c.getAll();
            errorString ='';
            
            //parsing the XML and creating a map of field and value
            map<string,string>mapFieldMapping1 = parseError(tcrmNotification.getChildElements());
            
            //Dynamic object creation
            sObject sObj = Schema.getGlobalDescribe().get(label.Error_Object).newSObject() ;  
            for(string strField : mapFieldMapping1.keyset()){
                sObj.put(strField , mapFieldMapping1.get(strField)) ;  
            }   
            if(sObj != null)                
            insert sObj;
            responseString = label.Success_message;
        }
        catch(exception e){
            H_Logger.log('Error - '+e.getMessage() ,'ERROR','statusCode','Webservice (MDM) - OutBound');
            responseString = e.getMessage()+' - Error not inserted successfully.';
        }
        return responseString;
    }

/*
    *  @author         Piyush Rathor (Deloitte) 
    *  @description    For parsing the Error
    *  @param          List<Dom.XMLNode>                     
    *  @return         Map<string,string> 
    
*/      
    public static map<string,string> parseError(list<Dom.XMLNode>lstXmlnode){
        for(Dom.XMLNode childNodes : lstXmlnode){
            if(childNodes.getChildElements().size() == 0){
                if(mapErrorMapping.containskey(childNodes.getName())){
                    string childTextVal = childNodes.getText().replaceAll('[^\\w\\s]','');
                    mapFieldMapping.put(mapErrorMapping.get(childNodes.getName()).nodefield__c,childTextVal);
                } 
                //Child of DWLError object will be stored as XML in Message field of error log object
                if(childNodes.getParent() != null && childNodes.getParent().getName() == label.DWLError){
                    string childText = childNodes.getText().replaceAll('[^\\w\\s]','');
                    errorString = errorString + '<'+childNodes.getName()+'>'+ childText+'</'+childNodes.getName()+'>';
                    mapFieldMapping.put(mapErrorMapping.get(childNodes.getParent().getName()).nodefield__c,errorString);
                }               
            }               
            else{                
                //parse the parent if there are child nodes
                parseError(childNodes.getChildElements());
            }
        }
        if(!mapFieldMapping.isEmpty())
            mapFieldMapping.put('Type__c','Webservice (MDM) - Outbound');
        //Map of Error Log field and value of the XML
        return mapFieldMapping;     
    }
}