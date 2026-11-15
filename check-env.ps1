# ============================================================
#  Java 学习环境体检脚本
#  用法：powershell -ExecutionPolicy Bypass -File check-env.ps1
#  作用：检查 JDK / Maven / Git / GitHub SSH / IDEA 是否装好、路径是否都在 D 盘
# ============================================================

$ErrorActionPreference = 'SilentlyContinue'
$results = New-Object System.Collections.ArrayList

function Add-Result {
    param([string]$Name, [bool]$Ok, [string]$Detail)
    [void]$results.Add([pscustomobject]@{ 检查项 = $Name; 结果 = $(if ($Ok) { 'OK' } else { 'FAIL' }); 详情 = $Detail })
}

function Get-VersionLine {
    param([string]$Exe, [string[]]$ArgList)
    $old = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $lines = & $Exe @ArgList 2>&1 | ForEach-Object { "$_" }
        return (($lines | Where-Object { $_.Trim() } | Select-Object -First 1) -as [string])
    } catch { return '' } finally { $ErrorActionPreference = $old }
}

function Get-VersionText {
    param([string]$Exe, [string[]]$ArgList)
    $old = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $lines = & $Exe @ArgList 2>&1 | ForEach-Object { "$_" }
        return ($lines -join "`n").Trim()
    } catch { return '' } finally { $ErrorActionPreference = $old }
}

Write-Host ''
Write-Host '===== Java 学习环境体检 =====' -ForegroundColor Cyan
Write-Host ''

# ---------- 1. 目录 ----------
$dev = 'D:\ai\deepseek\dev'
Add-Result '软件根目录 D:\ai\deepseek\dev' (Test-Path -LiteralPath $dev) $dev

# ---------- 2. JDK ----------
$javaHome = $env:JAVA_HOME
$jdkRootOk = $false
if ($javaHome -and (Test-Path -LiteralPath (Join-Path $javaHome 'bin\javac.exe'))) { $jdkRootOk = $true }
Add-Result 'JAVA_HOME 指向 JDK 根目录' $jdkRootOk $(if ($javaHome) { $javaHome } else { '未设置' })

$javaCmd = Get-Command java -ErrorAction SilentlyContinue
Add-Result 'PATH 里有 java' ([bool]$javaCmd) $(if ($javaCmd) { $javaCmd.Source } else { '找不到 java' })
if ($javaCmd) {
    $vt = Get-VersionText 'java' @('-version')
    $line = ($vt -split "`n" | Where-Object { $_ -match 'version' } | Select-Object -First 1)
    Add-Result 'java -version' ($vt -match '21\.\d+\.\d+') $line
}

$javacCmd = Get-Command javac -ErrorAction SilentlyContinue
Add-Result 'PATH 里有 javac' ([bool]$javacCmd) $(if ($javacCmd) { $javacCmd.Source } else { '找不到 javac' })

# ---------- 3. Maven ----------
$mvnHome = $env:MAVEN_HOME
Add-Result 'MAVEN_HOME 已设置' ([bool]$mvnHome -and (Test-Path -LiteralPath (Join-Path $mvnHome 'bin\mvn.cmd'))) $(if ($mvnHome) { $mvnHome } else { '未设置' })

$mvnCmd = Get-Command mvn -ErrorAction SilentlyContinue
Add-Result 'PATH 里有 mvn' ([bool]$mvnCmd) $(if ($mvnCmd) { $mvnCmd.Source } else { '找不到 mvn' })
if ($mvnCmd) {
    $vt = Get-VersionText 'mvn' @('-v')
    $line = ($vt -split "`n" | Where-Object { $_ -match 'Apache Maven' } | Select-Object -First 1)
    Add-Result 'mvn -v' ($vt -match 'Apache Maven') $line
}

