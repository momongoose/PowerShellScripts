<#iprange
$iprange = @()
$iprange = [System.Collections.ArrayList]::new()



for ($i=2; $i -le 254; $i= $i+1){



$ip1 = 'xx.xx.xx.' + $i



#[void]$iprange.add($ip1)
#[void]$iprange.add($ip2)
#}#>
#$jani= Import-Csv "path.csv"
#MySQL Verbindung Preload 
# Connect to the libaray MySQL.Data.dll
[System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
# Create a MySQL Database connection variable that qualifies:
# [Driver]@ConnectionString
# ============================================================
#  You can assign the connection string before using it or
#  while using it, which is what we do below by assigning
#  literal values for the following names:
#   - server=<ip_address> or 127.0.0.1 for localhost
#   - uid=<user_name>
#   - pwd=<password>
#   - database=<database_name>
# ============================================================
$janusliste = @()
$janusliste = [System.Collections.ArrayList]::new()
$iprange = 123..1234
[string]$sMySQLUserName = 'sMySQLUserName'
[string]$sMySQLPW = 'sMySQLPW'
[string]$sMySQLDB = 'sMySQLDB'
[string]$sMySQLHost = 'sMySQLHost'
[string]$sConnectionString = "server="+$sMySQLHost+";port=3306;uid=" + $sMySQLUserName + ";pwd=" + $sMySQLPW + ";database="+$sMySQLDB
Foreach ($ip in $iprange)
{
    $computer = "xx.xx.xx.$ip"
    $status = Test-Connection $computer -BufferSize 32 -count 1 -Quiet
    if ($status)
    {
        $janusliste.Add($computer)
    }
}
<#
connection to mysql 
Get-ChildItem -Path C:\ -Filter mysql.data.dll -Recurse -ErrorAction SilentlyContinue -Force 
[void][system.reflection.Assembly]::LoadFrom("C:\Program Files (x86)\MySQL\Connector NET 8.0\Assemblies\v4.8\MySql.Data.dll")
#>
$oConnection = New-Object MySql.Data.MySqlClient.MySqlConnection($sConnectionString)
$oMYSQLCommand = New-Object MySql.Data.MySqlClient.MySqlCommand
Foreach ($janus in $janusliste){
#Write-Output $janus
net use \\$janus pass$ /user:log
$item = (Get-Item "\\$janus\logs\*.txt" ).Basename
#Write-Output $item
Copy-Item -Path "\\$janus\logs\*" -Destination "\\ip\Protokolle\Analytik\MGI logs\$item" #-Credential $Cred
$files = Get-Item "\\ip\Protokolle\Analytik\MGI logs\$item\*.log"
$mgiNumber = ($item) -replace '\D+(\d+)','$1'
Foreach ($file in $files){
$Error.Clear()
try
{
    $oConnection.Open()
}
catch
{
    write-warning ("Could not open a connection to Database $sMySQLDB on Host $sMySQLHost. Error: "+$Error[0].ToString())
}
$oMYSQLCommand.Connection=$oConnection
$reader = [System.IO.File]::OpenText($file)
while($null -ne ($line = $reader.ReadLine())) {
    if($line -eq ""){continue}
    $time = $line.Substring($line.length -8)
    $date = $file.Name.Substring(0,10) + " " + $time
    [DateTime]$dateformat=get-date $date -Format 'yyyy-MM-dd HH:mm:ss'
    $Name = $line.Substring($line.IndexOf("root:") + 5, $line.IndexOf(" has") - 10)
    $val1 = $line.IndexOf("Plates:") + 8 
    $val2 = $line.IndexOf(" time") - $val1
    $plates = $line.Substring($val1, $val2).replace(" ","").Split(",")
    $p1a = $plates[0]
    $p1b = $plates[1]
    $p2a = $plates[2]
    $p2b = $plates[3]
    $p3a = $plates[4]
    $p3b = $plates[5]
    $p4a = $plates[6]
    $p4b = $plates[7]
    $oMYSQLCommand.CommandText="INSERT into table (`plate1a`,`plate1b`,`plate2a`,`plate2b`,`plate3a`,`plate3b`,`plate4a`,`plate4b`,name,`check_time`, `mgi`) VALUES('$p1a','$p1b','$p2a','$p2b','$p3a','$p3b','$p4a','$p4b','$Name','$date',$mgiNumber) ON DUPLICATE KEY UPDATE check_time=check_time;"
    $oMYSQLCommand.ExecuteNonQuery()
}
$oConnection.Close()
}
}