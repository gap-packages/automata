#############################################################################
##
#W  drawgraph.gi      GAP library     Manuel Delgado <mdelgado@fc.up.pt>
#W                                     Jose Morais    <jjoao@netcabo.pt>
##
#H  @(#)$Id: drawgraph.gi,v 1.0 $
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
##  The functions in this file make use of the external program dot (from
##  the freely available software package graphviz, for graph visualization)
##  to display the graphs.
############################################################################
##
#F  dotAutomaton( <A>, fich ) . . . . . . . . . . . Prepares a file in the DOT
## language to draw the automaton A using dot
##
InstallGlobalFunction(dotAutomaton, function(A, fich)
    local au, aut, l1, l2,  arr, array, colors, i, j, k, letters, max, name,
          nome, R, l, s, t;
    
    name := Concatenation("~/dot-tmp/", fich, ".dot");
    aut := A;

    nome := "Automaton";
    letters := [];
    au := StructuralCopy(aut!.transitions);
    for i in [1 .. Length(aut!.transitions)] do
        for j in [1 .. Length(aut!.transitions[1])] do
            if not IsBound(au[i][j]) or au[i][j] = 0 or au[i][j] = [0] then
                au[i][j] := " ";
            fi;
        od;
    od;
    
    if IsInt(FamilyObj(aut)!.alphabet) then
        if aut!.alphabet < 7 then       ##  for small alphabets, the letters
                                        ##  a, b, c, d are used
            letters := ["a", "b", "c", "d", "e", "f"];
            colors := ["red", "blue", "green", "yellow", "brown", "black"];
        else
            for i in [1 .. aut!.alphabet] do
                Add(letters, Concatenation("a", String(i)));
            od;
            colors := [];
            for i in [1 .. aut!.alphabet] do
                colors[i]:= "black";
            od;
        fi;
    else
        if aut!.alphabet < 7 then       ##  for small alphabets, the letters
                                        ##  a, b, c, d are used
            letters := [];
            for i in FamilyObj(A)!.alphabet do
                Add(letters, [i]);
            od;
            colors := ["red", "blue", "green", "yellow", "brown", "black"];
        else
            letters := [];
            for i in FamilyObj(A)!.alphabet do
                Add(letters, [i]);
            od;
            colors := [];
            for i in [1 .. aut!.alphabet] do
                colors[i]:= "black";
            od;
        fi;
    fi;
    if aut!.type = "epsilon" then
        letters[aut!.alphabet] := "@";
    fi;
    l2 := [];
    array := [];
    s := [];
    arr := List( au, x -> List( x, String ) );
    max := Maximum( List( arr, x -> Maximum( List(x,Length) ) ) );

    for i in [1 .. aut!.states] do
        for j in [1 .. aut!.alphabet] do
            if IsBound(au[j]) and IsBound(au[j][i]) and
               au[j][i] <> " " then
                if IsList(au[j][i]) then
                    for k in au[j][i] do
                        Add(array, [i, " -> ", k," [label=", "\"", letters[j],"\"",",color=", colors[j], "];"]);
                    od;
                else
                    Add(array, [i, " -> ", au[j][i]," [label=", "\"", letters[j],"\"",",color=", colors[j], "];"]);
                fi;
            fi;

        od;
    od;

    arr := List( array, x -> List( x, String ) );

    PrintTo(name, "digraph  ", nome, "{", "\n");
    for l  in [ 1 .. Length( arr ) ]  do
        for k  in [ 1 .. Length( arr[ l ] ) ]  do
            AppendTo(name,  String( arr[ l ][ k ]) );
 #           if k = Length( arr[ l ] )  then
 #               AppendTo(name,  " " );
 #           else
 #               AppendTo(name,  " " );
 #           fi;
        od;
        if l = Length( arr )  then
            AppendTo(name,  "\n" );
        else
            AppendTo(name,  "\n" );
        fi;
    od;
    for i in Difference(aut!.initial, aut!.accepting) do
        AppendTo(name, i, " [shape=triangle];","\n");
    od;
    for j in aut!.accepting do
        if j in aut!.initial then
            AppendTo(name, j, " [shape=triangle,peripheries=2];","\n");
        else
            AppendTo(name, j, " [shape=doublecircle];","\n");
        fi;
    od;
    for k in Difference([1..aut!.states],Concatenation(aut!.initial, aut!.accepting)) do
        AppendTo(name, k, " [shape=circle];","\n");
    od;
    AppendTo(name,"}","\n");
end);
#############################################################################
##
#F  DrawAutomaton( arg ) . . . . . . . . . . .  produces a ps file with the
##  automaton A using the dot language and stops after showing it
##
InstallGlobalFunction(DrawAutomaton, function(arg)
    local path, gv;
    
    if Length(arg) = 0 then
        Error("Please give me an automaton to draw");
    fi;
    path := DirectoriesSystemPrograms();
    gv := Filename( path, "gv" );
    if gv = fail then
        gv := Filename( path, "ggv" );
        if gv = fail then
            Error("Please install gv or ggv");
        fi;
    fi;
    if IsBound(arg[2]) then
        dotAutomaton(arg[1], arg[2]);
        Exec(Concatenation("dot -Tps ~/dot-tmp/", arg[2], ".dot -o ~/dot-tmp/", arg[2], ".ps"));
        Exec(Concatenation(gv, " ~/dot-tmp/", arg[2], ".ps &"));
    else
        dotAutomaton(arg[1], "automaton");
        Exec("dot -Tps ~/dot-tmp/automaton.dot -o ~/dot-tmp/automaton.ps");
        Exec(Concatenation(gv, " ~/dot-tmp/automaton.ps &"));
    fi;

    
end);

