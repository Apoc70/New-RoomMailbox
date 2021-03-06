<# 
  .SYNOPSIS 
  Creates a new room mailbox, security groups for full access and send-as permission 
  and adds the security groups to the room mailbox configuration.

  Thomas Stensitzki 

  THIS CODE IS MADE AVAILABLE AS IS, WITHOUT WARRANTY OF ANY KIND. THE ENTIRE  
  RISK OF THE USE OR THE RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER. 

  Version 1.2, 2018-007-06

  Please send ideas, comments and suggestions to support@granikos.eu 

  .LINK 
  http://scripts.granikos.eu

  .DESCRIPTION 
  This scripts creates a new room mailbox and additonal security groups
  for full access and and send-as delegation. The security groups are created 
  using a confgurable naming convention.

  All required settings are stored in a separate settings.xml file
 
  .NOTES 
  Requirements 
  - Windows Server 2012 R2, Windows Server 2016 
  - Exchange 2013/2016 Management Shell (aka EMS)
    
  Revision History 
  -------------------------------------------------------------------------------- 
  1.0 Initial community release
  1.1 Some PowerShell hygiene, issue #2 closed
  1.2 CalendarBooking added, issue #1
   
  .PARAMETER RoomMailboxName
  Name attribute of the new room mailbox

  .PARAMETER RoomMailboxDisplayName
  Display name attribute of the new room mailbox

  .PARAMETER RoomMailboxAlias
  Alias attribute of the new room mailbox

  .PARAMETER RoomMailboxSmtpAddress
  Primary SMTP address attribute the new room mailbox

  .PARAMETER DepartmentPrefix
  Department prefix for automatically generated security groups (optional)

  .PARAMETER GroupFullAccessMembers
  String array containing full access members
    
  .PARAMETER GroupSendAsMembers
  String array containing send as members

  .PARAMETER GroupCalendarBookingMembers
  String array containing users having calendar booking rights

  .PARAMATER RoomCapacity
  Capacity of the room, this value will show in the Outlook room list

  .PARAMETER RoomPhoneNumber
  Phone number of a phone located in the room, this value will show in the Outlook room list

  .PARAMETER RoomList
  Add the new room mailbox to this existing room list

  .PARAMETER AutoAccept
  Set room mailbox to automatically accept booking requests

  .PARAMETER Language
  Locale setting for calendar regional configuration language, e.g. de-DE, en-US
  
  .EXAMPLE 
  Create a new room mailbox, empty full access and empty send-as security groups

  .\New-RoomMailbox.ps1 -RoomMailboxName "MB - Conference Room" -RoomMailboxDisplayName "Board Conference Room" -RoomMailboxAlias "MB-ConferenceRoom" -RoomMailboxSmtpAddress "ConferenceRoom@mcsmemail.de" -DepartmentPrefix "C"

  .EXAMPLE 
  Create a new room mailbox, empty full access and empty send-as security groups, and add room to room list "Building 1"

  .\New-RoomMailbox.ps1 -RoomMailboxName "MB - Conference Room" -RoomMailboxDisplayName "Board Conference Room" -RoomMailboxAlias "MP-ConferencRoom" -RoomMailboxSmtpAddress "ConferenceRoom@mcsmemail.de" -DepartmentPrefix "C" -RoomList 'Building 1'

#> 
param (
  [parameter(Mandatory,HelpMessage='Room Mailbox Name')]
  [string] $RoomMailboxName,
  [parameter(Mandatory,HelpMessage='Room Mailbox Display Name')]
  [string] $RoomMailboxDisplayName,
  [parameter(Mandatory,HelpMessage='Room Mailbox Alias')]
  [string] $RoomMailboxAlias,
  [string] $RoomMailboxSmtpAddress = '',
  [string] $DepartmentPrefix = '',
  [int] $RoomCapacity = 0,
  [string] $RoomList = '',
  [switch] $AutoAccept,
  [string]$Language = 'de-DE',
  [string[]] $GroupFullAccessMembers = @(''),
  [string[]] $GroupSendAsMembers = @(),
  # Added for issue #1
  [string[]] $GroupCalendarBookingMembers = @(),
  [string] $RoomPhoneNumber = '' 
)

# Script Path
$scriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Path

