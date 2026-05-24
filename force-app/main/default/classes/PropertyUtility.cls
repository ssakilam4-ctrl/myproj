public class PropertyUtility {

    public static void newListedProperties() {

        List<Property__c> newPropList = [
            SELECT Name,
                   Broker__r.Email__c,
                   Days_On_Market__c
            FROM Property__c
            WHERE Date_Listed__c = LAST_N_DAYS:30
        ];

        for(Property__c prop : newPropList) {

            String propEmail = prop.Name + ' : ' + prop.Broker__r.Email__c;

            System.debug(propEmail);
        }
    }
}