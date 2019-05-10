<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.157
	 Created on:   	4/8/2019 12:00 PM
	 Created by:   	PTA40889-a
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
#Password Generator

function Get-RandomPassword
{
	param (
		$length = 8,
		$characters =
		'abcdefghkmnprstuvwxyzABCDEFGHKLMNPRSTUVWXYZ123456789_#|$:~'
	)
	# select random characters
	$random = 1 .. $length | ForEach-Object { Get-Random -Maximum $characters.length }
	# output random pwd
	$private:ofs = ""
	[String]$characters[$random]
}

function Randomize-Text
{
	param (
		$text
	)
	$anzahl = $text.length - 1
	$indizes = Get-Random -InputObject (0 .. $anzahl) -Count $anzahl
	
	$private:ofs = ''
	[String]$text[$indizes]
}

function Get-ComplexPassword
{
	$password = Get-RandomPassword -length 3 -characters 'abcdefghiklmnprstuvwxyz'
	$password += Get-RandomPassword -length 2 -characters '123456789'
	$password += Get-RandomPassword -length 3 -characters 'ABCDEFGHKLMNPRSTUVWXYZ'
	
	Randomize-Text $password
	
	
}
function Begin-ComplexPassword
{
	$password += Get-RandomPassword -length 2 -characters 'ABCDEFGHKLMNPRSTUVWXYZabcdefghiklmnprstuvwxyz'
	Randomize-Text $password
}





#Create Window
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object system.Windows.Forms.Form
$Form.ClientSize = '500,350'
$Form.text = "Form"
$Form.TopMost = $false


#Buttons
$ADButton = New-Object system.Windows.Forms.Button
$ADButton.text = "ActiveDirectory"
$ADButton.width = 180
$ADButton.height = 30
$ADButton.location = New-Object System.Drawing.Point(5, 5)
$ADButton.Font = 'Microsoft Sans Serif,10'

$CMDButton = New-Object system.Windows.Forms.Button
$CMDButton.text = "CMD"
$CMDButton.width = 180
$CMDButton.height = 30
$CMDButton.location = New-Object System.Drawing.Point(5, 40)
$CMDButton.Font = 'Microsoft Sans Serif,10'

$SCCMButton = New-Object system.Windows.Forms.Button
$SCCMButton.text = "SCCM"
$SCCMButton.width = 180
$SCCMButton.height = 30
$SCCMButton.location = New-Object System.Drawing.Point(5, 75)
$SCCMButton.Font = 'Microsoft Sans Serif,10'

$ComPuterMGMTButton = New-Object system.Windows.Forms.Button
$ComPuterMGMTButton.text = "Computer Management"
$ComPuterMGMTButton.width = 180
$ComPuterMGMTButton.height = 30
$ComPuterMGMTButton.location = New-Object System.Drawing.Point(5, 110)
$ComPuterMGMTButton.Font = 'Microsoft Sans Serif,10'

$PasswordTextBox = New-Object System.Windows.Forms.MaskedTextBox
$PasswordTextBox.Location = New-Object System.Drawing.Size(5, 180)
$PasswordTextBox.PasswordChar = '*'
$PasswordTextBox.Size = New-Object System.Drawing.Size(260, 20)

$CopyPasswordButton = New-Object system.Windows.Forms.Button
$CopyPasswordButton.text = "Copy Password"
$CopyPasswordButton.width = 180
$CopyPasswordButton.height = 30
$CopyPasswordButton.location = New-Object System.Drawing.Point(265, 175)
$CopyPasswordButton.Font = 'Microsoft Sans Serif,10'

$LockoutToolbarButton = New-Object system.Windows.Forms.Button
$LockoutToolbarButton.text = "Lockout Toolbar"
$LockoutToolbarButton.width = 180
$LockoutToolbarButton.height = 30
$LockoutToolbarButton.location = New-Object System.Drawing.Point(195, 5)
$LockoutToolbarButton.Font = 'Microsoft Sans Serif,10'

$RandomPasswordButton = New-Object system.Windows.Forms.Button
$RandomPasswordButton.text = "Generate Password"
$RandomPasswordButton.width = 180
$RandomPasswordButton.height = 30
$RandomPasswordButton.location = New-Object System.Drawing.Point(195, 40)
$RandomPasswordButton.Font = 'Microsoft Sans Serif,10'

$RandomPasswordField = New-Object System.Windows.Forms.TextBox
$RandomPasswordField.text = ""
$RandomPasswordField.AutoSize = $True
$RandomPasswordField.width = 180
$RandomPasswordField.height = 30
$RandomPasswordField.location = New-Object System.Drawing.Point(195, 75)
$RandomPasswordField.Font = 'Microsoft Sans Serif,10'


$PasswordTimeStamp = New-Object system.Windows.Forms.Label
$PasswordTimeStamp.text = ""
$PasswordTimeStamp.AutoSize = $True
$PasswordTimeStamp.width = 350
$PasswordTimeStamp.height = 200
$PasswordTimeStamp.location = New-Object System.Drawing.Point(195, 110)
$PasswordTimeStamp.Font = 'Microsoft Sans Serif,10'


#Button Click
$ComPuterMGMTButton.Add_Click(
{Start-Process C:\Windows\System32\compmgmt.msc})

$ADButton.Add_Click(
	{mmc.exe c:\windows\system32\dsa.msc}
)

$CMDButton.Add_Click(
{ Start-Process cmd.exe})

$SCCMButton.Add_Click(
{ Start-Process "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\Microsoft.ConfigurationManagement.exe" })

$CopyPasswordButton.add_Click({
		$copyText = $PasswordTextBox.Text.Trim()
		[System.Windows.Forms.Clipboard]::SetText($copyText)
	})

$LockoutToolbarButton.Add_Click(
	{ Start-Process C:\LockoutStatus.exe })

$RandomPasswordButton.Add_Click({
		$DateStamp = Get-Date -Format u
		$randompass1 = Begin-ComplexPassword
		$randompass2 = Get-ComplexPassword
		$randompass = $randompass1 + $randompass2
		$RandomPasswordField.Text = "$randompass"
		$PasswordTimeStamp.text = "Generated on $DateStamp"
	})


$Form.controls.AddRange(@($CMDButton, $ADButton, $SCCMButton, $ComPuterMGMTButton, $PasswordTextBox, $CopyPasswordButton, $LockoutToolbarButton, $RandomPasswordButton, $RandomPasswordField, $PasswordTimeStamp))

$Form.ShowDialog() | Out-Null