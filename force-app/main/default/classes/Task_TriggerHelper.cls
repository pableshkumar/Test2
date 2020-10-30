public class Task_TriggerHelper {
   public static void shareTask(List<Task> taskLink){
        try{
            upsert taskLink;
        }
        catch(Exception e){
            system.debug('Exception has occured ! ' +e.getMessage());
        }
    }
}