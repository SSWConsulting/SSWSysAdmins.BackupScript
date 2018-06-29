param (   
    $Service = $(throw "need service reference!"),   
    $Operation = $(throw "need operation: Update, Delete or New"),   
    $ListName = $(throw "need name of list."),     
    [hashtable]$Item = $(throw "need list item in hashtable format.")   
)    
  
# check if valid service reference provided   
[void][system.Reflection.Assembly]::LoadWithPartialName("system.web.services")   
if ($service -isnot [Web.Services.Protocols.SoapHttpClientProtocol]) {   
    Write-Warning "`$Service is not a webservice instance; exiting."  
    return  
}   
  
# check if valid operation (and fix casing)   
$Operation = [string]("Update","Delete","New" -like $Operation)   
if (-not $Operation) {   
    Write-Warning "`$Operation should be Update, Delete or New."  
    return  
}   
  
$xml = @"  
<Batch OnError='Continue' ListVersion='1' ViewName='{0}'>  
    <Method ID='1' Cmd='{1}'>{2}</Method>  
</Batch>  
"@   
  
if ($service) {   
    trap [Exception] {   
        Write-Warning "Error: $_"  
        return;        
    }   
       
    $listInfo = $service.GetListAndView($ListName, "")   
       
    $listItem = ""  
    foreach ($key in $item.Keys) {   
        $listItem += ("<Field Name='{0}'>{1}</Field>" -f $key,$item[$key])   
    }   
       
    $batch = [xml]($xml -f $listInfo.View.Name,$operation,$listItem)   
}   
  
$response = $service.UpdateListItems($listInfo.List.Name, $batch)   
  
$code = [int]$response.result.errorcode   
  
if ($code -ne 0) {   
    Write-Warning "Error $code - $($response.result.errormessage)"     
} else {   
    Write-Host "Success."  
    $response.Result   
}  