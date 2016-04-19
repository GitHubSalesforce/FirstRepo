/**
*      @author Shilpa Menghani
*      @date   22/06/2015
*      @description    A global utility class for Logging functionalities
Modification Log:        
*/

public  class H_Logger{
    /** LOG LEVEL FLAGS **/
      static boolean isTraceEnabled = true;
      static boolean isDebugEnabled = true;
      static boolean isInfoEnabled = true;
      static boolean isWarnEnabled = true;
      static boolean isErrorEnabled = true;
    
    public static boolean notify{get;set;}
    public static boolean isContactFailed = false;
    private enum Level{
        TRACE,
        DEBUG,
        INFO,
        WARN,
        ERROR,
        FATAL
    }
        
    /** Generic error log method **/
    public static void log(String message,String level,String statusCode,String logtype){
        boolean notifyAdmin=false;
        if(notify!=null && notify){
            notifyAdmin=true;
        }
        Integer MSG_LIMIT_SIZE=32768;
        //CHECK FOR MSG SIZE LIMIT
        if(message.length()>=MSG_LIMIT_SIZE){
            message=message.substring(0, MSG_LIMIT_SIZE-1);
            
        }
        
        ErrorLog__c log_obj=new ErrorLog__c(Message__c=message,Log_Level__c=level,Type__c=logtype,Notify_Admin__c=notifyAdmin);
        log_obj.Status_Code__c=statusCode==null?'':statusCode;
        if(String.isNotBlank(message) && message.length() > 255)
        log_obj.Message_Short__c = message.substring(0,255);
        else
        log_obj.Message_Short__c = message; 
        //Database.insert(log_obj,false);
        if(log_obj != null)
        insert log_obj;
     }
     
    /** Generic error log method **/
    public static void log(String message,String level,String statusCode,String logtype,String xmlFile,String objectType,String SFContactId,Boolean isBatchProcessed){
        boolean notifyAdmin=false;
        if(notify!=null && notify){
            notifyAdmin=true;
        }
        Integer MSG_LIMIT_SIZE=32768;
        //CHECK FOR MSG SIZE LIMIT
        if(message.length()>=MSG_LIMIT_SIZE){
            message=message.substring(0, MSG_LIMIT_SIZE-1);
            
        }
        
        ErrorLog__c log_obj=new ErrorLog__c(Message__c=message,Log_Level__c=level,Type__c=logtype,Notify_Admin__c=notifyAdmin);
        log_obj.Status_Code__c=statusCode==null?'':statusCode;
        log_obj.SObject__c = objectType==null?'':objectType;
        if(String.isNotBlank(objectType) && objectType.equalsIgnoreCase('Contact'))
        isContactFailed = true;
        if(String.isNotBlank(SFContactId))
        log_obj.SF_Contact_Id__c = SFContactId;
        if(String.isNotBlank(message) && message.length() > 255)
        log_obj.Message_Short__c = message.substring(0,255);
        else
        log_obj.Message_Short__c = message; 
        log_obj.IsBatchProcessed__c = isBatchProcessed;
        //Database.insert(log_obj,false);
        if(log_obj != null)
        insert log_obj;
        
        if(log_obj != null && log_obj.Id != null && String.isNotBlank(xmlFile)){
          saveNotificationXMLAttachment(xmlFile,log_obj);
        }
    }
     /** Error log level method **/
    public static void error(String message,String statusCode,String logtype){
            string strLevel = string.valueOf(Level.ERROR);
            if(isErrorEnabled){
              log(message,strLevel,statusCode,logtype);
            }
    }
    /** Error log level method **/
    public static void error(String message,String statusCode,String logtype,String xmlFile,String objectType,String SFContactId){
            string strLevel = string.valueOf(Level.ERROR);
            if(isErrorEnabled){
                log(message,strLevel,statusCode,logtype,xmlFile,objectType,SFContactId,false); 
            }
    }
    
    /** Async error log level method **/
    public static void errorAsync(String message,String statusCode,String logtype){
            string strLevel = string.valueOf(Level.ERROR);
             if(isErrorEnabled){
               log(message,strLevel,statusCode,logtype);
             }
    }
    
    /** Warn log level method **/
    public static void warn(String message,String statusCode,String logtype){
            string strLevel = string.valueOf(Level.WARN);
            if(isWarnEnabled){
            log(message,strLevel,statusCode,logtype);
            }
    }
    
    /** Info log level method **/
    public static void info(String message,String statusCode,String logtype){
            string strLevel = string.valueOf(Level.INFO);
             if(isInfoEnabled){
                log(message,strLevel,statusCode,logtype);
             }
    }
    
    /** Debug log level method **/
    public static void debug(String message,String statusCode,String logtype){
            string strLevel = string.valueOf(Level.DEBUG);
             if(isDebugEnabled){
              log(message,strLevel,statusCode,logtype);
             }
    }
    
    /** Trace log level method **/
    public static void trace(String message,String statusCode,String logtype){
            string strLevel = string.valueOf(Level.TRACE);
             if(isTraceEnabled){
              log(message,strLevel,statusCode,logtype);
             }
    }
    
