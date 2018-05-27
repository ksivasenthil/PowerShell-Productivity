<#
    .SYNOPSIS
    Saves the clipboard item of type image to disk.
    .DESCRIPTION
    When you take a screenshot it is saved as image in the clipboard for windows based machine.
    This Cmdlet copies the image in the clipboard and saves it to disk. 
    .PARAMETER Path
    Location where the image file should be saved. This can be fully qualified or relative path. The path should exist.
    Defaults to a folder named Screenshot located in Users profile directory
    .EXAMPLE
    Save-Screenshot
    Depending on whether there was image data or not either of the following message will be displayed
    If there was screenshot - Clipboard image saved!
    If there was no screenshot - Clipboard devoid of image
    .EXAMPLE
    Save-Screenshot -Path "D:\Screenshot"
    Output will be similar to that narrated in the example of Save-Screenshot.
    .NOTE
    Cmdlet does not have the Process block. Thus iterating over items when chained in pipeline will not be possible.
    The Cmdlet by default adds a timestamp to the image file which it saves.
    The Cmdlet removes the clipboard data to avoid multiple saves of the same image with different timestamp.
    Removal of clipboard data happens only if image is found in clipboard. If otherwise it will not remove.
#>
Function Save-Screenshot {
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory = $False,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Give the directory where you would want the screenshot image files to be saved. `
                            Defaults to Screenshot directory within the UserProfile directory."
        )]
        [String]
        $Path = "$($env:USERPROFILE)\Screenshots"
    )
    
    New-Item -Path $Path -ItemType Directory -Force;
    $screenShot = Get-Clipboard -Format Image;
    if ($null -ne $screenShot) {
        $fileName = Get-Date -Format "dd-MM-yyyy-HH-mm-ss-fff";
        $fileName = "$Path\$fileName.png"
        $screenShot.Save($fileName, "png");
        Write-Host "Clipboard image saved!";
    }
    else {
        Write-Host "Clipboard devoid of image";
    }
}