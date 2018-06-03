$FileList = @(
    [PSCustomObject]@{
        FullName = "HelloWorld.cs"
    },
    [PSCustomObject]@{
        FullName = "HelloWorld.py"
    }
);
$FileListWithSingleLineCommented = @(
    @{
        "Path" = "HelloWorld.js";
        "CommentToken" = "//(.*)?\r?\n"
    }
);
$FileListWithMultipleLineCommented = @(
    @{
        "Path" = "HelloWorld.js";
        "CommentToken" = "/\*(.*)?\*/"
    }
);
$SingleLineCommentFileContent1= @"
                                    //This is Hello World comment;
                                    function HelloWorld() {
                                        //No ref;
                                    }
"@;
$SingleLineCommentFileContent2= @"
                                    //This is Hello//World comment;
                                    function HelloWorld() {
                                        //No ref;
                                    }
"@;

$NoCommentFileContent=@"
                                    function HelloWorld() {

                                    }
"@;

$MultiLineCommentFileConent1=@"
                                /*This is Hello World comment;
                                Spanning multiple lines */
                                function HelloWorld() {
                                    //No ref;
                                }
"@;

$MultiLineCommentFileConent2=@"
                                /*This is Hello World comment;
                                * Spanning multiple lines */
                                function HelloWorld() {
                                    //No ref;
                                }
"@;
