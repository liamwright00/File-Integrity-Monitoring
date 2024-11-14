# File-Integrity-Monitoring
File integrity monitoring, or FIM, is a technology that monitors and detects file changes that could be indicative of a cyberattack. 

# PowerShell File Integrity Monitoring (FIM) Script

This PowerShell script is designed to monitor files in a specified directory for changes, functioning as a basic File Integrity Monitoring (FIM) tool. It allows users to create a baseline of file hashes, which will be used later to detect changes, additions, or deletions within the monitored directory. 

## Script Components

### 1. Calculate-File-Hash Function
This function calculates a SHA512 hash for a given file. The hash serves as a unique identifier for the file's contents, essential for tracking modifications.

### 2. Erase-Baseline-If-Already-Exists Function
This function checks if the baseline file (`baseline.txt`) already exists in the specified directory and deletes it if found, ensuring no conflicts with previous baselines.

### 3. User Menu
After running the script, the user is prompted with two options:
- **A** - Collect a new baseline of file hashes.
- **B** - Begin monitoring files using a saved baseline.

### 4. Option A: Collect New Baseline
If the user selects **A**, the script deletes any existing `baseline.txt`, then calculates SHA512 hashes for each file in the target directory (`FIM\Files`). It stores these file paths and their corresponding hashes in `baseline.txt`, creating a record of the initial state of the directory.

### 5. Option B: Begin Monitoring
If the user selects **B**, the script loads the baseline information (file paths and hashes) from `baseline.txt` into a dictionary for efficient lookups. It then continuously monitors the target directory for:

- **File Modifications**: If a file's hash differs from the baseline, a message is displayed indicating that the file has changed.
- **New Files**: If a file is detected that does not exist in the baseline, a message is displayed indicating that a new file has been created.
- **Deleted Files**: If a file from the baseline no longer exists in the directory, a message is displayed indicating that the file has been deleted.

## Intended Use and Application

This script can be used in environments where it's important to monitor files for unexpected changes, such as in a security context where file integrity is critical. It’s a simple yet powerful way to track modifications, additions, and deletions in a directory, making it ideal for systems that need to guard against unauthorized file tampering.
