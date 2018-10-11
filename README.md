Practice 4: Firebase

Welcome to project four. In this project we will be building off of the project we made last time to incorporate Firebase into our project. What we are going to do is
1. Set up a database online for our app.
2. Include the Firebase library into our app.
3. Write our code for communicating with the database.




The first thing to do is go to firebase.google.com. Click on Get Started, make sure you are logged in, then you can click the Add Project button. Enter the name of your project, accept the options, and create it.

When you get to the main page for your project, click on the Database option on the side bar, and create a new cloud Firestore database. When it gives you the option, select test mode for now.

If you are familiar with SQL databases, you may be a bit surprised. If you are not familiar with any databases, you may still be surprised by what you see. Firestore uses a database structure called "Document-Model Database", which saves your data in a large JSON tree made of Collections and Documents.

At the top layer, you see a collection. A collection is a grouping of document items. In a relational database like a SQL database, collections are similar to tables where you store a list of all of your data. A document, similar to a row in SQL, is where you save all of the information for a single item. One interesting things about Firestore is that documents can also contain sub collections. That results in you potentially having large chains like this in your database.


Try playing around in the Firestore console and get a feel for what can be saved with Google. You may also notice that Firestore provides features for Storage(pictures) and Authentication for creating users. We won't get into creating users in this tutorial, but projects that you will work on in the future might. If you added picture handlind into your app in the last project, you will need to worry about file storage on Firebase. Click on Storage and follow the setup until you get to a page that shows an empty table and an upload button. Next Click on the Rules tab of this page. Since we are not having users in this app, you need to edit the Rules to allow anyone to upload pictures. 



Now click on the Project Overview button on the left menu, and we will move on to the second part of this tutorial: adding Firestore to our app.

When you are on this home page, click on the iOS icon so we can set up our app. To find your iOS bundle ID, open up Xcode. On the top of the heirarchy on the left menu in Xcode, you will see a blue icon with the name of your project beside it. Click on that and it will bring you to a page that shows your Bundle Identifier. Copy that and paste it into the Firestore registration page. Name the app if you want to, then click next and download the configuration file. Once it is downloaded, drag it over into your xcode project.

Now we will install the Firebase Cocoa Pod. Cocoa Pods, or pods, are dependencies that you can add to your app to use code that others have already written for you. We will go over that more in the next tutorial.

To create the pod file to use Firebase, you need to open the terminal app and navigate to the directory where the project is saved. To help you get there, here are some useful commands:
'pwd'    This command shows you the current directory path you are in.
'cd'     This is how you add a folder to the path you are currently in.
'ls'     Lists all of the files you are in.
'cd ..'  Moves you back to the parent folder.


These are the commands that were used in this project to get add Firebase to our project.

When you type vim, this is what you need to have typed in before you run 'pod install'

Now open up your Finder app and go back to the folder where you saved this project. You will see some new files. Importantly there will be a file that ends in .xcworkspace. This is the new file that you will use to run your app. Click on it and it should open in XCode.



Going back to Firestore's registration, click the next button and look at step 4: 'Add Initialization code'. Click on the file 'AppDelegate.swift' and add that code to the method called 'didFinishLaunchingWithOptions', similar to what Firebase says.

Run the app and click next on the firebase tutorial and see if it connects.It may take a little longer to build becaue it has to install all of the Google code. If the app crashes, make sure that you have moved the GoogleService-Info.plist into your app. Once it runs, Firebase should tell you that you are connected, and we can now move on to implementing our code.

We need to add a few more pods into our Podfile to get started. Add these pods:
  pod 'Firebase/Storage'
  pod 'Firebase/Firestore'
Make sure you run 'pod install' again to include the new files


