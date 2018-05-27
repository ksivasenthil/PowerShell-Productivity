<#
    .NOTE
    Sourced from the website http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module/
#>
$PublicScripts = @(Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -ErrorAction SilentlyContinue);
$PrivateScripts = @(Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -ErrorAction SilentlyContinue);

ForEach($folder in @($PublicScripts, $PrivateScripts)){
    Try{
        . $folder.FullName;
    }
    Catch{
        Write-Error -Message "Failed to import function $($import.FullName): $_";
    }
}
Export-ModuleMember -Function $PublicScripts.BaseName;