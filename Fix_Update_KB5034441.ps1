
$ModeAdmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
$NewLine =  "`n"

if (!$ModeAdmin) {
    Write-Host $NewLine'** Please check your permissions... **'
    Write-Host 'This script can only be run with elevated privileges (run as administrator).'$NewLine 
    break
}

Write-Host $NewLine'*** This script is based on the official Microsoft documentation:'
Write-Host 'KB5028997: Instructions to manually resize your partition to install the WinRE update'
Write-Host '[https://support.microsoft.com/en-us/topic/kb5028997-instructions-to-manually-resize-your-partition-to-install-the-winre-update-400faa27-9343-461c-ada9-24c8229763bf]'
Write-Host $NewLine $NewLine

$step1= Read-Host 'You want to start with the resize your partition? (y/n)'

if ($step1.ToLower() -ne 'y') {break}
Clear-Host
Write-Host $NewLine'>>> STEP 1:'
Write-Host '>>>> Check the WinRE status'
Write-Host '*** If the WinRE is installed, there should be a <<Windows RE location>> with a path to the WinRE directory' $NewLine
reagentc /info

Write-Host $NewLine'>>> STEP 2:'
Write-Host '>>>> Disable the WinRE'
Write-Host 'Temporarily disabled the WinRE...'
reagentc /disable
Write-Host 'Done!!!'

Write-Host $NewLine'>>> STEP 3:'
Write-Host '>>>> Shrinking the OS partition and preparing the disk for a new recovery partition...'
((@"
list disk
"@)|diskpart)

Write-Host $NewLine'*** In the next step select the correct disk, this should be the same disk index as WinRE.'$NewLine

$numDisk = Read-Host $NewLine'Please, select the OS disk (disk number: 0, 1, 2, ...)'
$selectDisk = 'sel disk ' + $numDisk 
((@"
$selectDisk
"@)|diskpart)

Clear-Host
Write-Host '*** In the next step select the correct partition, select the OS partition.'
((@"
$selectDisk
list part
"@)|diskpart)

$numPart = Read-Host $NewLine'Please, select the OS partition (partition number: 1, 2, 3, ...)'
$selectPart = 'sel part ' + $numPart 
((@"
$selectDisk
$selectPart
"@)|diskpart)

Write-Host 'Reserving space for the new partition...'
((@"
$selectDisk
$selectPart 
shrink desired=250 minimum=250
"@)|diskpart) 

Write-Host 'Done!!!'
Pause

<#  Showing the partition table of the selected disk again  #>
((@"
$selectDisk
list part
"@)|diskpart)

$numPartWRE = Read-Host $NewLine'Please, select the WinRE partition (recovery partition number)'
$selectPartWRE = 'sel part ' + $numPartWRE
((@"
$selectDisk
$selectPartWRE
delete partition override
"@)|diskpart)


Write-Host 'Partition'$numPartWRE' was deleted successfully.'
Pause
Clear-Host

Write-Host $NewLine'>>> STEP 4:'
Write-Host '>>>> Create a new recovery partition'

Write-Host $NewLine'First, we must check if the disk partition is a Partition Type GTP or MRB.'
((@"
list disk
"@)|diskpart)

Write-Host $NewLine
Write-Host '*** Check if there is an asterisk character (*) in the <<Gpt>> column.'
Write-Host '*** If there is an asterisk character (*), then the drive is GPT.'
Write-Host '*** Otherwise, the drive is MBR.' $NewLine

$typePart = Read-Host 'On <<Disk'$numDisk'>> there is a (*) in the <<Gtp>> column? (y/n)'

Write-Host $NewLine'Creating the new recovery partition...'
if ($typePart.ToLower() -eq 'y') {
    ((@"
    $selectDisk
    create partition primary id=de94bba4-06d1-4d40-a16a-bfd50179d6ac gpt attributes =0x8000000000000001
    format quick fs=ntfs label='Windows RE tools'
"@)|diskpart)
} else {
    ((@"
    $selectDisk
    create partition primary id=27
    format quick fs=ntfs label='Windows RE tools'
    set id=27
"@)|diskpart)
}

Write-Host $NewLine'Done, the WinRE partition was created!!!'
((@"
list vol
"@)|diskpart)

Pause
Clear-Host

Write-Host $NewLine'>>> STEP 5:'
Write-Host '>>>> Enable the WinRE'
Write-Host $NewLine'Enabling the WinRE...'
reagentc /enable
reagentc /info

Write-Host $NewLine'Finished the process!!!'
Write-Host $NewLine'Now manually install the KB5034441 update from Windows Update'
Write-Host $NewLine
