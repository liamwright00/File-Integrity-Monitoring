Intended Use
This script is useful for monitoring files in environments where file integrity is crucial, such as in security-sensitive systems where unauthorized file changes need to be detected promptly.

Instructions for Use
Run the script in PowerShell.
Select Option A to create a new baseline of file hashes, or Option B to start monitoring files against the baseline.
Customize file paths or the hashing algorithm if desired.
Requirements
PowerShell with access to the Get-FileHash cmdlet.
Proper permissions to access the specified file paths.
Future Expansion
This script can be expanded to support:

Monitoring additional directories.
Integrating alerts (e.g., email notifications).
Logging results in a file for long-term monitoring.
