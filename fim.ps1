# Function to calculate file hash
Function Calculate-File-Hash {
    param ([string]$filepath)
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}

# Function to erase the baseline file if it already exists
Function Erase-Baseline-If-Already-Exists {
    $baselineExists = Test-Path -Path "C:\Users\liamg\OneDrive\Desktop\FIM\baseline.txt"
    if ($baselineExists) {
        # Delete it
        Remove-Item -Path "C:\Users\liamg\OneDrive\Desktop\FIM\baseline.txt"
        Write-Host "Existing baseline deleted."
    }
}

# Display menu to user
Write-Host ""
Write-Host "What would you like to do?"`n
Write-Host "     A - Collect new Baseline?"
Write-Host "     B - Begin monitoring files with saved Baseline?"`n

# Read user input
$user_reply = Read-Host -Prompt "Please enter 'A' or 'B'"
Write-Host "User entered $($user_reply)"

# Convert user input to upper case and compare
if ($user_reply.ToUpper() -eq "A") {
    # Delete baseline.txt if it already exists
    Erase-Baseline-If-Already-Exists

    # Calculate hash from the target files and store in baseline.txt
    # Collect all files in the target folder
    $files = Get-ChildItem -Path "C:\Users\liamg\OneDrive\Desktop\FIM\Files"

    # For each file, calculate the hash, and write to baseline.txt
    foreach ($file in $files) {
        $hash = Calculate-File-Hash $file.FullName
        "$($file.FullName)|$($hash.Hash)" | Out-File -FilePath "C:\Users\liamg\OneDrive\Desktop\FIM\baseline.txt" -Append
    }
    Write-Host "Baseline collected and stored."

} elseif ($user_reply.ToUpper() -eq "B") {
    $fileHashDictionary = @{}

    # Load file|hash from baseline.txt and store them in a dictionary
    $filePathsAndHashes = Get-Content -Path "C:\Users\liamg\OneDrive\Desktop\FIM\baseline.txt"
    
    foreach ($f in $filePathsAndHashes) {
        $filePath = $f.Split("|")[0]
        $fileHash = $f.Split("|")[1]

        # Check if key already exists before adding
        if (-not $fileHashDictionary.ContainsKey($filePath)) {
            $fileHashDictionary.Add($filePath, $fileHash)
        } else {
            Write-Host "Key '$filePath' already exists in the dictionary. Skipping."
        }
    }
    Write-Host "Loaded baseline into dictionary. Monitoring started..."

    # Begin (continuously) monitoring files with saved Baseline
    while ($true) {
        Start-Sleep -Seconds 1

        $files = Get-ChildItem -Path "C:\Users\liamg\OneDrive\Desktop\FIM\Files"

        foreach ($file in $files) {
            $hash = Calculate-File-Hash $file.FullName

            # Notify if a new file has been created
            if ($fileHashDictionary[$hash.Path] -eq $null) {
                Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
            }
            else {
                # Check if the file hash has changed
                if ($fileHashDictionary[$hash.Path] -ne $hash.Hash) {
                    Write-Host "$($hash.Path) has changed!!!" -ForegroundColor Yellow
                }
            }
        }

        # Check for deleted files
        foreach ($key in $fileHashDictionary.Keys) {
            $baselineFileStillExists = Test-Path -Path $key
            if (-Not $baselineFileStillExists) {
                Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed -BackgroundColor Gray
            }
        }
    }
} else {
    Write-Host "Invalid input. Please enter 'A' or 'B'."
}
