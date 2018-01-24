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
$groupSendAsMember = @()
$groupCalendarBooking = @()
$RoomCapacity = 0
$RoomList = 'AllRoomsHQ'


.\New-RoomMailbox.ps1 -RoomMailboxName $roomMailboxName -RoomMailboxDisplayName $roomMailboxDisplayName -RoomMailboxAlias $roomMailboxAlias -RoomMailboxSmtpAddress $roomMailboxSmtpAddress -DepartmentPrefix $departmentPrefix -GroupFullAccessMembers $groupFullAccessMembers -GroupSendAsMember $groupSendAsMember -Verbose -RoomCapacity $RoomCapacity -AutoAccept -RoomList $RoomList