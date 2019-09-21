/*
    Queueable class need to implement the Queueable interface.
    My standard naming convention for a Queueable is to always starts the class name with 'Qable_'
*/
public with sharing class Qable_ApiCall implements Queueable
{
    /*
        Private list as a class member
    */
    private List<Contact> createdContacts;

    /*
        You can  receive any kind of object or SObject in the Queueable constructor
    */
    public Qable_ApiCall(List<Contact> createdContacts)
    {
        this.createdContacts = createdContacts;
    }

    /*
        Required method to implement the Queuable interface.
        This is called by the Sytem when the queueable execution starts.
    */
    public void execute(QueueableContext context)
    {
        String payload = Json.serialize(createdContacts);

        Http client = new Http();
        HttpRequest request = new HttpRequest();

        // Set the endpoint with a named credential.
        // See documentation for more information: https://help.salesforce.com/articleView?id=named_credentials_about.htm
        request.setEndpoint('callout:SG_Services/');
        request.setBody(payload);
        request.setMethod('Post');

        client.send(request);
    }
}
