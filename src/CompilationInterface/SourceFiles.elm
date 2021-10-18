module CompilationInterface.SourceFiles exposing (..)


type FileTreeNode blobStructure
    = BlobNode blobStructure
    | TreeNode (List ( String, FileTreeNode blobStructure ))


file____docs_index_html : { utf8 : String }
file____docs_index_html =
    { utf8 = "The compiler replaces this value." }
