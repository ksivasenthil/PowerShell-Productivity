<#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER SingleLine
    .PARAMETER UsePath
    .PARAMETER OutputParameterName1
    .PARAMETER OutputParameterName2
    .PARAMETER Path
    .PARAMETER Content
    .PARAMETER CommentToken
    .EXAMPLE
    .NOTES
#>
Function Remove-3GlComments {
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory = $False
        )]
        [Switch]
        $SingleLine,
        
        [Parameter(
            Mandatory = $False
        )]
        [Switch]
        $UsePath,

        [Parameter(
            Mandatory = $False,
            ValueFromPipelineByPropertyName = $True
        )]
        [String]
        $OutputParameterName1 = "Path",

        [Parameter(
            Mandatory = $False,
            ValueFromPipelineByPropertyName = $True
        )]
        [String]
        $OutputParameterName2 = "Content",

        [Parameter(
            Mandatory = $False,
            ValueFromPipelineByPropertyName = $True
        )]
        [String]
        $Path,

        [Parameter(
            Mandatory = $False
        )]
        [String]
        $Content,
        
        [Parameter(
            Mandatory = $False,
            ValueFromPipelineByPropertyName = $True
        )]
        [String]
        $CommentToken

    )
    Process {
        if ($UsePath) {
            Write-Output ((Get-Content -Path $Path `
                        -Raw:$SingleLine
                ) `
                    -replace $CommentToken, ""`
                    | `
                    Select-Object -Property `
                @{
                    n = "$OutputParameterName1";
                    e = {$Path}
                },
                @{
                    n = "$OutputParameterName2";
                    e = {$_}
                });
        }
        else {
            Write-Output ($Content `
                    -replace $CommentToken, ""`
                    | `
                    Select-Object -Property `
                @{
                    n = "$OutputParameterName1";
                    e = {$Path}
                },
                @{
                    n = "$OutputParameterName2";
                    e = {$_}
                });
        }
        
    }
}