if ($mvnHome) {
    $settings = Join-Path $mvnHome 'conf\settings.xml'
    $hasRepo = $false; $hasMirror = $false
    if (Test-Path -LiteralPath $settings) {
        $txt = Get-Content -LiteralPath $settings -Raw
        $hasRepo   = $txt -match '<localRepository>\s*D:'
        $hasMirror = $txt -match 'maven\.aliyun\.com'
    }
    Add-Result 'Maven 本地仓库在 D 盘' $hasRepo 'settings.xml 的 localRepository'
    Add-Result 'Maven 阿里云镜像' $hasMirror 'settings.xml 的 mirrors'
}

# ---------- 4. Git ----------
$gitCmd = Get-Command git -ErrorAction SilentlyContinue
Add-Result 'PATH 里有 git' ([bool]$gitCmd) $(if ($gitCmd) { $gitCmd.Source } else { '找不到 git' })
if ($gitCmd) {
    $vt = Get-VersionText 'git' @('--version')
    $line = ($vt -split "`n" | Where-Object { $_ -match 'git version' } | Select-Object -First 1)
    Add-Result 'git --version' ($vt -match 'git version') $line

    $name  = (& git config --global user.name 2>$null | Out-String).Trim()
    $email = (& git config --global user.email 2>$null | Out-String).Trim()
    Add-Result 'git 用户名已设置' ([bool]$name)  $(if ($name)  { $name }  else { '未设置 user.name' })
    Add-Result 'git 邮箱已设置'   ([bool]$email) $(if ($email) { $email } else { '未设置 user.email' })

    $branch = (& git config --global init.defaultBranch 2>$null | Out-String).Trim()
    Add-Result '默认分支 = main' ($branch -eq 'main') $(if ($branch) { $branch } else { '未设置 init.defaultBranch' })
}

# ---------- 5. SSH ----------
$key = 'D:\ai\deepseek\dev\ssh\id_ed25519'
Add-Result 'SSH 私钥存在' (Test-Path -LiteralPath $key) $key
Add-Result 'SSH 公钥存在' (Test-Path -LiteralPath "$key.pub") "$key.pub"
Add-Result 'GIT_SSH_COMMAND 已设置' ([bool]$env:GIT_SSH_COMMAND) $(if ($env:GIT_SSH_COMMAND) { '已设置' } else { '未设置' })

# ---------- 6. IDEA ----------
$ideaCandidates = @(
    'D:\ai\deepseek\dev\idea\bin\idea64.exe',
    'C:\Program Files\JetBrains'
)
$ideaOk = Test-Path -LiteralPath $ideaCandidates[0]
if (-not $ideaOk -and (Test-Path -LiteralPath $ideaCandidates[1])) {
    $ideaOk = [bool](Get-ChildItem -LiteralPath $ideaCandidates[1] -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like 'IntelliJ IDEA*' })
}
Add-Result 'IDEA 已安装' $ideaOk '查找 D:\ai\deepseek\dev\idea 或 C:\Program Files\JetBrains'
Add-Result 'IDEA 缓存已改到 D 盘' (Test-Path -LiteralPath 'D:\ai\deepseek\dev\idea-data') 'idea.properties 的 idea.system.path'

# ---------- 7. 代码目录 ----------
Add-Result '代码目录 java\' (Test-Path -LiteralPath 'D:\ai\deepseek\dsh-workplace\java') 'D:\ai\deepseek\dsh-workplace\java'

# ---------- 输出 ----------
$results | Format-Table -AutoSize | Out-String -Width 200 | Write-Host

$fail = @($results | Where-Object { $_.结果 -eq 'FAIL' }).Count
$total = $results.Count
Write-Host ("通过 {0}/{1}" -f ($total - $fail), $total) -ForegroundColor $(if ($fail -eq 0) { 'Green' } else { 'Yellow' })
if ($fail -eq 0) {
    Write-Host '全部通过：环境已就绪，可以进入第 1 阶段。把这张表截图发我。' -ForegroundColor Green
} else {
    Write-Host ("还有 {0} 项没通过。对照《00-环境搭建指南.md》第 7 节排查，或把上面 FAIL 的行发我。" -f $fail) -ForegroundColor Yellow
}
Write-Host ''
