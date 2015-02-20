# KinveyTest
Testscript for adding new collection

Given Test case : 

Logged in to the Kinvey console and created an app, the left hand navigation should contain a link to "Data". 
Clicking on the link, you'll see "Files" in the top left with a dropdown arrow. 
Clicking on "Files" reveals a popup with a link to "Add Collection ...". 
That link takes to the "new collection" page.
Single input for a name, and a platform picker control.
After creation, you should be redirected to the collection's page ( a databrowser view). 
Collection names must start with a letter, and can only contain letters, numbers, and underscores. 
At least one platform should be selected.
 
Test script available in : https://github.com/GQKinvey/KinveyTest/blob/master/new-collection-test.coffee

Steps to Execute :
Copy and paste the new-collection-test.coffee into https://github.com/Kinvey/console/tree/master/tests/integration
Start the server
Execute the script http://localhost:4200/tests

 

