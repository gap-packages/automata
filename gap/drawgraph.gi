#############################################################################
##
#W  drawgraph.gi      GAP library     Manuel Delgado <mdelgado@fc.up.pt>
#W                                     Jose Morais    <josejoao@fc.up.pt>
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
##  The functions in this file make use of the external program dot (from
##  the freely available software package graphviz, for graph visualization)
##  to display the graphs.
############################################################################

#Siegen
# ############################################################################
# ##
# #F  SetDrawingsExtraFormat(f)
# ##
# ##  This function sets the value of DrawingsExtraFormat to <f>.
# ##
# InstallGlobalFunction(SetDrawingsExtraFormat, function(f)
#     if not f in DrawingsListOfExtraFormats then
#         Print("The specified format is not valid.\nThe valid formats are:\n", DrawingsListOfExtraFormats, ".\nPlease check  https://www.graphviz.org/doc/info/output.html\nfor more info.\n");
#         return;
#     fi;
#     MakeReadWriteGlobal("DrawingsExtraFormat");
#     DrawingsExtraFormat := f;
#     MakeReadOnlyGlobal("DrawingsExtraFormat");
# end);


# ############################################################################
# ##
# #F  SetDrawingsExtraGraphAttributes(L)
# ##
# ##  This function sets the value of DrawingsExtraGraphAttributes to <L>.
# ##  For example if we wanted to define the graph size to be 7x9, we would call
# ##  SetDrawingsExtraGraphAttributes(["size=7,9"]);
# ##
# InstallGlobalFunction(SetDrawingsExtraGraphAttributes, function(L)
#     if not (IsList(L) and ForAll(L, l -> IsString(l))) then
#         Error("The argument must be a list of strings");
#     fi;
#     MakeReadWriteGlobal("DrawingsExtraGraphAttributes");
#     DrawingsExtraGraphAttributes := L;
#     MakeReadOnlyGlobal("DrawingsExtraGraphAttributes");
# end);

# ############################################################################
# ##
# #F  ClearDrawingsExtraGraphAttributes()
# ##
# ##  This function sets DrawingsExtraGraphAttributes to "none"
# ##  Thus indicating that the graph should be drawn with dot's default parameters.
# ##
# InstallGlobalFunction(ClearDrawingsExtraGraphAttributes, function()
#     MakeReadWriteGlobal("DrawingsExtraGraphAttributes");
#     DrawingsExtraGraphAttributes := "none";
#     MakeReadOnlyGlobal("DrawingsExtraGraphAttributes");
# end);




