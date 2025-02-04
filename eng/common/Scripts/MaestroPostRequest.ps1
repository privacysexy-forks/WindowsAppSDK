[CmdLetBinding()]
Param(
    [string]$url,
    [string]$token,
    [string]$api,
    [string]$jsonBodyPath,
    [string]$queryParameters = ''
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

$headers = @{
    Authorization="Bearer $token"
}

$body = ''
if (-not [string]::IsNullOrEmpty($jsonBodyPath))
{
  $body = Get-Content -Raw -Path $jsonBodyPath
}

$contentType = 'application/json'
$api = $api + '?api-version=2020-02-20' + $queryParameters
$fullUri = $url + $api

Write-Host $fullUri

$Response = Invoke-WebRequest -Method 'POST' -Uri $fullUri -Headers $headers -Body $body -ContentType $contentType -UseBasicParsing
Write-Host $Response

if ($Response.statuscode -lt '200')
{
  Write-Host $Response.statuscode
  Write-Host "##vso[task.complete result=Failed;]DONE"
}
if ($Response.statuscode -ge '300')
{
  Write-Host $Response.statuscode
  Write-Host "##vso[task.complete result=Failed;]DONE"
}

return $Response
