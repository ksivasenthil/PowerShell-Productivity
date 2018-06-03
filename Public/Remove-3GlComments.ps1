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

        [Parameter(
            ValueFromPipelineByPropertyName=$True
        )]
        [String]
        $OutputParameterName1="Path",

        [Parameter(
            ValueFromPipelineByPropertyName=$True
        )]
        [String]
        $OutputParameterName2="Content",

        [Parameter(
            ValueFromPipelineByPropertyName=$True
        )]
        [String]
        $Path,

        [Parameter(
            ValueFromPipelineByPropertyName=$True
        )]
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