#========================================================================
# This function parses the arguments for the functions DrawAutomaton and DrawSCCAutomaton.
#------------------------------------------------------------------------
InstallGlobalFunction(AUX__parseDrawAutArgs, function(LA)
    local   A,  fich,  state_names,  states_to_colorize,  l,  s;
    
    A := LA[1];  # the automaton to draw
    fich := "automaton";  # this is a string with the name of the .dot file
    state_names := List([1..A!.states], s -> String(s));  # this is a list of strings with new state names
    states_to_colorize := [];
    
    # ------------------------------------------------------------------------------
    # ----- Treat the arguments ----------------------------------------------------
    # Check if there is a second argument
    if IsBound(LA[2]) then
        if IsString(LA[2]) then  # this is a string with the name of the .dot file
            fich := LA[2];
        elif IsList(LA[2]) and IsString(LA[2][1]) then  # this is a list of strings with new state names
            state_names := LA[2];
            if Length(state_names) <> A!.states then
                Error("The list of new state names must have length equal to the number of states of the automaton");
            fi;
        elif IsList(LA[2]) and IsList(LA[2][1]) and IsPosInt(LA[2][1][1]) then  # this is a list of lists of state numbers to draw in colorize
            states_to_colorize := LA[2];
            for l in states_to_colorize do
                for s in l do
                    if s < 1 or s > A!.states then
                        Error("The states to colorize must be integers in [1 ..", A!.states, "]");
                    fi;
                od;
            od;
        else
            Error("Wrong second argument, please check the manual");
        fi;
        # Check if there is a third argument
        if IsBound(LA[3]) then
            if IsString(LA[3]) then  # this is a string with the name of the .dot file
                fich := LA[3];
            elif IsList(LA[3]) and IsString(LA[3][1]) then  # this is a list of strings with new state names
                state_names := LA[3];
                if Length(state_names) <> A!.states then
                    Error("The list of new state names must have length equal to the number of states of the automaton");
                fi;
            elif IsList(LA[3]) and IsList(LA[3][1]) and IsPosInt(LA[3][1][1]) then  # this is a list of lists of state numbers to draw in colorize
                states_to_colorize := LA[3];
                for l in states_to_colorize do
                    for s in l do
                        if s < 1 or s > A!.states then
                            Error("The states to colorize must be integers in [1 ..", A!.states, "]");
                        fi;
                    od;
                od;
            else
                Error("Wrong third argument, please check the manual");
            fi;
            # Check if there is a fourth argument
            if IsBound(LA[4]) then
                if IsString(LA[4]) then  # this is a string with the name of the .dot file
                    fich := LA[4];
                elif IsList(LA[4]) and IsString(LA[4][1]) then  # this is a list of strings with new state names
                    state_names := LA[4];
                    if Length(state_names) <> A!.states then
                        Error("The list of new state names must have length equal to the number of states of the automaton");
                    fi;
                elif IsList(LA[4]) and IsList(LA[4][1]) and IsPosInt(LA[4][1][1]) then  # this is a list of lists of state numbers to draw in colorize
                    states_to_colorize := LA[4];
                    for l in states_to_colorize do
                        for s in l do
                            if s < 1 or s > A!.states then
                                Error("The states to colorize must be integers in [1 ..", A!.states, "]");
                            fi;
                        od;
                    od;
                else
                    Error("Wrong fourth argument, please check the manual");
                fi;
            fi;
        fi;
    fi;
    # ----- End of  Treat the arguments --------------------------------------------
    # ------------------------------------------------------------------------------
    return [A, fich, state_names, states_to_colorize];
end);


#========================================================================
###########################################################################
##
#F DotStringForDrawingAutomaton
##
## outputs a string consisting of dot code for an automaton
##
#### the code is based on the code for the outdated function WriteDotFileForGraph
## A is an automaton, map a list of states names and states_to_colorize 

  
    
