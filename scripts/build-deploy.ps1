# E-Ticaret Portal - Derleme ve Tomcat Deploy
# Kullanım: .\scripts\build-deploy.ps1

$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$TomcatHome  = if ($env:CATALINA_HOME) { $env:CATALINA_HOME } else { "C:\tools\apache-tomcat-10.1.33" }
$ContextName = "odevweb"
$DeployDir   = Join-Path $TomcatHome "webapps\$ContextName"
$SrcJava     = Join-Path $ProjectRoot "src\com\ecommerce"
$WebSrc      = Join-Path $ProjectRoot "src\webapp"
$BuildDir    = Join-Path $ProjectRoot "build"
$ClassesOut  = Join-Path $ProjectRoot "out\classes"
$LibDir      = Join-Path $WebSrc "WEB-INF\lib"

Write-Host "=== E-Ticaret Build & Deploy ===" -ForegroundColor Cyan
Write-Host "Proje   : $ProjectRoot"
Write-Host "Tomcat  : $TomcatHome"
Write-Host "Deploy  : $DeployDir"

if (-not (Test-Path $TomcatHome)) {
    throw "Tomcat bulunamadi: $TomcatHome`nCATALINA_HOME ortam degiskenini ayarlayin."
}

if (-not (Test-Path $LibDir)) {
    throw "WEB-INF/lib bos. Once jar indirin: .\scripts\download-libs.ps1"
}

# Classpath: Tomcat servlet API + proje lib
$TomcatLibs = Join-Path $TomcatHome "lib\*.jar"
$ProjectLibs = Join-Path $LibDir "*.jar"
$CompileCp = ((Get-ChildItem $TomcatLibs, $ProjectLibs).FullName -join ";")

# Java kaynaklarini derle
Write-Host "`n[1/4] Java derleniyor..." -ForegroundColor Yellow
if (Test-Path $ClassesOut) { Remove-Item $ClassesOut -Recurse -Force }
New-Item -ItemType Directory -Force -Path $ClassesOut | Out-Null

$JavaFiles = Get-ChildItem -Path $SrcJava -Filter "*.java" -Recurse
if ($JavaFiles.Count -eq 0) { throw "Java kaynak dosyasi bulunamadi." }

javac -encoding UTF-8 -d $ClassesOut -cp $CompileCp ($JavaFiles.FullName)
if ($LASTEXITCODE -ne 0) { throw "Derleme basarisiz." }
Write-Host "  $($JavaFiles.Count) dosya derlendi." -ForegroundColor Green

# Build dizinine webapp + derlenmis siniflari birlestir
Write-Host "`n[2/4] WAR icerigi hazirlaniyor..." -ForegroundColor Yellow
if (Test-Path $BuildDir) { Remove-Item $BuildDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null
Copy-Item -Path (Join-Path $WebSrc "*") -Destination $BuildDir -Recurse -Force
$DestClasses = Join-Path $BuildDir "WEB-INF\classes"
New-Item -ItemType Directory -Force -Path $DestClasses | Out-Null
Copy-Item -Path "$ClassesOut\*" -Destination $DestClasses -Recurse -Force

# Tomcat'e deploy
Write-Host "`n[3/4] Tomcat'e deploy ediliyor..." -ForegroundColor Yellow
if (Test-Path $DeployDir) {
    Remove-Item $DeployDir -Recurse -Force
}
Copy-Item -Path $BuildDir -Destination $DeployDir -Recurse -Force
Write-Host "  -> $DeployDir" -ForegroundColor Green

# Tomcat yeniden baslat (varsa durdur)
Write-Host "`n[4/4] Tomcat yeniden baslatiliyor..." -ForegroundColor Yellow
if (-not $env:JAVA_HOME) {
    $javaCmd = (Get-Command java -ErrorAction SilentlyContinue).Source
    if ($javaCmd) {
        $env:JAVA_HOME = (Get-Item $javaCmd).Directory.Parent.FullName
        Write-Host "  JAVA_HOME = $($env:JAVA_HOME)" -ForegroundColor Gray
    }
}
$env:CATALINA_HOME = $TomcatHome
$env:CATALINA_BASE = $TomcatHome
$Shutdown = Join-Path $TomcatHome "bin\shutdown.bat"
$Startup  = Join-Path $TomcatHome "bin\startup.bat"

& cmd /c "`"$Shutdown`"" 2>$null
Start-Sleep -Seconds 4
Start-Process -FilePath "cmd.exe" -ArgumentList "/c", "`"$Startup`"" -WindowStyle Minimized
Start-Sleep -Seconds 12

$url = "http://localhost:8080/$ContextName/home"
Write-Host "`n=== TAMAMLANDI ===" -ForegroundColor Green
Write-Host "Uygulama: $url"
Write-Host "Admin   : http://localhost:8080/$ContextName/login (admin@ecommerce.com / admin123)"

# Baglanti testi
try {
    $r = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 15
    if ($r.StatusCode -eq 200) {
        Write-Host "`nHTTP 200 - Uygulama calisiyor!" -ForegroundColor Green
    }
} catch {
    Write-Host "`nUyari: Sayfa henuz hazir olmayabilir, 10 sn sonra tekrar deneyin: $url" -ForegroundColor Yellow
}
