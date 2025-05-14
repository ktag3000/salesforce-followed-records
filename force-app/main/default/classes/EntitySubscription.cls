public class EntitySubscription {
  // Method to get a list of entity subscriptions
  public static void getListOfSubscriptions() {
    // Access the running user id from the UserInfo class
    String userId = UserInfo.getUserId();

    // Query entity subscriptions for the running user
    List<SObject> queryList = [
      SELECT Id, ParentId, CreatedById
      FROM EntitySubscription
      WHERE CreatedById = :userId
      ORDER BY ParentId
    ];
    //System.debug('queryList: ' + queryList);

    // Group ParentIds by SObject type
    Map<String, List<Id>> parentIdMap = new Map<String, List<Id>>();
    List<SObject> subscriptionList = new List<SObject>();
    for (SObject subscriptionLoop : queryList) {
      Id parentId = String.valueOf(subscriptionLoop.get('ParentId'));
      String objectName = String.valueOf(parentId.getsobjecttype());

      // Check for existing key in the map. If it's there don't overwrite with a new value, add it
      if (!parentIdMap.containsKey(objectName)) {
        parentIdMap.put(objectName, new List<Id>());
      }
      parentIdMap.get(objectName).add(parentId);

      //System.debug('parentIdMap: ' + parentIdMap);
    }

    // Try to query name from each type
    for (String objectType : parentIdMap.keySet()) {
      List<Id> ids = parentIdMap.get(objectType);
      String query;
      List<SObject> results;

      // Attempt to select common name fields. If name is not found, catch the exception and check for case fields
      try {
        query = 'SELECT Id, Name FROM ' + objectType + ' WHERE Id IN :ids';
        results = Database.query(query);
      } catch (QueryException e1) {
        System.debug('e1');
        try {
          query =
            'SELECT Id, CaseNumber, Subject FROM ' +
            objectType +
            ' WHERE Id IN :ids';
          results = Database.query(query);
        } catch (QueryException e2) {
          System.debug('Skipping unsupported object type: ' + objectType);
          continue;
        }
      }
      System.debug('results:' + results);
    }
  }
}