if(Test-Path -Path ('{0}\Settings.xml' -f $scriptPath)) {

    # Load Script settings
    [xml]$Config = Get-Content -Path ('{0}\Settings.xml' -f $scriptPath)
    
    Write-Verbose -Message 'Loading script settings'
    
    # Group settings
    $groupPrefix = $Config.Settings.GroupSettings.Prefix
    $groupSendAsSuffix = $Config.Settings.GroupSettings.SendAsSuffix
    $groupFullAccessSuffix = $Config.Settings.GroupSettings.FullAccessSuffix
    $groupCalendarBookingSuffix = $Config.Settings.GroupSettings.CalendarBookingSuffix
    $groupTargetOU = $Config.Settings.GroupSettings.TargetOU
    $groupDomain = $Config.Settings.GroupSettings.Domain
    $groupPrefixSeperator = $Config.Settings.GroupSettings.Seperator
    
    # Room mailbox settings
    $roomMailboxTargetOU = $Config.Settings.AccountSettings.TargetOU

    # General settings
    $sleepSeconds = $Config.Settings.GeneralSettings.Sleep

    Write-Verbose -Message 'Script settings loaded'    
}
else {
    Write-Error -Message 'Script settings file settings.xml missing'
    exit 99
}

# Add department prefix to group prefix, if configured
if($DepartmentPrefix -ne '') {
    # Change pattern as needed
    $groupPrefix = ('{0}{1}{2}' -f $groupPrefix, $DepartmentPrefix, $groupPrefixSeperator)
}

#region Mailbox stuff first

# Create room mailbox
Write-Verbose -Message ('New-Mailbox -Room -Name {0} -Alias {1}' -f $RoomMailboxName, $RoomMailboxAlias)

if ($RoomMailboxSmtpAddress -ne '') {
  $null = New-Mailbox -Room -Name $RoomMailboxName -Alias $RoomMailboxAlias -OrganizationalUnit $roomMailboxTargetOU -PrimarySmtpAddress $RoomMailboxSmtpAddress -DisplayName $RoomMailboxDisplayName
}
else {
  $null = New-Mailbox -Room -Name $RoomMailboxName -Alias $RoomMailboxAlias -OrganizationalUnit $roomMailboxTargetOU -DisplayName $RoomMailboxDisplayName
}

# Set phone number, if defined
if($RoomPhoneNumber -ne '') {
  Start-Sleep -Seconds $sleepSeconds
  
  $null = Set-User -Phone $RoomPhoneNumber
}

# Set room capacity, if defined
if($RoomCapacity -ne 0) {
  Start-Sleep -Seconds $sleepSeconds

  # Set room capacity 
  Write-Verbose -Message ('Setting room mailbox capacity to {0}' -f ($RoomCapacity))

  Set-Mailbox -Identity $RoomMailboxAlias -ResourceCapacity $RoomCapacity
}

# Configure calendar processing to autoaccept
if ($AutoAccept) {
  Start-Sleep -Seconds $sleepSeconds

  Write-Verbose -Message 'Setting caledar processing to AutoAccept'

  Set-CalendarProcessing -Identity $RoomMailboxAlias -AutomateProcessing AutoAccept
}

# Configure Language Regional Configuration
if($Language -ne '') {
  
  Write-Verbose -Message ('Setting calendar regional configuration language to {0}' -f $Language) 

  Set-MailboxRegionalConfiguration -Language $Language
}

# Add to room list
if ($RoomList -ne '') {
  Start-Sleep -Seconds $sleepSeconds

  Write-Verbose -Message ('Adding mailbox to room list {0}' -f ($RoomList))

  Add-DistributionGroupMember -Identity $RoomList -Member $RoomMailboxAlias
}

#endregion

#region FullAccess

# Create FullAccess group
$groupName = ('{0}{1}{2}' -f $groupPrefix, $RoomMailboxAlias, $groupFullAccessSuffix)
$notes = ('FullAccess for mailbox: {0}' -f $RoomMailboxName)
$primaryEmail = ('{0}@{1}' -f $groupName, $groupDomain)

Write-Host ('Creating new FullAccess Group: {0}' -f $groupName)

Write-Verbose -Message ('New-DistributionGroup -Name {0} -Type Security -OrganizationalUnit {1} -PrimarySmtpAddress {2}' -f $groupName, $groupTargetOU, $primaryEmail)

