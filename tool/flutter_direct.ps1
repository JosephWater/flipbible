param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$FlutterArgs
)

$projectRoot = Split-Path -Parent $PSScriptRoot
$localPropertiesPath = Join-Path $projectRoot 'android\local.properties'

if (-not (Test-Path $localPropertiesPath)) {
    Write-Error "Could not find android/local.properties at $localPropertiesPath"
    exit 1
}

$flutterSdkLine = Get-Content $localPropertiesPath |
    Where-Object { $_ -like 'flutter.sdk=*' } |
    Select-Object -First 1

if (-not $flutterSdkLine) {
    Write-Error 'Could not resolve flutter.sdk from android/local.properties'
    exit 1
}

$flutterRoot = $flutterSdkLine.Substring('flutter.sdk='.Length).Replace('\\', '\')
$dart = Join-Path $flutterRoot 'bin\cache\dart-sdk\bin\dart.exe'
$snapshot = Join-Path $flutterRoot 'bin\cache\flutter_tools.snapshot'

if (-not (Test-Path $dart)) {
    Write-Error "Could not find Dart runtime at $dart"
    exit 1
}

if (-not (Test-Path $snapshot)) {
    Write-Error "Could not find flutter_tools snapshot at $snapshot"
    exit 1
}

& $dart $snapshot @FlutterArgs
exit $LASTEXITCODE
