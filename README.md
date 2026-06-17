# claude-audio-notifications

PowerShell hooks for Claude Code that play audio cues when Claude finishes a response and remind you if you haven't followed up after 3 minutes.

## What it does

- Plays a short beep when Claude stops responding (`Stop` hook → `claude-stop.ps1`)
- Starts a background timer that plays three slower beeps after 180 seconds if you haven't typed anything
- Cancels the reminder timer as soon as you submit a new prompt (`UserPromptSubmit` hook → `claude-input.ps1`)

## Prerequisites

- Windows (uses `[console]::Beep` and `powershell.exe`)
- [Claude Code](https://claude.ai/code) installed
- PowerShell 5.1 or later (ships with Windows 10/11)

## Setup

### 1. Clone the repo

```
git clone https://github.com/OllieTHam/claude-audio-notifications.git
```

Place it wherever you like. The path you choose goes into the hook commands below.

### 2. Add the hooks to `~/.claude/settings.json`

Open `%USERPROFILE%\.claude\settings.json` (create it if it doesn't exist) and add the `hooks` block. Replace the path with wherever you cloned the repo:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "powershell.exe -ExecutionPolicy Bypass -File \"C:\\YOUR\\PATH\\claude-audio-notifications\\hooks\\claude-stop.ps1\""
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "powershell.exe -ExecutionPolicy Bypass -File \"C:\\YOUR\\PATH\\claude-audio-notifications\\hooks\\claude-input.ps1\""
          }
        ]
      }
    ]
  }
}
```

If `settings.json` already has other content (e.g. `"theme"`), merge the `hooks` key into the existing object — don't replace the whole file.

## Testing manually

Run these three commands from PowerShell to confirm the scripts work before relying on the hooks:

```powershell
# 1. Trigger the completion beep and start the reminder timer
powershell.exe -ExecutionPolicy Bypass -File ".\hooks\claude-stop.ps1"

# 2. Check the timer process was created
Test-Path C:\Temp\claude_timer.pid

# 3. Cancel the reminder (simulates submitting a prompt)
powershell.exe -ExecutionPolicy Bypass -File ".\hooks\claude-input.ps1"
```

After step 1 you should hear one short beep. After step 3 the timer is cancelled and `C:\Temp\claude_timer.pid` is deleted.

## Adjusting the reminder delay

The timer is set to **180 seconds** in `hooks\claude-stop.ps1`:

```powershell
Start-Sleep -Seconds 180
```

Change that number to whatever suits you.
