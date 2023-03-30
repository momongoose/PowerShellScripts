[System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
[string]$sMySQLUserName = 'sMySQLUserName'
[string]$sMySQLPW = 'sMySQLPW'
[string]$sMySQLDB = 'sMySQLDB'
[string]$sMySQLHost = 'sMySQLHost'
[string]$sConnectionString = "server="+$sMySQLHost+";port=3306;uid=" + $sMySQLUserName + ";pwd=" + $sMySQLPW + ";database="+$sMySQLDB
$oConnection = New-Object MySql.Data.MySqlClient.MySqlConnection($sConnectionString)
$oMYSQLCommand = New-Object MySql.Data.MySqlClient.MySqlCommand
$oMYSQLDataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter
try
{
    $oConnection.Open()
}
catch
{
    write-warning ("Could not open a connection to Database $sMySQLDB on Host $sMySQLHost. Error: "+$Error[0].ToString())
}
$oMYSQLCommand.Connection=$oConnection
$oMYSQLDataSet = New-Object System.Data.DataSet 
$oMYSQLCommand.CommandText="SELECT username FROM table"
$oMYSQLDataAdapter.SelectCommand=$oMYSQLCommand
$iNumberOfDataSets=$oMYSQLDataAdapter.Fill($oMYSQLDataSet, "data")
foreach($oDataSet in $oMYSQLDataSet.tables[0])
{
     write-output "User:" $oDataSet.username
}
$oConnection.Close()