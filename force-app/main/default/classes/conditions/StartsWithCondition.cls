public inherited sharing class StartsWithCondition implements Conditionable {
    
    public Boolean evaluate(Object value, Object comparison) {
        if (!(value instanceof String) || !(comparison instanceof String)) {
            throw new InvalidConditionTypeException('Invalid type for starts with expression expected String');
        }
        return ((String) value).startsWith((String) comparison);
    }
}
