public inherited sharing class EqualsCondition implements Conditionable {
    
    public Boolean evaluate(Object value, Object comparison) {
        return value == comparison;
    }
}