#############################################################################
##
#F  dotGraph( <G>, fich ) . . . . . . . . . . . Prepares a file in the DOT
## language to draw the graph G using dot
##
InstallGlobalFunction(dotGraph, function(G, fich)
    local k, l, name, nome;
    
    if not IsString(fich) then
        Error("The second argument must be a string");
    fi;
    name := Concatenation("~/dot-tmp/", fich, ".dot");

    nome := "grafo";

    PrintTo(name, "digraph  ", nome, "{", "\n");
    for l  in [ 1 .. Length( G ) ]  do
        for k  in G[ l ]  do
            AppendTo(name, l, " -> ", k," [style=bold, color=black];","\n");
        od;
    od;

    for k in [1..Length(G)] do
        AppendTo(name, k, " [shape=circle];","\n");
    od;
    AppendTo(name,"}","\n");
end);

#############################################################################
##
#F  DrawGraph( arg ) . . . . . . . . . . .  produces a ps file with the
## Graph A using the dot language and stops after showing it
##
InstallGlobalFunction(DrawGraph, function(arg)
    local path, gv;
    
    if Length(arg) = 0 then
        Error("Please give me an automaton to draw");
    fi;
    path := DirectoriesSystemPrograms();
    gv := Filename( path, "gv" );
    if gv = fail then
        gv := Filename( path, "ggv" );
        if gv = fail then
            Error("Please install gv or ggv");
        fi;
    fi;
    if IsBound(arg[2]) then
        dotGraph(arg[1], arg[2]);
        Exec(Concatenation("dot -Tps ~/dot-tmp/", arg[2], ".dot -o ~/dot-tmp/", arg[2], ".ps"));
        Exec(Concatenation(gv, " ~/dot-tmp/", arg[2], ".ps &"));
    else
        dotGraph(arg[1], "graph");
        Exec("dot -Tps ~/dot-tmp/graph.dot -o ~/dot-tmp/graph.ps");
        Exec(Concatenation(gv, " ~/dot-tmp/graph.ps &"));
    fi;
end);

