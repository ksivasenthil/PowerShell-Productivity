<#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER
    .EXAMPLE
    .NOTE
#>
Function Remove-3GlComments {
    [CmdletBinding()]
    Param(
        [Switch]
        $SingleLine,

        [String]
        $OutputParameterName="SourceFile",

        [String]
        $Path,

        [String]
        $CommentToken
    )
    Process{
        Write-Output ((Get-Content -Path $Path) -replace [regex]::Escape($CommentToken));
    }
}