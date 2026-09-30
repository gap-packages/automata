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
  local  alph, letters, colors, T, str, out_str, scc, G, p, 
         q, a, color_of_node, k;

    # ---------------------------------------------------------------------------------
    # List of Colors
    colors := [ "red", "blue", "green", "purple", "orange", "brown", "darksalmon", "darkseagreen", "darkturquoise",
                "darkviolet", "deeppink", "deepskyblue", "dodgerblue", "firebrick", "forestgreen", "gold",
                "brown", "burlywood", "cadetblue", "chartreuse", "chocolate", "coral", "cornflowerblue",
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


    # Setting up Graphviz Environment
    f := GraphvizDigraph("Automaton");
    GraphvizSetAttrs(f, rec(rankdir:="LR", size:="\"8,5\"", layout:="dot"));

    # Extracting all info from automaton
    accepting := FinalStatesOfAutomaton(A);
    initial := InitialStatesOfAutomaton(A);
    T := TransitionMatrixOfAutomaton(A);
    alph := AlphabetOfAutomatonAsList(A);

    # Draw the initial states
    for i in initial do
        GraphvizSetAttrs(GraphvizAddNode(f, Concatenation("in",String(i)) ), rec(shape:="none", label:="\"\""));
        GraphvizAddNode(f, String(i));
        GraphvizAddEdge(f, Concatenation("in",String(i)), String(i));
        for j in [1 .. aut!.states] do  
            GraphvizSetAttr(GraphvizAddEdge(f, String(i), String(j)), "style","invis");
        od;
    od;

    # Draw the accepting/final states.
    accepting := FinalStatesOfAutomaton(aut);
    for i in accepting do
        GraphvizSetAttr(GraphvizAddNode(f, String(i)),"shape","doublecircle");
    od;

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

    # Draw the edges
    if IsDeterministicAutomaton(A) then
        for i in [1..Size(T)] do
            letter := [alphabet[i]];
            for j in [1.. Size(T[i])] do
                if T[i][j] <> 0 then
                    GraphvizSetAttr(GraphvizAddEdge(f, String(j), String(T[i][j])), "label", Concatenation("\"", letter, "\""));
                fi;
            od;
        od;
    else 
        for i in [1..Size(T)] do
            letter := [alphabet[i]];
            for j in [1.. Size(T[i])] do
                for n in T[i][j] do
                    if n <> 0 then
                        GraphvizSetAttr(GraphvizAddEdge(f, String(j), String(n)), "label", Concatenation("\"", letter, "\""));
                    fi;
                od;
            od;
        od;
    fi;

   # ---------------------------------------------------------------------------------
    # Prepare the list color_of_node, such that state p will be in color colors[k] <==> color_of_node[p] = k
    #color_of_node := List([1 .. A!.states], _ -> 1);
    for k in [1 .. Length(states_to_colorize)] do
        for p in states_to_colorize[k] do
            GraphvizSetAttr(String(p), "style", "filled");
            GraphvizSetAttr(String(p), "fillcolor", String(color[k]));
        od;
    od;

    # ---------------------------------------------------------------------------------
    # Write the nodes
    # for p in Difference(A!.initial, A!.accepting) do
    #     AppendTo(out_str, "\"", map[p], "\" [shape=triangle, style=filled, fillcolor=", node_colors[color_of_node[p]], "];\n");
    # od;
    # for p in A!.accepting do
    #     if p in A!.initial then
    #         AppendTo(out_str, "\"", map[p], "\" [shape=triangle,peripheries=2, style=filled, fillcolor=", node_colors[color_of_node[p]], "];\n");
    #     else
    #         AppendTo(out_str, "\"", map[p], "\" [shape=doublecircle, style=filled, fillcolor=", node_colors[color_of_node[p]], "];\n");
    #     fi;
    # od;
    # for p in Difference([1 .. A!.states], Concatenation(A!.initial, A!.accepting)) do
    #     AppendTo(out_str, "\"", map[p], "\" [shape=circle, style=filled, fillcolor=", node_colors[color_of_node[p]], "];\n");
    # od;
    # AppendTo(out_str,"}","\n");
    # ---------------------------------------------------------------------------------

    Splash(f,rec(filename:=fich,path:="./",filetype:="dot"));
    
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
  local  f, l, k;

    f := GraphvizDigraph(name);
    GraphvizSetAttrs(f, rec(rankdir:="LR", size:="\"8,5\"", layout:="dot"));
    GraphvizSetAttr(f, "node [shape = circle]");

    for l  in [ 1 .. Length( G ) ]  do
        for k  in G[ l ]  do
            GraphvizAddEdge(f,String(l), String(k));
        od;
    od;

    return AsString(f)
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


    nome := "Automaton";

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
        colors := ["red", "blue", "green", "yellow", "brown", "black"];
    else
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

end);

##
#E

