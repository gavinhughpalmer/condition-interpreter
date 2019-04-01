public inherited sharing class NotCondition implements Conditionable {

    private final Conditionable condition;

    public NotCondition(Conditionable condition) {
        this.condition = condition;
    }

    public Boolean evaluate(Object value, Object comparison) {
        return !condition.evaluate(value, comparison);
    }
}