if(($GroupFullAccessMembers | Measure-Object).Count -ne 0) {

    Write-Host ('Creating FullAccess group and adding members: {0}' -f $groupName)

    $null = New-DistributionGroup -Name $groupName -Type Security -OrganizationalUnit $groupTargetOU -PrimarySmtpAddress $primaryEmail -Members $GroupFullAccessMembers -Notes $notes

    Start-Sleep -Seconds $sleepSeconds

}
else {

    Write-Host ('Creating empty FullAccess group: {0}' -f $groupName)

    $null = New-DistributionGroup -Name $groupName -Type Security -OrganizationalUnit $groupTargetOU -PrimarySmtpAddress $primaryEmail -Notes $notes

    Start-Sleep -Seconds $sleepSeconds
}

# Hide FullAccess group from GAL    
Set-DistributionGroup -Identity $primaryEmail -HiddenFromAddressListsEnabled $true

# Add FullAccess group to mailbox permissions

Write-Verbose -Message ('Add-MailboxPermission -Identity {0} -User {1}' -f $RoomMailboxName, $primaryEmail)

$null = Add-MailboxPermission -Identity $RoomMailboxName -User $primaryEmail -AccessRights FullAccess -InheritanceType all

#endregion

#region SendAs

# Create Send As group
$groupName = ('{0}{1}{2}' -f $groupPrefix, $RoomMailboxAlias, $groupSendAsSuffix)
$notes = ('SendAs for mailbox: {0}' -f $RoomMailboxName)
$primaryEmail = ('{0}@{1}' -f $groupName, $groupDomain)

Write-Host ('Creating new SendAs Group: {0}' -f $groupName)

Write-Verbose -Message ('New-DistributionGroup -Name {0} -Type Security -OrganizationalUnit {1} -PrimarySmtpAddress {2}' -f $groupName, $groupTargetOU, $primaryEmail)

if(($GroupSendAsMembers | Measure-Object).Count -ne 0) {

  Write-Host ('Creating SendAs group and adding members: {0}' -f $groupName)

  $null = New-DistributionGroup -Name $groupName -Type Security -OrganizationalUnit $groupTargetOU -PrimarySmtpAddress $primaryEmail -Members $GroupSendAsMembers -Notes $notes

  Start-Sleep -Seconds $sleepSeconds

}
else {

  Write-Host ('Creating empty SendAs group: {0}' -f $groupName)

  $null = New-DistributionGroup -Name $groupName -Type Security -OrganizationalUnit $groupTargetOU -PrimarySmtpAddress $primaryEmail -Notes $notes

  Start-Sleep -Seconds $sleepSeconds

}

# Hide SendAs from GAL
Set-DistributionGroup -Identity $primaryEmail -HiddenFromAddressListsEnabled $true

# Add SendAs permission
Write-Verbose -Message ('Add-ADPermission -Identity {0} -User {1}' -f $RoomMailboxName, $groupName)

$null = Add-ADPermission -Identity $RoomMailboxName -User $groupName -ExtendedRights 'Send-As'

#endregion

#region CalendarBooking

# Create CalendarBooking group
$groupName = ('{0}{1}{2}' -f $groupPrefix, $RoomMailboxAlias, $groupCalendarBookingSuffix)
$notes = ('CalendarBooking for mailbox: {0}' -f $RoomMailboxName)
$primaryEmail = ('{0}@{1}' -f $groupName, $groupDomain)

Write-Host ('Creating new CalendarBooking Group: {0}' -f $groupName)

Write-Verbose -Message ('New-DistributionGroup -Name {0} -Type Security -OrganizationalUnit {1} -PrimarySmtpAddress {2}' -f $groupName, $groupTargetOU, $primaryEmail)

if(($GroupCalendarBookingMembers | Measure-Object).Count -ne 0) {
  
  Write-Host ('Creating CalendarBooking group and adding members: {0}' -f $groupName)

  $null = New-DistributionGroup -Name $groupName -Type Security -OrganizationalUnit $groupTargetOU -PrimarySmtpAddress $primaryEmail -Members $GroupCalendarBookingMembers -Notes $notes

  Start-Sleep -Seconds $sleepSeconds

}
else {

  Write-Host ('Creating empty CalendarBooking group: {0}' -f $groupName)

  $null = New-DistributionGroup -Name $groupName -Type Security -OrganizationalUnit $groupTargetOU -PrimarySmtpAddress $primaryEmail -Notes $notes
}

# Hide CalendarBooking group from GAL
Set-DistributionGroup -Identity $primaryEmail -HiddenFromAddressListsEnabled $true

#endregion

Write-Host ('Script finished. Room mailbox {0} created.' -f $RoomMailboxName) 