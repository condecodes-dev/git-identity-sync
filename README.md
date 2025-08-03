# git-identity-sync

This tool rewrites the author and committer information in Git history to match corporate identity before pushing code to the company's repository.

It is intended for developers who work in personal environments and need to synchronize commit metadata (such as name and email) to comply with internal project standards.

---

## Purpose

- Avoid exposing personal identity in corporate repositories
- Ensure consistent commit history across environments
- Automate author rewriting based on a simple configuration file

---

## Structure

- `rewrite_commits.ps1` – PowerShell script that rewrites Git history using corporate identity
- `config_user.txt` – Simple configuration file where you define personal and corporate information
- `README.md` – Documentation and usage instructions

---

## Requirements

- PowerShell Core (`pwsh`) installed and available in PATH
- Git installed and available in PATH
- This repository should be cloned or copied alongside your project

---

## How to Use

### Step 1: Prepare your project

Make sure you have a Git project with commits done using your **personal identity**.  
This tool must be executed **inside that Git repository** (i.e., where `.git/` exists).

### Step 2: Create or update `config_user.txt`

Inside the `git-identity-sync` folder, edit the file `config_user.txt` with the following structure:

```
OLD_NAME=Your Personal Name
OLD_EMAIL=your.personal@email.com
NEW_NAME=Corporate Identity Name
NEW_EMAIL=corporate@email.com
```

All four fields are **required** and must match exactly what appears in the commit history.

### Step 3: Execute the script

From inside your Git project root (where `.git/` is located), run:

```bash
pwsh path/to/git-identity-sync/rewrite_commits.ps1
```

The script will:

- Read `config_user.txt`
- Replace all matching authors/committers across all branches and tags
- Rebuild the commit history using `git filter-branch`

---

## Final Step: Push to the corporate repository

After verifying that your commit history is correct, push the rewritten history using:

```bash
git push --force --tags origin 'refs/heads/*'
```

This ensures all branches and tags are updated with the rewritten metadata.

---

## Notes

- Make a backup of your repository before running this script
- Rewriting history is destructive and should only be done before pushing to a new remote
- This script is intended for local pre-push sanitization, not for production use after collaboration begins
