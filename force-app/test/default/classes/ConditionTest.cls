/**
 * Created by admin-1019 on 08/06/2018.
 */
@isTest
private class ConditionTest {

    @isTest
    private static void constructorTest_InvalidField() {
        final String fakeObject = 'Not an object';
        try {
            Condition testCondition = new Condition(fakeObject, 'not a field', 'not an operator', 'not a value');

            System.assert(false, 'An exception should be thrown for invalid fields/objects');

        } catch (Condition.InvalidConditionException exceptionToCheck) {
            System.assert(
                exceptionToCheck.getMessage().contains(fakeObject),
                'The message should contain the name of the invalid object, actual error given: ' + exceptionToCheck.getMessage()
            );
        } catch (Exception wrongException) {
            System.assert(
                false,
                'A more specific exception should have been thrown, error given: ' + wrongException.getMessage()
            );
        }
    }

    @isTest
    private static void isMatchTest_InvalidSObject() {
        final String filterValue = 'Gavin';
        Condition equalsCondition = new Condition('Account', 'Name', Condition.EQUAL, filterValue);
        try {
            equalsCondition.isMatch(new Contact());
            System.assert(false, 'An exception should be thrown if the provided sobject does not match the conditions sobject');

        } catch (Condition.InvalidConditionException exceptionToCheck) {
            System.assert(
                exceptionToCheck.getMessage().contains(filterValue),
                'The message should contain the name of the details of the condition, actual error given: ' + exceptionToCheck.getMessage()
            );
        } catch (Exception wrongException) {
            System.assert(
                false,
                'A more specific exception should have been thrown, error given: ' + wrongException.getMessage()
            );
        }
    }

    @isTest
    private static void isMatchTest_Equals_EqualStrings() {
        final String matchingName = 'Gavin';
        Condition equalsCondition = new Condition('Account', 'Name', Condition.EQUAL, matchingName);
        Account matchingAccount = new Account(Name = matchingName);
        System.assert(
            equalsCondition.isMatch(matchingAccount),
            'The account name should return true for a match'
        );
    }

    @isTest
    private static void isMatchTest_Equals_NotEqualStrings() {
        final String nonMatchingName = 'Gavin';
        Condition equalsCondition = new Condition('Account', 'Name', Condition.EQUAL, nonMatchingName);
        Account matchingAccount = new Account(Name = 'Annother name');
        System.assert(
            !equalsCondition.isMatch(matchingAccount),
            'The account name should return false for an invalid match'
        );
    }

    @isTest
    private static void isMatchTest_NotEquals_EqualStrings() {
        final String matchingName = 'Gavin';
        Condition conditionNotEqual = new Condition('Account', 'Name', Condition.NOT_EQUAL, matchingName);
        Account matchingAccount = new Account(Name = matchingName);
        System.assert(
            !conditionNotEqual.isMatch(matchingAccount),
            'The account name should return false for a match'
        );
    }

    @isTest
    private static void isMatchTest_NotEquals_NotEqualStrings() {
        final String nonMatchingName = 'Gavin';
        Condition conditionNotEqual = new Condition('Account', 'Name', Condition.NOT_EQUAL, nonMatchingName);
        Account matchingAccount = new Account(Name = 'Annother name');
        System.assert(
            conditionNotEqual.isMatch(matchingAccount),
            'The account name should return true for an invalid match'
        );
    }

    @isTest
    private static void isMatchTest_LessThan_LessThanDate() {
        final Date today = Date.today();
        Condition lessThanCondition = new Condition('Contact', 'Birthdate', Condition.LESS_THAN, String.valueOf(today));
        Contact testContact = new Contact(Birthdate = today.addDays(-1));
        System.assert(
            lessThanCondition.isMatch(testContact),
            'The match should return true for a smaller date value'
        );
    }

    @isTest
    private static void isMatchTest_LessThan_InvalidLessThan() {
        Condition lessThanCondition = new Condition('Contact', 'FirstName', Condition.LESS_THAN, 'A name');
        Contact testContact = new Contact(FirstName = 'Different name');
        try {
            lessThanCondition.isMatch(testContact);
            System.assert(false, 'An exception should be thrown when calling less than on a string');
        } catch (Condition.InvalidConditionException exceptionToHandle) {
            System.assert(
                exceptionToHandle.getMessage().containsIgnoreCase(Condition.LESS_THAN),
                'The error message should contain the less than operator'
            );
        } catch (Exception exceptionToHandle) {
            System.assert(false, 'A more specific exception should have been thrown ' + exceptionToHandle.getMessage());
        }
    }

