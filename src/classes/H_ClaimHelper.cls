/**
*      @author       : Merisha Shim (Deloitte)
*      @date         : 03/04/2016
*      @description  : Helper Class for H_ClaimTrigger
*      Modification Log:
*      ------------------------------------------------------------------------------------------
*      Developer               User story            Date                Description
*      ------------------------------------------------------------------------------------------
*      Merisha Shim                                  03/04/2016          Helper class for H_ClaimTrigger
*																																				 Visualforce Page
*/
public with sharing class H_ClaimHelper {
	
	private static final String ACCESS_LEVEL_READ = 'Read';

	/**
	 * Method that takes claim record and shares it to the users within the same Account of the user that inserted the claim.
	 *
	 */
	public static void addClaimSharingRuleToAllContactsOnAccount(Map<Id, Claim__c> newClaimsMap) {
		Id partnerProfileId = [SELECT Id FROM Profile WHERE Name = 'Dealer Community User' LIMIT 1].Id;

		newClaimsMap = new Map<Id, Claim__c>([SELECT Id, CreatedBy.AccountId, CreatedById 
												FROM Claim__c 
												WHERE Id IN: newClaimsMap.keySet()
												AND CreatedBy.ProfileId =: partnerProfileId]);
		
		Map<Id, Account> accountsMap = new Map<Id, Account>();
		Set<Id> accountIds = new Set<Id>();

		Map<Id, List<Claim__c>> accountIdToClaimListMap = new Map<Id, List<Claim__c>>();
		Map<Id, List<Id>> accountIdToUserIdListMap = new Map<Id, List<Id>>();

		List<Claim__Share> claimShares = new List<Claim__Share>();

		for(Claim__c c : newClaimsMap.values()) {
			// Get all the Users on the Claims
			accountIds.add(c.CreatedBy.AccountId);
		}

		// Get all the Account Ids from the Users on the Claims
		List<User> partnerPortalUsersList = [SELECT Id, AccountId, ContactId FROM User WHERE AccountId IN: accountIds AND ProfileId =: partnerProfileId];
		Map<Id, Id> userIdToAccountIdMap = new Map<Id, Id>();

		// Add all the Partner User Ids to the list
		for(User u : partnerPortalUsersList) {
			userIdToAccountIdMap.put(u.Id, u.AccountId);
			if(accountIdToUserIdListMap.containsKey(u.AccountId)) {
				List<Id> userIdsList = accountIdToUserIdListMap.get(u.AccountId);
				userIdsList.add(u.Id);
				accountIdToUserIdListMap.put(u.AccountId, userIdsList);
			} else {
				List<Id> userIdsList = new List<Id>{ u.Id };
				accountIdToUserIdListMap.put(u.AccountId, userIdsList);
			}
		}

		// Iterate through the Claims being inserted
		for(Integer i = 0; i < newClaimsMap.size(); i++) {

			//Add the Account Id with the List of Claims
			if(accountIdToClaimListMap.containsKey(newClaimsMap.values()[i].CreatedBy.AccountId)) {
				List<Claim__c> claimsList = accountIdToClaimListMap.get(newClaimsMap.values()[i].CreatedBy.AccountId);
				claimsList.add(newClaimsMap.values()[i]);
				accountIdToClaimListMap.put(newClaimsMap.values()[i].CreatedBy.AccountId, claimsList);
			} else {
				List<Claim__c> claimsList = new List<Claim__c>{ newClaimsMap.values()[i] };
				accountIdToClaimListMap.put(newClaimsMap.values()[i].CreatedBy.AccountId, claimsList);
			}
		}

		if(!accountIdToClaimListMap.isEmpty()) {
			for(Id aId : accountIdToClaimListMap.keySet()) {
				for(Claim__c c : accountIdToClaimListMap.get(aId)) {
					for(Id uId : accountIdToUserIdListMap.get(aId)) {
						
						if(c.CreatedById != uId) {
							Claim__Share claimShare = new Claim__Share();
							claimShare.ParentId = c.Id;
							claimShare.UserOrGroupId = uId;
							claimShare.AccessLevel = ACCESS_LEVEL_READ;

							claimShares.add(claimShare);
						}
						
						
					}
					
				}
				
			}
		}

		if(!claimShares.isEmpty()) {

			try {
				Database.SaveResult[] lsr = Database.insert(claimShares,false);
			} catch(Exception e) {
				throw new H_ClaimHelperException(e.getMessage());
			}
			

		}

	
	}

	public class H_ClaimHelperException extends Exception{}


}