/**
 * Created by admin-1019 on 08/06/2018.
 */

public class SchemaFacade {

    public class InvalidDescribeException extends Exception {}

    private static final SchemaFacade instance = new SchemaFacade();

    public static SchemaFacade getInstance() {
        return instance;
    }

    private Map<String, SObjectType> sObjectTypeByObjectNames = Schema.getGlobalDescribe();
    private Map<String, DescribeSObjectResult> sObjectDescribeByObjectNames = new Map<String, DescribeSObjectResult>();
    private Map<String, Map<String, SObjectField>> fieldTypesByNameAndObject = new Map<String, Map<String, SObjectField>>();
    private Map<String, Map<String, DescribeFieldResult>> fieldDescribeByNameAndObject = new Map<String, Map<String, DescribeFieldResult>>();

    private SchemaFacade() {
    }

    public Boolean isValidSObject(String objectApiName) {
        return sObjectTypeByObjectNames.containsKey(objectApiName);
    }

    public Boolean isNotValidSObject(String objectApiName) {
        return !isValidSObject(objectApiName);
    }

    public DescribeSObjectResult getDescribe(String objectApiName) {
        objectApiName = objectApiName.toLowerCase();
        validateObjectApiName(objectApiName);
        if (!sObjectDescribeByObjectNames.containsKey(objectApiName)) {
            DescribeSObjectResult sObjectDescribe = sObjectTypeByObjectNames.get(objectApiName).getDescribe();
            sObjectDescribe.fields.getMap();
            sObjectDescribeByObjectNames.put(objectApiName, sObjectDescribe);
        }
        return sObjectDescribeByObjectNames.get(objectApiName);
    }

    public void validateObjectApiName(String objectApiName) {
        if (isNotValidSObject(objectApiName)) {
            throw new InvalidDescribeException('SObject name (' + objectApiName + ') is invalid');
        }
    }

    public Boolean isValidField(String objectApiName, String fieldApiName) {
        return isValidSObject(objectApiName) && getFieldsMap(objectApiName).containsKey(fieldApiName);
    }

    public Boolean isNotValidField(String objectApiName, String fieldApiName) {
        return !isValidField(objectApiName, fieldApiName);
    }

    private Map<String, SObjectField> getFieldsMap(String objectApiName) {
        objectApiName = objectApiName.toLowerCase();
        validateObjectApiName(objectApiName);
        if (!fieldTypesByNameAndObject.containsKey(objectApiName)) {
            Map<String, SObjectField> fieldsMap = getDescribe(objectApiName).fields.getMap();
            fieldTypesByNameAndObject.put(objectApiName, fieldsMap);
        }
        return fieldTypesByNameAndObject.get(objectApiName);
    }

    public DescribeFieldResult getFieldDescribe(String objectApiName, String fieldApiName) {
        objectApiName = objectApiName.toLowerCase();
        fieldApiName = fieldApiName.toLowerCase();
        validateFieldApiName(objectApiName, fieldApiName);
        if (!fieldDescribeByNameAndObject.containsKey(objectApiName) || !fieldDescribeByNameAndObject.get(objectApiName).containsKey(fieldApiName)) {
            Map<String, DescribeFieldResult> fieldDescribeMap = fieldDescribeByNameAndObject.get(objectApiName);
            fieldDescribeMap = fieldDescribeMap == null ? new Map<String, DescribeFieldResult>() : fieldDescribeMap;
            fieldDescribeMap.put(fieldApiName, getFieldsMap(objectApiName).get(fieldApiName).getDescribe());
            fieldDescribeByNameAndObject.put(objectApiName, fieldDescribeMap);
        }
        return fieldDescribeByNameAndObject.get(objectApiName).get(fieldApiName);
    }

    public void validateFieldApiName(String objectApiName, String fieldApiName) {
        if (isNotValidField(objectApiName, fieldApiName)) {
            throw new InvalidDescribeException('Field name (' + fieldApiName + ') does not exist on the object ' + objectApiName);
        }
    }
}