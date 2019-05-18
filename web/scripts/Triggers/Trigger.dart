//borrow concepts from the AiEngine.
abstract class Trigger {

    String importantWord;
    int importantInt;

    static bool allTriggered(List<Trigger> triggers) {
        return triggers.every((Trigger trigger) => trigger.isTriggered());
    }

    //each sub type implements this. if ANY are false, return false.
    bool isTriggered();

    void renderForm() {
        //TODO
    }

    void syncToForm() {
        //TODO
    }
    void syncFormToMe() {
        //TODO
    }

}