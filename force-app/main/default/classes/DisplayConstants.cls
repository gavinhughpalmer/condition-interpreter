/**
 * Created by admin-1019 on 13/06/2018.
 */

public with sharing class DisplayConstants {

    public static final Set<Schema.DisplayType> NUMBER_TYPES = new Set<DisplayType>{
        DisplayType.DOUBLE,
        DisplayType.CURRENCY,
        DisplayType.PERCENT,
        DisplayType.INTEGER
    };
    public static final Set<Schema.DisplayType> DATE_TYPES = new Set<DisplayType>{
        DisplayType.DATE,
        DisplayType.DATETIME
    };
    public static final Set<Schema.DisplayType> TEXT_TYPES = new Set<DisplayType>{
        DisplayType.TEXTAREA,
        DisplayType.PICKLIST,
        DisplayType.ADDRESS,
        DisplayType.BASE64,
        DisplayType.EMAIL,
        DisplayType.JSON,
        DisplayType.MULTIPICKLIST,
        DisplayType.STRING,
        DisplayType.URL
    };
    public static final Set<Schema.DisplayType> ID_TYPES = new Set<DisplayType>{
        DisplayType.ID,
        DisplayType.REFERENCE
    };
}