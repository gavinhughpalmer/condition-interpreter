public inherited sharing class OrCondition implements Conditionable {

    private final Conditionable first;
    private final Conditionable second;

    public OrCondition(Conditionable first, Conditionable second) {
        this.first = first;
        this.second = second;
    }

    public Boolean evaluate(Object value, Object comparison) {
        return first.evaluate(value, comparison) || second.evaluate(value, comparison);
    }
}
