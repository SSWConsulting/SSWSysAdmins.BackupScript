param (   
    $UserName = $(throw "need username!")
)      

$service = \\flea\UserBackups\ztBackupScripts\get-webservice2.ps1 https://sswcom.sharepoint.com/SysAdmin/_vti_bin/lists.asmx?WSDL
$service.Url = "https://sswcom.sharepoint.com/SysAdmin/_vti_bin/lists.asmx"
$ListName = "Backup's - User Data"

# Does this Title exist already?
$query = [xml]"<Query><Where><Eq><FieldRef Name='Title' /><Value Type='Text'>$UserName</Value></Eq></Where></Query>"
$viewFields = [xml]"<ViewFields><FieldRef Name='ID' /></ViewFields>"
$queryOptions = [xml]"<QueryOptions><QueryOptions/></QueryOptions>"
$result = $service.GetListItems("Backup's - User Data", "", $query, $viewFields, 100, $queryOptions, "")
$foundID = $result.data.row | foreach { $_.ows_ID }


if (!$foundID)
{
    # Insert
    $item = @{Title = $UserName; LastRunDate=Get-Date -format "yyyy-MM-dd HH:mm:ss"}
    $result = \\flea\UserBackups\ztBackupScripts\invoke-listoperation.ps1 $service new $ListName $item
}
else
{
    # Update
    $item = @{ID = $foundID; Title = $UserName; LastRunDate=Get-Date -format "yyyy-MM-dd HH:mm:ss"}
    $result = \\flea\UserBackups\ztBackupScripts\invoke-listoperation.ps1 $service update $ListName $item
}

# http://msdn.microsoft.com/en-us/library/lists.lists.getlistitems.aspx
# http://www.novolocus.com/2009/05/08/updatelistitems-web-service-fails-when-using-item-level-permissions/