# Pre-work - *TipIt*

**TipIt** is a tip calculator application for iOS.

Submitted by: **Satoru Sasozaki**

Time spent: **30** hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [x] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

Tip View Controller

* [x] Add icons in the navigation bar and the split labels
* [x] Add labels that tells user the total amount split by 2-4 people
* [x] Add Save button in the navigation bar to save the current bill to history
* [x] Add an alert view when the save button is clicked

Setting View Controller

* [x] Add UISlider to change tip amounts
* [x] Add a switch to change the theme color
* [x] Add a cell to go to the history table view

* [x] Add history table view controller to show the bills that users have saved
* [x] Add detail view controller to show the selected bill in detail in history table view


## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/link/to/your/gif/file.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes
TL;TR
I used a struct and subscript operator to make an array of dictionary with type [[String : String]] to return a model object bound to a dictionary item.

Model object as a wrapper for BillRecords array of dictionary

UserManager and BillRecord class
Issue
- Client class could put unexpected random key into BillRecord dictionary to get values, which would cause unwanted nil.
The content of BillRecord was
[billKey: bill, tipPercentKey: tipPercent, totalKey: total, dateKey, date]

UserManager class used to have billRecords as a computed variable that returns [[String : String]] array of dictionary. The class also used to have public static key constants to the dictionary so that client of UserManager class can use them to get values from billRecords array.
Client class had to specify key like this billRecords[0][UserManger.billKey]. This could cause the client class to use invalid random key to a dictionary item from billRecords.

Challenge
- You cannot specify what to return from array with just a computed variable
I don’t want the above to happen, so tried to make a wrapper model object called BillRecord to wrap items from BillRecords, and then to make UserManager return BillRecord object when BillRecords[0] is executed.
but with a computed variable functionality, it is not possible for array to specify what to return in getter when index is specified. It can just return the whole array but not an item.

Solution
- Make it struct and use subscript operator
To make the above possible, I created the BillRecords as struct instead of an array variable and put subscript operator in it. With this way, I could specify for an array inside the struct what to return which in this case is BillRecord model object.
billRecords[0] returns billRecord object and then, client class can get values with billRecord.bill but not billRecord[UserManager.billKey]. I give a least privilege to a client class of UserManger and the client class would never fail to get values from billRecord.


## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