    /** Add page message  method **/
    public static void addPageMessage(ApexPages.Message msg){
        ApexPages.addMessage(msg);
    }
    
    /** Add page message  method with serverity **/
    public static void addPageMessage(ApexPages.Severity severity,String msg){
        ApexPages.Severity serv_level=severity==null?ApexPages.Severity.INFO:severity;
        ApexPages.Message pgMsg=new ApexPages.Message(serv_level,msg);
         addPageMessage(pgMsg);
    }
    
    /** String representation of error log record **/
    public static String toString(ErrorLog__c log){
        String msg=log.Log_Level__c + ' : '+log.Message__c;
        System.debug(LoggingLevel.Error,'## VM ERROR LOG : '+msg);
        return msg;
    }
   
    /** Error log method for DML results object **/ 
    public static void error(List<Object> dmlResults,String origin,String xmlFile,String objectType,String ContactId){
            
            //implement for merge results - others
            
            String msg=getDMLErrorMsg(dmlResults);
            if(!String.isBlank(msg)){
               H_Logger.error(msg, null,origin,xmlFile,objectType,ContactId); 
            }
        }
        
    
    /** Constructs Error log message from DMLResults **/
     public static String getDMLErrorMsg(List<Object> dmlResults ){
        String msg='';
        
        if(dmlResults!=null && !dmlResults.isEmpty()){
            Object dmlResult=dmlResults[0];
                boolean isError=false;
            if(dmlResult instanceof Database.Saveresult ){
                //create error msg details for failed records
                for(Database.Saveresult res:(List<Database.Saveresult>)dmlResults){
                    if(!res.isSuccess()){
                        System.debug(System.loggingLevel.Error,res.getErrors());
                        isError=true;
                        for(Database.Error err:res.getErrors()){
                        msg+=err.getMessage();
                      }
                      String recId=res.getId()!=null ?'-'+res.getId():'';
                      msg+=recid;
                    }
                 }  
                    
            }
                
            
            else if(dmlResult instanceof Database.Upsertresult){
                //create error msg details for failed records
                    for(Database.Upsertresult res:(List<Database.Upsertresult>)dmlResults){
                    if(!res.isSuccess()){
                    isError=true;
                    System.debug(res.getErrors());
                    for(Database.Error err:res.getErrors()){
                    msg+=err.getMessage();
                 }
                 
                 String recId=res.getId()!=null ?'-'+res.getId():'';
                      msg+=recid;
               }
            }   
                
                
            }
            
            else if(dmlResult instanceof Database.DeleteResult){
                //create error msg details for failed records
                for(Database.DeleteResult res:(List<Database.DeleteResult>)dmlResults){
                    if(!res.isSuccess()){
                     System.debug(res.getErrors());
                     isError=true;
                       for(Database.Error err:res.getErrors()){
                       msg+=err.getMessage();
                 }
                     String recId=res.getId()!=null ?'-'+res.getId():'';
                    msg+=recId;
              }
            }   
                
            }
            
            //implement for merge results - others
        
    }
                return msg;
     }
     
     
     /** Constructs Success message from DMLResults **/
      public static String getDMLSuccessMsg(List<Object> dmlResults ){
        String msg='';
        Integer rec_count=0;
        if(dmlResults!=null && !dmlResults.isEmpty()){
            Object dmlResult=dmlResults[0];
                boolean isError=false;
            if(dmlResult instanceof Database.Saveresult ){
                //create error msg details for failed records
                for(Database.Saveresult res:(List<Database.Saveresult>)dmlResults){
                    if(res.isSuccess()){
                    msg+=res.getId() +',';
                    rec_count++;
                    }
                 }  
                    
            }
                
            
            else if(dmlResult instanceof Database.Upsertresult){
                //create error msg details for failed records
                    for(Database.Upsertresult res:(List<Database.Upsertresult>)dmlResults){
                    if(res.isSuccess()){
                    msg+=res.getId() +',';
                    rec_count++;
                    }          
                    
                     }  
                
                
            }
            
            else if(dmlResult instanceof Database.DeleteResult){
                //create error msg details for failed records
                for(Database.DeleteResult res:(List<Database.DeleteResult>)dmlResults){
                if(res.isSuccess()){
                    msg+=res.getId() +',';
                    rec_count++;
                    }          
                     }  
                
            }
            
            //implement for merge results - others
        
    }
    
                return msg +'\n Total records success : '+rec_count;
     }
    
    /** futhre async error log method **/
    @future
    public static void errorAsync(String msg,String origin){
        H_Logger.error(msg, null,origin,null,null,null);
        
    }
    /** method to save error notification file as attachment **/
    public static void saveNotificationXMLAttachment(String xmlFile,ErrorLog__c ErrorLogRec){
        Attachment XmlAttach = new Attachment();
        XmlAttach.ParentId =  ErrorLogRec.id;
        XmlAttach.body = Blob.valueOf(xmlFile);
        XmlAttach.Description = 'Error Notification XML File';
        XmlAttach.Name = 'NotificationFile.xml';
        XmlAttach.ContentType = 'application/octet-stream';
        
        if(XmlAttach != null)
        insert XmlAttach;
    }
}