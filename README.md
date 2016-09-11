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
Describe any challenges encountered while building the app.
### Used struct and subscript operator to customize what to return when an item at a specified index of an array is about to return.

####Issue

I had `UserManager` class that had billRecords property of type `[[String:String]]`. When the property gets accessed, it go get `[[String:String]]` object in `NSUserDefault` and return it. `userManger.billRecords` returns an Array object that has `[billKey: bill, tipPercentKey: tipPercent, totalKey: total, dateKey, date]`. `UserManager` also had public static properties of key to dictionary.
In order for Client class of `UserManager` to get the dictionary value, it had to do like `userManager.billRecords[0][UserManager.billKey]`. This could cause the client class to put an invalid random key to a dictionary item from billRecords. Client class used to able to do like `billRecords[0]["invalidKey"]`.

```swift
class UserManger: NSObject {
	static let billKey = "billKey"
	static let tipPercentKey = "tipPercentKey"
	...
	
	var billRecords: [[String:String]] {
		get {
			return userDefault.objectForKey("billRecordsKey") as! [[String:String]]
		}
}

// In client of UserManger
let user = UserManager()
let billRecord = userManger!.billRecords[0]
let bill = billRecord[UserManager.billKey] // can be billRecord["invalidKey"]
```

####Challenge
In order to make a client class of UserManger not able to put random keys in a dictionary item in billRecords array, I made a model object called BillRecord to wrap the dictionary items in billRecords, and then try to make UserManager return a BillRecord object when BillRecords[index] is executed. With this way client class can get values that are used to in a dictionary with like `billRecord[index].bill` but not `billRecord[index]["key"]`. What I wanted to do is to make `billRecords` of type `[[String:String]]` return an object of type `BillRecord`.


```swift
class BillRecord: NSObject {
    // keys
    static let billRecordKey = "billRecord"
    static let tipPercentRecordKey = "tipPercentRecord"
    static let totalRecordKey = "totalRecord"
    static let dateRecordKey = "dateRecord"
    
    let bill: String?
    let tipPercent: String?
    let total: String?
    let date: String?
    
    override init() {
        bill = ""
        tipPercent = ""
        total = ""
        date = ""
        super.init()
    }
    
    // init with an item from [[String:String]]
    init(rawRecord: [String:String]) {
        self.bill = rawRecord[BillRecord.billRecordKey]
        self.tipPercent = rawRecord[BillRecord.tipPercentRecordKey]
        self.total = rawRecord[BillRecord.totalRecordKey]
        self.date = rawRecord[BillRecord.dateRecordKey]
    }
}
```
But getter in an Array type computed property can only return the whole array and I cannot specify what to do when an index is specified like billRecords[0].
`billRecords[0]` returns an object of type `[String:String]` and there is no way to make billRecords return BillRecord object by using an Array property.


####Solution
I used `struct` and `subscript` operator to make `billRecords[index]` return `BillRecord` object but not `[String:String]` object.
<a target="_blank" href="https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Subscripts.html">subscript</a> allows you to customize the behavior when an item at a specified index of collection object is about to return.

```swift
// UserManager.swift
struct BillRecords {
    
    let ud: NSUserDefaults?
    var count: Int
    
    init(ud: NSUserDefaults) {
        self.ud = ud
        if let records = ud.objectForKey(UserManager.recordKey) {
            let records = records as! [[String:String]]
            count = records.count
        } else {
            count = 0
        }
    }
    
    subscript (i: Int) -> BillRecord {
        mutating get {
            if let records = ud?.objectForKey(UserManager.recordKey) {
                let records = records as! [[String:String]]
                count = records.count
                return BillRecord(rawRecord: records[i])
            } else {
                let records: [[String:String]] = []
                count = records.count
                ud?.setObject(records, forKey: UserManager.recordKey)
                return BillRecord()
            }
        }
    }
}

// Client class of UserManager
let records = userManager.records
let record = records[0]
let bill = record.bill 
```

After making an instance of BillRecords a public property of UserManager,
`billRecords[index]` became able to return `BillRecord` object and then, client class can now get values by `billRecord.bill` without caring about the keys like `billRecord[UserManager.billKey]` as it used to be before. I give a least privilege to a client class of UserManger and the client class would never fail to get values from billRecord.


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
