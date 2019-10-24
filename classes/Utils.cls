/**
 * Utils
 * @description Utility functions
 */

public class Utils {
    /**
   * @author Ryan Scott
   * @date 11/02/2015
   * @description Simple utility function that adds a leading zero to an integer to make it 2 digits.
   *   Used in this class for converting single digit month and day integers to 2 digits.
   * @param Integer i - Any integer value
   * @return String - String value of input integer with at least 2 digits. 8 -> '08'
   **/
    public static String padIntegerWithLeadingZero(Integer i) {
        if(i > 9) {
            return String.valueOf(i);
        } else {
            return '0' + String.valueOf(i);
        }
    }

    /**
    * @author Ryan Scott
    * @date 11/02/2015
    * @description Converts a specifically formatted timestring to military time. Expects the format outlined below,
    *   any other format will receive an error response.
    * @param String timeStr - String containing a time, examples: '11:00A' or '2:30P'
    * @return String - Time string in miliary format, examples: '11:00' or '14:30P'. An error is returned if the input
    *   could not be converted.
    **/
    public static String civilianToMilitaryTime(String timeStr) {
        try {
            if(timeStr == '12:00A') {
                return '00:00';
            } else if(timeStr.startsWith('12') && timeStr.endsWith('A')) {
                timeStr = timeStr.removeEnd('A');
                List<String> timePieces = timeStr.split(':');
                timeStr = '00:' + timePieces[1];
                return timeStr;
            } else if(timeStr == '12:00P') {
                return '12:00';
            } else if(timeStr.startsWith('12') && timeStr.endsWith('P')) {
                timeStr = timeStr.removeEnd('P');
                List<String> timePieces = timeStr.split(':');
                timeStr = '12:' + timePieces[1];
                return timeStr;
            } else if(timeStr.endsWith('A')) {
                return timeStr.removeEnd('A');
            } else {
                timeStr = timeStr.removeEnd('P');
                List<String> timePieces = timeStr.split(':');
                timeStr = String.valueOf(Integer.valueOf(timePieces[0]) + 12) + ':' + timePieces[1];
                return timeStr;
            }
        } catch(Exception e) {
            return 'Error: Invalid time string';
        }
    }

    /**
     * Retrieve a random string of supplied length
     *
     * @param length The requested length of the random String
     *
     * @return A randomly generated alphanumeric string (caps and non-caps)
     */
    public static String randomString(Integer length) {
        List<String> chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'.split('');
        String result = '';
        for (Integer x = 0; x < length; x++) {
            result += chars.get(randomBounds(0, chars.size()));
        }
        return result;
    }

    /**
     * @description Retrieve a random integer between two values
     *
     * @param min The minimum value (inclusive)
     * @param max The maximum value (exclusive)
     *
     * @return A randomly generated value between the supplied bounds
     */
    public static Integer randomBounds(Integer min, Integer max) {
        Integer rand = Math.round(Math.random() * 1000);
        return Math.mod(rand, max) + min;
    }

    /**
     * @description Helper method to retrieve an entry from a map with a supplied SObjectField,
     *  Or default to supplied default value
     *
     * @param fields The map of fields to be checked
     * @param field The field being accessed
     * @param defaultValue The default value to revert to
     *
     * @return The value of the field in the map, or the default supplied argument
     */
    public static Object getOrDefault(Map<SObjectField, Object> fields, SObjectField field, Object defaultValue) {
        if (fields.get(field) == null) {
            return defaultValue;
        } else {
            return fields.get(field);
        }
    }

    public static String generateRandomCallsign() {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < 3) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }
}