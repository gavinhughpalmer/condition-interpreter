/**
 * Created by admin-1019 on 08/06/2018.
 */
@isTest
private class FieldConditionTest {

    @isTest
    private static void isMatchTestInvalidSObject() {
        final String filterValue = 'Gavin';
        FieldCondition equalsCondition = new FieldCondition(Account.Name, FieldCondition.EQUAL, filterValue);
        try {
            equalsCondition.isMatch(new Contact());
            System.assert(false, 'An exception should be thrown if the provided sobject does not match the conditions sobject');

        } catch (FieldCondition.InvalidConditionException exceptionToCheck) {
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
    private static void isMatchTestEqualsEqualStrings() {
        final String matchingName = 'Gavin';
        FieldCondition equalsCondition = new FieldCondition(Account.Name, FieldCondition.EQUAL, matchingName);
        Account matchingAccount = new Account(Name = matchingName);
        System.assert(
            equalsCondition.isMatch(matchingAccount),
            'The account name should return true for a match'
        );
    }

    @isTest
    private static void isMatchTestEqualsNotEqualStrings() {
        final String nonMatchingName = 'Gavin';
        FieldCondition equalsCondition = new FieldCondition(Account.Name, FieldCondition.EQUAL, nonMatchingName);
        Account matchingAccount = new Account(Name = 'Annother name');
        System.assert(
            !equalsCondition.isMatch(matchingAccount),
            'The account name should return false for an invalid match'
        );
    }

    @isTest
    private static void isMatchTestNotEqualsEqualStrings() {
        final String matchingName = 'Gavin';
        FieldCondition conditionNotEqual = new FieldCondition(Account.Name, FieldCondition.NOT_EQUAL, matchingName);
        Account matchingAccount = new Account(Name = matchingName);
        System.assert(
            !conditionNotEqual.isMatch(matchingAccount),
            'The account name should return false for a match'
        );
    }

    @isTest
    private static void isMatchTestNotEqualsNotEqualStrings() {
        final String nonMatchingName = 'Gavin';
        FieldCondition conditionNotEqual = new FieldCondition(Account.Name, FieldCondition.NOT_EQUAL, nonMatchingName);
        Account matchingAccount = new Account(Name = 'Annother name');
        System.assert(
            conditionNotEqual.isMatch(matchingAccount),
            'The account name should return true for an invalid match'
        );
    }

    @isTest
    private static void isMatchTestLessThanLessThanDate() {
        final Date today = Date.today();
        FieldCondition lessThanCondition = new FieldCondition(Contact.Birthdate, FieldCondition.LESS_THAN, today);
        Contact testContact = new Contact(Birthdate = today.addDays(-1));
        System.assert(
            lessThanCondition.isMatch(testContact),
            'The match should return true for a smaller date value'
        );
    }

    @isTest
    private static void isMatchTestLessThanInvalidLessThan() {
        FieldCondition lessThanCondition = new FieldCondition(Contact.FirstName, FieldCondition.LESS_THAN, 'A name');
        Contact testContact = new Contact(FirstName = 'Different name');
        try {
            lessThanCondition.isMatch(testContact);
            System.assert(false, 'An exception should be thrown when calling less than on a string');
        } catch (InvalidConditionTypeException exceptionToHandle) {
            System.assert(
                exceptionToHandle.getMessage().containsIgnoreCase(FieldCondition.LESS_THAN),
                'The error message should contain the less than operator'
            );
        } catch (Exception exceptionToHandle) {
            System.assert(false, 'A more specific exception should have been thrown ' + exceptionToHandle.getMessage());
        }
    }

    @isTest
    private static void isMatchTestLessThanEqualDate() {
        final Date today = Date.today();
        FieldCondition lessThanCondition = new FieldCondition(Contact.Birthdate, FieldCondition.LESS_THAN, today);
        Contact testContact = new Contact(Birthdate = today);
        System.assert(
            !lessThanCondition.isMatch(testContact),
            'The match should return false for equal dates'
        );
    }

    @isTest
    private static void isMatchTestLessOrEqualEqualDate() {
        final Date today = Date.today();
        FieldCondition lessThanCondition = new FieldCondition(Contact.Birthdate, FieldCondition.LESS_OR_EQUAL, today);
        Contact testContact = new Contact(Birthdate = today);
        System.assert(
            lessThanCondition.isMatch(testContact),
            'The match should return true for equal dates'
        );
    }

    @isTest
    private static void isMatchTestGreaterThanGreaterDate() {
        final Date today = Date.today();
        FieldCondition lessThanCondition = new FieldCondition(Contact.Birthdate, FieldCondition.GREATER_THAN, today);
        Contact testContact = new Contact(Birthdate = today.addDays(1));
        System.assert(
            lessThanCondition.isMatch(testContact),
            'The match should return true for a greater date'
        );
    }

    @isTest
    private static void isMatchTestGreaterOrEqualGreaterDate() {
        final Date today = Date.today();
        FieldCondition lessThanCondition = new FieldCondition(Contact.Birthdate, FieldCondition.GREATER_OR_EQUAL, today);
        Contact testContact = new Contact(Birthdate = today.addDays(1));
        System.assert(
            lessThanCondition.isMatch(testContact),
            'The match should return true for a greater date'
        );
    }

    @isTest
    private static void isMatchTestGreaterOrEqualGreaterNumber() {
        final Decimal smallerNumber = 200.0;
        FieldCondition lessThanCondition = new FieldCondition(Account.AnnualRevenue, FieldCondition.GREATER_OR_EQUAL, smallerNumber);
        Account testAccount = new Account(AnnualRevenue = smallerNumber + 10);
        System.assert(
            lessThanCondition.isMatch(testAccount),
            'The match should return true for a greater number'
        );
    }

    @isTest
    private static void isMatchTestInvalidOperator() {
        final String invalidOperator = 'Not An operator';
        try {
            FieldCondition condition = new FieldCondition(Account.AnnualRevenue, invalidOperator, '');
            System.assert(false, 'an exception should be thrown when an invalid operator is passed into the constuctor');
        } catch (FieldCondition.InvalidConditionException invalidConditionException) {
            System.assert(
                invalidConditionException.getMessage().containsIgnoreCase(invalidOperator),
                'The exception message should contain the operator name'
            );
        } catch (Exception exceptionToHandle) {
            System.assert(false, 'A more specific exception should have been thrown ' + exceptionToHandle.getMessage());
        }
    }

    // @isTest
    // private static void isMatchTestIncludingIncludingPicklist() {
//        final String includedPicklistValue = 'Test Value';
//        FieldCondition condition = new FieldCondition(Account.?, FieldCondition.INCLUDES, includedPicklistValue);
//        Account testAccount = new Account(); // need to set a multi picklist field
//        System.assert(condition.isMatch(testAccount), 'The ');
        //TODO
    // }

    // @isTest
    // private static void isMatchTestExcludingExcludingPicklist() {
//        FieldCondition condition = new FieldCondition(Account.?, FieldCondition.INCLUDES, 'Some;picklist;values');
//        Account testAccount = new Account(); // need to set a multi picklist field
//        System.assert(condition.isMatch(testAccount), 'The ');
        //TODO
    // }

    @isTest
    private static void isMatchTestContainsHasString() {
        final String containedString = 'Test Value';
        FieldCondition condition = new FieldCondition(Account.Name, FieldCondition.CONTAINS, containedString);
        Account testAccount = new Account(Name = 'Some other string' + containedString);
        System.assert(
            condition.isMatch(testAccount),
            'The string ' + containedString + ' should have been found within the account name'
        );
    }

    @isTest
    private static void isMatchTestContainsInvalidStringField() {
        FieldCondition condition = new FieldCondition(Account.AnnualRevenue, FieldCondition.CONTAINS, '10.1');
        Account testAccount = new Account(Name = 'An account Name');
        try {
            condition.isMatch(testAccount);
            System.assert(false, 'An exception should have been thrown');
        } catch (InvalidConditionTypeException invalidFieldException) {
            System.assert(
                invalidFieldException.getMessage().containsIgnoreCase('string'),
                'The invalid field should be contained within the error message'
            );
        } catch (Exception exceptionToHandle) {
            System.assert(false, 'A more specific error message should be thrown: ' + exceptionToHandle.getMessage());
        }
    }

    @isTest
    private static void isMatchTestDoesNotContainNoString() {
        FieldCondition condition = new FieldCondition(Account.Name, FieldCondition.DOES_NOT_CONTAIN, 'A string');
        Account testAccount = new Account(Name = 'Some other string');
        System.assert(
            condition.isMatch(testAccount),
            'The string should be contained within the account name'
        );
    }

    @isTest
    private static void isMatchTestStartsWithHasString() {
        final String containedString = 'Test Value';
        FieldCondition condition = new FieldCondition(Account.Name, FieldCondition.STARTS_WITH, containedString);
        Account testAccount = new Account(Name = containedString + 'Some other string');
        System.assert(
            condition.isMatch(testAccount),
            'The string ' + containedString + ' should have been found at the beginning of the account name'
        );
    }

    @isTest
    private static void isMatchTestEndsWithHasString() {
        final String containedString = 'Test Value';
        FieldCondition condition = new FieldCondition(Account.Name, FieldCondition.ENDS_WITH, containedString);
        Account testAccount = new Account(Name = 'Some other string' + containedString);
        System.assert(
            condition.isMatch(testAccount),
            'The string ' + containedString + ' should have been found at the end of the account name'
        );
    }

    @isTest
    private static void isMatchTestStartsWithHasNoString() {
        FieldCondition condition = new FieldCondition(Account.Name, FieldCondition.STARTS_WITH, 'Beginning');
        Account testAccount = new Account(Name = 'Some other string');
        System.assert(
            !condition.isMatch(testAccount),
            'The string should not be matched at the beginning of the account name'
        );
    }

    @isTest
    private static void isMatchTestEndsWithHasNoString() {
        FieldCondition condition = new FieldCondition(Account.Name, FieldCondition.ENDS_WITH, 'Ending');
        Account testAccount = new Account(Name = 'Some other string');
        System.assert(
            !condition.isMatch(testAccount),
            'The string should not be matched at the end of the account name'
        );
    }

    @isTest
    private static void isMatchTestStartsWithInvalidStringField() {
        FieldCondition condition = new FieldCondition(Account.AnnualRevenue, FieldCondition.STARTS_WITH, '10.1');
        Account testAccount = new Account(Name = 'An account Name');
        try {
            condition.isMatch(testAccount);
            System.assert(false, 'An exception should have been thrown');
        } catch (InvalidConditionTypeException invalidFieldException) {
            System.assert(
                invalidFieldException.getMessage().containsIgnoreCase('string'),
                'The invalid field should be contained within the error message'
            );
        } catch (Exception exceptionToHandle) {
            System.assert(false, 'A more specific error message should be thrown: ' + exceptionToHandle.getMessage());
        }
    }

    @isTest
    private static void isMatchTestEndsWithInvalidStringField() {
        FieldCondition condition = new FieldCondition(Account.AnnualRevenue, FieldCondition.ENDS_WITH, '10.1');
        Account testAccount = new Account(Name = 'An account Name');
        try {
            condition.isMatch(testAccount);
            System.assert(false, 'An exception should have been thrown');
        } catch (InvalidConditionTypeException invalidFieldException) {
            System.assert(
                invalidFieldException.getMessage().containsIgnoreCase('string'),
                'The invalid field should be contained within the error message'
            );
        } catch (Exception exceptionToHandle) {
            System.assert(false, 'A more specific error message should be thrown: ' + exceptionToHandle.getMessage());
        }
    }
}