Now there are 4 things that we are going to do in our app to let our FoodEvent program connect with Firebase and look decent to the user. First, we need to do some prep work. One of the nice but challenging things about Firebase is that any call to its server is asyncronous. That means that our program will not wait for Firebase to give us back the information before it continues to run. Why is that good? Well, that means that our App does not freeze while we wait for the data from the server. What happens if the user has a bad internet connection? Should the app be frozen for 15 minutes while it waits? Certainly not. We will talk more later about how we handle updating our app after Firebase gives us information, but first we need to do a little protection of our data. 

If you are familiar with what a Race Condition is, great! We are going to create an atomic variable to fix that. If you are not familiar with Race Conditions, a Race Conditions is something that can happen when you have multiple threads running asyncronous code. Watch this video to get a quick idea of what a race condition is.

https://www.youtube.com/watch?v=8zyYjlaEY1k

What you see is that there are multiple people (processes) who need that shared information (the cookies). But since they do not eat the cookies at the same time, the first person is unaware that all of his cookies were gone. That is the simple idea behind a race condition. 


To fix that, we create this class called an Atomic Counter. What it does is it has an integer that we will use to track progress. The queue.sync() method protects us so that only one process can read/write to it at a time. If some other process needs it, it will have to join the queue. 



Now that we have our AtomicCounter made, lets set up our Database class. Create a new swift file and name it DatabaseManager.swift. Add the code below. The init method simply starts up the connections to Firestore and its Storage feature.

Below we have the create method for events.

1. In section 'A', we upload our file to the database. Because we cant save images in Firestore, we must upload them to Firebase Storage. We create a name for our image, then call our method uploadImageWithFilename(). 
2. When that finishes, we get to section 'B' where we tell Firestore to add a document to the collection called 'Events'. 
3. In section 'C', we create the data that will be uploaded. We create it using a key value pair of the form ["Key":Any]. That means that the key for the data is a string, but the actual data may be any type we want. So it could be "Number":36, or "Date":Date(). 
4. In section 'D', we check for an error and give the error to our onDone function. This is a function that is created then given to us to run once we are done.

Below we have the get method for the events.

1. In section 'A', we create the request to the database. We look for a collection called 'Events' and get the documents which are returned in querySnapshot as well as an error if there is one. 
2. In section 'B', we create a for loop to iterate through all of the documents that were returned from the server. We also create an Atomic Counter that will let us know when we have everything downloaded.
3. In section 'C', we look at a document and try to turn it into an Event class. If you look at the Event model, you see that it has a name and an image. So in our database method, we need to get the name of the event and the image name. 
4. In section 'D', we take the file name and call our database method to download the image. Once it is complete, we turn the name and the image into an Event object.
5. In section 'E', we increment the counter. If the counter's value is equal to the number of documents returned from the database, we know we are done.

Now that you have this example, try to create the get and create database methods for the restaurant. 
Tips:
1. You do not need to have the collection created before hand. If it does not exist, Google will make it for you.
2. To know what to upload to the server, look at the Restaurant model. It has everything needed there.



Now we are going to jump back into the DataManager. Look below at the four methods we have. You will see two that add events/restaurants to the database and two that get them from the database. Look at two things. One, we create a private let dbm = DatabaseManager at the top of the file. That creates an instance of our DatabaseManager for us to use. We call it private because we only want to be able to access it in the DataManager class. Two look at how we use the OnDone functions: we have them in the method headers and we use them in the method themselves. 




The third thing that we need to do is to implement the add code into our app. This is pretty easy and looks like this.



Lastly, we need to make sure that our code is actually loading the data from Firestore. We will create a simple little loading screen to set this up for us. Create a new View controller in the storyboard, set it as the initial and drag a label onto it so the user knows it is a loading screen. Next create a segue between the loading view controller and the tab bar controller and give it a title of "FinishLoading".


Now create a new ViewController file for it, name it LoadingViewController and add this code. This will cause the app to wait on this loading screen, then call the segue to the rest of the app once it is done loading.




Congrats, you have finished Tutorial 4. If you have any questions, let us know, and we are more than willing to help!