#========================================================================
# This function writes the .dot file specifying a graph.
# It is used by DrawAutomaton and DrawSCCAutomaton.
#
# The argument 'who_called' specifies which function requested the .dot file:
# who_called = 1  --->  DrawAutomaton
# who_called = 2  --->  DrawSCCAutomaton
#------------------------------------------------------------------------
InstallGlobalFunction(WriteDotFileForGraph, function(A, fich, map, states_to_colorize, who_called)
  local  alph, letters, edge_colors, node_colors, T, str, out_str, scc, G, p, 
         q, a, color_of_node, k;
    
    alph := AlphabetOfAutomaton(A);   
    
    # When the alphabet has more than 27 letters, they are given in the form
    if IsList(AlphabetOfAutomatonAsList(A)[1]) then
        letters := AlphabetOfAutomatonAsList(A);
    else
        letters := List(AlphabetOfAutomatonAsList(A), a -> [a]);
    fi;
    
    edge_colors := ["red", "blue", "green", "purple", "orange", "brown", "darksalmon", "darkseagreen", "darkturquoise",
                    "darkviolet", "deeppink", "deepskyblue", "dodgerblue", "firebrick", "forestgreen", "gold"];
    
    if alph > 16 then
        edge_colors := List([1 .. alph], i -> edge_colors[(i mod 16) + 1]);#to reuse colors
    fi;
    
    node_colors := [ "white", "brown", "burlywood", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue",
                     "crimson", "cyan", "darkgoldenrod", "darkkhaki", "darkorange", "darkorchid", "darksalmon", 
                     "darkseagreen", "darkturquoise", "darkviolet", "deeppink", "deepskyblue", "dodgerblue", "firebrick",
                     "forestgreen", "gold", "goldenrod", "green", "greenyellow", "grey", "hotpink", "indianred", "khaki", 
                     "lawngreen", "lightblue", "lightcoral", "lightpink", "lightsalmon", "lightseagreen", "lightskyblue", 
                     "lightslateblue", "lightslategrey", "limegreen", "magenta", "maroon", "mediumaquamarine", "mediumorchid", 
                     "mediumpurple", "mediumseagreen", "mediumspringgreen", "mediumturquoise", "mediumvioletred",
                     "moccasin", "navajowhite", "olivedrab2", "orange", "orangered", "orchid", "palegreen", "paleturquoise", 
                     "palevioletred", "peachpuff", "peru", "pink", "plum", "powderblue", "purple", "red", "rosybrown", "royalblue1", 
                     "saddlebrown", "salmon", "sandybrown", "seagreen", "skyblue", "slateblue", "slategrey", "springgreen", 
                     "steelblue", "tan", "thistle", "tomato", "turquoise", "violet", "violetred", "wheat", "yellow", "yellowgreen" ];

#    tdir := CMUP__getTempDir();
#    name := Filename(tdir, Concatenation(fich, ".dot"));

    # ---------------------------------------------------------------------------------

    T := StructuralCopy(A!.transitions);
    str := "digraph  Automaton{\n";  # the string that will hold the code of the .dot file
    out_str := OutputTextString(str, true);
    
    # ---------------------------------------------------------------------------------
    # If we were called by DrawSCCAutomaton, determine the edges to be drawn with dotted lines
    if who_called = 2 then
        scc := GraphStronglyConnectedComponents(UnderlyingGraphOfAutomaton(A));
        G := [];
        for p in scc do
            for q in p do
                G[q] := p;
            od;
        od;
    fi;
    # ---------------------------------------------------------------------------------
    
    # ---------------------------------------------------------------------------------
    # Write the edges
    for a in [1 .. alph] do
        for p in [1 .. A!.states] do
            if IsList(T[a][p]) then  # this is a nondet or epsilon automaton
                if who_called = 1 then
                    for q in T[a][p] do  # write edge  p --a--> q
                        AppendTo(out_str, "\"", map[p], "\" -> \"", map[q], "\" [label=\"", letters[a], "\",color=", edge_colors[a], "];\n");
                    od;
                elif who_called = 2 then
                    for q in T[a][p] do  # write edge  p --a--> q
                        if p in G[p] and q in G[p] and IsBound(G[p][2]) then
                            AppendTo(out_str, "\"", map[p], "\" -> \"", map[q], "\" [label=\"", letters[a], "\",color=", edge_colors[a], "];\n");
                        else
                            AppendTo(out_str, "\"", map[p], "\" -> \"", map[q], "\" [label=\"", letters[a], "\",color=", edge_colors[a], ",style = dotted];\n");
                        fi;
                    od;
                fi;
            else
                q := T[a][p];
                if q > 0 then
                    if who_called = 1 then
                        AppendTo(out_str, "\"", map[p], "\" -> \"", map[q], "\" [label=\"", letters[a], "\",color=", edge_colors[a], "];\n");
                    elif who_called = 2 then
                        if p in G[p] and q in G[p] and IsBound(G[p][2]) then
                            AppendTo(out_str, "\"", map[p], "\" -> \"", map[q], "\" [label=\"", letters[a], "\",color=", edge_colors[a], "];\n");
                        else
                            AppendTo(out_str, "\"", map[p], "\" -> \"", map[q], "\" [label=\"", letters[a], "\",color=", edge_colors[a], ",style = dotted];\n");
                        fi;
                    fi;
                    
                fi;
            fi;
        od;
    od;
    # ---------------------------------------------------------------------------------
        
    # ---------------------------------------------------------------------------------
    # Prepare the list color_of_node, such that state p will be in color node_colors[k] <==> color_of_node[p] = k
    color_of_node := List([1 .. A!.states], _ -> 1);
    for k in [1 .. Length(states_to_colorize)] do
        for p in states_to_colorize[k] do
            color_of_node[p] := k+1;
        od;
    od;
    # ---------------------------------------------------------------------------------
    
    # ---------------------------------------------------------------------------------
    # Write the nodes
    for p in Difference(A!.initial, A!.accepting) do
        AppendTo(out_str, "\"", map[p], "\" [shape=triangle, style=filled, fillcolor=", node_colors[color_of_node[p]], "];\n");
    od;
    for p in A!.accepting do
        if p in A!.initial then
            AppendTo(out_str, "\"", map[p], "\" [shape=triangle,peripheries=2, style=filled, fillcolor=", node_colors[color_of_node[p]], "];\n");
        else
            AppendTo(out_str, "\"", map[p], "\" [shape=doublecircle, style=filled, fillcolor=", node_colors[color_of_node[p]], "];\n");
        fi;
    od;
    for p in Difference([1 .. A!.states], Concatenation(A!.initial, A!.accepting)) do
        AppendTo(out_str, "\"", map[p], "\" [shape=circle, style=filled, fillcolor=", node_colors[color_of_node[p]], "];\n");
    od;
    AppendTo(out_str,"}","\n");
    # ---------------------------------------------------------------------------------

    CloseStream(out_str);
    #Siegen    PrintTo(name, str);
    
    #Siegen return tdir;
    return str;
    
end);
## ----  End of WriteDotFileForGraph()  ---- 
#========================================================================



