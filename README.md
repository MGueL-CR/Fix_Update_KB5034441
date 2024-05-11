# Fix_Update_KB5034441
It is a semi-automatic PowerShell script that fixes the problem when trying to install the KB5034441 update for Windows 10 and Windows 11.  

This script is based on the official Microsoft documentation: [KB5028997: Instructions to manually resize your partition to install the WinRE update](https://support.microsoft.com/en-us/topic/kb5028997-instructions-to-manually-resize-your-partition-to-install-the-winre-update-400faa27-9343-461c-ada9-24c8229763bf).

## How to use
1. Make sure that script execution is enabled on this system. ([Read more...](https://go.microsoft.com/fwlink/?LinkID=135170)).

3. Open a new PowerShell window with administrator permissions.

4. Download the file named "Fix_Update_KB5034441.ps1" or copy the contents of it.

5. Navigate to the directory where it is located (Downloads Folder) and type the following command: ```.\Fix_Update_KB5034441.ps1```

6. During the execution of the script, necessary queries will be made to solve the current error and install the KB5034441 update.

7. Once the process is finished, open Windows Update, search for or retry installing the KB5034441 update.

## Tags
* Error Windows Update (0x80070643)
* Fix Update KB5034441
* KB5028997 Instructions
* Solution error 0x80070643
