public class EntitySubscriptionController {
  
  public static void main(){
  // Running user
    String userId = UserInfo.getUserId();
  

  // Query entity subscriptions for the running user
    Id objectId;
    String objectName;
    Map<String, List<Id>> objectMap = new Map<String, List<Id>>();

  List<EntitySubscription> entityList = [
    SELECT Id, SubscriberId, ParentId 
    FROM EntitySubscription 
    WHERE SubscriberId = :userId 
    ORDER BY ParentId
    ];

  for(EntitySubscription sub: entityList){
    objectId = String.valueOf(sub.get('ParentId'));
    objectName = String.valueOf(objectId.getsobjecttype());
    
    if(!objectMap.containsKey(objectName)){
      objectMap.put(objectName, new List<Id>());
    }
    objectMap.get(objectName).add(objectId);
  }
  System.debug(objectMap);

  // Query fields to be displayed to the user. Name field for most but handle the execptions if the object does not (ie Case).
 

  }
}