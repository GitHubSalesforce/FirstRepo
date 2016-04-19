/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 15/10/2015
       @description  : Contants Class
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
          Piyush Rathor                                   15/10/2015         Contants Class
*/    
public with sharing class H_Constants{
    public static final String deletedObject = 'ContactMethod__c,Address__c,Customer_Role__c';
    //Address Primary Residence
    public static final String addressUsageVal = 'Primary Residence';
    //Contact Methods Primary and Secondary Info
    public static final String contactMethodUsageValue = 'Primary Email';
    public static final String SECONDARY_EMAIL = 'Secondary Email'; 
    public static final String contactMethodUsageValuePhone = 'Primary Phone';
    public static final String SECONDARY_PHONE = 'Secondary Phone';
    public static final String contactMethodValue = 'Email Address';
    public static final String contactMethodValuePhone = 'Telephone Number';
    public static final String MOBILE_TELEPHONE = 'MOBILE TELEPHONE';
    public static final String MultiplePrimaryEmail_Phone = 'You cannot Add multiple Primary Email/ Phone';
    public static final String MultiplePrimaryAddress = 'You cannot Add multiple Primary Address';
    public static final String InvalidEmail = 'InvalidEmail@Honda.com';
    
    public static boolean customerRoleHFSError = false;
    public static final String provinceValue = 'AK,AS,AZ,AR,CA,CO,CT,DE,DC,FM,FL,GA,GU,HI,ID,IL,IN,IA,KS,KY,LA,ME,MH,MD,MA,MI,MN,MS,MO,MT,NE,NV,NH,NJ,NM,NY,NC,ND,MP,OH,OK,OR,PW,PA,PR,RI,SC,SD,TN,TX,UT,VT,VI,VA,WA,WV,WI,WY,AL,AE,AA,AC,AU,AM,AP,AB,BC,MB,NB,NL,NT,NS,ON,PE,QC,SK,YT,NU,Unknown';
    public static final String countryValue = 'Afghanistan,Albania,Algeria,Andorra,Angola,Antigua and Barbuda,Argentina,Armenia,Australia,Austria,Azerbaijan,Bahamas,Bahrain,Bangladesh,Barbados,Belarus,Belgium,Belize,Benin,Bhutan,Bolivia,Bosnia and Herzegovina,Botswana,Brazil,Brunei Darussalam,Bulgaria,Burkina Faso,Burundi,Cambodia,Cameroon,Canada,Cape Verde,Central African Republic,Chad,Chile,China,Colombia,Comoros,Congo,Costa Rica,Cote d Ivoire,Croatia,Cuba,Cyprus,Czech Republic,Demo People s Rep of Korea,Democratic Republic of Congo,Denmark,Dijibouti,Dominica,Dominican Republic,Ecuador,Egypt,El Salvador,Equatorial Guinea,Eritrea,Estonia,Ethiopia,Federated States of Micronesia,Fiji,Finland,France,Gabon,Gambia,Georgia,Germany,Ghana,Great Britain and N Ireland,Greece,Grenada,Guatemala,Guinea,Guinea-Bissau,Guyana,Haiti,Honduras,Hungary,Iceland,India,Indonesia,Iraq,Ireland,Islamic Republic of Iran,Israel,Italy,Jamaica,Japan,Jordan,Kazakhstan,Kenya,Kiribati,Kuwait,Kyrgyzstan,Lao People s Democratic Rep,Latvia,Lebanon,Lesotho,Liberia,Libyan Arab Jamahiririya,Liechtenstein,Lithuania,Luxembourg,Macedonia,Madagascar,Malawi,Malaysia,Maldives,Mali,Malta,Marshall Islands,Mauritania,Mauritius,Mexico,Monaco,Mongolia,Morocco,Mozambique,Myanmar,Namibia,Nauru,Nepal,Netherlands,New Zealand,Nicaragua,Niger,Nigeria,Norway,Oman,Pakistan,Palau,Panama,Papua New Guinea,Paraguay,Peru,Philippines,Poland,Portugal,Qatar,Republic of Korea,Republic of Moldova,Romania,Russian Federation,Rwanda,Saint Kitts,Saint Lucia,Saint Vincent and Grenadines,Samoa,San Marino,Sao Tome and Principe,Saudi Arabia,Senegal,Seychelles,Sierra Leone,Singapore,Slovakia,Slovenia,Solomon Islands,Somalia,South Africa,Spain,Sri Lanka,Sudan,Suriname,Swaziland,Sweden,Switzerland,Syrian Arab Republic,Tajikistan,Thailand,Togo,Tonga,Trinidad and Tobago,Tunisia,Turkey,Turkmenistan,Tuvalu,Uganda,Ukraine,United Arab Emirates,United Republic of Tanzania,United States of America,Unknown,Uruguay,Uzbekistan,Vanuatu,Venezuela,Viet Nam,Yemen,Yugoslavia,Zambia,Zimbabwe';
    
    // WebService Constants
    //Node value, matching key to fetch record from custom setting
    public static final String TCRMAdminContEquivBObj = 'TCRMAdminContEquivBObj';
    public static final String AdminSystemValue = 'AdminSystemValue';
    public static final String TCRMExtension = 'TCRMExtension';
    public static final String XContEquivBObjExt = 'XContEquivBObjExt';
    public static final String TCRMPersonNameBObj = 'TCRMPersonNameBObj';
    public static final String NameUsageValue = 'NameUsageValue';
    public static final String TCRMOrganizationNameBObj = 'TCRMOrganizationNameBObj';
    public static final String TCRMPartyGroupingBObj = 'TCRMPartyGroupingBObj';
    public static final String PartyGroupingValue = 'PartyGroupingValue';
    public static final String XPartyProductRoleBObj = 'XPartyProductRoleBObj';
    public static final String RoleValue = 'RoleValue';
    public static final String XPartyDealerPreferenceBObj = 'XPartyDealerPreferenceBObj';
    public static final String PreferredDealerCode = 'PreferredDealerCode';
    
    public static final String AdminSystemValue_CASS = 'CASS';
    public static final String AdminSystemValue_SFSD = 'SFSD';
    public static final String NameUsageValue_Legal = 'Legal';
    public static final String NameUsageValue_AKA = 'Also Known As';
    public static final String OrgNameUsageValue_DBS = 'Doing Business As';
    public static final String HouseHold = 'HouseHold';
    //PrivacyPrefernces Fields
    public static final String ContactbyEmail = 'Contact by Email';
    public static final String ContactbyMail = 'Contact by Mail';
    public static final String ContactbyPhoneText = 'Contact by Phone-Text';
    public static final String ContactbyPhoneVoice = 'Contact by Phone-Voice';
    public static final String ContactbySocialMedia = 'Contact by Social Media';
    public static final String HFS = 'HFS';
    public static final String Dealer = 'Dealer';
    public static final String HC = 'HC';
    //Notification Type
    public static final String CollapseParty_Transaction_type = 'CollapsePartyNotification';
    public static final String SplitParty_Notification_type = 'SplitPartyNotification';
    //Role Values
    public static final String Lesse = 'Lesse';
    public static final String Colesse = 'Colesse';
    public static final String Buyer = 'Buyer';
    public static final String Cobuyer = 'Cobuyer';
    public static final String Guarantor = 'Guarantor';
    public static final String Subscriber = 'Subscriber';
    public static final String Owner = 'Owner';
    public static final String Coowner = 'Coowner';
    public static final String Warrantee = 'Warrantee';
    public static final String Servicer = 'Servicer';
    
    //Product Line
    public static final String honda = 'honda';
    public static final String acura = 'acura';
    public static final String moto = 'moto';
    public static final String powerequip = 'powerequip';
}