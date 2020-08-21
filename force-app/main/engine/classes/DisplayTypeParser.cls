/**
 * Created by admin-1019 on 07/06/2018.
 */

public with sharing class DisplayTypeParser implements Parsable {

    private DisplayType fieldDisplayType;

    public DisplayTypeParser(DisplayType fieldDisplayType) {
        this.fieldDisplayType = fieldDisplayType;
    }

    // allow errors to surface as I will not be able to provide any additional detail
    public Object parse(String stringToParse) {
        Object parsedValue;
        if (fieldDisplayType == Schema.DisplayType.BOOLEAN) {
            parsedValue = parseBoolean(stringToParse);
        } else if (DisplayConstants.NUMBER_TYPES.contains(fieldDisplayType)) {
            parsedValue = parseDecimal(stringToParse);
        } else if (fieldDisplayType == Schema.DisplayType.DATE) {
            parsedValue = parseDate(stringToParse);
        } else if (fieldDisplayType == Schema.DisplayType.DATETIME) {
            parsedValue = parseDatetime(stringToParse);
        } else if (DisplayConstants.ID_TYPES.contains(fieldDisplayType)) {
            parsedValue = parseId(stringToParse);
        } else {
            parsedValue = stringToParse;
        }
        return parsedValue;
    }

    private Boolean parseBoolean(String valueToParse) {
        return String.isNotBlank(valueToParse) && Boolean.valueOf(valueToParse);
    }

    private Decimal parseDecimal(String valueToParse) {
        Decimal decimalToReturn;
        if (String.isNotBlank(valueToParse)) {
            decimalToReturn = Decimal.valueOf(valueToParse);
        }
        return decimalToReturn;
    }

    private Date parseDate(String valueToParse) {
        Date dateToReturn;
        if (String.isNotBlank(valueToParse)) {
            dateToReturn = Date.valueOf(valueToParse);
        }
        return dateToReturn;
    }

    private Datetime parseDatetime(String valueToParse) {
        Datetime datetimeToReturn;
        if (String.isNotBlank(valueToParse)) {
            datetimeToReturn = Datetime.valueOf(valueToParse);
        }
        return datetimeToReturn;
    }

    private Id parseId(String valueToParse) {
        Id idToReturn;
        if (String.isNotBlank(valueToParse)) {
            idToReturn = Id.valueOf(valueToParse);
        }
        return idToReturn;
    }
}