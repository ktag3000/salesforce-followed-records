public class EntitySubscriptionController {
  
  // TODO add return type of List<SObject> when done
  public static void main(){
  
  // Running user
    String userId = UserInfo.getUserId();
  
    Id objectId;
    String objectName;
    Map<String, List<Id>> objectMap = new Map<String, List<Id>>();

  // Query entity subscriptions for the running user
  List<EntitySubscription> entityList = [
    SELECT Id, SubscriberId, ParentId 
    FROM EntitySubscription 
    WHERE SubscriberId = :userId 
    ORDER BY ParentId
    ];

    // Loop over query and get Id and Type for the objects. Then add to the map.
  for(EntitySubscription sub: entityList){
    objectId = String.valueOf(sub.get('ParentId'));
    objectName = String.valueOf(objectId.getsobjecttype());
    
    if(!objectMap.containsKey(objectName)){
      objectMap.put(objectName, new List<Id>());
    }
    objectMap.get(objectName).add(objectId);
  }
  System.debug('Object map: ' +objectMap);
  System.debug('Object map key set: ' +objectMap.keySet());
  System.debug('Object map values: ' +objectMap.values());
  
  // Query fields to be displayed to the user. Name field for most but handle the execptions if the object does not (ie Case).
  

  // TODO add in return info when done
  // return
  }
}