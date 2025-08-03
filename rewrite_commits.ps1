# rewrite_commits.ps1
# PowerShell script to rewrite Git commit history with corporate identity

$configPath = "$PSScriptRoot\config_user.txt"

if (-Not (Test-Path $configPath)) {
    Write-Host "File config_user.txt not found at: $configPath" -ForegroundColor Red
    exit 1
}

# Read configuration variables
Get-Content $configPath | ForEach-Object {
    if ($_ -match '^([^#=]+)=([^\r\n]+)$') {
        Set-Variable -Name $matches[1].Trim() -Value $matches[2].Trim()
    }
}

# Basic validation
if (-not $OLD_NAME -or -not $OLD_EMAIL -or -not $NEW_NAME -or -not $NEW_EMAIL) {
    Write-Host "Error: All fields (OLD_*/NEW_*) must be filled in correctly." -ForegroundColor Red
    exit 1
}

# Execute Git history rewrite
git filter-branch --env-filter @"
if [ "\$GIT_COMMITTER_NAME" = "$OLD_NAME" ] && [ "\$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]; then
    export GIT_COMMITTER_NAME="$NEW_NAME"
    export GIT_COMMITTER_EMAIL="$NEW_EMAIL"
fi
if [ "\$GIT_AUTHOR_NAME" = "$OLD_NAME" ] && [ "\$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]; then
    export GIT_AUTHOR_NAME="$NEW_NAME"
    export GIT_AUTHOR_EMAIL="$NEW_EMAIL"
fi
"@ --tag-name-filter cat -- --branches --tags

Write-Host ""
Write-Host "✔️ Git history successfully rewritten." -ForegroundColor Green
Write-Host "To push the changes, run:" -ForegroundColor Yellow
Write-Host "  git push --force --tags origin 'refs/heads/*'"
