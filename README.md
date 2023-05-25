# SDPluginMover
For users of the Portable version of OBS Studio. This PowerShell script will check the Elgato StreamDeck Plugin and move it to your OBS Studio Portable folder.

### Features
* Checks if the directories exist in the appropriate locations within the OBS Portable directory, and if not, create them.
* Checks if the original source files exist (ie. StreamDeck Application installed) and notifies the user if not
* Checks the version number between the source version and the OBS Plugin version to only copy if an update is required.

### Usage
Download the .PS1 file and run using Powershell (Windows should automatically pick it up, otherwise set it to run using Powershell). Probably best to use Powershell 7 from https://github.com/PowerShell/PowerShell/.
