#Declare variables to point to the folders relevant for the tess
$TestDataDirectory = "$PSScriptRoot\TestData";
$ScriptDirectory = "$PSScriptRoot\Public";

#Dotsource all the alpha test data 
Get-ChildItem -Path $TestDataDirectory `
                -Recurse `
                -Filter "*.ps1" `
| `
ForEach-Object {
    . $_.FullName;
};

#Dotsource all the scripts in the Public folder
Get-ChildItem -Path $ScriptDirectory `
                -Recurse `
                -Filter "*.ps1" `
| `
ForEach-Object {
    . $_.FullName;
}

$VerbosePreference="Contine";
Describe "Alpha test mocking feature of Pester" {
    #Setting up mocks for the alpha tests
    Mock Get-ChildItem -Verifiable `
                        -MockWith `
                        {
                            return $FileList;
                        };

    It "Verify if the mock is set properly" {
        Get-ChildItem `
        | `
        Should BeOfType [PSCustomObject][];
    }
    
    Assert-VerifiableMock;
}