############################################################################
##
#F  dotAutomata( [ <A> , <B> ] )  . . . . . . . . Prepares a file in the DOT
## language to draw the automaton B and showing the automaton A as a 
## subautomaton.
##
InstallGlobalFunction(dotAutomata, function(A)
    local au, au1, aut1, aut2, l1, l2,  arr, array, colors, i, j, k, 
          letters, max, name, nome, R, l, s, t;
    if not (IsList(A) and 1 < Length(A) and Length(A) < 4 and 
            IsAutomatonObj(A[1]) and IsAutomatonObj(A[2]) ) then
                Error("The argument of dotAutomata is a list of automata");
    fi;

    if Length(A) = 3 then
        name := "~/dot-tmp/";
        Append(name,String(A[3]));
        Append(name,".dot");
        aut1 := A[1];
        aut2 := A[2];
    elif Length(A) = 2 then
        name := "~/dot-tmp/automato.dot";
        aut1 := A[1];
        aut2 := A[2];
    fi;

    nome := "automato";
    letters := [];
    
    au := StructuralCopy(aut2!.transitions);
    au1 := StructuralCopy(aut1!.transitions);
    for i in [1 .. Length(aut1!.transitions)] do
        for j in [1 .. Length(aut1!.transitions[1])] do
            if not IsBound(au1[i][j]) or au1[i][j] = 0 or au1[i][j] = [0] 
               or au1[i][j] = [] then
                au1[i][j] := " ";
            fi;
        od;
    od;
    for i in [1 .. Length(aut2!.transitions)] do
        for j in [1 .. Length(aut2!.transitions[1])] do
            if not IsBound(au[i][j]) or au[i][j] = 0 or au[i][j] = [0] 
               or au[i][j] = [] then
                au[i][j] := " ";
            fi;
        od;
    od;

    if aut2!.alphabet < 7 then     ##  for small alphabets, the letters
                                      ##  a, b, c, d are used
        letters := ["a", "b", "c", "d", "e", "f"];
        colors := ["red", "blue", "green", "yellow", "brown", "black"];
    else
        for i in [1 .. aut2!.alphabet] do
            Add(letters, Concatenation("a", String(i)));
        od;
        colors := [];
        for i in [1 .. aut2!.alphabet] do
            colors[i]:= "black";
        od;
    fi;
    
    l2 := [];
    array := [];
    s := [];
    arr := List( au, x -> List( x, String ) );
    max := Maximum( List( arr, x -> Maximum( List(x,Length) ) ) );

    for i in [1 .. aut2!.states] do 
        for j in [1 .. aut2!.alphabet] do
            if IsBound(au[j]) and IsBound(au[j][i]) and
               au[j][i] <> " " then
                if IsList(au[j][i]) then
                    for k in au[j][i] do
                        if i <= aut1!.states and j <= aut1!.alphabet and 
                           IsBound(au1[j]) and IsBound(au1[j][i]) and k in au1[j][i] and
                             au1[j][i] <> " " then
                            
                            Add(array, [i, " -> ", k," [label=", "\"", letters[j],"\"",",color=", colors[j],"];"]);
                        else
                            Add(array, [i, " -> ", k," [label=", "\"", letters[j],"\"",",color=", colors[j], ",style = dotted];"]);

                        fi;
                    od;
                else
                    if i <= aut1!.states and j <= aut1!.alphabet and 
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

    PrintTo(name, "digraph  ", nome, "{", "\n");
    for l  in [ 1 .. Length( arr ) ]  do
        for k  in [ 1 .. Length( arr[ l ] ) ]  do
            AppendTo(name,  String( arr[ l ][ k ]) );
        od;
        if l = Length( arr )  then
            AppendTo(name,  "\n" );
        else
            AppendTo(name,  "\n" );
        fi;
    od;
    for i in aut1!.initial do
        AppendTo(name, i, " [shape=triangle];","\n");
    od;
    for i in Difference(aut2!.initial,aut1!.initial) do
        AppendTo(name, i, " [shape=triangle,color=gray];","\n");
    od;
    for j in aut1!.accepting do
        if j in aut1!.initial then
            AppendTo(name, j, " [shape=triangle,peripheries=2];","\n");
        else
            AppendTo(name, j, " [shape=doublecircle];","\n");
        fi;
    od;
    for j in Difference(aut2!.accepting,aut1!.accepting) do
        if j in aut2!.initial then
            AppendTo(name, i, " [shape=triangle,peripheries=2,color=gray];","\n");
        else
            AppendTo(name, j, " [shape=doublecircle,color=gray];","\n");
        fi;    
    od;
    for k in Difference(Difference([1..aut1!.states],aut2!.accepting),Concatenation(aut1!.initial, aut2!.initial,aut1!.accepting)) do
        AppendTo(name, k, " [shape=circle];","\n");
    od;
    for k in Difference(Difference([1..aut2!.states],aut2!.accepting),Concatenation(aut1!.initial, aut2!.initial, [1..aut1!.states])) do
        AppendTo(name, k, " [shape=circle,color=gray];","\n");
    od;
    AppendTo(name,"}","\n");
end);

