[console]::Beep(800, 400)

if (-not (Test-Path 'C:\Temp')) {
    New-Item -ItemType Directory -Path 'C:\Temp' | Out-Null
}

$reminderScript = {
    Start-Sleep -Seconds 180
    [console]::Beep(500, 600)
    Start-Sleep -Milliseconds 200
    [console]::Beep(500, 600)
    Start-Sleep -Milliseconds 200
    [console]::Beep(500, 600)
    Start-Sleep -Milliseconds 500
}

$encodedCommand = [Convert]::ToBase64String(
    [Text.Encoding]::Unicode.GetBytes($reminderScript.ToString())
)

$proc = Start-Process powershell.exe `
    -ArgumentList "-NonInteractive -WindowStyle Hidden -EncodedCommand $encodedCommand" `
    -PassThru `
    -WindowStyle Hidden

$proc.Id | Out-File -FilePath 'C:\Temp\claude_timer.pid' -Encoding utf8