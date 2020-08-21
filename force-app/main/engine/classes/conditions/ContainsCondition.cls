public inherited sharing class ContainsCondition implements Conditionable {
    
    public Boolean evaluate(Object value, Object comparison) {
        if (!(value instanceof String) || !(comparison instanceof String)) {
            throw new InvalidConditionTypeException('Invalid type for contains expression expected String');
        }
        return ((String) value).contains((String) comparison);
    }
}