#############################################################################
##
#F  DotStringForDrawingAutomaton( arg ) 
##
##  outputs a string consisting of dot code for an automaton
##
InstallGlobalFunction(DotStringForDrawingAutomaton, function(arg)
    local   A,  fich,  state_names,  states_to_colorize,  l,  s,  gv,  
            dot,  tdir, res;

    if Length(arg) = 0 then
        Error("Please give me an automaton to draw");
    fi;
    if not IsAutomatonObj(arg[1]) then
        Error("The first argument must be an automaton");
    fi;
    
    res := AUX__parseDrawAutArgs(arg);  # parse the arguments
    A := res[1];
    fich := res[2];
    state_names := res[3];
    states_to_colorize := res[4];
    
    return WriteDotFileForGraph(A, fich, state_names, states_to_colorize, 1);
end);

#############################################################################
##
#F  DotStringForDrawingGraph( <G> ) . . . . . . . . . . . 
## outputs a string consisting of dot code for a graph
## 
## 
InstallGlobalFunction(DotStringForDrawingGraph, function(G)
  local  dotstr, l, k;

  dotstr := "digraph Graph__{\n";
  # the string that will hold the code of the .dot file
    for l  in [ 1 .. Length( G ) ]  do
        for k  in G[ l ]  do
          Append(dotstr, Concatenation(String(l), " -> "));
          Append(dotstr, Concatenation(String(k)," [style=bold, color=black];\n"));
        od;
    od;

    for k in [1..Length(G)] do
        Append(dotstr, Concatenation(String(k), " [shape=circle];\n"));
    od;
    Append(dotstr,"}\n");
    return(dotstr);
end);

