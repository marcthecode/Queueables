# Queueables
Queueables are small jobs you can trigger asynchronously in your org. They are useful in many uses cases. Here are a few that I use.

# 1. API communication
Your Salesforce Org probably has a lot of integrations with the rest of your ecosystem. 

Whether it's with the licensing system or with your marketing automation tool, you need to be able to communicate with external API's when some specific actions happens in your org. 

This is the perfect use case for queueables. Since they are asynchronous, you can use them to make an outbound call from a trigger.

In the org I work in, we have an outside marketing automation tool that needs to be notified when a checkbox values changes in the opportunity. We use a queueable to make that outbound call.

# 2. Prioritize work in triggers
In your trigger, it happens that you have some actions that are not as important as the rest. You can use queueables to make the trigger execution appear faster for the end user but still make those low priority action happen. 

In my org, we want to close all open task related to an opportunity when that opportunity is closed. I could execute that code in the trigger but since it's not required for any validation rule and nothing else really depends on those task being closed, I use a queueables to close them asynchronously.

# 3. Decouple triggers
It happens pretty often that you need to update another object after some conditions happens in one of your object trigger. With the help of queueables, you can make those updates in another context than your trigger, keeping the code clean and unaware of those other object it needs to update.

In my org, for example, we use a queueable to update a custom License object with the Contact information when a Lead is converted to a Contact. It keeps the concern of updating the related license outside the Lead Trigger, making it easier to understand what is going on with the Lead and keeping the responsibility of the Lead Trigger clean.

For the full article and more, please visit: https://www.marctheforce.com/post/queueables
