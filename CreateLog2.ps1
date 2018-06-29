$Logfile = "\\flea\UserBackups\ztBackupScripts\UserLogs.log"

Function LogWrite
{
   $username = $env:USERNAME
   
   $PcName = $env:computername

   $Stamp = (Get-Date).toString("dd/MM/yyyy HH:mm:ss")
   $Line = "$Stamp $PcName $Username"

   Add-content $Logfile -value $Line
}

LogWrite


