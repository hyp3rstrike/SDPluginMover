# Set the filepath to the root folder of your Portable OBS folder.
$dirToOBSPortableRoot = "D:\OBS-Studio" #Example: "D:\OBS-Studio" with no trailing backslash. It'll fuck the pathing below.

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

$checkSWInstall = "Please check that the Elgato StreamDeck software has been installed on your machine properly.`r`n`r`nYou may need to reinstall it."

$err1 = "You have not specified the location of your Portable OBS installation in this PowerShell Script.`r`n`r`nPlease refer to the Github page."
$err2 = "Unable to locate the source files for the StreamDeck Plugin at`r`n`r`n$dirToPluginBase`r`n`r`nPlease check that you've installed the StreamDeck Application from Elgato's website on this machine."
$err3 = "$sdPluginDllQt6Fn was not moved because the destination file version matches the source file version.`r`n`r`nClick OK to continue."
$err4 = "$sdPluginMainDll was not moved because the destination file version matches the source file version.`r`n`r`nClick OK to exit."

Add-Type -AssemblyName PresentationCore, PresentationFramework
$buttons = [System.Windows.MessageBoxButton]::OK
$icon = [System.Windows.MessageBoxImage]::Information

function InitDirCheck {
    if ($dirToOBSPortableRoot -eq "") {
        [System.Windows.MessageBox]::Show($err1, "OBS Portable Directory Not Set", $buttons, $icon)
        exit
    } else {
        If (-not (Test-Path -Path $dirToOBSPortableRoot)) {
            [System.Windows.MessageBox]::Show($err1, "Unable to find OBS Portable Directory", $buttons, $icon)
            exit
        }
    }
    if ($dirToOBSPortableRoot -eq "") {
        [System.Windows.MessageBox]::Show($err1, "OBS Portable Directory Not Set", $buttons, $icon)
        exit
    } else {
        If (-not (Test-Path -Path $dirToOBSPortableRoot)) {
            [System.Windows.MessageBox]::Show($err1, "Unable to find OBS Portable Directory", $buttons, $icon)
            exit
        }
    }
}

function CheckSrcFilesExist {
    if (-not (Test-Path -Path $dirToPluginBin)) {
        [System.Windows.MessageBox]::Show($err2, "Files Not Found in Source Directory $dirToPluginBin", $buttons, $icon)
        exit
    }
    if (-not (Test-Path -Path $dirToPluginData)) {
        [System.Windows.MessageBox]::Show($err2, "Files Not Found in Source Directory $dirToPluginData", $buttons, $icon)
        exit
    }
}


if (-not (Test-Path -Path $dirToObsBin)) {
    New-Item -ItemType Directory -Path $dirToObsData | Out-Null
}
elseif (-not (Test-Path -Path $sdPluginQt6Source)) {
    [System.Windows.MessageBox]::Show("Could not find $sdPluginDllQt6Fn in $sdPluginQt6Source.`r`n`r`n$checkSWInstall", "$sdPluginDllQt6Fn Source File Not Found", $buttons, $icon)
    Break
}
else {
    if (-not (Get-Item $sdPluginDest).VersionInfo.FileVersion -lt $sdPluginMainSource) {
        [System.Windows.MessageBox]::Show($err4, "$sdPluginMainDll Move Not Required", $buttons, $icon)
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
    [System.Windows.MessageBox]::Show("Could not find $sdPluginMainDll in $sdPluginMainSource.`r`n`r`n$checkSWInstall", "$sdPluginMainDll Source File Not Found", $buttons, $icon)
    Break
}
else {
    if (-not (Get-Item $sdPluginQt6Dest).VersionInfo.FileVersion -lt $sdPluginQt6Source) {
        [System.Windows.MessageBox]::Show($err3, "$sdPluginDllQt6Fn Move Not Required", $buttons, $icon)
    }
    else {
        Move-Item -Path $dirToPluginData\* -Destination $dirToObsData -Force
    }
}
