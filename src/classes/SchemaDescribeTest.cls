/**
 * Created by admin-1019 on 08/06/2018.
 */

@IsTest
private class SchemaDescribeTest {

    @IsTest
    private static void isValidSObject() {
        System.assert(
            SchemaDescribe.getInstance().isValidSObject('account'),
            'The account object should return as an existing object'
        );
    }

    @IsTest
    private static void isNotValidSObject() {
        System.assert(
            SchemaDescribe.getInstance().isNotValidSObject('abaoefjk'),
            'The invalid object name should return as a not valid object'
        );
    }

    @IsTest
    private static void isValidField() {
        System.assert(
            SchemaDescribe.getInstance().isValidField('account', 'Name'),
            'The account object should return as an existing object'
        );
    }

    @IsTest
    private static void isNotValidField() {
        System.assert(
            SchemaDescribe.getInstance().isNotValidField('Account', 'adfasd'),
            'The invalid object name should return as a not valid object'
        );
    }

    @IsTest
    private static void getDescribe() {
        System.assertEquals(
            Account.SObjectType.getDescribe(),
            SchemaDescribe.getInstance().getDescribe('Account'),
            'The dynamic describe call should return the account describe object'
        );
    }

    @IsTest
    private static void getFieldDescribe() {
        System.assertEquals(
            Account.Name.getDescribe(),
            SchemaDescribe.getInstance().getFieldDescribe('Account', 'Name'),
            'The dynamic describe call should return the account name describe object'
        );
    }

    @IsTest
    private static void getDescribe_Exception() {
        final String invalidObjectName = 'Invalid Object';
        try {
            SchemaDescribe.getInstance().getDescribe(invalidObjectName);
            System.assert(false, 'An exception should have been thrown');
        } catch (SchemaDescribe.InvalidDescribeException invalidDescribeException) {
            System.assert(
                invalidDescribeException.getMessage().containsIgnoreCase(invalidObjectName),
                'The error message should contain the invalid object name: ' + invalidObjectName
            );
        } catch (Exception exceptionToCheck) {
            System.assert(false, 'A more specific error should be thrown: ' + exceptionToCheck.getMessage());
        }
    }

    @IsTest
    private static void getFieldDescribe_Exception() {
        final String invalidFieldName = 'Invalid Field';
        try {
            SchemaDescribe.getInstance().getFieldDescribe('Account', invalidFieldName);
            System.assert(false, 'An exception should have been thrown');
        } catch (SchemaDescribe.InvalidDescribeException invalidDescribeException) {
            System.assert(
                invalidDescribeException.getMessage().containsIgnoreCase(invalidFieldName),
                'The error message should contain the invalid field name: ' + invalidFieldName
            );
        } catch (Exception exceptionToCheck) {
            System.assert(false, 'A more specific error should be thrown: ' + exceptionToCheck.getMessage());
        }
    }
}