/**
 * FieldUpdater
 * @description
 */

public with sharing abstract class FieldUpdater {

    public Object oldData {get;set;}
    public Object newData {get;set;}

    public FieldUpdater() {}

    public virtual void ResetData() {
        newData = oldData;
    }

    public abstract Boolean Validate();

    public abstract void UpdateField();
}