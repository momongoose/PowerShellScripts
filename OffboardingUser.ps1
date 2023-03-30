<#
First you need to install all the dependencies just copy paste these in an admin ps Console
Find-PackageProvider -Name "NuGet" -AllVersions
Install-PackageProvider -Name "NuGet" -RequiredVersion "2.8.5.206" -Force
Install-Module -Name AzureAD
Install-Module -Name ExchangeOnlineManagement
Install-Module Microsoft.Graph
#>
#To establish connection
Connect-AzureAD
Connect-ExchangeOnline
#Error handling
$ErrorActionpreference = "silentlycontinue"
#Import Users from text
$path = Read-Host "Please enter the Filepath of the User-List"
[string[]]$users = Get-Content -Path $path
#for each Name in File loop
foreach($person in $users){
#here I get the Azure User
try { $user = Get-AzureADUser -SearchString $person }
catch { continue }
#here I set the Mailbox to a shared Mailbox
Set-Mailbox $user.Mail -Type Shared
#here I remove all Groups the User is in
$membership = Get-AzureADUserMembership -ObjectId $user.ObjectID
#Write-Output $membership
foreach($group in $membership)
{
Remove-DistributionGroupMember -Identity $group.ObjectId -Member $user.ObjectId
if ($error) {
   Remove-AzureADGroupMember -ObjectId $group.ObjectId -MemberId $user.ObjectId
   $error.clear()
}
}
#here I remove all the licenses from the User
$SKUs = @($user.AssignedLicenses)
if (!$SKUs) { Write-Verbose "No Licenses found for user $($user.UserPrincipalName), skipping..." ; continue }
 
$userLicenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
foreach ($SKU in $SKUs) {
$userLicenses.RemoveLicenses += $SKU.SkuId
}
 
Write-Verbose "Removing license(s) $($userLicenses.RemoveLicenses -join ",") from user $($user.UserPrincipalName)"
try {
Set-AzureADUserLicense -ObjectId $user.ObjectId -AssignedLicenses $userLicenses -ErrorAction Stop
}
catch {
if ($_.Exception.ErrorContent.Message.Value -eq "User license is inherited from a group membership and it cannot be removed directly from the user.") {
Write-Verbose "At least one of the user's licenses is assigned via group-based licensing feature, use the Azure AD blade to remove it"
continue
}
else {$_ | fl * -Force;} #catch-all for any unhandled errors
}
#here I set the Account to disabled
$manid = $user | Set-AzureADUser -AccountEnabled $false
}
