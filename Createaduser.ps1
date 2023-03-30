import-module ActiveDirectory
Install-Module -Name ImportExcel
$Newusers= Import-Excel .\users.xlsm


$PasswordProfile = ConvertTo-SecureString -AsPlainText -Force "password"


foreach($dummy in $Newusers){

New-ADUser -SamAccountName $dummy.userid -UserPrincipalName $dummy.userid -DisplayName $dummy.Displayname -Name $dummy.Displayname -Surname $dummy.Nachname -GivenName $dummy.Vorname -Path "OU=OrganizationalUnit,OU=OrganizationalUnit,OU=OrganizationalUnit,DC=DomainController" -Description $dummy.BusinessUnit -Accountpassword $PasswordProfile -Enabled $true

}
