<#
    .SYNOPSIS
    Removes comments from source code typically found in 3 generation programming languages.

    .DESCRIPTION
    Uses regular expression to remove the comments. The regular expression is expected as input.
    Cmdlet can be used to pipeline with customizable property names.

    .PARAMETER SingleLine
    Optional switch parameter, to indicate if the content of the file has to be read all together.
    Defaults to false.

    .PARAMETER UsePath
    Optional switch parameter, to indicate if the Cmdlet needs to pick the content from the file in disk.
    Defaults to false.

    .PARAMETER OutputParameterName1
    Optional string parameter, to name the property which will carry the name of the file.
    In situations when the Cmdlet is working with piped content this value might be filled from higher up in pipeline.
    Defaults to Path.

    .PARAMETER OutputParameterName2
    Optional string parameter, to name the property which will contain the content post removing comments.
    Defaults to Content.

    .PARAMETER Path
    Optional string parameter, used to contain the name of the file from which the text needs to be parsed.
    
    .PARAMETER Content
    Optional string parameter, used to contain the content on which the comments are removed.
    Required status of the parameter is logical XOR to required status of the Path parameter.
    Thus, if Path and UsePath are specified this parameter is not required.
    If Path is not specified this parameter is required.

    .PARAMETER CommentToken
    Mandatory regular expression which carries the comment token which is used to remove the comment from the file.

    .EXAMPLE
    Remove-3GlComments -UsePath -Path "C:\SourceCode\Foo.cs" -CommentToken "//(.*)?\r?\n"
    Path                         Content
    ----------                   -----------
    C:\SourceCode\Foo.cs         [Content from the file with single line comments removed]

    .EXAMPLE
    Get-Content -Path "C:\SourceCode\Foo.cs" | Remove-3GlComments -UsePath -CommentToken "//(.*)?\r?\n"
    Path                         Content
    ----------                   -----------
    C:\SourceCode\Foo.cs         [Content from the file with single line comments removed]

    Here the use of Get-Content is defeated since the Remove-3GlComments will read the file again and do it 
    for the number of times the lines are present in the C:\SourceCode\Foo.cs file.
    
    .EXAMPLE
    Get-Content -Path "C:\SourceCode\Foo.cs" | Remove-3GlComments -CommentToken "//(.*)?\r?\n"
    Path                         Content
    ----------                   -----------
    C:\SourceCode\Foo.cs         [Content from the file with single line comments removed]

    Here the use of Get-Content is useful and Remove-3GlComments replaces single line comment on
    string read using the Get-Content Cmdlet.

    .EXAMPLE
    Get-Content -Path "C:\SourceCode\Foo.cs" | Remove-3GlComments -CommentToken "//(.*)?\r?\n" -OutputPropertyName1 "File" -OutputPropertyName2 "Line"
    File                         Line
    ----------                   -----------
    C:\SourceCode\Foo.cs         [Content from the file with single line comments removed]

    Here the use of Get-Content is useful and Remove-3GlComments replaces single line comment on
    string read using the Get-Content Cmdlet.

    .NOTES
    While using the Cmdlet for multiline comment remember to use the regex switch ?s to treat the incoming 
    stream of text as single line.

#>
Function Remove-3GlComments {
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory = $False
        )]
        [Switch]
        $SingleLine = $False,
        
        [Parameter(
            Mandatory = $False
        )]
        [Switch]
        $UsePath = $False,

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
            Mandatory = $False,
            ValueFromPipelineByPropertyName = $True
        )]
        [String]
        $Content,
        
        [Parameter(
            Mandatory = $True,
            ValueFromPipelineByPropertyName = $True
        )]
        [ValidateNotNullOrEmpty()]
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