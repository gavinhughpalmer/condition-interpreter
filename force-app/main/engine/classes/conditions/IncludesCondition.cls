public inherited sharing class IncludesCondition implements Conditionable {
    
    public Boolean evaluate(Object value, Object comparison) {
        if (!(value instanceof String) || !(comparison instanceof String)) {
            throw new InvalidConditionTypeException('Invalid type for includes expression expected String');
        }
        Boolean isIncluding = false;
        Set<String> uniqueFieldValues = getPicklistValues((String) value);
        Set<String> uniqueFilterValues = getPicklistValues((String) comparison);

        for (String valueToCheck : uniqueFilterValues) {
            if (uniqueFieldValues.contains(valueToCheck)) {
                isIncluding = true;
                break;
            }
        }
        return isIncluding;
    }

    private static Set<String> getPicklistValues(String fieldValue) {
        return new Set<String>(
            fieldValue.toLowerCase().split(';')
        );
    }
}
