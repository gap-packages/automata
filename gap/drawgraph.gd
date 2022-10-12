#############################################################################
##
#W  drawgraph.gd      GAP library     Manuel Delgado <mdelgado@fc.up.pt>
#W                                     Jose Morais    <josejoao@fc.up.pt>
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##

#Siegen
# ############################################################################
# ##
# #V  DrawingsExtraFormat
# ##
# ##  This variable holds a string which is a dot output format.
# ##  If it is different from "none", any drawing will generate also
# ##  an output in this format.
# ##
# if not IsBound(DrawingsExtraFormat) then
#     BindGlobal( "DrawingsExtraFormat", "none" );
# fi;


# ############################################################################
# ##
# #V  DrawingsListOfExtraFormats
# ##
# ##  This variable holds a list of possible dot output formats.
# ##
# BindGlobal( "DrawingsListOfExtraFormats", ["dia", "fig", "gd", "gd2", "gif", "hpgl", "jpg", "mif", "mp", "pcl", "pic", "plain", "plain-ext", "png", "ps", "ps2", "svg", "svgz", "vrml", "vtx", "wbmp", "none"]);

# ############################################################################
# ##
# #F  SetDrawingsExtraFormat(f)
# ##
# ##  This function sets the value of DrawingsExtraFormat to <f>.
# ##
# DeclareGlobalFunction( "SetDrawingsExtraFormat" );

# ############################################################################
# ##
# #V  DrawingsExtraGraphAttributes
# ##
# ##  This variable holds a list of strings, each of which defines a dot graph attribute.
# ##  For example if we wanted to define the graph size to be 7x9, we would call
# ##  SetDrawingsExtraGraphAttributes(["size=7,9"]);
# ##  to set the size attribute, and DrawingsExtraGraphAttributes would become = ["size=7,9"].
# ##  If we also wanted to define the graph to be displayed in landscape mode
# ##  we would call
# ##  SetDrawingsExtraGraphAttributes(["size=7,9", "rotate=90"]);
# ##  and DrawingsExtraGraphAttributes would become = ["size=7,9", "rotate=90"].
# ##  If DrawingsExtraGraphAttributes = "none" then the default dot settings will be used.
# ##  Use ClearDrawingsExtraGraphAttributes() to set it to "none".
# ##
# BindGlobal( "DrawingsExtraGraphAttributes", "none" );

# ############################################################################
# ##
# #F  SetDrawingsExtraGraphAttributes(L)
# ##
# ##  This function sets the value of DrawingsExtraGraphAttributes to <L>.
# ##  For example if we wanted to define the graph size to be 7x9, we would call
# ##  SetDrawingsExtraGraphAttributes(["size=7,9"]);
# ##
# DeclareGlobalFunction( "SetDrawingsExtraGraphAttributes" );

# ############################################################################
# ##
# #F  ClearDrawingsExtraGraphAttributes()
# ##
# ##  This function sets DrawingsExtraGraphAttributes to "none"
# ##  Thus indicating that the graph should be drawn with dot's default parameters.
# ##
# DeclareGlobalFunction( "ClearDrawingsExtraGraphAttributes" );


#========================================================================
# This function parses the arguments for the functions DrawAutomaton and DrawSCCAutomaton.
#------------------------------------------------------------------------
DeclareGlobalFunction( "AUX__parseDrawAutArgs" );


#========================================================================
# This function writes the .dot file specifying a graph.
# It is used by DrawAutomaton and DrawSCCAutomaton.
#------------------------------------------------------------------------
DeclareGlobalFunction( "WriteDotFileForGraph" );

#############################################################################
##
#F  DotStringForDrawingGraph( <G> ) . . . . . . . . . . . 
## outputs a string consisting of dot code for a graph
##
DeclareGlobalFunction( "DotStringForDrawingGraph" );
#############################################################################
##
#F  DotStringForDrawingAutomaton( <G> ) . . . . . . . . . . . 
## outputs a string consisting of dot code for a graph
##
DeclareGlobalFunction( "DotStringForDrawingAutomaton" );
############################################################################
##
#F DotStringForDrawingTwoAutomata( [ <A> , <B> ] )  . . . . . . . . Prepares a file in the DOT
## language to draw the automaton B and showing the automaton A as a 
## subautomaton.
##
DeclareGlobalFunction( "AUX__DotStringForDrawingSubAutomaton" );
DeclareGlobalFunction( "DotStringForDrawingSubAutomaton" );

#############################################################################
##
#F DotStringForDrawingSCCAutomaton( <A> ) . . . . . . . . Prepares a file in the DOT language
## to draw automaton A using the dot language. The strongly connected components are 
## emphasized.
##
DeclareGlobalFunction( "DotStringForDrawingSCCAutomaton" );