    @isTest
    private static void isMatchTest_LessThan_EqualDate() {
        final Date today = Date.today();
        Condition lessThanCondition = new Condition('Contact', 'Birthdate', Condition.LESS_THAN, String.valueOf(today));
        Contact testContact = new Contact(Birthdate = today);
        System.assert(
            !lessThanCondition.isMatch(testContact),
            'The match should return false for equal dates'
        );
    }

    @isTest
    private static void isMatchTest_LessOrEqual_EqualDate() {
        final Date today = Date.today();
        Condition lessThanCondition = new Condition('Contact', 'Birthdate', Condition.LESS_OR_EQUAL, String.valueOf(today));
        Contact testContact = new Contact(Birthdate = today);
        System.assert(
            lessThanCondition.isMatch(testContact),
            'The match should return true for equal dates'
        );
    }

    @isTest
    private static void isMatchTest_GreaterThan_GreaterDate() {
        final Date today = Date.today();
        Condition lessThanCondition = new Condition('Contact', 'Birthdate', Condition.GREATER_THAN, String.valueOf(today));
        Contact testContact = new Contact(Birthdate = today.addDays(1));
        System.assert(
            lessThanCondition.isMatch(testContact),
            'The match should return true for a greater date'
        );
    }

    @isTest
    private static void isMatchTest_GreaterOrEqual_GreaterDate() {
        final Date today = Date.today();
        Condition lessThanCondition = new Condition('Contact', 'Birthdate', Condition.GREATER_OR_EQUAL, String.valueOf(today));
        Contact testContact = new Contact(Birthdate = today.addDays(1));
        System.assert(
            lessThanCondition.isMatch(testContact),
            'The match should return true for a greater date'
        );
    }

    @isTest
    private static void isMatchTest_GreaterOrEqual_GreaterNumber() {
        final Decimal smallerNumber = 200.0;
        Condition lessThanCondition = new Condition('Account', 'AnnualRevenue', Condition.GREATER_OR_EQUAL, String.valueOf(smallerNumber));
        Account testAccount = new Account(AnnualRevenue = smallerNumber + 10);
        System.assert(
            lessThanCondition.isMatch(testAccount),
            'The match should return true for a greater number'
        );
    }

    @isTest
    private static void isMatchTest_InvalidOperator() {
        final String invalidOperator = 'Not An operator';
        Condition condition = new Condition('Account', 'AnnualRevenue', invalidOperator, '');
        try {
            condition.isMatch(new Account());
            System.assert(false, 'an exception should be thrown when isMatch is called on an invalid operator');
        } catch (Condition.InvalidConditionException invalidConditionException) {
            System.assert(
                invalidConditionException.getMessage().containsIgnoreCase(invalidOperator),
                'The exception message should contain the operator name'
            );
        } catch (Exception exceptionToHandle) {
            System.assert(false, 'A more specific exception should have been thrown ' + exceptionToHandle.getMessage());
        }
    }

    @isTest
    private static void isMatchTest_Including_IncludingPicklist() {
//        final String includedPicklistValue = 'Test Value';
//        Condition condition = new Condition('Account', 'A multi picklist field', Condition.INCLUDES, includedPicklistValue);
//        Account testAccount = new Account(); // need to set a multi picklist field
//        System.assert(condition.isMatch(testAccount), 'The ');
        //TODO
    }

    @isTest
    private static void isMatchTest_Excluding_ExcludingPicklist() {
//        Condition condition = new Condition('Account', 'A multi picklist field', Condition.INCLUDES, 'Some;picklist;values');
//        Account testAccount = new Account(); // need to set a multi picklist field
//        System.assert(condition.isMatch(testAccount), 'The ');
        //TODO
    }

    @isTest
    private static void isMatchTest_Contains_HasString() {
        final String containedString = 'Test Value';
        Condition condition = new Condition('Account', 'Name', Condition.CONTAINS, containedString);
        Account testAccount = new Account(Name = 'Some other string' + containedString);
        System.assert(
            condition.isMatch(testAccount),
            'The string ' + containedString + ' should have been found within the account name'
        );
    }

