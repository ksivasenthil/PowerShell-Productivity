$FileList = @(
    [PSCustomObject]@{
        FullName = "HelloWorld.cs"
    },
    [PSCustomObject]@{
        FullName = "HelloWorld.py"
    }
);
$FileListWithUncommentedFiles = @(
    [PSCustomObject]@{
        SourceFile = "HelloWorld.js";
        UncommentedFile = "HelloWorld.js.uncommented"
    }
);
$SingleLineFileContentWithComment= @"
                                    //This is Hello World comment;
                                    function HelloWorld() {
                                        //No ref;
                                    }
"@;

$SingleLineFileContentWithNoComment=@"
                                    function HelloWorld() {

                                    }
"@;
