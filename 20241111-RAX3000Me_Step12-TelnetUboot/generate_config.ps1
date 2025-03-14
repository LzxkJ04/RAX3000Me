# 日志文件路径
$LOG_FILE = Join-Path (Get-Location) "generate_config.log"

# 记录日志函数
function Log-Message {
    param (
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $Message"
    #Write-Output $logEntry
    Add-Content -Path $LOG_FILE -Value $logEntry
}

# 检查 OpenSSL 是否安装
function Check-OpenSSL {
    $opensslPath = "C:\Program Files\OpenSSL-Win64\bin\openssl.exe"
    if (-not (Test-Path $opensslPath)) {
        Log-Message "OpenSSL not found at: $opensslPath"
        Log-Message "Please install OpenSSL and ensure it is available in the specified path."
        Write-Output "OpenSSL not found at: $opensslPath"
        Write-Output "Please install OpenSSL and ensure it is available in the specified path."
        exit 1
    }
    Log-Message "OpenSSL found at: $opensslPath"
    Write-Output "OpenSSL found at: $opensslPath"
}

# 生成密码函数
function Generate-Password {
    param (
        [string]$SN
    )
    $salt = "aV6dW8bD"
    try {
        $mypassword = & "C:\Program Files\OpenSSL-Win64\bin\openssl.exe" passwd -1 -salt $salt $SN
        Log-Message "Password generated successfully."
        return $mypassword
    } catch {
        Log-Message "Failed to generate password! Error: $_"
        exit 1
    }
}

# 生成配置文件函数
function Generate-Config {
    param (
        [string]$Password,
        [string]$SN
    )
    # 设置文件路径
    $IMPORT_FILE = Join-Path (Get-Location) "RAX3000M_XR30_cfg-telnet-20240117.conf"
    $EXPORT_FILE = Join-Path (Get-Location) "cfg_import_config_file_new.conf"

    # 检查配置文件是否存在
    if (-not (Test-Path $IMPORT_FILE)) {
        Log-Message "Configuration file not found: $IMPORT_FILE"
        Write-Output "Configuration file not found: $IMPORT_FILE"
        exit 1
    }
    Log-Message "Using existing configuration file: $IMPORT_FILE"
    Write-Output "Using existing configuration file: $IMPORT_FILE"

    # 清理旧的加密文件
    if (Test-Path $EXPORT_FILE) {
        Remove-Item -Path $EXPORT_FILE -Force
        Log-Message "Deleted old encrypted file: $EXPORT_FILE"
    }

    # 使用 OpenSSL 加密文件
    try {
        Log-Message "Encrypting configuration file..."
        & "C:\Program Files\OpenSSL-Win64\bin\openssl.exe" aes-256-cbc -pbkdf2 -k $Password -in $IMPORT_FILE -out $EXPORT_FILE
        if (-not (Test-Path $EXPORT_FILE)) {
            throw "Encrypted file not found!"
        }
        Log-Message "Configuration file encrypted and saved to: $EXPORT_FILE"
        Write-Output "Configuration file encrypted and saved to: $EXPORT_FILE"
    } catch {
        Log-Message "Failed to encrypt configuration file! Error: $_"
        Write-Output "Failed to encrypt configuration file! Error: $_"
        exit 1
    }

    # 检查加密后的文件是否存在
    if (Test-Path $EXPORT_FILE) {
        Log-Message "Done!"
        Write-Output "Done!"
    } else {
        Log-Message "Failed to export file! Check the SN or password!"
        Write-Output "Failed to export file! Check the SN or password!"
    }
}

# 主程序
try {
    # 初始化日志文件
    if (Test-Path $LOG_FILE) {
        Remove-Item -Path $LOG_FILE -Force
    }
    New-Item -Path $LOG_FILE -ItemType File -Force

    # 检查 OpenSSL
    Check-OpenSSL

    # 调用函数
    if ($SN) {
        $mypassword = Generate-Password -SN $SN
        Log-Message "Your password: $mypassword"
        Generate-Config -Password $mypassword -SN $SN
    } else {
        Log-Message "SN is not provided!"
    }
} catch {
    Log-Message "An error occurred during execution: $_"
    Write-Output "An error occurred during execution: $_"
}

# 暂停，等待用户按回车键
#Log-Message "Script execution completed."