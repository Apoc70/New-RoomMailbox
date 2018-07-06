<#
    Run-NewRoomMailbox.ps1

    Helper script to simplify the use of New-RoomMailbox.ps1
#>

$roomMailboxName = 'MB-Conference Room'
$roomMailboxDisplayName = 'Board Conference Room'
$roomMailboxAlias = 'MB-ConferenceRoom'
$roomMailboxSmtpAddress = 'ConferenceRoom@mcsmemail.de'
$departmentPrefix = 'C'
$groupFullAccessMembers = @('JohnDoe','JaneDoe')  # Empty = @()
$groupSendAsMembers = @()
$groupCalendarBookingMembers = @()
$RoomCapacity = 0
$RoomList = 'AllRoomsHQ'
$Language = 'en-GB'


.\New-RoomMailbox.ps1 -RoomMailboxName $roomMailboxName -RoomMailboxDisplayName $roomMailboxDisplayName -RoomMailboxAlias $roomMailboxAlias -RoomMailboxSmtpAddress $roomMailboxSmtpAddress -DepartmentPrefix $departmentPrefix -GroupFullAccessMembers $groupFullAccessMembers -GroupSendAsMembers $groupSendAsMember -Verbose -RoomCapacity $RoomCapacity -AutoAccept -RoomList $RoomList -Language $Language