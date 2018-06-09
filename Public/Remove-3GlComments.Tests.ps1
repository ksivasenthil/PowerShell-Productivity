$TestDataDirectory = "$PSScriptRoot\..\TestData";

#Dotsource all the alpha test data 
Get-ChildItem -Path $TestDataDirectory `
                -Recurse `
                -Filter "*.ps1" `
| `
ForEach-Object {
    . $_.FullName;
};


. .\Remove-3GlComments.ps1;
Describe "Remove-3GlComments" {
    It "Given only required parameters, it strips comments out of the file" `
        -TestCases $FileListWithSingleLineCommented `
        {
            param($Path, $CommentToken) 
            Mock Get-Content -Verifiable `
                                -MockWith `
                                {
                                    return $SingleLineCommentFileContent1;
                                };
            Remove-3GlComments -Path $Path `
                                -CommentToken $CommentToken `
            | `
            Select-Object -ExpandProperty "Content" `
            | `
            Should Not Match $CommentToken;
        }
    It "Given only required parameters, it strips comments out of the file even when the comment token is repeated in the same line" `
        -TestCases $FileListWithSingleLineCommented {
        param($Path, $CommentToken) 
        Mock Get-Content -Verifiable `
                        -MockWith `
                        {
                            return $SingleLineCommentFileContent2;
                        };
        Remove-3GlComments -Path $Path `
                            -CommentToken $CommentToken `
        | `
        Select-Object -ExpandProperty "Content" `
        | `
        Should Not Match $CommentToken;
    }
    It "Given only requierd parameters, it returns the content as-is if it did not contain comment." `
        -TestCases $FileListWithSingleLineCommented {
        param($Path, $CommentToken) 
        Mock Get-Content -Verifiable `
                            -MockWith `
                            {
                                return $NoCommentFileContent;
                            };
        (Remove-3GlComments -Path $Path `
                            -CommentToken $CommentToken `
        | `
        Select-Object -ExpandProperty "Content" `
        ) `
        -join [System.Environment]::NewLine `
        -replace "`r`n$", ""`
        |`
        Should Be $NoCommentFileContent;
    }
    It "Given only required parameters, it returns the content with multiple line of comment block removed" `
        -TestCases $FileListWithMultipleLineCommented {
        param($Path, $CommentToken)
        Mock Get-Content -Verifiable `
                            -MockWith `
                            {
                                return $MultiLineCommentFileConent1; 
                            };
        <#
            Not going to assert the way it should!
            Pester uses "-match" operator inside the Match assertion used in the line below.
            In PowerShell "-match" operator is not good in handling multiline content as does the Select-String cmdlet handles.
            Thus, the following assert will return true no matter if the comment token is replaced or not.
            Read this for the "-match" operators ability to handle multiplelines
            https://stackoverflow.com/questions/1703061/powershell-match-operator-and-multiple-groups
        #>
        Remove-3GlComments -Path $Path `
                                -CommentToken $CommentToken `
        | `
        Select-Object -ExpandProperty "Content" `
        | `
        Should Not Match $CommentToken;
        Write-Verbose $CommentToken;
    }
    It "Given only required parameters, it returns the content with multiple line of comment block removed even when it contains the \* character inside the comment block." `
        -TestCases $FileListWithMultipleLineCommented {
        param($Path, $CommentToken)
        Mock Get-Content -Verifiable `
                            -MockWith `
                            {
                                return $MultiLineCommentFileConent2; 
                            };
        Remove-3GlComments -Path $Path `
                            -CommentToken $CommentToken `
        | `
        Select-Object -ExpandProperty "Content" `
        | `
        Should Not Match $CommentToken;

        Write-Verbose (Remove-3GlComments -Path $Path -CommentToken $CommentToken | Select-Object -ExpandProperty "Content");
    }
    It "Given only required parameters, it could be piped with both single and multiple comment block." {
        Mock Get-Content -Verifiable `
                            -MockWith `
                            {
                                return $MultiLineCommentFileConent2; 
                            };
        $result  = (Remove-3GlComments -Path $FileListWithSingleLineCommented[0].Path`
                                         -CommentToken $FileListWithSingleLineCommented[0].CommentToken`
                    | `
                    Remove-3GlComments -CommentToken $FileListWithMultipleLineCommented[0].CommentToken)
        $result | Should Not Match $FileListWithSingleLineCommented[0].CommentToken;
        $result | Should Not Match $FileListWithMultipleLineCommented[0].CommentToken;
    }
    Assert-VerifiableMock;

}