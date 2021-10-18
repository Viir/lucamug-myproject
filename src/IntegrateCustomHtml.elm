module IntegrateCustomHtml exposing (..)

import CompilationInterface.ElmMake
import CompilationInterface.SourceFiles


htmlMain : String
htmlMain =
    String.replace "<script src='elm.js'></script>"
        (String.join "\n" [ "<string>", CompilationInterface.ElmMake.elm_make____src_Main_elm.javascript.utf8, "</string>" ])
        CompilationInterface.SourceFiles.file____docs_index_html.utf8
