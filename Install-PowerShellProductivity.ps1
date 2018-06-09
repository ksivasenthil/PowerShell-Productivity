$VerbosePreference = "Continue";
$moduleName = (Get-ChildItem -Path "$PSScriptRoot\*.psd1" `
        | `
        Select-Object -First 1 `
        | `
        Select-Object -ExpandProperty BaseName);
$userDirectory = "$env:USERPROFILE\Documents\WindowsPowerShell";
$userModuleDirectory = ($env:PSModulePath -split ";" `
        | `
        Foreach-Object -Process { 
        if ($_ -match [regex]::escape($userDirectory)) {
            Write-Output $_;
        }
    });
$moduleDirectory = "$userModuleDirectory\$moduleName";
Remove-Item -Force -Recurse -Path $moduleDirectory -ErrorAction SilentlyContinue;
New-Item -Force -Path $moduleDirectory -ItemType Directory;
$moduleAssets = @(
    ".\$moduleName.psm1",
    ".\$moduleName.psd1",
    ".\Public"
);
$moduleAssets | Foreach-Object -Process {
    Copy-Item -Path $_ -Destination $moduleDirectory -Force -Recurse;
}