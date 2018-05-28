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
        $OutputParameterName2="UncommentedFile",
        
        [String]
        $Path <#,

        [String]
        $CommentToken #>
    )
    Process{
        (Get-Content -Path $Path) -replace "\/\/" | Out-File "$Path.uncommented";
        return @(
            [PSCustomObject]@{
                $($OutputParameterName1) = $Path;
                $($OutputParameterName2) = $("$Path.uncommented")
            }
        );
    }
}