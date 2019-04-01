public inherited sharing class EndsWithCondition implements Conditionable {
    
    public Boolean evaluate(Object value, Object comparison) {
        if (!(value instanceof String) || !(comparison instanceof String)) {
            throw new InvalidConditionTypeException('Invalid type for ends with expression expected String');
        }
        return ((String) value).endsWith((String) comparison);
    }
}
