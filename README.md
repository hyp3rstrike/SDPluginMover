# SDPluginMover
For users of the Portable version of OBS Studio. This PowerShell script will check the Elgato StreamDeck Plugin and move it to your OBS Studio Portable folder.

### Features
* Checks if the directories exist in the appropriate locations within the OBS Portable directory, and if not, create them.
* Checks if the original source files exist (ie. StreamDeck Application installed) and notifies the user if not
* Checks the version number between the source version and the OBS Plugin version to only copy if an update is required.

### Usage
Depending if you're run a PowerShell script on your PC before, you may be required to configure your PowerShell's Execution-Policy.

Do you a learning here:
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.3

You may also be required to install [PowerShell 7.0+](https://github.com/PowerShell/PowerShell/), which I'd recommend doing anyway.

1. Download the [latest release](https://github.com/hyp3rstrike/SDPluginMover/releases).
2. Unzip the archive.
3. Right-click the **ElgatoPluginMover.ps1** file and open it with Notepad/VSCode/Your preferred text editor environment.
4. Modify the top-most variable inside the  quotation marks with the filepath to the root of your OBS Portable directory.
5. Save the file and close the editor.
6. Double-click the file **ElgatoPluginMover.ps1** and run through it. 

The script should error on any condition that isn't met. I've done my best to anticipate any potential issues and raise them as native dialogue boxes (I'm assuming people read, my bad) and added any corrective measures that's possible within the script.

But if something fucks up outside of that, raise an issue on this here Git repo.

**Do not raise issues regarding PowerShell Execution Policies** because I won't respond to them.