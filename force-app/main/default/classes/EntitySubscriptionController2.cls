public class EntitySubscriptionController2 {

    public static List<Map<String, String>> getSubscribedEntities() {
        String userId = UserInfo.getUserId();
        Map<String, List<Id>> objectMap = new Map<String, List<Id>>();

        // Step 1: Group ParentIds by object type
        List<EntitySubscription> entityList = [
            SELECT ParentId 
            FROM EntitySubscription 
            WHERE SubscriberId = :userId 
        ];

        for (EntitySubscription sub : entityList) {
            Id objectId = sub.ParentId;
            String objectName = objectId.getSObjectType().getDescribe().getName();

            if (!objectMap.containsKey(objectName)) {
                objectMap.put(objectName, new List<Id>());
            }
            objectMap.get(objectName).add(objectId);
        }

        // Step 2: Query once per object type (outside the loop)
        List<Map<String, String>> results = new List<Map<String, String>>();

        for (String objectName : objectMap.keySet()) {
            List<Id> ids = objectMap.get(objectName);

            // Get field metadata to check if Name field exists
            Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            Boolean hasNameField = fields.containsKey('Name');

            // Build SOQL query
            String fieldList = hasNameField ? 'Id, Name' : 'Id';
            String soql = 'SELECT ' + fieldList + ' FROM ' + objectName + ' WHERE Id IN :ids';
            List<SObject> queriedRecords = Database.query(soql);

            // Build response map
            for (SObject record : queriedRecords) {
                Map<String, String> row = new Map<String, String>{
                    'objectType' => objectName,
                    'Id' => String.valueOf(record.get('Id')),
                    'Name' => hasNameField ? String.valueOf(record.get('Name')) : '[No Name Field]'
                };
                results.add(row);
            }
        }

        System.debug(results);
        return results;
    }
}
