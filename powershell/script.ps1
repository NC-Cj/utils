# Set aliases for managing multi-version interpreters
Set-Alias -Name py38 -Value "C:\Users\$($env:USERNAME)\AppData\Local\Programs\Python\Python38\python.exe"
Set-Alias -Name pip38 -Value "C:\Users\$($env:USERNAME)\AppData\Local\Programs\Python\Python38\Scripts\pip3.exe"
Set-Alias -Name py310 -Value "C:\Users\$($env:USERNAME)\AppData\Local\Programs\Python\Python310\python.exe"
Set-Alias -Name pip310 -Value "C:\Users\$($env:USERNAME)\AppData\Local\Programs\Python\Python310\Scripts\pip3.exe"


# Find which process is occupied by port and then close it
function Killnet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$Port
    )

    # 使用 PowerShell 自带的 cmdlet 来获取 TCP 连接信息
    $tcpConnections = Get-NetTCPConnection -State Listen | Where-Object { $_.LocalPort -eq $Port }

    if ($tcpConnections) {
        foreach ($connection in $tcpConnections) {
            # 获取拥有该连接的进程ID
            $processId = $connection.OwningProcess
    
            # 获取对应进程对象
            $process = Get-Process -Id $processId -ErrorAction SilentlyContinue

            if ($process) {
                Write-Warning "Killing the process $($process.Name) (PID: $($process.Id))..."
                Stop-Process -InputObject $process -Force
            }
            else {
                Write-Warning "No process is currently using port $Port ."
            }
        }
    }
    else {
        Write-Host "No process is currently using port $Port ."
    }
}