#############################################################################
##
#F  DrawAutomata( <A>, fich ) . . . . . . . . . . .  produces a ps file with the
## automaton A using the dot language and stops after showing it
##
InstallGlobalFunction(DrawAutomata, function(arg)
    local fich, A, B, q, a, k, path, gv;
    
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
    
    path := DirectoriesSystemPrograms();
    gv := Filename( path, "gv" );
    if gv = fail then
        gv := Filename( path, "ggv" );
        if gv = fail then
            Error("Please install gv or ggv");
        fi;
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
    
    dotAutomata([A,B, fich]);

    Exec(Concatenation("dot -Tps ~/dot-tmp/", fich, ".dot -o ~/dot-tmp/", fich, ".ps"));
    Exec(Concatenation(gv, " ~/dot-tmp/", fich, ".ps &"));
end);
#############################################################################
##
#F  DrawSCCAutomaton( <A>, fich ) . . . . . . . .  produces a ps file with the
## automaton A using the dot language. The strongly connected components are 
## emphasized.
##
InstallGlobalFunction(DrawSCCAutomaton, function(arg)
    local G, G2, A, fich, au, aut, l1, l2,  arr, array, colors, i, j, k, letters, max, name,
          nome, R, l, s, t, path, gv;
    
    if not IsBound(arg[1]) then
        Error("The first argument must be an automaton");
    fi;
    A := arg[1];
    if not IsAutomatonObj(A) then
        Error("The first argument must be an automaton");
    fi;
    if not IsBound(arg[2]) then
        fich := "sccautomaton";
    else
        fich := arg[2];
    fi;
    
    path := DirectoriesSystemPrograms();
    gv := Filename( path, "gv" );
    if gv = fail then
        gv := Filename( path, "ggv" );
        if gv = fail then
            Error("Please install gv or ggv");
        fi;
    fi;

    G := GraphStronglyConnectedComponents(UnderlyingGraphOfAutomaton(A));
    G2 := [];
    for i in G do
        for j in i do
            G2[j] := i;
        od;
    od;
    
    name := Concatenation("~/dot-tmp/", fich, ".dot");
    aut := A;

    nome := "Automaton";
    letters := [];
    au := StructuralCopy(aut!.transitions);
    for i in [1 .. Length(aut!.transitions)] do
        for j in [1 .. Length(aut!.transitions[1])] do
            if not IsBound(au[i][j]) or au[i][j] = 0 or au[i][j] = [0] then
                au[i][j] := " ";
            fi;
        od;
    od;
    
    if IsInt(FamilyObj(aut)!.alphabet) then
        if aut!.alphabet < 7 then       ##  for small alphabets, the letters
                                        ##  a, b, c, d are used
            letters := ["a", "b", "c", "d", "e", "f"];
            colors := ["red", "blue", "green", "yellow", "brown", "black"];
        else
            for i in [1 .. aut!.alphabet] do
                Add(letters, Concatenation("a", String(i)));
            od;
            colors := [];
            for i in [1 .. aut!.alphabet] do
                colors[i]:= "black";
            od;
        fi;
    else
        if aut!.alphabet < 7 then       ##  for small alphabets, the letters
                                        ##  a, b, c, d are used
            letters := [];
            for i in FamilyObj(A)!.alphabet do
                Add(letters, [i]);
            od;
            colors := ["red", "blue", "green", "yellow", "brown", "black"];
        else
            letters := [];
            for i in FamilyObj(A)!.alphabet do
                Add(letters, [i]);
            od;
            colors := [];
            for i in [1 .. aut!.alphabet] do
                colors[i]:= "black";
            od;
        fi;
    fi;
    l2 := [];
    array := [];
    s := [];
    arr := List( au, x -> List( x, String ) );
    max := Maximum( List( arr, x -> Maximum( List(x,Length) ) ) );

    for i in [1 .. aut!.states] do
        for j in [1 .. aut!.alphabet] do
            if IsBound(au[j]) and IsBound(au[j][i]) and
               au[j][i] <> " " then
                if IsList(au[j][i]) then
                    for k in au[j][i] do
                        if i in G2[i] and k in G2[i] and Length(G2[i]) > 1 then
                            Add(array, [i, " -> ", k," [label=", "\"", letters[j],"\"",",color=", colors[j], "];"]);
                        else
                            Add(array, [i, " -> ", k," [label=", "\"", letters[j],"\"",",color=", colors[j], ",style = dotted];"]);
                        fi;
                    od;
                else
                    if i in G2[i] and au[j][i] in G2[i] and Length(G2[i]) > 1 then
                        Add(array, [i, " -> ", au[j][i]," [label=", "\"", letters[j],"\"",",color=", colors[j], "];"]);
                    else
                        Add(array, [i, " -> ", au[j][i]," [label=", "\"", letters[j],"\"",",color=", colors[j], ",style = dotted];"]);
                    fi;
                fi;
            fi;

        od;
    od;

    arr := List( array, x -> List( x, String ) );

    PrintTo(name, "digraph  ", nome, "{", "\n");
    for l  in [ 1 .. Length( arr ) ]  do
        for k  in [ 1 .. Length( arr[ l ] ) ]  do
            AppendTo(name,  String( arr[ l ][ k ]) );
 #           if k = Length( arr[ l ] )  then
 #               AppendTo(name,  " " );
 #           else
 #               AppendTo(name,  " " );
 #           fi;
        od;
        if l = Length( arr )  then
            AppendTo(name,  "\n" );
        else
            AppendTo(name,  "\n" );
        fi;
    od;
    for i in aut!.initial do
        AppendTo(name,"{rank = same; \" \";", i,"}","\n");
        AppendTo(name,"\" \" [shape=plaintext];","\n");
        AppendTo(name,"\" \" ", " -> ", i, " [style=bold, color=black];","\n");
    od;
    for j in aut!.accepting do
        if Length(G2[j]) = 1 then
            AppendTo(name, j, " [shape=doublecircle,color=gray];","\n");
        else
            AppendTo(name, j, " [shape=doublecircle];","\n");
        fi;
    od;
    for k in Difference([1..aut!.states],aut!.accepting) do
        if Length(G2[k]) = 1 then
            AppendTo(name, k, " [shape=circle,color=gray];","\n");
        else
            AppendTo(name, k, " [shape=circle];","\n");
        fi;
    od;
    AppendTo(name,"}","\n");
    
    Exec(Concatenation("dot -Tps ~/dot-tmp/", fich, ".dot -o ~/dot-tmp/", fich, ".ps"));
    Exec(Concatenation(gv, " ~/dot-tmp/", fich, ".ps &"));
end);

##
#E

