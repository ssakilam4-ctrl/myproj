public with sharing class SearchIndianPostalBranchesController {

    // Wrapper Class
    public class PostalBranchWrapper {

        @AuraEnabled public String Name;

        @AuraEnabled public String BranchType;

        @AuraEnabled public String DeliveryStatus;

        @AuraEnabled public String Circle;

        @AuraEnabled public String District;

        @AuraEnabled public String Division;

        @AuraEnabled public String Region;

        @AuraEnabled public String State;

        @AuraEnabled public String Country;

        @AuraEnabled public String Pincode;
    }

    // Apex Method
    @AuraEnabled(cacheable=true)

    public static List<PostalBranchWrapper>
    searchIndianPostalBranches(String pinCode) {

        List<PostalBranchWrapper> branchList =
            new List<PostalBranchWrapper>();

        try {

            // Validation
            if(String.isBlank(pinCode)) {

                throw new AuraHandledException(
                    'Pin Code cannot be empty.'
                );
            }

            if(pinCode.length() != 6 ||
               !Pattern.matches('^[0-9]+$', pinCode)) {

                throw new AuraHandledException(
                    'Please enter valid 6 digit pincode.'
                );
            }

            // HTTP Callout
            Http http = new Http();

            HttpRequest req =
                new HttpRequest();

            req.setEndpoint(
                'https://api.postalpincode.in/pincode/'
                + pinCode
            );

            req.setMethod('GET');

            req.setHeader(
                'Content-Type',
                'application/json'
            );

            req.setTimeout(20000);

            HttpResponse res =
                http.send(req);

            // Status Validation
            if(res.getStatusCode() != 200) {

                throw new AuraHandledException(
                    'Unable to fetch data.'
                );
            }

            // Deserialize JSON
            List<Object> responseList =

                (List<Object>)
                JSON.deserializeUntyped(
                    res.getBody()
                );

            if(responseList == null ||
               responseList.isEmpty()) {

                return branchList;
            }

            Map<String, Object> responseMap =

                (Map<String, Object>)
                responseList[0];

            String status =

                (String)
                responseMap.get('Status');

            if(status != 'Success') {

                return branchList;
            }

            List<Object> postOfficeList =

                (List<Object>)
                responseMap.get('PostOffice');

            if(postOfficeList == null) {

                return branchList;
            }

            // Loop through response
            for(Object obj : postOfficeList) {

                Map<String, Object> branchMap =

                    (Map<String, Object>) obj;

                PostalBranchWrapper branch =
                    new PostalBranchWrapper();

                branch.Name =
                    (String) branchMap.get('Name');

                branch.BranchType =
                    (String) branchMap.get('BranchType');

                branch.DeliveryStatus =
                    (String) branchMap.get('DeliveryStatus');

                branch.Circle =
                    (String) branchMap.get('Circle');

                branch.District =
                    (String) branchMap.get('District');

                branch.Division =
                    (String) branchMap.get('Division');

                branch.Region =
                    (String) branchMap.get('Region');

                branch.State =
                    (String) branchMap.get('State');

                branch.Country =
                    (String) branchMap.get('Country');

                branch.Pincode =
                    (String) branchMap.get('Pincode');

                branchList.add(branch);
            }
        }

        catch(Exception ex) {

            throw new AuraHandledException(

                'Error occurred : '
                + ex.getMessage()
            );
        }

        return branchList;
    }
}