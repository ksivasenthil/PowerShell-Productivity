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
        $OutputParameterName1="SourceFile",

        [String]
        $OutputParameterName2="Content",

        [String]
        $Path,

        [String]
        $CommentToken

    )
    Process{
        Write-Output ((Get-Content -Path $Path) `
                        -replace [regex]::Escape($CommentToken) `
                        | `
                    Select-Object -Property `
                    @{
                        n="$OutputParameterName1";
                        e={$Path}
                    },
                    @{
                        n="$OutputParameterName2";
                        e={$_}
                    });
    }
}