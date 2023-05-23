# Set the filepath to the root folder of your Portable OBS folder.
$dirToOBSPortableRoot = ""

#----- DO NOT MODIFY ANYTHING BELOW THIS LINE -------
$dirToPluginBase = $env:ProgramData + "\obs-studio\plugins\StreamDeckPlugin\"
$dirToPluginBin = $env:ProgramData + "\obs-studio\plugins\StreamDeckPlugin\bin\64bit\"
$dirToPluginData = $env:ProgramData + "\obs-studio\plugins\StreamDeckPlugin\data\"
$dirToObsBin = $dirToOBSPortableRoot + "\obs-plugins\64bit\"
$dirToObsData = $dirToOBSPortableRoot + "\data\obs-plugins\StreamDeckPlugin\"

$sdPluginMainDll = "StreamDeckPlugin.dll"
$sdPluginDllQt6Fn = "StreamDeckPluginQt6.dll"
$sdPluginQt6Source = $dirToPluginData + $sdPluginDllQt6Fn 
$sdPluginMainSource = $dirToPluginData + $sdPluginMainDll
$sdPluginQt6Dest = $dirToPluginData + $sdPluginDllQt6Fn 
$sdPluginDest = $dirToPluginData + $sdPluginMainDll

Add-Type -AssemblyName PresentationCore, PresentationFramework

$checkSWInstall = "Please check that the Elgato StreamDeck software has been installed on your machine properly.`r`n`r`nYou may need to reinstall it."

$message1 = "You have not specified the location of your Portable OBS installation in this PowerShell Script.`r`n`r`nPlease refer to the Github page."
$title1 = "OBS Portable Directory Not Set"

$message2 = "Unable to locate the source files for the StreamDeck Plugin at`r`n`r`n$dirToPluginBase`r`n`r`nPlease check that you've installed the StreamDeck Application from Elgato's website on this machine."
$title2 = "StreamDeck Plugin Source Files Not Found"

$message3 = "$sdPluginDllQt6Fn was not moved because the destination file version matches the source file version.`r`n`r`nClick OK to continue."
$message4 = "$sdPluginMainDll was not moved because the destination file version matches the source file version.`r`n`r`nClick OK to exit."
$title3 = "No Update Required"

$buttons = [System.Windows.MessageBoxButton]::OK
$icon = [System.Windows.MessageBoxImage]::Information

if ($dirToOBSPortableRoot -eq "") {
    [System.Windows.MessageBox]::Show($message1, $title1, $buttons, $icon)
    break
}

if (-not (Test-Path -Path $dirToPluginBin)) {
    [System.Windows.MessageBox]::Show($message2, $title2, $buttons, $icon)
    break
}

if (-not (Get-Item $sdPluginQt6Dest).VersionInfo.FileVersion -lt $sdPluginQt6Source) {
    [System.Windows.MessageBox]::Show($message3, $title3, $buttons, $icon)
}
if (-not (Get-Item $sdPluginDest).VersionInfo.FileVersion -lt $sdPluginMainSource) {
    [System.Windows.MessageBox]::Show($message4, $title3, $buttons, $icon)
    break
}

if (-not (Test-Path -Path $dirToObsBin)) {
    New-Item -ItemType Directory -Path $dirToObsData | Out-Null
    Write-Host "Directory created as it did not exist: $dirToObsBin"
}
elseif (-not (Test-Path -Path $sdPluginQt6Source)) {
    [System.Windows.MessageBox]::Show("Could not find $sdPluginDllQt6Fn in $sdPluginQt6Source.`r`n`r`n$checkSWInstall", $title3, $buttons, $icon)
    Break
}
else {
    if (-not (Get-Item $sdPluginDest).VersionInfo.FileVersion -lt $sdPluginMainSource) {
        [System.Windows.MessageBox]::Show($message4, $title3, $buttons, $icon)
        Break
    }
    else {
        Move-Item -Path $dirToPluginBin\* -Destination $dirToObsBin -Force
    }
}

if (-not (Test-Path -Path $dirToObsData)) {
    New-Item -ItemType Directory -Path $dirToObsData | Out-Null
    Write-Host "Directory created as it did not exist: $dirToObsData"
}
elseif (-not (Test-Path -Path $sdPluginQt6Source)) {
    [System.Windows.MessageBox]::Show("Could not find $sdPluginMainDll in $sdPluginMainSource.`r`n`r`n$checkSWInstall", $title3, $buttons, $icon)
    Break
}
else {
    if (-not (Get-Item $sdPluginQt6Dest).VersionInfo.FileVersion -lt $sdPluginQt6Source) {
        [System.Windows.MessageBox]::Show($message3, $title3, $buttons, $icon)
    }
    else {
        Move-Item -Path $dirToPluginData\* -Destination $dirToObsData -Force
    }
}
