<#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER
    .EXAMPLE
    .NOTE
#>
Function Get-FileNamesByExtension {
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Give one of the extension string which will be used to search. Extensions are limited to cs, vb, py, csproj. Defaults to cs"
        )]
        [ValidateSet("cs", "vb", "py", "csproj")]
        [Alias("ex")]
        [String]
        $Extension="cs",
        
        [Parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$false,
            HelpMessage="Give the property name of the PSCustomObject which be emitted as output of the Cmdlet. Use only string, refrain from using numbers and special characters.Defaults to Path"
        )]
        [ValidateNotNullOrEmpty()]
        [Alias("opn")]
        [String]
        $OutputPropertyName = "Path",

        [Parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Indicate whether the search should be recursed over sub folders with no limit on the depth of recursion."
        )]
        [switch]
        $Recurse,

        [Parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Give the folder where the search is to be conducted."
        )]
        [ValidateScript({
            if(Test-Path -LiteralPath $_ -PathType Container) {
                $true;
            } else {
                throw "The folder you gave in as parameter does not exist. Re-try with correct folder path.";
            }
        })]
        [String]
        $Path
    )
    Process{
        Write-Output (Get-ChildItem -Path $Path -Filter "*.$Extension" -Recurse:$Recurse | Select-Object -Property @{n=$OutputPropertyName;e={$_.FullName}});
    }
}