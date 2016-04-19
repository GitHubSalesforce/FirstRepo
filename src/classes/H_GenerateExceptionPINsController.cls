public with sharing class H_GenerateExceptionPINsController {
	
	private final String ACTIVE = 'Active';

	public Integer numberOfPins { get; set; }
	public Integer numberOfPinsLabel { get; set; }
	public String campaignId { get; set; }
	public Campaign campaignDetails { get; set; }
	public Boolean isPINsGenerated { get; set; }

	public H_GenerateExceptionPINsController() {
		campaignId = ApexPages.currentPage().getParameters().get('id');
		campaignDetails = [SELECT Id, Name FROM Campaign WHERE Id =: campaignId];
		isPINsGenerated = false;
	}

	public void generateExceptionPINs() {
		List<PIN__c> exceptionPinsList = H_GeneratePINs.createPIN(numberOfPins, campaignId, ACTIVE);
		try {
			insert exceptionPinsList;
			isPINsGenerated = true;
			numberOfPinsLabel = numberOfPins;
			numberOfPins = null;

		} catch(Exception e) {
			throw new H_GeneratePINs.H_GeneratePINsException(e.getMessage());
		}
	}

}