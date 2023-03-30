<#
Was macht das Tool?
Für alle Benutzer in der Offboarding Liste, welche Ihr selber erstellen könnt, gilt:
Das Tool disabled die User in der Liste
Das Tool verschiebt die User in inactive

Verwendung:
Ausführen mit Admin rechten und den Dateipfad der Namensliste eingeben :)
#>
#Import the AD module
import-module ActiveDirectory
#Import Users from text
$path = Read-Host "Please enter the Filepath of the User-List: "
[string[]]$users = Get-Content -Path $path
#for each Name in File loop
foreach($person in $users){
#set var firstname and lastname
$firstname = $person.split(" ")[0]
$lastname = $person.split(" ")[1]
#get Active Directory User, Disable and Move him
$aduser = Get-ADUser -Filter "Name -eq '$firstname $lastname'"
$aduser | Disable-ADAccount
Get-ADUser -Filter "Name -eq '$firstname $lastname'" | Move-ADObject -TargetPath "OU=OrganizationalUnit,DC=DomainController"
}