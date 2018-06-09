$TestDataDirectory = "$PSScriptRoot\..\TestData";

#Dotsource all the alpha test data 
Get-ChildItem -Path $TestDataDirectory `
                -Recurse `
                -Filter "*.ps1" `
| `
ForEach-Object {
    . $_.FullName;
};


. .\Get-FileNamesByExtension.ps1;

Describe "Get-FileNamessByExtension" {
    Mock Get-ChildItem -Verifiable `
                        -MockWith `
                        {
                            return $FileList;
                        };

    It "Given no extension, it lists only cs files" {
        Get-FileNamesByExtension -Path . `
        | `
        Where-Object `
        {
            $_.Path -match "\.cs";
        } `
        | `
        Select-Object -ExpandProperty Path `
        | `
        Should Be "HelloWorld.cs" 
    }

    It "Given an extension, it should only list the respective file with that extension" {
        Get-FileNamesByExtension -Path . `
                                -Extension "py" `
        | `
        Where-Object `
        {
            $_.Path -match "\.py";
        } `
        | `
        Select-Object -ExpandProperty Path `
        | `
        Should Be "HelloWorld.py"
    }

    It "Given an extention for which there is no file, it should return an empty array" {
        Get-FileNamesByExtension -Path . `
                                    -Extension "csproj" `
        | `
        Where-Object `
        {
            $_.Path -match "\.csproj";
        } `
        | `
        Select-Object -ExpandProperty Path `
        | `
        Should BeNullOrEmpty
    }

    Assert-VerifiableMock;
}