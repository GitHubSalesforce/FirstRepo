/**
*   @author       : Aaron Clancy(Deloitte)
*   @date         : 30/10/2015
    @description  : For showing contact related information on Banner
    Modification Log:
    ------------------------------------------------------------------------------------------
    Developer               User story            Date                Description
    ------------------------------------------------------------------------------------------
    Aaron (Deloitte)                            30/10/2015          Redesigned look based on new business input
    Piyush (Deloitte)                           03/12/2015          Added logic for Recall Information
*/
public with sharing class H_CustomerBannerController4{
    public contact contactRecord{get;set;}                      //Contact record

    // count Customer roles that are ownership ex. owner, lesse
    public Integer hondaActiveCount{get;set;}                   //Count of Active Honda cars 
    public Integer acuraActiveCount{get;set;}                   //Count of Active Acura cars
    public Integer motoActiveCount{get;set;}                    //Count of Active Customer Roles that are motorcycles
    public Integer powerEquipActiveCount{get;set;}              //Count of Active Customer Roles that are power equipment
    
    // count Customer roles that arent ownership ex. Servicer
    public Integer hondaRoleCount{get;set;}                     //Count of Honda cars
    public Integer acuraRoleCount{get;set;}                     //Count of Acura cars
    public Integer motoRoleCount{get;set;}                      //Count of Customer Roles that are motorcycles
    public Integer powerEquipRoleCount{get;set;}                //Count of Customer Roles that are power equipment
    
    public integer maxValue {get;set;}                          //Max Loyalty Score
    public integer activeAlertCount{get;set;}                   //Count of unviewed Alerts
    public integer viewedAlertCount{get;set;}                   //Count of viewed Alerts
    public decimal showStars{get;set;}                          //Stars to show
    private Set<String> activeRoles;                            //List of Active Customer Role names
    
    private STATIC String HONDA = 'C';
    private STATIC String ACURA = 'A';
    private STATIC String MOTO = 'M';
    private STATIC String POWEREQUIP = 'P';
    
    Public Integer recallCount{get;set;}
    Public Integer pudsCount{get;set;}
    
    //Constructor
    public H_CustomerBannerController4(ApexPages.StandardController controller) {
        contactRecord = (contact)controller.getRecord();        //Load contact record on page load
  
        //activeRoles = new Set<String>{'Lesse','Colesse','Buyer','Cobuyer','Owner','Coowner'};
        activeRoles = new Set<String>{'Owner'};

        hondaActiveCount = 0; acuraActiveCount = 0; motoActiveCount = 0; powerEquipActiveCount = 0;
        hondaRoleCount = 0; acuraRoleCount = 0; motoRoleCount = 0; powerEquipRoleCount =0;
        maxValue = 0; activeAlertCount = 0; viewedAlertCount = 0;
        showStars = 0;
        recallCount =0;
        pudsCount=0;
        
        Banner__c bannerMax = Banner__c.getValues('gauge');
        if(bannerMax.Max_Value__c != null){
            maxValue = Integer.valueOf(bannerMax.Max_Value__c);
        }
        
        calculateStars();

        DateTime today = Datetime.now();
        if(contactRecord != null && contactRecord.Id != null){
            for(Customer_Role__c cr : [SELECT Product_Line__c,RoleValue__c,EffectiveEndDate__c FROM Customer_Role__c WHERE Contact__c =: contactRecord.Id]){
                // only active roles
                if(activeRoles.contains(cr.RoleValue__c)){
                    if(cr.EffectiveEndDate__c >= today || cr.EffectiveEndDate__c == null){
                        if(cr.Product_Line__c.equalsIgnoreCase('honda')){ hondaActiveCount++; }
                        else if(cr.Product_Line__c.equalsIgnoreCase('acura')){ acuraActiveCount++; }
                        else if(cr.Product_Line__c.equalsIgnoreCase('moto')){ motoActiveCount++; }
                        else if(cr.Product_Line__c.equalsIgnoreCase('powerequip')){ powerEquipActiveCount++; }
                    }
                }
                // all roles
                if(cr.Product_Line__c.equalsIgnoreCase('honda')){ hondaRoleCount++; }
                else if(cr.Product_Line__c.equalsIgnoreCase('acura')){ acuraRoleCount++; }
                else if(cr.Product_Line__c.equalsIgnoreCase('moto')){ motoRoleCount++; }
                else if(cr.Product_Line__c.equalsIgnoreCase('powerequip')){ powerEquipRoleCount++; }
            }
            
            //Add related Information of Contact in list of contact
            contactRecord = [Select id,CustomerLoyaltyScore__c,UCID__c from contact where Id =: contactRecord.Id];
            for(Alert__c al : [select id,LastViewedDate,CreatedDate from Alert__c where Contact__c =: contactRecord.Id AND (End_Date__c > Today OR End_Date__c = null)]){
                system.debug(' *** ' + al.LastViewedDate +'__'+al.CreatedDate);
                if(al.LastViewedDate != null && al.CreatedDate != null){
                    system.debug(' ***___' +al.LastViewedDate.isSameDay(al.CreatedDate));
                    if(al.LastViewedDate.isSameDay(al.CreatedDate)){
                        activeAlertCount++;
                    }else{
                        viewedAlertCount++;   
                    }
                }
            }
        }
        system.debug(' ***1___'+activeAlertCount+'__'+viewedAlertCount);
        if(contactRecord != null){
        
            list<RecallInformations__x>lstRecall = [Select id,CmpgnTypCd__c from RecallInformations__x where MdmUcid__c =: contactRecord.UCID__c AND (CmpgnTypCd__c = 'R' OR CmpgnTypCd__c = 'U') limit 2000];
            
            if(!lstRecall.isEmpty()){
                for(RecallInformations__x recallInfo : lstRecall){
                    if(recallInfo.CmpgnTypCd__c != null && recallInfo.CmpgnTypCd__c !=''){
                        if(recallInfo.CmpgnTypCd__c == 'R')
                            recallCount++;
                        if(recallInfo.CmpgnTypCd__c == 'U')
                            pudsCount ++;
                    }
                }               
            }  
            
        }
        
    }

    // number of stars to be displayed for this customer
    public void calculateStars() {
        if(contactRecord.CustomerLoyaltyScore__c != null){
             showStars = (contactRecord.CustomerLoyaltyScore__c/maxValue)*5;
         }
    }
}