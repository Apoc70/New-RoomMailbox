# New-TeamMailbox.ps1
Creates a new shared mailbox, security groups for full access and send-as permission and adds the security groups to the shared mailbox configuration.

## Description
This scripts creates a new shared mailbox (aka team mailbox) and security groups for full access and and send-as delegation. Security groups are created using a naming convention.

## Parameters
### TeamMailboxName
Name attribute of the new team mailbox

### TeamMailboxDisplayName
Display name attribute of the new team mailbox

### TeamMailboxAlias
Alias attribute of the new team mailbox

### TeamMailboxSmtpAddress
Primary SMTP address attribute the new team mailbox

### DepartmentPrefix
Department prefix for automatically generated security groups (optional)

### GroupFullAccessMembers
String array containing full access members

### GroupFullAccessMembers
String array containing send as members

## Examples
```
.\New-TeamMailbox.ps1 -TeamMailboxName "TM-Exchange Admins" -TeamMailboxDisplayName "Exchange Admins" -TeamMailboxAlias "TM-ExchangeAdmins" -TeamMailboxSmtpAddress "ExchangeAdmins@mcsmemail.de" -DepartmentPrefix "IT"
```
Create a new team mailbox, empty full access and empty send-as security groups


## TechNet Gallery
Find the script at TechNet Gallery
* https://gallery.technet.microsoft.com/Create-a-new-Mailbox-with-1b02f6e7

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