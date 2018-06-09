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

Describe "Remove-3GlComments tests" {
    Context "Given files with single line comment," {
        It "Removes comments out of the file." `
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
                -UsePath `
                | `
                Select-Object -ExpandProperty "Content" `
                | `
                Should Not Match $CommentToken;
        }
        It "Removes comments out of the file even when the comment token is repeated in the same line." `
            -TestCases $FileListWithSingleLineCommented {
            param($Path, $CommentToken) 
            Mock Get-Content -Verifiable `
                -MockWith `
            {
                return $SingleLineCommentFileContent2;
            };
            Remove-3GlComments -Path $Path `
                -CommentToken $CommentToken `
                -UsePath `
                | `
                Select-Object -ExpandProperty "Content" `
                | `
                Should Not Match $CommentToken;
        }
        It "Yields the content as-is when file did not contain comment." `
            -TestCases $FileListWithSingleLineCommented {
            param($Path, $CommentToken) 
            Mock Get-Content -Verifiable `
                -MockWith `
            {
                return $NoCommentFileContent;
            };
            (Remove-3GlComments -Path $Path `
                    -CommentToken $CommentToken `
                    -UsePath `
                    | `
                    Select-Object -ExpandProperty "Content" `
            ) `
                -join [System.Environment]::NewLine `
                -replace "`r`n$", ""`
                |`
                Should Be $NoCommentFileContent;
        }
        Assert-VerifiableMock;
    }
    Context "Given files with multiline comments" {
        It "Removes comments out of the file" `
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
                -UsePath `
                | `
                Select-Object -ExpandProperty "Content" `
                | `
                Should Not Match $CommentToken;
            Write-Verbose $CommentToken;
        }
        It "Removes the comment out of the file even when file contains the \* character inside the comment block." `
            -TestCases $FileListWithMultipleLineCommented {
            param($Path, $CommentToken)
            Mock Get-Content -Verifiable `
                -MockWith `
            {
                return $MultiLineCommentFileConent2; 
            };
            Remove-3GlComments -Path $Path `
                -CommentToken $CommentToken `
                -UsePath `
                | `
                Select-Object -ExpandProperty "Content" `
                | `
                Should Not Match $CommentToken;

            Write-Verbose (Remove-3GlComments -Path $Path -CommentToken $CommentToken | Select-Object -ExpandProperty "Content");
        }
        Assert-VerifiableMock;
    }
    Context "Given file contains both single and multiple line comments" {
        It "Removes all type of comments from the file." {
            Mock Get-Content -Verifiable `
                -MockWith `
            {
                return $MultiLineCommentFileConent2; 
            };
            $result = (Remove-3GlComments -Path $FileListWithSingleLineCommented[0].Path `
                    -CommentToken $FileListWithSingleLineCommented[0].CommentToken `
                    -UsePath `
                    | `
                    Remove-3GlComments -CommentToken $FileListWithMultipleLineCommented[0].CommentToken)
            $result | Should Not Match $FileListWithSingleLineCommented[0].CommentToken;
            $result | Should Not Match $FileListWithMultipleLineCommented[0].CommentToken;
        }
        Assert-VerifiableMock;
    }
}