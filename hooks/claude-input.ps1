$pidFile = 'C:\Temp\claude_timer.pid'

if (Test-Path $pidFile) {
    $timerPid = Get-Content $pidFile
    Stop-Process -Id $timerPid -Force -ErrorAction SilentlyContinue
    Remove-Item $pidFile -Force
}
