Queueables are small jobs you can trigger asynchronously in your org. They are useful in many uses cases. For more information, read the part one of this article. 

This example will demonstrate how to create a small Queueable that will make a callout to an external service after the insertion of new contacts.

# 1. Setup
For this example, I created a brand new SFDX project. For more information about how to create and use SFDX, please visit this article I wrote about it. 

# 2. The code
Let's create our first Queueable. 

## Step 1: Create the apex class

Start by running this command in the terminal:
  
    sfdx force:apex:class:create -n 'Qable_ApiCall' -d 'force-app/main/default/classes'

That command will create a new Apex Class called 'Qable_ApiCall' and place it in the classes folder. As a personal standard, I always prefix my Queueable class with "Qable_", making it very easy to find them.

The new class should be pretty much empty and look like this:

    public with sharing class Qable_ApiCall 
    {
        public Qable_ApiCall () 
        {
        }
    }

## Step 2: Bare bone Queueable implementation

To implement the interface, update the class definition to make it look like this:

    public with sharing class Qable_ApiCall implements Queueable
    {
        public Qable_ApiCall()
        {
        }

        public void execute(QueueableContext context)
        {

        }
    }

The implements keyword in the class definition tells Salesforce that this class is in fact a Queueable. 

The execute method is required by the Queueable interface and is the method that will be called by the system when the Queueable execution starts.

## Step 3: Add some logic

The last step to make our Queueable class is by adding some logic in it. Our goal is to make a callout with the newly created contacts. 

To receive those contacts, we will add a new member in the Queueable class and assign that member from a parameter in the constructor.

    private List<Contact> createdContacts;

    public Qable_ApiCall(List<Contact> createdContacts)
    {
        this.createdContacts = createdContacts;
    }

And then update the execute method to make the callout using the data we received in the constructor.

    public void execute(QueueableContext context)
    {
        String payload = Json.serialize(createdContacts);

        Http client = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint('callout:ExternalService/');
        request.setBody(payload);
        request.setMethod('Post');
        client.send(request);
    }

## Step 4: Create the trigger

Create the trigger class by running the following command in your terminal: 

    sfdx force:apex:trigger:create -n 'Trigger_Contact' -d 'force-app/main/default/triggers'

That command will create a new Apex Trigger called 'ContactTrigger' and place it in the trigger folder. As a personal standard, I always prefix my Triggers with "Trigger_", making it very easy to find them.

The new class should be pretty much empty and look like this:

    trigger Trigger_Contact on SOBJECT (before insert)
    {
    }

The created trigger needs to be configured to our needs. Let's make it so he fires after the insertion of new contacts

    trigger Trigger_Contact on Contact (after insert) 
    {
    }

## Step 5: Hook things up

The last step is to finally hook everything up. 

Update the trigger so he creates a new Qable_ApiCall with the new Contacts and then schedule the execution of the Queueable.

    trigger Trigger_Contact on Contact (after insert)
    {
        List<Contact> contacts = ( List<Contact>)Trigger.New;
        Qable_ApiCall qable = new Qable_ApiCall(contacts);

        System.enqueueJob(qable);
    }