############################################################################
##
#F  AUX__DotStringForDrawingSubAutomaton(  <A> , <B>  )  . . . . . . . . Prepares a file in the DOT
## language to draw the automaton B and showing the automaton A as a
## subautomaton.
##
InstallGlobalFunction(AUX__DotStringForDrawingSubAutomaton, function(A,B)
  local  nome, letters, au, au1, i, j, colors, l2, array, s, arr, max, k, 
         dotstr, l;

    # if not (IsList(A) and 1 < Length(A) and Length(A) < 4 and
    #         IsAutomatonObj(A[1]) and IsAutomatonObj(A[2]) ) then
    #     Error("The argument of dotAutomata is a list of automata");
    # fi;
    
##    tdir := CMUP__getTempDir();
#    if Length(A) = 3 then
#        name := Filename(tdir, Concatenation(String(A[3]), ".dot"));
#        xname := Concatenation(String(A[3]), ".dot");
#        aut1 := A[1];
#        aut2 := A[2];
#    elif Length(A) = 2 then
# 	name := Filename(tdir, "automaton.dot");
#        xname := "automato.dot";
#        aut1 := A[1];
#        aut2 := A[2];
  #    fi;
  

    nome := "Automaton";
#    letters := [];
    letters := List(AlphabetOfAutomatonAsList(A), a -> [a]);
    
    au := StructuralCopy(B!.transitions);
    au1 := StructuralCopy(A!.transitions);
    for i in [1 .. Length(A!.transitions)] do
        for j in [1 .. Length(A!.transitions[1])] do
            if not IsBound(au1[i][j]) or au1[i][j] = 0 or au1[i][j] = [0]
               or au1[i][j] = [] then
                au1[i][j] := " ";
            fi;
        od;
    od;
    for i in [1 .. Length(B!.transitions)] do
        for j in [1 .. Length(B!.transitions[1])] do
            if not IsBound(au[i][j]) or au[i][j] = 0 or au[i][j] = [0]
               or au[i][j] = [] then
                au[i][j] := " ";
            fi;
        od;
    od;

    if B!.alphabet < 7 then     ##  for small alphabets, the letters
                                      ##  a, b, c, d are used
#        letters := ["a", "b", "c", "d", "e", "f"];
        colors := ["red", "blue", "green", "yellow", "brown", "black"];
    else
#        for i in [1 .. B!.alphabet] do
#            Add(letters, Concatenation("a", String(i)));
#        od;
        colors := [];
        for i in [1 .. B!.alphabet] do
            colors[i]:= "black";
        od;
    fi;

    l2 := [];
    array := [];
    s := [];
    arr := List( au, x -> List( x, String ) );
    max := Maximum( List( arr, x -> Maximum( List(x,Length) ) ) );

    for i in [1 .. B!.states] do
        for j in [1 .. B!.alphabet] do
            if IsBound(au[j]) and IsBound(au[j][i]) and
               au[j][i] <> " " then
                if IsList(au[j][i]) then
                    for k in au[j][i] do
                        if i <= A!.states and j <= A!.alphabet and
                           IsBound(au1[j]) and IsBound(au1[j][i]) and k in au1[j][i] and
                             au1[j][i] <> " " then

                            Add(array, [i, " -> ", k," [label=", "\"", letters[j],"\"",",color=", colors[j],"];"]);
                        else
                            Add(array, [i, " -> ", k," [label=", "\"", letters[j],"\"",",color=", colors[j], ",style = dotted];"]);

                        fi;
                    od;
                else
                    if i <= A!.states and j <= A!.alphabet and
                       IsBound(au1[j]) and IsBound(au1[j][i]) and
                          au1[j][i] <> " " then
                        Add(array, [i, " -> ", au[j][i]," [label=", "\"", letters[j],"\"",",color=", colors[j], "];"]);
                    else
                            Add(array, [i, " -> ", au[j][i]," [label=", "\"", letters[j],"\"",",color=", colors[j], ",style = dotted];"]);
                    fi;
                fi;
            fi;

        od;
    od;

    arr := List( array, x -> List( x, String ) );
    
    dotstr :="digraph  Automaton {\n";
 ##   PrintTo(name, "digraph  ", nome, "{", "\n");
    for l  in [ 1 .. Length( arr ) ]  do
        for k  in [ 1 .. Length( arr[ l ] ) ]  do
            Append(dotstr,  String( arr[ l ][ k ]) );
        od;
        if l = Length( arr )  then
            Append(dotstr,  "\n" );
        else
            Append(dotstr,  "\n" );
        fi;
    od;
    for i in A!.initial do
        Append(dotstr, Concatenation(String(i), " [shape=triangle];\n"));
    od;
    for i in Difference(B!.initial,A!.initial) do
        Append(dotstr, Concatenation(String(i), " [shape=triangle,color=gray];\n"));
    od;
    for j in A!.accepting do
        if j in A!.initial then
            Append(dotstr, Concatenation(String(j), " [shape=triangle,peripheries=2];\n"));
        else
            Append(dotstr, Concatenation(String(j), " [shape=doublecircle];\n"));
        fi;
    od;
    for j in Difference(B!.accepting,A!.accepting) do
        if j in B!.initial then
            Append(dotstr, Concatenation(String(i), " [shape=triangle,peripheries=2,color=gray];\n"));
        else
            Append(dotstr, Concatenation(String(j), " [shape=doublecircle,color=gray];n"));
        fi;
    od;
    for k in Difference(Difference([1..A!.states],B!.accepting),Concatenation(A!.initial, B!.initial,A!.accepting)) do
        Append(dotstr, Concatenation(String(k), " [shape=circle];\n"));
    od;
    for k in Difference(Difference([1..B!.states],B!.accepting),Concatenation(A!.initial, B!.initial, [1..A!.states])) do
        Append(dotstr, Concatenation(String(k), " [shape=circle,color=gray];\n"));
    od;
    Append(dotstr,"}\n");
    return(dotstr);
end);

