$TestDataDirectory = "$PSScriptRoot\..\TestData";

#Dotsource all the alpha test data 
Get-ChildItem -Path $TestDataDirectory `
    -Recurse `
    -Filter "*.ps1" `
    | `
    ForEach-Object {
    . $_.FullName;
};


. .\Get-ContentAsObject.ps1;

Describe "Get-ContentAsObject" {
    Context "Given a file path" {
        It "Should read the content and yield one line at a time" {
            Get-ContentAsObject -Path "$TestDataDirectory\VanillaFile.txt" `
                | `
                Measure-Object `
                | `
                Select-Object -ExpandProperty Count `
                | `
                Should BeGreaterThan 2;
        }

        It "Should report error if the file path is invalid" {
            {
                Get-ContentAsObject -Path "foo";
            } `
                | `
                Should Throw

        }

        It "Should allow customization of output property names" {
            $result = Get-ContentAsObject -OutputPropertyName1 "File" `
                -OutputPropertyName2 "Line" `
                -Path "$TestDataDirectory\VanillaFile.txt" `
                | `
                Get-Member `
                | `
                Where-Object {$_.MemberType -eq "NoteProperty"};
            $result[0] | Select-Object -ExpandProperty Name | Should Be "File";
            $result[1] | Select-Object -ExpandProperty Name |  Should Be "Line";

        }

        It "Should report error if reading non-ASCII files" {
            Get-Content -Path "$TestDataDirectory\EncodingModifiedFile.txt" | Should Throw;
        }
    }

    Context "Given a file path and switch to read all content at once" {
        It "Should read the content and yield a string" {
            Get-ContentAsObject -Path "$TestDataDirectory\VanillaFile.txt" `
                -AsString `
                | `
                Measure-Object `
                | `
                Select-Object -ExpandProperty Count `
                | `
                Should BeExactly 1;
        }

        It "Should preserve the new line characters when read as single string" {
            Get-ContentAsObject -Path "$TestDataDirectory\EolModifiedFile.txt" `
                -AsString `
                | `
                Select-Object -ExpandProperty Content `
                | `
                Should Match "(?sm)\r\n$";
        }
    }
}