    @isTest
    private static void isMatchTest_Contains_InvalidStringField() {
        final String invalidFieldName = 'AnnualRevenue';
        Condition condition = new Condition('Account', invalidFieldName, Condition.CONTAINS, '10.1');
        Account testAccount = new Account(Name = 'An account Name');
        try {
            condition.isMatch(testAccount);
            System.assert(false, 'An exception should have been thrown');
        } catch (Condition.InvalidConditionException invalidFieldException) {
            System.assert(
                invalidFieldException.getMessage().containsIgnoreCase(invalidFieldName),
                'The invalid field should be contained within the error message'
            );
        } catch (Exception exceptionToHandle) {
            System.assert(false, 'A more specific error message should be thrown');
        }
    }

    @isTest
    private static void isMatchTest_DoesNotContain_NoString() {
        Condition condition = new Condition('Account', 'Name', Condition.DOES_NOT_CONTAIN, 'A string');
        Account testAccount = new Account(Name = 'Some other string');
        System.assert(
            condition.isMatch(testAccount),
            'The string should be contained within the account name'
        );
    }

    @isTest
    private static void isMatchTest_StartsWith_HasString() {
        final String containedString = 'Test Value';
        Condition condition = new Condition('Account', 'Name', Condition.STARTS_WITH, containedString);
        Account testAccount = new Account(Name = containedString + 'Some other string');
        System.assert(
            condition.isMatch(testAccount),
            'The string ' + containedString + ' should have been found at the beginning of the account name'
        );
    }

    @isTest
    private static void isMatchTest_EndsWith_HasString() {
        final String containedString = 'Test Value';
        Condition condition = new Condition('Account', 'Name', Condition.ENDS_WITH, containedString);
        Account testAccount = new Account(Name = 'Some other string' + containedString);
        System.assert(
            condition.isMatch(testAccount),
            'The string ' + containedString + ' should have been found at the end of the account name'
        );
    }

    @isTest
    private static void isMatchTest_StartsWith_HasNoString() {
        Condition condition = new Condition('Account', 'Name', Condition.STARTS_WITH, 'Beginning');
        Account testAccount = new Account(Name = 'Some other string');
        System.assert(
            !condition.isMatch(testAccount),
            'The string should not be matched at the beginning of the account name'
        );
    }

    @isTest
    private static void isMatchTest_EndsWith_HasNoString() {
        Condition condition = new Condition('Account', 'Name', Condition.ENDS_WITH, 'Ending');
        Account testAccount = new Account(Name = 'Some other string');
        System.assert(
            !condition.isMatch(testAccount),
            'The string should not be matched at the end of the account name'
        );
    }

    @isTest
    private static void isMatchTest_StartsWith_InvalidStringField() {
        final String invalidFieldName = 'AnnualRevenue';
        Condition condition = new Condition('Account', invalidFieldName, Condition.STARTS_WITH, '10.1');
        Account testAccount = new Account(Name = 'An account Name');
        try {
            condition.isMatch(testAccount);
            System.assert(false, 'An exception should have been thrown');
        } catch (Condition.InvalidConditionException invalidFieldException) {
            System.assert(
                invalidFieldException.getMessage().containsIgnoreCase(invalidFieldName),
                'The invalid field should be contained within the error message'
            );
        } catch (Exception exceptionToHandle) {
            System.assert(false, 'A more specific error message should be thrown');
        }
    }

    @isTest
    private static void isMatchTest_EndsWith_InvalidStringField() {
        final String invalidFieldName = 'AnnualRevenue';
        Condition condition = new Condition('Account', invalidFieldName, Condition.ENDS_WITH, '10.1');
        Account testAccount = new Account(Name = 'An account Name');
        try {
            condition.isMatch(testAccount);
            System.assert(false, 'An exception should have been thrown');
        } catch (Condition.InvalidConditionException invalidFieldException) {
            System.assert(
                invalidFieldException.getMessage().containsIgnoreCase(invalidFieldName),
                'The invalid field should be contained within the error message'
            );
        } catch (Exception exceptionToHandle) {
            System.assert(false, 'A more specific error message should be thrown');
        }
    }
}