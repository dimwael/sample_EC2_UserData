# Install IIS Features
Install-WindowsFeature Web-Server -IncludeManagementTools -IncludeAllSubFeature
# Enable Windows Optional Features
$features = @(
    "IIS-WebServerRole",
    "IIS-WebServer",
    "IIS-CommonHttpFeatures",
    "IIS-HttpErrors",
    "IIS-HttpRedirect",
    "IIS-ApplicationDevelopment",
    "NetFx4Extended-ASPNET45",
    "IIS-NetFxExtensibility45",
    "IIS-HealthAndDiagnostics",
    "IIS-HttpLogging",
    "IIS-LoggingLibraries",
    "IIS-RequestMonitor",
    "IIS-HttpTracing",
    "IIS-Security",
    "IIS-RequestFiltering",
    "IIS-Performance",
    "IIS-WebServerManagementTools",
    "IIS-IIS6ManagementCompatibility",
    "IIS-Metabase",
    "IIS-ManagementConsole",
    "IIS-BasicAuthentication",
    "IIS-WindowsAuthentication",
    "IIS-StaticContent",
    "IIS-DefaultDocument",
    "IIS-WebSockets",
    "IIS-ApplicationInit",
    "IIS-ISAPIExtensions",
    "IIS-ISAPIFilter",
    "IIS-HttpCompressionStatic",
    "IIS-ASPNET45"
)
foreach ($feature in $features) {
    Enable-WindowsOptionalFeature -Online -FeatureName $feature
}
# Remove existing contents in the web root directory
Remove-Item -Recurse C:\inetpub\wwwroot\*
# Download and extract files
$downloadUrl = "https://static.us-east-1.prod.workshops.aws/public/b2083843-9bc2-4f94-bf8e-c4f6238d04f4//static/common/ec2_web_hosting/ec2-windows.zip"
$downloadPath = "C:\inetpub\wwwroot\ec2-windows.zip"
(New-Object System.Net.WebClient).DownloadFile($downloadUrl, $downloadPath)
$shell = New-Object -ComObject Shell.Application
$zip = $shell.NameSpace($downloadPath)
foreach ($item in $zip.Items()) {
    $shell.Namespace("C:\inetpub\wwwroot\").CopyHere($item)
}
# Create a simple HTML file
$htmlContent = @"
<html>
<head>
    <title>Hi Wael, it works!</title>
</head>
<body>
    <h1>Hi Wael, it works!</h1>
</body>
</html>
"@
$htmlContent | Out-File -FilePath "C:\inetpub\wwwroot\index.html" -Encoding UTF8
# Start the IIS service
Start-Service W3SVC
# Set the IIS service to start automatically
Set-Service W3SVC -StartupType Automatic





