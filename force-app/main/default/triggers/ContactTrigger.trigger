/*
    Trigger class that will enqueue the Queueable.
    You normally can't make any callout from a trigger class, but with a Queueable it's now possible !
*/
trigger ContactTrigger on Contact (after insert)
{
    List<Contact> contacts = (List<Contact>)Trigger.new;
    Qable_ApiCall qable = new Qable_ApiCall(contacts);

    System.enqueueJob(qable);
}