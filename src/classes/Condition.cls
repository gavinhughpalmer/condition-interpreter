/**
 * Created by admin-1019 on 07/06/2018.
 */

public class Condition {

    private static final String INVALID_OPERATOR = 'Invalid operator ({0}) for field {1}';
    private static final String INVALID_FIELD = 'Invalid field ({0}) for object {1}';
    @testVisible private static final String EQUAL = 'equal';
    @testVisible private static final String NOT_EQUAL = 'not equal';
    @testVisible private static final String CONTAINS = 'contains';
    @testVisible private static final String DOES_NOT_CONTAIN = 'does not contain';
    @testVisible private static final String STARTS_WITH = 'starts with';
    @testVisible private static final String ENDS_WITH = 'ends with';
    @testVisible private static final String LESS_THAN = 'less than';
    @testVisible private static final String LESS_OR_EQUAL = 'less or equal';
    @testVisible private static final String GREATER_THAN = 'greater than';
    @testVisible private static final String GREATER_OR_EQUAL = 'greater or equal';
    @testVisible private static final String INCLUDES = 'includes';
    @testVisible private static final String EXCLUDES = 'excludes';
    @testVisible private static final String WITHIN = 'within';

    public class InvalidConditionException extends Exception {}

    private final DescribeFieldResult field;
    private final String operator;
    private final Object filterValue;

    public Condition(String objectApiName, String fieldApiName, String operator, String filterValueString) {
        SchemaDescribe schema = SchemaDescribe.getInstance();
        if (schema.isNotValidField(objectApiName, fieldApiName)) {
            throw new InvalidConditionException(
                String.format(INVALID_FIELD, new List<String>{fieldApiName, objectApiName})
            );
        }
        field = schema.getFieldDescribe(objectApiName, fieldApiName);
        filterValue = parseFieldValue(filterValueString);
        this.operator = operator.toLowerCase();
    }

    private Object parseFieldValue(String stringToParse) {
        Parsable displayTypeParser = new DisplayTypeParser(field.getType());
        return displayTypeParser.parse(stringToParse);
    }

    public Boolean isMatch(SObject recordToCheck) {
        Boolean isMatch = false;
        Object fieldValue = recordToCheck.get(field.getName());
        if (operator == EQUAL) {
            isMatch = isEqual(fieldValue);
        } else if (operator == NOT_EQUAL) {
            isMatch = isNotEqual(fieldValue);
        } else if (operator == CONTAINS) {
            isMatch = contains(fieldValue);
        } else if (operator == DOES_NOT_CONTAIN) {
            isMatch = doesNotContain(fieldValue);
        } else if (operator == STARTS_WITH) {
            isMatch = startsWith(fieldValue);
        } else if (operator == ENDS_WITH) {
            isMatch = endsWith(fieldValue);
        } else if (operator == LESS_THAN) {
            isMatch = isLessThan(fieldValue);
        } else if (operator == LESS_OR_EQUAL) {
            isMatch = isLessOrEqual(fieldValue);
        } else if (operator == GREATER_THAN) {
            isMatch = isGreater(fieldValue);
        } else if (operator == GREATER_OR_EQUAL) {
            isMatch = isGreaterOrEqual(fieldValue);
        } else if (operator == INCLUDES) {
            isMatch = isIncluding(fieldValue);
        } else if (operator == EXCLUDES) {
            isMatch = isExcluding(fieldValue);
        } else if (operator == WITHIN) {
            // not implemented yet
        } else {
            throwInvalidOperatorException();
        }
        return isMatch;
    }

    private Boolean isEqual(Object fieldValue) {
        return fieldValue == filterValue;
    }

    private Boolean isNotEqual(Object fieldValue) {
        return !isEqual(fieldValue);
    }

    private Boolean contains(Object fieldValue) {
        Boolean contains = false;
        if (DisplayConstants.TEXT_TYPES.contains(field.getType())) {
            contains = ((String) fieldValue).contains((String) filterValue);
        } else {
            throwInvalidOperatorException();
        }
        return contains;
    }

    private Boolean doesNotContain(Object fieldValue) {
        return !contains(fieldValue);
    }

    private Boolean startsWith(Object fieldValue) {
        Boolean startsWith = false;
        if (DisplayConstants.TEXT_TYPES.contains(field.getType())) {
            startsWith = ((String) fieldValue).startsWith((String) filterValue);
        } else {
            throwInvalidOperatorException();
        }
        return startsWith;
    }

    private Boolean endsWith(Object fieldValue) {
        Boolean endsWith = false;
        if (DisplayConstants.TEXT_TYPES.contains(field.getType())) {
            endsWith = ((String) fieldValue).endsWith((String) filterValue);
        } else {
            throwInvalidOperatorException();
        }
        return endsWith;
    }

    private Boolean isLessThan(Object fieldValue) {
        Boolean isLessThan = false;
        if (DisplayConstants.NUMBER_TYPES.contains(field.getType())) {
            isLessThan = ((Decimal) fieldValue) < ((Decimal) filterValue);
        } else if (DisplayConstants.DATE_TYPES.contains(field.getType())) {
            isLessThan = ((Datetime) fieldValue) < ((Datetime) filterValue);
        } else {
            throwInvalidOperatorException();
        }
        return isLessThan;
    }

    private Boolean isLessOrEqual(Object fieldValue) {
        return isEqual(fieldValue) || isLessThan(fieldValue);
    }

    private Boolean isGreater(Object fieldValue) {
        return !isLessOrEqual(fieldValue);
    }

    private Boolean isGreaterOrEqual(Object fieldValue) {
        return !isLessThan(fieldValue);
    }

    private Boolean isIncluding(Object fieldValue) {
        validatePicklist();

        Boolean isIncluding = false;
        Set<String> uniqueFieldValues = getPicklistValues((String) fieldValue);
        Set<String> uniqueFilterValues = getPicklistValues((String) filterValue);

        for (String valueToCheck : uniqueFilterValues) {
            if (uniqueFieldValues.contains(valueToCheck)) {
                isIncluding = true;
                break;
            }
        }
        return isIncluding;
    }

    private Boolean isExcluding(Object fieldValue) {
        return !isIncluding(fieldValue);
    }

    private void validatePicklist() {
        if (field.getType() != DisplayType.PICKLIST) {
            throwInvalidOperatorException();
        }
    }

    private void throwInvalidOperatorException() {
        throw new InvalidConditionException(
            String.format(INVALID_OPERATOR, new List<String>{operator, field.getName()})
        );
    }

    private static Set<String> getPicklistValues(String fieldValue) {
        return new Set<String>(
            fieldValue.toLowerCase().split(';')
        );
    }
}