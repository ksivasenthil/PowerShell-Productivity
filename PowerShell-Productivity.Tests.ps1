#Declare variables to point to the folders relevant for the tess
$TestDataDirectory =  ".\TestData";
$ScriptDirectory = ".\Public";

#Dotsource all the alpha test data 
Get-ChildItem -Path $TestDataDirectory -Recurse -Filter "*.ps1" | ForEach-Object {
    . $_.FullName;
};

#Dotsource all the scripts in the Public folder
Get-ChildItem -Path $ScriptDirectory -Recurse -Filter "*.ps1" | ForEach-Object {
    . $_.FullName;
}

Invoke-Pester