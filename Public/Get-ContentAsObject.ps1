<#
    .SYNOPSIS
    Content of a file is read and returned as PSCustomObject.
    .DESCRIPTION
    Under the hoods the Cmdlet uses Get-Content and the returned String / String[] is yielded as PSCustomObject. 
    .PARAMETER OutputPropertyName1
    Optional string parameter. 
    Used to name the property which will carry the path of the file which is read.
    Defaults to Path.
    .PARAMETER OutputPropertyName2
    Optional string parameter.
    Used to name the property which will carry the content of the line or entire file.
    Defaults to Content.
    .PARAMETER AsString
    Optional switch parameter.
    Used to instruct Cmdlet to read all content of file in a single operation.
    Without this switch the content is read one line at a time and yielded as string array.
    .PARAMETER Path
    Mandatory string parameter.
    The path (preferrably Fully Qualified Path (FQP)) to the file which has to be read.
    .EXAMPLE
    .NOTES
    The Cmdlet might be look archaic particularly when you could use Get-Content directly.
    It is true. However the intent of this Cmdlet is not provide you alternative to Get-Content.
    Intent of this Cmdlet is yield a PSCustomObject which could be used to pipeline other Cmdlets to operate on the content of a file.
    Without such an object nested ForEach-Object will have to be used.
#>
Function Get-ContentAsObject {
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory = $False,
            ValueFromPipelineByPropertyName = $True
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $OutputPropertyName1 = "Path",
        
        [Parameter(
            Mandatory = $False,
            ValueFromPipelineByPropertyName = $True
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $OutputPropertyName2 = "Content",
        
        [Parameter(
            Mandatory = $False,
            ValueFromPipelineByPropertyName = $False
        )]
        [Switch]
        $AsString,
        
        [Parameter(
            Mandatory = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Path/location of the file which you want to be read, preferrably Fully Qualified Path."
        )]
        [ValidateScript( {
                if ((Test-Path -Path $_ -PathType Leaf)) {
                    $true;
                }
                else {
                    Write-Verbose $_;
                    throw "Path you have specified does not exist! Please validate verify and invoke the Cmdlet again."
                }
            })]
        [Alias("SourceFile", "p", "sf")]
        [String]
        $Path
    )
    Begin {

    }
    Process {
        if ($AsString) {
            Get-Content -Path $Path `
                -Raw `
                | `
                Select-Object -Property `
            @{
                n = $OutputPropertyName1;
                e = {
                    $Path;
                }
            }, `
            @{
                n = $OutputPropertyName2;
                e = {
                    $_;
                }
            };
    }
    else {
        Get-Content -Path $Path `
            | `
            Select-Object -Property `
        @{
            n = $OutputPropertyName1;
            e = {
                $Path;
            }
        }, `
        @{
            n = $OutputPropertyName2;
            e = {
                $_;
            }
        }
    };
}
}
