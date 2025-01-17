﻿#region Safety

#Safety net incase F5 is mistakenly used instead of F8
Start-Sleep -Seconds 1800

#endregion

#region Presentation Prep

#Begin demo on Win10-PowerShell101 (sign in as Mike)

#Set PowerShell ISE Zoom to 175%
$psISE.Options.Zoom = 175

<#
    Multiline Comment Example
    PowerShell 101
    Presentation from the Austin PowerShell User Group 2017
    Author:  Mike F Robbins
    Website: http://mikefrobbins.com
    Twitter: @mikefrobbins
#>

#Change error message color to yellow so errors are easier to read
$host.PrivateData.ErrorForegroundColor = 'Yellow'

#Cntl+M to contract / expand regions

#Begin presentation in the PowerShell console

#endregion

#region PowerShell Console

#Show why it's necessary to run PowerShell elevated
#which requires local admin privileges (attempt to
#start/stop a service) from a non-elevated session 

#F7 for history in the console (show it doesn't work with the PSReadLine module loaded)
#Unload and reload the PSReadLine module

#use the ise alias in the console to start the ISE
#endregion



#region Before you begin

#What version of PowerShell am I running?

#region Answer

$PSVersionTable
$PSVersionTable | Get-Member
$PSVersionTable.PSVersion

#If this doesn't work, you have PowerShell version 1 and need to update

#endregion

#Newer versions of PowerShell are distributed as part of the ____________?

#region Answer

    #Windows Management Framework (WMF)
    #A specific version of the .NET Framework is required depending on the WMF version
    #Full Version of the .NET Framework is required (The client version is not sufficient) 

#endregion

#Show the current execution policy
Get-ExecutionPolicy

#Try to run saved script

#Change execution policy to remote signed
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

#endregion

#region Discoverability

#Cmdlets are in the form or Singular Verb-Noun commands
#This makes the commands in PowerShell easily discoverable

#The three core cmdlets for figuring out PowerShell
#Get-Command
#Get-Help
#Get-Member

#Get-Command is designed to help you find commands
#Name is a parameter and 'Get-Command' is the value provided
Get-Help -Name 'Get-Command'

#Update-Help
#Save-Help -DestinationPath \\dc01\PSHelp
Update-Help -SourcePath \\dc01\PSHelp

#Get-Help helps you learn how to use commands once you find them
#Parameter Sets
#Syntax
Get-Help -Name 'Get-Command' -ShowWindow
Get-Command | Get-Random | Get-Help -ShowWindow

#Help is a function that pipes Get-Help to more.exe

#Get-Member helps you discover what objects (properties and methods) are available for commands
#Name which has been omitted is a positional parameter
#ShowWindow is a switch parameter
Get-Service | Get-Member

#Highlight a command and press F1 to open the help in ShowWindow
#Mandatory parameters
Get-EventLog
Get-EventLog -LogName 'Windows PowerShell' -Newest 3

#Best Practice: Avoid aliases and positional parameters in anything other than one-liners
#Use full cmdlet and parameter names in any code that you're sharing
Get-Alias -Definition Get-Command, Get-Member, help

#List the about help topics
help about_*
help about_Execution_Policies -ShowWindow

#Show-Command can make the transition from the GUI to PowerShell easier
Show-Command

#Highlight or put the cursor at the end of a command and then press Cntl + F1 to open it in Show-Command
Get-WindowsOptionalFeature
Get-WindowsOptionalFeature -FeatureName TelnetClient -Online

#To learn more about Get-Help, Get-Command, and Get-Member see the video from my
#PowerShell Fundamentals for Beginners Presentation from a couple of years ago:
#http://mikefrobbins.com/2013/03/21/florida-powershell-user-group-march-meeting-video-and-presentation-materials/

#endregion

#region The Pipeline

#Properties and Methods
Get-Service -Name W32Time
Get-Service -Name W32Time | Get-Member
Get-Service -Name W32Time | Format-List -Property *

#Sometimes you have to use force (the force parameter)
$profile
$profile | Format-List -Property *
$profile | Format-List -Property * -Force
$profile | Select-Object -Property *

#What cmdlets have parameters that accept ServiceController objects?
#This does NOT mean that they accept Service Controllers via the pipeline
Get-Command -ParameterType ServiceController

#Find out if Stop-Service accepts ServiceController objects via the pipeline
help Stop-Service -ShowWindow

#ByValue (ServiceController). Notice the WhatIf parameter
Get-Service -Name BITS, W32Time | Stop-Service -WhatIf

#Confirm parameter
Get-Service -Name BITS, W32Time | Stop-Service -Confirm

#ByValue (String)
'bits', 'w32time' | Get-Member
'bits', 'w32time' | Stop-Service -WhatIf

#ByPropertyName
$Object = New-Object -TypeName PSObject -Property @{'Name' = 'w32time', 'bits'}
$Object
$Object | Get-Member
$Object | Stop-Service -WhatIf

#PassThru parameter
Stop-Service -Name BITS

#Only items that produce output can be piped to Get-Member
Stop-Service -Name BITS | Get-Member

Stop-Service -Name BITS -PassThru
Stop-Service -Name BITS -PassThru | Get-Member

#Stop the Windows time service using the stop method
Get-Service w32time
(Get-Service w32time).Stop()
Get-Service w32time
(Get-Service w32time).Start()
Get-Service w32time

#endregion

#region Comparison Operators

#Comparison Operators
help about_Comparison_Operators -ShowWindow

#Equal
'powershell' -eq 'PowerShell'

#Equal - Case Sensitive
'powershell' -ceq 'PowerShell'

#Not Equal
'powershell' -ne 'PowerShell'

#Greater Than
6 -gt 4

#Less Than
6 -lt 4

#Like
'Windows PowerShell' -like '*PowerShell'

#Match
'Windows PowerShell' -match 'PowerShell'
'mike@.com' -match  "^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
'mike@me.com' -match  "^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"

[mailaddress]'mike@.com'
[mailaddress]'mike@me.com'

#Use the following to find type accelerators:
[psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::Get |
Sort-Object -Property Value

#Store the numbers 1 to 10 in the $Numbers array
$Numbers = 1..10
$Numbers

#Does the numbers array contain 628?
$Numbers -contains 15
$Numbers -contains 7

#Is 628 in $Numbers
15-in $Numbers
7 -in $Numbers

#Replace operator
'Windows PowerShell' -Replace 'Windows','Microsoft'

#Replace method
'Windows PowerShell'.Replace('windows','Microsoft')
'Windows PowerShell'.Replace('Windows','Microsoft')

[array]::Reverse($Numbers)
$Numbers
$Numbers -join ', '

#endregion