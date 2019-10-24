/**

 *
 * ProgramTestSelector
 * Test Selector for Programs__c objects
 */

public with sharing class ProgramTestSelector extends ProgramSelector {

    private static Integer POS = 0;
    public static void setPos(Integer p) {
        POS = p;
    }

    private static Map<SObjectField, Object> FIELDS = new Map<SObjectField, Object> {
            Programs__c.Id => 'a06C000001pVGTMIA4',
            Programs__c.ClientCode__c => 'm1',
            Programs__c.RCreconciled_Week__c => Date.newInstance(2019, 1, 7),
            Programs__c.Team__c => 'Team10'
    };
    private static List<Programs__c> PROGRAMS = new List<Programs__c> {
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'BounceTV - Local').toSObject(),
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'BounceTV').toSObject(),
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'EscapeTV').toSObject(),
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'GritTV').toSObject(),
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'Laff').toSObject(),
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'AntennaTV').toSObject(),
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'Justice Network').toSObject(),
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'ThisTV').toSObject(),
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'Stadium').toSObject(),
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'TeamOnyx')
                    .setField(Programs__c.Team__c, 'Onyx').toSObject(),
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'MLB').toSObject(),
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'NHL').toSObject(),
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'Newsy').toSObject(),
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'TVG').toSObject(),
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'MGM').toSObject(),
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'Quest').toSObject(),
            (Programs__c) new sfab_FabricatedSObject(Programs__c.class, FIELDS)
                    .setField(Programs__c.Name, 'Legally Blond 3: Revengence').toSObject()
    };

    public override List<Programs__c> GetPrograms(List<SObjectField> fields) {
        return new List<Programs__c> { PROGRAMS[POS] };
    }

    public override List<Programs__c> GetProgramsWithIds(List<String> Ids) {
        if (POS == 1337) {
            return new List<Programs__c>();
        }
        return this.GetPrograms(null);
    }


    private List<String> FieldsToStrings(List<SObjectField> fields) {
        List<String> result = new List<String>();
        for (SObjectField field : fields) {
            result.add(field.getDescribe().name);
        }
        return result;
    }
}