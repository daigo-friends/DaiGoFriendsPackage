# DaiGoFriendsPackage
DaiGo-Friends delphi DaiGoFriendsPackage

[English README](README.md)  
[日本語 README_JP](README_JP.md)

# About
This is the DaiGo-Friends components that can be used in the Delphi IDE.

Currently there are two components.
* StringsHolder  
* TableIniFile

# StringsHolder

This is a component that has only the Lines property.
Making long strings into constants or resources is tedious. TMemo Components cannot be placed in data modules.
So I created this component.
You can open the Lines property in the Object Inspector and edit the string.

See sample project for usage
 
# TableIniFile

This is an INIFILE component that uses a database table.  
See sample project for usage

# Installation

1. Open the DaiGoFriendsPackage project in the Delphi IDE
2. Open Tools -> Options and add the folder with DaiGoFriendsPackage.dproj to your library path
3. Right-click DaiGoFriendsPackage.bpl in the project window to build
4. Right-click DaiGoFriendsPackage.bpl in the project window to install

# License
Copyright (c) 2020 daigo-friends  
Released under the MIT license  
https://opensource.org/licenses/mit-license.php  
