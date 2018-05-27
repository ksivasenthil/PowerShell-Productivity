<#
    .SYNOPSIS
    Lists all the files with a specific extension in the path you asked the command to search inside.
    .DESCRIPTION
    File extensions that this Cmdlet can operate is limited to cs, vb, py, and csproj. 
    The reason for this limitation is the subsequent use of which for the time being will be built only for those file types.
    .PARAMETER Extension
    Optional in nature, file extension which you want to be listed. It should one of the cs, vb, py, or csproj. Defaults to cs.
    Only one file extension can be used with the Cmdlet.
    .PARAMETER OutputPropertyName
    Optional in nature, you specify the name of the property which you will get as output from this Cmdlet. 
    The custom property name will be applied to the PSCustomObject emitted from this Cmdlet.
    This will help in situations where you intend to pipeline this Cmdlet to other Cmdlets down in the chain.
    .PARAMETER Recurse
    Optional in nature, it is a switch indicating whether you intend to recurse through sub-folders present in the current directory.
    .PARAMETER Path
    Required parameter, it should be the fully qualified or relative path within which the files will be searched.
    In scenarios where Recurse switch is present it will recurse all sub-folders present inside this folder.
    .EXAMPLE
    Get-FileNamesByExtension -Path "C:\Source code" -Extension "py"
    Path
    -----
    [List of files with .py extension as directy child to the current folder.]
    .NOTE
    This Cmdlet has the process block and can operate through multiple Path and Extension parameters.
    The Cmdlet is pipeline friendly for downstream Cmdlets as well.
#>
Function Get-FileNamesByExtension {
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Give one of the extension string which will be used to search. `
                        Extensions are limited to cs, vb, py, csproj. Defaults to cs"
        )]
        [ValidateSet("cs", "vb", "py", "csproj")]
        [Alias("ex")]
        [String]
        $Extension="cs",
        
        [Parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$false,
            HelpMessage="Give the property name of the PSCustomObject which be emitted as output of the Cmdlet. `
                        Use only string, refrain from using numbers and special characters.Defaults to Path"
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
        Write-Output (Get-ChildItem -Path $Path -Filter "*.$Extension" -Recurse:$Recurse |`
                         Select-Object -Property @{n=$OutputPropertyName;e={$_.FullName}});
    }
}