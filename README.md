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
Computed variable
to subscript array I needed to make computed variable to struct and implement subscript
Trying to make functions without parameter to computed variable

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
