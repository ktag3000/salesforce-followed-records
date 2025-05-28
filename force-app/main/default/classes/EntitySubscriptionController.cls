public class EntitySubscriptionController {
  
  public static void main(){
  // get running user
  String userId = UserInfo.getUserId();

  // get entity subscriptions by object and order by created date asc
  List<EntitySubscription> entityList = [SELECT Id, SubscriberId, ParentId FROM EntitySubscription WHERE SubscriberId = :userId ORDER BY ParentId];
  for(EntitySubscription subs: entityList){
    System.debug('Subs: ' +subs);
  }
  System.debug('Entity list: ' +entityList);
  }
}