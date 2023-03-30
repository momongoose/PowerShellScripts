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
#Connect-ExchangeOnline
#$ErrorActionpreference = "silentlycontinue"
$s1 = Get-Content -Path ".\1.txt" 
$s2 = Get-Content -Path ".\2.txt"
$s3 = Get-Content -Path ".\3.txt"
#[string[]]$1 = Get-DistributionGroupMember -Identity "1"
#[string[]]$2 = Get-DistributionGroupMember -Identity "2"
#[string[]]$3 = Get-DistributionGroupMember -Identity "3"
$test =  Get-ADGroup -filter { Name -eq "2" } | Get-ADGroupMember | select Name
[string[]]$missing1
[string[]]$missing2
[string[]]$missing3
rite-Output "------------------------------"
foreach($person in $1){
$per = $person.ToLower()
if($s1 -contains $per){
continue
} else {
$missing1.Add($per)
}
}
Write-Output $1
Write-Output "------------------------------"
foreach($person in $2){
$per = $person.ToLower()
if($s2 -contains $per){
continue
} else {
$missing2.Add($per)
}
}
Write-Output $2
Write-Output "------------------------------"
foreach($person in $3){
$per = $person.ToLower()
if($s3 -contains $per){
Write-Output $per
continue
} else {
$missing3.Add($per)
}
}
Write-Output $3
Write-Output "------------------------------"
$a = Get-DistributionGroup
Write-Output $test