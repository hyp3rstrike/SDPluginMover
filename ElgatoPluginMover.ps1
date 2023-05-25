# Set the filepath to the root folder of your Portable OBS folder.
$dirToOBSPortableRoot = "" #Example: "D:\OBS-Studio" with no trailing backslash. It'll fuck the pathing below.

#----- DO NOT MODIFY ANYTHING BELOW THIS LINE -------
$dirToPluginBase = $env:ProgramData + "\obs-studio\plugins\StreamDeckPlugin\"
$dirToPluginBin = $env:ProgramData + "\obs-studio\plugins\StreamDeckPlugin\bin\64bit\"
$dirToPluginData = $env:ProgramData + "\obs-studio\plugins\StreamDeckPlugin\data\"
$dirToObsBin = $dirToOBSPortableRoot + "\obs-plugins\64bit\"
$dirToObsData = $dirToOBSPortableRoot + "\data\obs-plugins\StreamDeckPlugin\"

$sdPluginMainDll = "StreamDeckPlugin.dll"
$sdPluginDllQt6Fn = "StreamDeckPluginQt6.dll"
$sdPluginQt6Source = $dirToPluginData + $sdPluginDllQt6Fn 
$sdPluginMainSource = $dirToPluginBin + $sdPluginMainDll
$sdPluginQt6Dest = $dirToObsData + $sdPluginDllQt6Fn 
$sdPluginDest = $dirToObsBin + $sdPluginMainDll

#$checkSWInstall = "Please check that the Elgato StreamDeck software has been installed on your machine properly.`r`n`r`nYou may need to reinstall it."

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
}

function DestinationCheck {
  if (-not (Test-Path -Path $dirToObsData)) {
      New-Item -ItemType Directory -Path $dirToObsData | Out-Null
  }
  if (-not (Test-Path -Path $dirToObsBin)) {
      New-Item -ItemType Directory -Path $dirToObsData| Out-Null
  }
}

function SourceCheck {
    if (-not (Test-Path -Path $dirToPluginBin)) {
        [System.Windows.MessageBox]::Show($err2, "Files Not Found in Source Directory $dirToPluginBin", $buttons, $icon)
        exit
    }
    if (-not (Test-Path -Path $dirToPluginData)) {
        [System.Windows.MessageBox]::Show($err2, "Files Not Found in Source Directory $dirToPluginData", $buttons, $icon)
        exit
    }
}

function CompareAndMove {
    if (Get-Item -Path $sdPluginQt6Dest) {
        $srcFileVer = [version](Get-Command $sdPluginQt6Source).Version
        $destFileVer = [version](Get-Command $sdPluginQt6Dest).Version
        if (-not $destFileVer -lt $srcFileVer) {
            [System.Windows.MessageBox]::Show($err3, "$sdPluginDllQt6Fn Move Not Required", $buttons, $icon)
        }
    }
     else {
        Copy-Item -Path $dirToPluginData\* -Destination $dirToObsData -Force
        [System.Windows.MessageBox]::Show("$sdPluginDllQt6Fn files successfully copied to $dirToObsData", "$sdPluginDllQt6Fn Copied", $buttons, $icon)
    }
    if (Get-Item -Path $sdPluginDest){
        if (-not (Get-Item $sdPluginDest).VersionInfo.FileVersion -lt (Get-Item $sdPluginMainSource).VersionInfo.FileVersion) {
            [System.Windows.MessageBox]::Show("$err4", "$sdPluginMainDll Move Not Required", $buttons, $icon)
        }
    } else {
        Copy-Item -Path $dirToPluginBin\* -Destination $dirToObsBin -Force
        [System.Windows.MessageBox]::Show("$sdPluginMainDll files successfully copied to $dirToObsBin", "$sdPluginMainDll Copied", $buttons, $icon)
    }
}

InitDirCheck
DestinationCheck
SourceCheck
CompareAndMove