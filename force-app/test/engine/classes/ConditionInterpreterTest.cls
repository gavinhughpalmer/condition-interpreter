/**
 * Created by admin-1019 on 08/06/2018.
 */
@isTest
private class ConditionInterpreterTest {
    @isTest
    private static void isMatchTestValidMatch() {
        final String matchingAccountName = 'Test Account';
        final String firstMatchingStreetValue = 'Street';
        final String secondMatchingStreetValue = 'Avenue';
        ConditionInterpreter interpreter = new ConditionInterpreter(
            '1 AND (2 OR 3)',
            new Map<Integer, FieldCondition>{
                1 => new FieldCondition(Account.Name, FieldCondition.EQUAL, matchingAccountName),
                2 => new FieldCondition(Account.BillingStreet, FieldCondition.CONTAINS, firstMatchingStreetValue),
                3 => new FieldCondition(Account.BillingStreet, FieldCondition.CONTAINS, secondMatchingStreetValue)
            }
        );

        Account firstMatch = new Account(Name = matchingAccountName, BillingStreet = 'Palmer' + firstMatchingStreetValue);
        Account secondMatch = new Account(Name = matchingAccountName, BillingStreet = 'Palmer' + secondMatchingStreetValue);

        System.assert(
            interpreter.isMatch(firstMatch),
            'The match should return true if the account name and the billing street match'
        );
        System.assert(
            interpreter.isMatch(secondMatch),
            'The match should return true if the account name and the billing street match'
        );
    }

    @isTest
    private static void isMatchTestInvalidMatch() {
        final String matchingAccountName = 'Test Account';
        final String firstMatchingStreetValue = 'Street';
        final String secondMatchingStreetValue = 'Avenue';
        ConditionInterpreter interpreter = new ConditionInterpreter(
            '1 AND (2 OR 3)',
            new Map<Integer, FieldCondition>{
                1 => new FieldCondition(Account.Name, FieldCondition.EQUAL, matchingAccountName),
                2 => new FieldCondition(Account.BillingStreet, FieldCondition.CONTAINS, firstMatchingStreetValue),
                3 => new FieldCondition(Account.BillingStreet, FieldCondition.CONTAINS, secondMatchingStreetValue)
            }
        );
        Account firstNonMatch = new Account(Name = 'Not Match', BillingStreet = firstMatchingStreetValue + secondMatchingStreetValue);
        Account secondNonMatch = new Account(Name = matchingAccountName, BillingStreet = 'No match');

        System.assert(
            !interpreter.isMatch(firstNonMatch),
            'The match should return false if the account name is not a match'
        );
        System.assert(
            !interpreter.isMatch(secondNonMatch),
            'The match should return false if the billing street is not a match'
        );
    }

    @isTest
    private static void isMatchTestInvalidKeyword() {
        final String invalidKeyword = 'wrongkeyword';

        ConditionInterpreter interpreter = new ConditionInterpreter(
            '1 ' + invalidKeyword + ' (2 OR 3)',
            new Map<Integer, FieldCondition>{
                1 => new FieldCondition(Account.Name, FieldCondition.EQUAL, 'Test'),
                2 => new FieldCondition(Account.BillingStreet, FieldCondition.CONTAINS, 'Test'),
                3 => new FieldCondition(Account.BillingStreet, FieldCondition.CONTAINS, 'Test')
            }
        );
        Account testAccount = new Account(Name = 'Not Match', BillingStreet = 'Test');
        try {
            interpreter.isMatch(testAccount);
            System.assert(false, 'An exception should have been thrown');
        } catch (ConditionInterpreter.InvalidLogicException invalidKeywordException) {
            System.assert(
                invalidKeywordException.getMessage().containsIgnoreCase(invalidKeyword),
                'The error message should contain the invalid keyword that was found'
            );
        } catch (Exception excetionToHandle) {
            System.assert(false, 'A more specific error message should have been thrown ' + excetionToHandle.getMessage());
        }
    }

    @isTest
    private static void isMatchTestInvalidSyntax() {
        ConditionInterpreter interpreter = new ConditionInterpreter(
            ')',
            new Map<Integer, FieldCondition>()
        );
        Account testAccount = new Account(Name = 'Not Match', BillingStreet = 'Test');
        try {
            interpreter.isMatch(testAccount);
            System.assert(false, 'An exception should have been thrown');
        } catch (ConditionInterpreter.InvalidLogicException invalidKeywordException) {
            System.assert(
                invalidKeywordException.getMessage().containsIgnoreCase(')'),
                'The error message should contain the invalid ): ' + invalidKeywordException.getMessage()
            );
        } catch (Exception excetionToHandle) {
            System.assert(false, 'A more specific error message should have been thrown ' + excetionToHandle.getMessage());
        }
    }

    @isTest
    private static void isMatchTestInvalidIndex() {
        ConditionInterpreter interpreter = new ConditionInterpreter(
            '1 AND (2 OR 3)',
            new Map<Integer, FieldCondition>{
                1 => new FieldCondition(Account.Name, FieldCondition.EQUAL, 'Test'),
                2 => new FieldCondition(Account.BillingStreet, FieldCondition.CONTAINS, 'Test')
            }
        );
        Account testAccount = new Account(Name = 'Not Match', BillingStreet = 'Test');
        try {
            interpreter.isMatch(testAccount);
            System.assert(false, 'An exception should have been thrown');
        } catch (ConditionInterpreter.InvalidLogicException invalidKeywordException) {
            System.assert(
                invalidKeywordException.getMessage().containsIgnoreCase('3'),
                'The error message should the index that is not found'
            );
        } catch (Exception excetionToHandle) {
            System.assert(false, 'A more specific error message should have been thrown ' + excetionToHandle.getMessage());
        }
    }
}