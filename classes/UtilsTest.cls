/**
 * UtilsTest
 * @description Tests for the Utils class
 */

@IsTest
private class UtilsTest {
    @isTest static void Utils_civilianToMilitaryTime() {
        System.assert(Utils.civilianToMilitaryTime('10:00A').equals('10:00'));
        System.assert(Utils.civilianToMilitaryTime('12A').equals('Error: Invalid time string'));
        System.assert(Utils.civilianToMilitaryTime('12:05A').equals('00:05'));
        System.assert(Utils.civilianToMilitaryTime('12:00A').equals('00:00'));
        System.assert(Utils.civilianToMilitaryTime('12:00P').equals('12:00'));
        System.assert(Utils.civilianToMilitaryTime('12:15P').equals('12:15'));
        System.assert(Utils.civilianToMilitaryTime('10:00P').equals('22:00'));
        System.assert(Utils.civilianToMilitaryTime('13:00A').equals('13:00'));
        System.assert(Utils.civilianToMilitaryTime('13:00P').equals('25:00'));
        System.assert(Utils.civilianToMilitaryTime('25:00P').equals('37:00'));
        System.assert(Utils.civilianToMilitaryTime('P').equals('Error: Invalid time string'));
        System.assert(Utils.civilianToMilitaryTime('A').equals(''));
        System.assert(Utils.civilianToMilitaryTime(':').equals('Error: Invalid time string'));
        System.assert(Utils.civilianToMilitaryTime('iuhwergoihe').equals('Error: Invalid time string'));
    }
}