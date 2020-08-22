/**
 * Created by admin-1019 on 07/06/2018.
 */

public class FieldCondition {

    private static final String INVALID_OPERATOR = 'Invalid operator {0} not found';
    private static final String INVALID_FIELD = 'Invalid field ({0}) for object {1}';
    public static final String EQUAL = 'equal';
    public static final String NOT_EQUAL = 'not equal';
    public static final String CONTAINS = 'contains';
    public static final String DOES_NOT_CONTAIN = 'does not contain';
    public static final String STARTS_WITH = 'starts with';
    public static final String ENDS_WITH = 'ends with';
    public static final String LESS_THAN = 'less than';
    public static final String LESS_OR_EQUAL = 'less or equal';
    public static final String GREATER_THAN = 'greater than';
    public static final String GREATER_OR_EQUAL = 'greater or equal';
    public static final String INCLUDES = 'includes';
    public static final String EXCLUDES = 'excludes';
    public static final String WITHIN = 'within';

    private static final Map<String, Conditionable> CONDITIONS = new Map<String, Conditionable>{
        EQUAL => new EqualsCondition(),
        NOT_EQUAL => new NotCondition(new EqualsCondition()),
        CONTAINS => new ContainsCondition(),
        DOES_NOT_CONTAIN => new NotCondition(new ContainsCondition()),
        STARTS_WITH => new StartsWithCondition(),
        ENDS_WITH => new EndsWithCondition(),
        LESS_THAN => new LessThanCondition(),
        LESS_OR_EQUAL => new OrCondition(new EqualsCondition(), new LessThanCondition()),
        GREATER_THAN => new NotCondition(new OrCondition(new EqualsCondition(), new LessThanCondition())),
        GREATER_OR_EQUAL => new NotCondition(new LessThanCondition()),
        INCLUDES => new IncludesCondition(),
        EXCLUDES => new NotCondition(new IncludesCondition()),
        WITHIN => new WithinCondition()
    };

    public class InvalidConditionException extends Exception {}

    private final SObjectType objectType;
    private final DescribeFieldResult field;
    private final String operator;
    private final Conditionable condition;
    private final Object filterValue;

    public FieldCondition(SObjectField fieldToCheck, String operator, Object filterValue) {
        field = fieldToCheck.getDescribe();
        this.filterValue = filterValue;
        this.operator = operator.toLowerCase();
        validateOperator();
        condition = CONDITIONS.get(operator);
        // TODO Check if the filter value is a valid type for the field input to fail fast, seems to be quite difficult
    }

    private void validateOperator() {
        if (!CONDITIONS.containsKey(operator)) {
            throw new InvalidConditionException(
                String.format(INVALID_OPERATOR, new List<String>{operator})
            );
        }
    }

    public Boolean isMatch(SObject recordToCheck) {
        validateSObject(recordToCheck);
        Object fieldValue = recordToCheck.get(field.getName());
        return condition.evaluate(fieldValue, filterValue);
    }

    private void validateSObject(SObject recordToValidate) {
        DescribeSObjectResult objectDescribe = recordToValidate.getSObjectType().getDescribe();
        Boolean recordHasField = objectDescribe.fields.getMap().containsKey(field.getName());
        if (!recordHasField) {
            throw new InvalidConditionException('Invalid sobject provided into the condition ' + toString());
        }
    }

    public override String toString() {
        return field.getName() + ' ' + operator + ' ' + String.valueOf(filterValue);
    }
}