

Import-Module -Name AzureAD
Connect-AzureAD
Import-Module Exchangeonline
Connect-ExchangeOnline
Install-Module -Name ImportExcel

$Newusers= Import-Excel .\user.xlsm
$country = "AT"
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "password"

$LicensedUser = Get-AzureADUser -ObjectId "mailn@mail.com"    
$License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense 
$License.SkuId = $LicensedUser.AssignedLicenses.SkuId 
$Licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses 
$Licenses.AddLicenses = $License 
 
foreach($dummy in $Newusers){


New-AzureADUser -AccountEnabled $true -Companyname "Companyname" -UsageLocation $country -PasswordProfile $PasswordProfile -DisplayName $dummy.Displayname -UserPrincipalName $dummy.mail -GivenName $dummy.Vorname -Surname $dummy.Nachname -MailNickName $dummy.userid -Department $dummy.Abteilung


Set-AzureADUserLicense -ObjectId $dummy.mail -AssignedLicenses $Licenses

$refid = Get-AzureADUser -ObjectID $dummy.mail

if($dummy.mail -like "*mail.com"){
Add-AzureADGroupMember -ObjectId 1234-56-789-1011-1213141516 -RefObjectId $refid.ObjectId
}
if($dummy.mail -like "*mail.com"){
Add-AzureADGroupMember -ObjectId 1234-56-789-1011-1213141516 -RefObjectId $refid.ObjectId
}


}
