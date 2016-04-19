/**
 *      @author       : Shilpa Menghani (Deloitte)
 *      @date         : 08/25/2015
        @description  : MCPM-: Test class for H_DBFunctions.
        Modification Log:
        ------------------------------------------------------------------------------------------
                Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
              Shilpa Menghani (Deloitte)                    08/25/2015            Original Version

*/
@isTest
public  class Test_H_DBFunctions {
    
    static testMethod void testDBFunctionInsert() {
        
        List<Address__c> lstAddress = H_ParsingTestDataUtility.createAddress(1);
        lstAddress[0].AddressUsageValue__c = 'PRIMARY RESIDENCE';
        Test.startTest();
        
            H_DBFunctions.doInsert(lstAddress, 'H_DBFunctionsTest', 'testDBFunctionInsert', false);          
           
        Test.stopTest();
        
        Integer intCount = Integer.valueOf([Select count(Id) total from Address__c where Id != null][0].get('total'));
        
        System.assertEquals(1, intCount, 'Count didnt match');
     } 
     
     static testMethod void testDBFunctionUpdate() {
        
        String strCountry = 'Canada';
        
        List<Address__c> lstAddress = H_ParsingTestDataUtility.createAddress(1);
        lstAddress[0].AddressUsageValue__c = 'PRIMARY RESIDENCE';
        
        if(lstAddress != null && !lstAddress.isEmpty())
        insert lstAddress;
        
        for(Address__c objAddress : lstAddress){
            objAddress.CountryValue__c = strCountry;
        }
        
        Test.startTest();
        
            H_DBFunctions.doUpdate(lstAddress, 'H_DBFunctionsTest', 'testDBFunctionUpdate', false);          
           
        Test.stopTest();
        if(lstAddress != null && !lstAddress.isEmpty())
        lstAddress = [SELECT CountryValue__c FROM Address__c WHERE ID IN :lstAddress];
          
        for(Address__c objNewAddress :lstAddress){
            System.assertEquals(objNewAddress.CountryValue__c, strCountry,'Address country name not matching');
         } 
    }  
    
    
    static testMethod void testDBFunctionUpsert() {
       
       
       String strCountry = 'Canada';
        
       List<Address__c> lstAddress = H_ParsingTestDataUtility.createAddress(1);
       lstAddress[0].AddressUsageValue__c = 'PRIMARY RESIDENCE';
       if(lstAddress != null && !lstAddress.isEmpty())
       insert lstAddress;
        
       lstAddress.addAll(H_ParsingTestDataUtility.createAddress(2));
    
       lstAddress[1].CountryValue__c = strCountry;
       for(Address__c objAddress : lstAddress){
            objAddress.AddressUsageValue__c = 'PRIMARY RESIDENCE';
       }
        
       Test.startTest();
        
          H_DBFunctions.doUpsert(lstAddress, 'H_DBFunctionsTest', 'testDBFunctionUpsert', false);          
           
       Test.stopTest();
       
       if(lstAddress != null && !lstAddress.isEmpty())
       lstAddress = [SELECT CountryValue__c FROM Address__c WHERE ID IN :lstAddress];
         
       System.assertEquals(lstAddress[1].CountryValue__c, strCountry,'Address country name not matching');
        
    }  
    
    static testMethod void testDBFunctionDelete() {
        
       List<Address__c> lstAddress = H_ParsingTestDataUtility.createAddress(2);
       for(Address__c objAddress : lstAddress){
            objAddress.AddressUsageValue__c = 'PRIMARY RESIDENCE';
       }
       if(lstAddress != null && !lstAddress.isEmpty())
       insert lstAddress;
        
        Test.startTest();
        
            H_DBFunctions.doDelete(lstAddress, 'H_DBFunctionsTest', 'testDBFunctionDelete', false);          
           
        Test.stopTest();
            
        try{
            if(lstAddress != null && !lstAddress.isEmpty()){
             lstAddress[1].CountryValue__c ='Canada';
             update lstAddress;
            }
        }
        catch(DmlException e){
            System.assertEquals('ENTITY_IS_DELETED', e.getDmlStatusCode(0),'ENTITY_IS_NOT_DELETED');
        }
             
     } 
    
}