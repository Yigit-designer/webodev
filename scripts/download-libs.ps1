# PostgreSQL JDBC + JSTL (Jakarta) kutuphanelerini indirir
$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$LibDir = Join-Path $ProjectRoot "src\webapp\WEB-INF\lib"
$RootLib = Join-Path $ProjectRoot "lib"
New-Item -ItemType Directory -Force -Path $LibDir, $RootLib | Out-Null

$jars = @(
    @{ Url = "https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.4/postgresql-42.7.4.jar"; Name = "postgresql-42.7.4.jar" },
    @{ Url = "https://repo1.maven.org/maven2/jakarta/servlet/jsp/jstl/jakarta.servlet.jsp.jstl-api/3.0.0/jakarta.servlet.jsp.jstl-api-3.0.0.jar"; Name = "jakarta.servlet.jsp.jstl-api-3.0.0.jar" },
    @{ Url = "https://repo1.maven.org/maven2/org/glassfish/web/jakarta.servlet.jsp.jstl/3.0.1/jakarta.servlet.jsp.jstl-3.0.1.jar"; Name = "jakarta.servlet.jsp.jstl-3.0.1.jar" }
)

foreach ($j in $jars) {
    $dest = Join-Path $LibDir $j.Name
    Write-Host "Indiriliyor: $($j.Name)"
    Invoke-WebRequest -Uri $j.Url -OutFile $dest -UseBasicParsing
    Copy-Item $dest (Join-Path $RootLib $j.Name) -Force
}

Write-Host "`nKutuphaneler hazir:" -ForegroundColor Green
Get-ChildItem $LibDir | Format-Table Name, @{N='KB';E={[math]::Round($_.Length/1KB,1)}}
