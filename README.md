# New-RoomMailbox.ps1
Creates a new room mailbox, security groups for full access and send-as permission and adds the security groups to the room mailbox configuration.

## Description
This scripts creates a new room mailbox and security groups for full access and and send-as delegation. Security groups are created using a naming convention.

## Parameters
### RoomMailboxName
Name attribute of the new room mailbox

### RoomMailboxDisplayName
Display name attribute of the new room mailbox

### RoomMailboxAlias
Alias attribute of the new room mailbox

### RoomMailboxSmtpAddress
Primary SMTP address attribute the new room mailbox

### DepartmentPrefix
Department prefix for automatically generated security groups (optional)

### GroupFullAccessMembers
String array containing full access members

### GroupFullAccessMembers
String array containing send as members

## Examples
```
.\New-RoomMailbox.ps1 -RoomMailboxName "MB - Conference Room" -RoomMailboxDisplayName "Board Conference Room" -RoomMailboxAlias "MB-ConferenceRoom" -RoomMailboxSmtpAddress "ConferenceRoom@mcsmemail.de" -DepartmentPrefix "C"
```
reate a new room mailbox, empty full access and empty send-as security groups


## TechNet Gallery
Find the script at TechNet Gallery
* https://gallery.technet.microsoft.com/Create-a-new-Room-Mailbox-99a4e477

## Credits
Written by: Thomas Stensitzki

## Social

* About: http://www.stensitzki.de
* My Blog: http://justcantgetenough.granikos.eu
* Archived Blog: http://www.sf-tools.net/
* Twitter: https://twitter.com/stensitzki
* LinkedIn:	http://de.linkedin.com/in/thomasstensitzki
* Github: https://github.com/Apoc70

For more Office 365, Cloud Security and Exchange Server stuff checkout the services provided by Granikos

* Blog: http://blog.granikos.eu/
* Website: https://www.granikos.eu/en/
* Twitter: https://twitter.com/granikos_de