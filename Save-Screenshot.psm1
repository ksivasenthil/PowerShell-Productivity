Function Save-Screenshot() {
    $directoryExists = Test-Path -Path "$($env:USERPROFILE)\Screenshots";
    if(-not($directoryExists)){
        New-Item -Path "$($env:USERPROFILE)\Screenshots\" -ItemType Directory;    }
    $screenShot = Get-Clipboard -Format Image;
    if($null -ne $screenShot) {
        $fileName = Get-Date -Format "dd-MM-yyyy-HH-mm-ss-fff";
        $fileName = "$($env:USERPROFILE)\Screenshots\$fileName.png"
        $screenShot.Save($fileName, "png");
    }
}
Export-ModuleMember -Function Save-Screenshot