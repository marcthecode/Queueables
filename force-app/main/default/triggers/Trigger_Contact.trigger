trigger Trigger_Contact on Contact (after insert)
{
    List<Contact> contacts = (List<Contact>)Trigger.New;
    Qable_ApiCall qable = new Qable_ApiCall(contacts);

    System.enqueueJob(qable);
}