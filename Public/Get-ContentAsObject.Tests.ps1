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
        Mock Get-Content `
            -Verifiable `
            -ParameterFilter {
            $Path -ne "foo"
        } `
            -MockWith {
            return "$TestDataDirectory\VanillaFile.txt";
        };
        It "Should read the content and yield one line at a time" {
            Get-ContentAsObject -Path . `
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
                -Path . `
                | `
                Select-Object -Property PSCustomObject `
                | `
                Select-Object -ExpandProperty Properties;
            $result[0] | Should Be "File";
            $result[1] | Should Be "Line";

        }

        It "Should report error if reading non-ASCII files" {
            Mock Get-Content -Verifiable `
                -MockWith {
                return "$TestDataDirectory\EncodingModifiedFile.txt";
            }
            #Check the BOM of file by reading it as byte stream.
        }
        Assert-VerifiableMock;
    }

    Context "Given a file path and switch to read all content at once" {
        Mock Get-Content -Verifiable `
            -MockWith {
            return "$TestDataDirectory\EolModifiedFile.txt"
        }
        It "Should read the content and yield a string" {

        }

        It "Should preserve the new line characters when read as single string" {
            #Need some research on how to assert this!!
        }
        Assert-VerifiableMock;
    }
}