#############################################################################
##
#F  DrawAutomata( <A>, fich ) . . . . . . . . . . .  produces a ps file with the
## automaton A using the dot language and stops after showing it
##
#Siegen DeclareGlobalFunction( "DrawAutomata" );
#############################################################################
##
#F DrawSCCAutomaton( <A>, fich ) . . . . . . . .  produces a ps file with the
## automaton A using the dot language. The strongly connected components are 
## emphasized.
##
#Siegen DeclareGlobalFunction( "DrawSCCAutomaton" );

#E

#Siegen: to be removed

# ##==========================================================
# ##This function returns a temporary directory (used to write .dot files).
# ##----------------------------------------------------------
# if not IsBound(CMUP__getTempDir) then
#     BindGlobal("CMUP__getTempDir", function()
#         local   tdir;
        
#         tdir := DirectoryTemporary();
#         if tdir = fail then
#             tdir := Directory(GAPInfo.UserHome);
#         fi;
#         return tdir;
#     end);
# fi;
# ##----  End of CMUP__getTempDir()  ---- 
# ##==========================================================


# ##==========================================================
# ##This function finds and returns a postscript viewer.
# ##----------------------------------------------------------
# if not IsBound(CMUP__getPsViewer) then
#     BindGlobal("CMUP__getPsViewer", function()
#         local   path,  gv;
        
#         path := DirectoriesSystemPrograms();
#         gv := Filename( path, "evince" );
#         if gv = fail then
#             gv := Filename( path, "ggv" );
#         fi;
#         if gv = fail then
#             gv := Filename( path, "gsview32" );
#         fi;
#         if gv = fail then
#             gv := Filename( path, "gsview64" );
#         fi;
#         if gv = fail then
#             gv := Filename( path, "gv" );
#         fi;
#         if gv = fail then
#             Error("Please install evince, ggv, gsview or gv");
#         fi;
#         return gv;
#     end);
# fi;
# ##----  End of CMUP__getPsViewer()  ---- 
# ##==========================================================


# ##==========================================================
# ##This function finds and returns the dot executable
# ##----------------------------------------------------------
# if not IsBound(CMUP__getDotExecutable) then
#     BindGlobal("CMUP__getDotExecutable", function()
#         local   path,  dot,  d__,  name__,  s1__;
        
#         path := DirectoriesSystemPrograms();
#         if ARCH_IS_UNIX( ) then
#             dot := Filename( path, "dot" );
#         elif ARCH_IS_WINDOWS( ) then
#             for d__ in path do
#                 name__ := LowercaseString(Filename(d__, ""));
#                 s1__ := ReplacedString(name__, "graphviz", "xx");
#                 if s1__ <> name__ then
#                     dot := Filename( d__, "dot" );
#                     break;
#                 fi;
#             od;
#         else

#         fi;
#         if dot = fail then
#             Error("Please install GraphViz ( https://www.graphviz.org )");
#         fi;
#         return dot;
#     end);
# fi;
# ##----  End of CMUP__getDotExecutable()  ---- 
# ##==========================================================


# ##==========================================================
# ##This function executes dot and displays the postscript file.
# ##----------------------------------------------------------
# if not IsBound(CMUP__executeDotAndViewer) then
#     BindGlobal("CMUP__executeDotAndViewer", function(tdir, dot, gv, name)
#         local params, gatt, att;
        
#         params := ["-Tps", "-o", Concatenation(name, ".ps"), name];
#         if DrawingsExtraGraphAttributes <> "none" then
#             gatt := [];
#             for att in DrawingsExtraGraphAttributes do
#                 Add(gatt, Concatenation("-G", att));
#             od;
#             params := Concatenation(gatt, params);
#         fi;
#         Process(tdir, dot, InputTextUser(), OutputTextUser(), params);
#         Print(Concatenation("Displaying file: ", Filename(tdir, name), ".ps\n"));
#         if DrawingsExtraFormat <> "none" then
#             params := [Concatenation("-T", DrawingsExtraFormat), "-o", Concatenation(name, ".", DrawingsExtraFormat), name];
#             if DrawingsExtraGraphAttributes <> "none" then
#                 gatt := [];
#                 for att in DrawingsExtraGraphAttributes do
#                     Add(gatt, Concatenation("-G", att));
#                 od;
#                 params := Concatenation(gatt, params);
#             fi;
#             Process(tdir, dot, InputTextUser(), OutputTextUser(), params);
#             Print(Concatenation("The extra output format file: ", Filename(tdir, name), ".", DrawingsExtraFormat, "\nhas also been created.\n"));
#         fi;
#         if ARCH_IS_UNIX( ) then
#             Exec(Concatenation("cd ", Filename(tdir, ""), "; ", gv, Concatenation(" ", name, ".ps 2>/dev/null 1>/dev/null &")));
#         elif ARCH_IS_WINDOWS( ) then
#             Process(tdir, gv, InputTextUser(), OutputTextUser(), [Concatenation(name, ".ps")]);
#         else

#         fi;
#     end);
# fi;
# ##----  End of CMUP__executeDotAndViewer()  ---- 
# ##==========================================================


