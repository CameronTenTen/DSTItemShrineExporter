# DSTItemShrineExporter
Companion mod to the (DSTItemShrine)[CameronTenTen/DSTItemShrine] mod. This part of the mod is server only so that the scripts can be customised without the client needing a copy.  
This mod outputs a csv record of all the items submitted to the shrine to the mod folder (called itemlog by default).  
The administrator could run more complicated scoring systems either externally (as a spreadsheet), or by customising the script.  

### Configuration
Exporter Type - there are several preconfigured exporters
 - All = All items accepted and logged
 - Basic Food = Only food items are accepted, food related columns are recorded (e.g. hunger value)
 - Custom = Uses the "custom.lua" script

How to create a new outputter?
The `custom.lua` file has lots of comments on the things you have to implement and some of the available variables  
- AbleToAcceptTest
  - Test for if the shrine can be clicked on (e.g. pig king is sleeping)
- AcceptTest
  - Test for if the shrine can accept a specific item (e.g. pig king shakes head at some items)
- OnAccept
  - Called when the shrine takes an item from the player
- OnRefuse
  - Called when the shrine refuses an item (the accept test failed)