#############################################################################
##
#F  DotStringForDrawingSubAutomaton( <A> , <B> ) 
## outputs a string consisting of dot code for automaton B and showing A as a subautomaton.
##
InstallGlobalFunction(DotStringForDrawingSubAutomaton, function(arg)
  local  A, B, fich, a, q, k, dotstr;

    if not (IsBound(arg[1]) and IsBound(arg[2])) then
        Error("This function takes two automata as arguments");
    fi;
    A := arg[1];
    B := arg[2];
    if not IsAutomatonObj(A) then
        Error("The first argument must be an automaton");
    fi;
    if not IsAutomatonObj(B) then
        Error("The second argument must be an automaton");
    fi;
    if IsBound(arg[3]) then
        if not IsString(arg[3]) or arg[3] = "" then
            fich := "implausible987678";
        else
            fich := arg[3];
        fi;
    else
        fich := "implausible987678";
    fi;

    if A!.states > B!.states or A!.alphabet > B!.alphabet then
        Print("The first argument is not a subautomaton of the second argument.\n");
        return;
    fi;

#    gv := CMUP__getPsViewer();
#    dot := CMUP__getDotExecutable();

    for a in [1 .. A!.alphabet] do
        for q in [1 .. A!.states] do
            k := A!.transitions[a][q];
            if IsInt(k) then
                if not (k = B!.transitions[a][q] or k = 0) then
                    Print("The first argument is not a subautomaton of the second argument.\n");
                    return;
                fi;
            else
                if not ForAll(k, s -> s in B!.transitions[a][q]) then
                    Print("The first argument is not a subautomaton of the second argument.\n");
                    return;
                fi;
            fi;
        od;
    od;
    
    dotstr := AUX__DotStringForDrawingSubAutomaton(A,B);
    return dotstr;
    
    # res := dotAutomata([A,B, fich]);

    # tdir := res[1];
    # name := res[2];
    # CMUP__executeDotAndViewer(tdir, dot, gv, name);
end);
#############################################################################
##
#F  DotStringForDrawingSCCAutomaton( <A>, fich ) . . . . . . . .  produces a ps file with the
## automaton A using the dot language. The strongly connected components are
## emphasized.
##
InstallGlobalFunction(DotStringForDrawingSCCAutomaton, function(arg)
  local  res, A, fich, state_names, states_to_colorize, dotstr;

    if Length(arg) = 0 then
        Error("Please give me an automaton to draw");
    fi;
    if not IsAutomatonObj(arg[1]) then
        Error("The first argument must be an automaton");
    fi;
    
    res := AUX__parseDrawAutArgs(arg);  # parse the arguments
    A := res[1];
    fich := res[2];
    state_names := res[3];
    states_to_colorize := res[4];
    
 dotstr := WriteDotFileForGraph(A, fich, state_names, states_to_colorize, 2);
 return dotstr;
 
    
    # gv := CMUP__getPsViewer();
    # dot := CMUP__getDotExecutable();
    # tdir := WriteDotFileForGraph(A, fich, state_names, states_to_colorize, 2);
    # CMUP__executeDotAndViewer(tdir, dot, gv, Concatenation(fich, ".dot"));
end);

##
#E

