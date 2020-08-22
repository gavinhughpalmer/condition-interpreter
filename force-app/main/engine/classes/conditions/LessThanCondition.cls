public inherited sharing class LessThanCondition implements Conditionable {

    public Boolean evaluate(Object value, Object comparison) {
        if ((value instanceof Decimal) && (comparison instanceof Decimal)) {
            return ((Decimal) value) < ((Decimal) comparison);
        } else if ((value instanceof Datetime) && (comparison instanceof Datetime)) {
            return ((Datetime) value) < ((Datetime) comparison);
        }
        throw new InvalidConditionTypeException('Invalid type for less than expression expected Date or Decimal');
    }
}
