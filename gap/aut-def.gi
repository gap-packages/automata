#############################################################################
##
#W  aut-def.gi                         Manuel Delgado <mdelgado@fc.up.pt>
#W                                     Jose Morais    <josejoao@fc.up.pt>
##
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
#############################################################################
##
##  This file contains some generic methods for automata. 
##
#############################################################################
##
##
## Example
## gap> A:=Automaton("det",4,2,[[3,3,3,4],[3,4,3,4]],[1],[4]);
## < deterministic automaton on 2 letters with 4 states >
## gap> Display(A);
##    |  1  2  3  4
## -----------------
##  a |  3  3  3  4
##  b |  3  4  3  4
## Initial state:   [ 1 ]
## Accepting state: [ 4 ]
##
## The first component of a non deterministic automaton is <"nondet">
## and that of an epsilon automaton is <"epsilon">.
##
## In the case of automata with e-transitions, the last line of the 
## transition table corresponds to the e-transitions (i.e., epsilon is 
## considered the last letter of the alphabet).

#############################################################################
##
#R  
## The transitions of a deterministic automaton are always represented by 
## a matrix that may be dense or 
## not. If it is dense, the automaton is dense deterministic.
## The holes in the list may be replaced by zeros.
##
## The nondeterministic automata may be represented the same way, with
## sets of states instead of states in the transition matrix.
##
## In order to use this representation for epsilon-automata, an extra letter 
## must be added to the alphabet.
##

############################################################################
DeclareRepresentation( "IsAutomatonRep", IsComponentObjectRep, 
        ["type","states","alphabet","transitions","initial","accepting"]);

######################################################################
##
#F  Automaton(Type, Size, Alphabet, TransitionTable, ListInitial, 
##  ListAccepting )
##
##  Produces an automaton
##  The Alphabet may be given as a list of symbols (e.g. "xy" or "01")
##  or as an integer, representing its size. In the latter case, the alphabet
##  is taken as "abc..." (or "a_1,a_2,a_3,..." for an alphabet of more than 
##  26 symbols.
##  The meaning of the other arguments is clear.
##
InstallGlobalFunction( Automaton, function(Type, Size, Alphabet, 
        TransitionTable, ListInitial, ListAccepting )

#        local   F,  alph,  j,  i,  TT,  y,  x,  aut,  alphabet,  states,  
#                       initial,  accepting,  transitions,  A;
        local A, alph, aut, F, i, j, x, y, TT, l;

    #some tests...
    if not IsPosInt(Size) then
        Error("The size of the automaton must be a positive integer");
    elif not (IsPosInt(Alphabet) or IsList(Alphabet)) then
        Error("The size of the alphabet must be a positive integer or a list");
    fi;

    # Construct the family of all automata.
    F:= NewFamily( "Automata" ,
                IsAutomatonObj );
    if IsPosInt(Alphabet) then
        if Alphabet < 27 then
            alph := (List([1..Alphabet], i -> jascii[68+i]));
        else
            alph := (List([1..Alphabet], i -> Concatenation("a", String(i))));
        fi;
        if Type = "epsilon" then
            alph[Length(alph)] := '@';
        fi;

        F!.alphabet := MakeImmutable(alph);
    else
        if Type = "epsilon" then
            if not Alphabet[Length(Alphabet)] = '@' then
                Error("The last letter of the alphabet must be @");
            fi;
            j:=0;
            for i in Alphabet do
                if i = '@' then
                    j := j + 1;
                fi;
            od;
            if j > 1 then
                Error("The alphabet must contain only one @");
            fi;
        fi;
        F!.alphabet := Alphabet;
        Alphabet := Length(F!.alphabet);
    fi;

    if not IsList(TransitionTable) then
        Error("The transition table must be given as a matrix");
    elif not IsList(ListInitial) then
        Error("The initial states must be provided as a list");
    elif not IsList(ListAccepting) then
        Error("The accepting states must be provided as a list");
    elif (Length(TransitionTable) <> Alphabet) then
        Error("The number of rows of the transition table must equal the size of the alphabet");
    fi;

    #The type of the automaton: deterministic or not must be given
    if Type <> "det" and Type <> "nondet" and Type <> "epsilon" then
        Error( "Please specify the type of the automaton as \"det\" or \"nondet\" or \"epsilon\"");
    fi;


    # Fill the holes in the transition table with <0> in the case of 
    # deterministic automata and with <[0]> in the case of non 
    # deterministic automata
    TT := NullMat(Alphabet,Size);
    for i in [1 .. Alphabet] do
        for j in[1 .. Size] do
            if Type = "det" then
                if IsBound(TransitionTable[i][j]) then
                    if IsInt(TransitionTable[i][j]) then
                        if TransitionTable[i][j] > Size or TransitionTable[i][j] < 0 then
                            Error(Concatenation("TransitionTable[", String(i), "][", String(j), "] must be in [0 .. ", String(Size), "]"));
                        else
                            TT[i][j] := TransitionTable[i][j];
                        fi;
                    else
                        Error(Concatenation("TransitionTable[", String(i), "][", String(j), "] must be an integer"));
                    fi;
                else
                    TT[i][j] := 0;
                fi;
            else
                if IsBound(TransitionTable[i][j]) then 
                    if IsInt(TransitionTable[i][j]) then
                        if TransitionTable[i][j] > Size or TransitionTable[i][j] < 0 then
                            Error(Concatenation("TransitionTable[", String(i), "][", String(j), "] must be in [0 .. ", String(Size), "]"));
                        else
                            if TransitionTable[i][j] = 0 then
                                TT[i][j] := [];
                            else
                                TT[i][j] := [TransitionTable[i][j]];
                            fi;
                        fi;
                    elif IsRowVector(TransitionTable[i][j]) then
                        for y in [1 .. Length(TransitionTable[i][j])] do
                            if not IsBound(TransitionTable[i][j][y]) then
                                Error(Concatenation("TransitionTable[", String(i), "][", String(j), "] must have all elements in [1 .. ", String(Size), "]"));
                            elif IsPosInt(TransitionTable[i][j][y]) then
                                x := TransitionTable[i][j][y];
                                if x > Size or x < 0 then
                                    Error(Concatenation("TransitionTable[", String(i), "][", String(j), "] must have all elements in [1 .. ", String(Size), "]"));
                                fi;
                            elif TransitionTable[i][j][y] = 0 then
                                Unbind(TransitionTable[i][j][y]);
                            else
                                Error(Concatenation("TransitionTable[", String(i), "][", String(j), "] must have all elements in [1 .. ", String(Size), "]"));
                            fi;
                        od;
                        TT[i][j] := TransitionTable[i][j];
                    elif not TransitionTable[i][j] = [] then
                        Error(Concatenation("TransitionTable[", String(i), "][", String(j), "] must be in [0 .. ", String(Size), "]"));
                    else
                        TT[i][j] := TransitionTable[i][j];
                    fi;
                else
                    TT[i][j] := [];
                fi;
            fi;
        od;
    od;

    aut := rec(type := Type,
               alphabet := Alphabet,
               states := Size,
               initial := ListInitial,
               accepting := ListAccepting,
               transitions := TT );

    A := Objectify( NewType( F, IsAutomatonObj and 
                 IsAutomatonRep and IsAttributeStoringRep ),
                 aut );

    # Return the automaton.
    return A;
end);


#############################################################################
##
#M  ViewObj( <A> ) . . . . . . . . . . . print automata
##
InstallMethod( ViewObj,
        "displays an automaton",
        true,
        [IsAutomatonObj and IsAutomatonRep], 0,
        function( A )
    if A!.type = "det" then
        Print("< deterministic automaton on ", A!.alphabet, " letters with ", A!.states, " states >");
    elif A!.type = "nondet" then
        Print("< non deterministic automaton on ", A!.alphabet, " letters with ", A!.states, " states >");
    else
        Print("< epsilon automaton on ", A!.alphabet, " letters with ", A!.states, " states >");
    fi;
end);


#############################################################################
##
#M  PrintObj( <A> ) . . . . . . . . . . . print automata
##
InstallMethod( PrintObj,
        "displays an automaton",
        true,
        [IsAutomatonObj and IsAutomatonRep], 0,
        function( A )
    Print(String(A),"\n");
end);

#############################################################################
##
#M  Display( <A> ) . . . . . . . . . . . print automata
##
InstallMethod( Display,
        "displays an automaton",
        true,
        [IsAutomatonObj and IsAutomatonRep], 0,
        function( A )
    local   letters,  i,  str,  a,  xs,  xout,  q,  lsizeq,  sizeq,  len,  j;

    letters := [];
    for i in AlphabetOfAutomatonAsList(A) do
        Add(letters, [i]);
    od;

    if A!.states < 10 then
        if A!.type = "det" then
            str := "   |  ";
            for i in [1 .. A!.states] do
                str := Concatenation(str, String(i), "  ");
            od;
            str := Concatenation(str, "\n-----");
            for i in [1 .. A!.states] do
                str := Concatenation(str, "---");
            od;
            str := Concatenation(str, "\n");
            for a in [1 .. A!.alphabet] do
                xs := "";
                xout := OutputTextString(xs, false);
                PrintTo(xout, letters[a]);
                str := Concatenation(str, " ", xs, " |  ");
                CloseStream(xout);
                for i in [1 .. A!.states] do
                    q := A!.transitions[a][i];
                    if q = 0 then
                        str := Concatenation(str, "   ");
                    else
                        str := Concatenation(str, String(q),"  ");
                    fi;
                od;
                str := Concatenation(str, "\n");
            od;
            if IsBound(A!.accepting[2]) then
                xs := "";
                xout := OutputTextString(xs, false);
                PrintTo(xout, A!.initial);
                str := Concatenation(str, "Initial state:    ", String(xs), "\n");
                CloseStream(xout);
                xs := "";
                xout := OutputTextString(xs, false);
                PrintTo(xout, A!.accepting);
                str := Concatenation(str, "Accepting states: ", xs, "\n");
                CloseStream(xout);
            else
                xs := "";
                xout := OutputTextString(xs, false);
                PrintTo(xout, A!.initial);
                str := Concatenation(str, "Initial state:   ", xs, "\n");
                CloseStream(xout);
                xs := "";
                xout := OutputTextString(xs, false);
                PrintTo(xout, A!.accepting);
                str := Concatenation(str, "Accepting state: ", xs, "\n");
                CloseStream(xout);
            fi;

        elif A!.type = "nondet" then
            lsizeq := [];
            for i in [1 .. A!.states] do
                sizeq := 0;
                for a in [1 .. A!.alphabet] do
                    len := Length(A!.transitions[a][i]);
                    if len > sizeq then
                        sizeq := len;
                    fi;
                od;
                sizeq := sizeq + 2*(sizeq-1) + 4;
                lsizeq[i] := sizeq;
            od;

            str := "   |  ";
            for i in [1 .. A!.states-1] do
                str := Concatenation(str, String(i), "  ");
                for j in [1 .. lsizeq[i]] do
                    str := Concatenation(str, " ");
                od;
            od;
            str := Concatenation(str, String(A!.states), "\n---");
            for i in [1 .. A!.states] do
                str := Concatenation(str, "---");
                for j in [1 .. lsizeq[i]] do
                    str := Concatenation(str, "-");
                od;
            od;
            str := Concatenation(str, "\n");
            for a in [1 .. A!.alphabet] do
                str := Concatenation(str, " ", letters[a], " | ");
                for i in [1 .. A!.states] do
                    q := A!.transitions[a][i];

                    if q = [] then
                        str := Concatenation(str, "   ");
                        for j in [1 .. lsizeq[i]] do
                            str := Concatenation(str, " ");
                        od;
                    else
                        str := Concatenation(str, String(q),"  ");
                        len := Length(q);
                        len := len + 2*(len-1) + 4;
                        for j in [len .. lsizeq[i]] do
                            str := Concatenation(str, " ");
                        od;
                    fi;
                od;
                str := Concatenation(str, "\n");
            od;
            if IsBound(A!.initial[2]) then
                if IsBound(A!.accepting[2]) then
                    str := Concatenation(str, "Initial states:   ", String(A!.initial), "\n");
                    str := Concatenation(str, "Accepting states: ", String(A!.accepting), "\n");
                elif A!.accepting = [] then
                    str := Concatenation(str, "Initial states:  ", String(A!.initial), "\n");
                else
                    str := Concatenation(str, "Initial states:  ", String(A!.initial), "\n");
                    str := Concatenation(str, "Accepting state: ", String(A!.accepting), "\n");
                fi;
            elif A!.initial = [] then
                if IsBound(A!.accepting[2]) then
                    str := Concatenation(str, "Accepting states: ", String(A!.accepting), "\n");
                elif A!.accepting = [] then
                else
                    str := Concatenation(str, "Accepting state: ", String(A!.accepting), "\n");
                fi;
            else
                if IsBound(A!.accepting[2]) then
                    str := Concatenation(str, "Initial state:    ", String(A!.initial), "\n");
                    str := Concatenation(str, "Accepting states: ", String(A!.accepting), "\n");
                elif A!.accepting = [] then
                    str := Concatenation(str, "Initial state:    ", String(A!.initial), "\n");
                else
                    str := Concatenation(str, "Initial state:   ", String(A!.initial), "\n");
                    str := Concatenation(str, "Accepting state: ", String(A!.accepting), "\n");
                fi;
            fi;

        else
            lsizeq := [];
            for i in [1 .. A!.states] do
                sizeq := 0;
                for a in [1 .. A!.alphabet] do
                    len := Length(A!.transitions[a][i]);
                    if len > sizeq then
                        sizeq := len;
                    fi;
                od;
                sizeq := sizeq + 2*(sizeq-1) + 4;
                lsizeq[i] := sizeq;
            od;

            str := "   |  ";
            for i in [1 .. A!.states-1] do
                str := Concatenation(str, String(i), "  ");
                for j in [1 .. lsizeq[i]] do
                    str := Concatenation(str, " ");
                od;
            od;
            str := Concatenation(str, String(A!.states), "\n---");
            for i in [1 .. A!.states] do
                str := Concatenation(str, "---");
                for j in [1 .. lsizeq[i]] do
                    str := Concatenation(str, "-");
                od;
            od;
            str := Concatenation(str, "\n");
            for a in [1 .. A!.alphabet-1] do
                str := Concatenation(str, " ", letters[a], " | ");
                for i in [1 .. A!.states] do
                    q := A!.transitions[a][i];

                    if q = [] then
                        str := Concatenation(str, "   ");
                        for j in [1 .. lsizeq[i]] do
                            str := Concatenation(str, " ");
                        od;
                    else
                        str := Concatenation(str, String(q),"  ");
                        len := Length(q);
                        len := len + 2*(len-1) + 4;
                        for j in [len .. lsizeq[i]] do
                            str := Concatenation(str, " ");
                        od;
                    fi;
                od;
                str := Concatenation(str, "\n");
            od;
            a := A!.alphabet;
            str := Concatenation(str, " @ | ");
            for i in [1 .. A!.states] do
                q := A!.transitions[a][i];
                if q = [] then
                    str := Concatenation(str, "   ");
                    for j in [1 .. lsizeq[i]] do
                        str := Concatenation(str, " ");
                    od;
                else
                    str := Concatenation(str, String(q),"  ");
                    len := Length(q);
                    len := len + 2*(len-1) + 4;
                    for j in [len .. lsizeq[i]] do
                        str := Concatenation(str, " ");
                    od;
                fi;
            od;
            str := Concatenation(str, "\n");
            if IsBound(A!.initial[2]) then
                if IsBound(A!.accepting[2]) then
                    str := Concatenation(str, "Initial states:   ", String(A!.initial), "\n");
                    str := Concatenation(str, "Accepting states: ", String(A!.accepting), "\n");
                else
                    str := Concatenation(str, "Initial states:  ", String(A!.initial), "\n");
                    str := Concatenation(str, "Accepting state: ", String(A!.accepting), "\n");
                fi;
            else
                if IsBound(A!.accepting[2]) then
                    str := Concatenation(str, "Initial state:    ", String(A!.initial), "\n");
                    str := Concatenation(str, "Accepting states: ", String(A!.accepting), "\n");
                else
                    str := Concatenation(str, "Initial state:   ", String(A!.initial), "\n");
                    str := Concatenation(str, "Accepting state: ", String(A!.accepting), "\n");
                fi;
            fi;

        fi;
    else
        sizeq := Length(String(A!.states));
        if A!.type = "det" then
            str := "";
            for i in [1 .. A!.states] do
                for a in [1 .. A!.alphabet] do
                    q := A!.transitions[a][i];
                    if q > 0 then
                        str := Concatenation(str, String(i));
                        for j in [Length(String(i)) .. sizeq] do
                            str := Concatenation(str, " ");
                        od;
                        str := Concatenation(str, "  ", letters[a], "   ", String(q), "\n");
                    fi;
                od;
            od;
            if IsBound(A!.accepting[2]) then
                str := Concatenation(str, "Initial state:    ", String(A!.initial), "\n");
                str := Concatenation(str, "Accepting states: ", String(A!.accepting), "\n");
            else
                str := Concatenation(str, "Initial state:   ", String(A!.initial), "\n");
                str := Concatenation(str, "Accepting state: ", String(A!.accepting), "\n");
            fi;

        elif A!.type = "nondet" or A!.type = "epsilon" then
            str := "";
            for i in [1 .. A!.states] do
                for a in [1 .. A!.alphabet] do
                    q := A!.transitions[a][i];
                    if IsBound(q[1]) then
                        str := Concatenation(str, String(i));
                        for j in [Length(String(i)) .. sizeq] do
                            str := Concatenation(str, " ");
                        od;
                        str := Concatenation(str, "  ", letters[a], "   ", String(q), "\n");
                    fi;
                od;
            od;
            if IsBound(A!.initial[2]) then
                if IsBound(A!.accepting[2]) then
                    str := Concatenation(str, "Initial states:   ", String(A!.initial), "\n");
                    str := Concatenation(str, "Accepting states: ", String(A!.accepting), "\n");
                else
                    str := Concatenation(str, "Initial states:  ", String(A!.initial), "\n");
                    str := Concatenation(str, "Accepting state: ", String(A!.accepting), "\n");
                fi;
            else
                if IsBound(A!.accepting[2]) then
                    str := Concatenation(str, "Initial state:    ", String(A!.initial), "\n");
                    str := Concatenation(str, "Accepting states: ", String(A!.accepting), "\n");
                else
                    str := Concatenation(str, "Initial state:   ", String(A!.initial), "\n");
                    str := Concatenation(str, "Accepting state: ", String(A!.accepting), "\n");
                fi;
            fi;
        fi;
    fi;
    Print(str);    
end);

#############################################################################
##
#F  IsAutomaton(A)
##
##  Tests if A is an automaton
##
InstallGlobalFunction( IsAutomaton, function(A)
    return(IsAutomatonObj(A));
end);

#############################################################################
##
#F  RandomAutomaton(T, Q, A)
##
##  Given the type T, number of states Q and number of the input alphabet
##  symbols A, this function returns a pseudo random automaton with those
##  parameters. To obtain an epsilon automata with 3 non-@-letters plus @, use
##  RandomAutomaton("epsilon",2,"abc");
##  < epsilon automaton on 4 letters with 2 states >
##
##
InstallGlobalFunction(RandomAutomaton, function(T, Q, A)
    local i, transitions, a;

    if not IsPosInt(Q) then
        Error("The number of states must be a positive integer");
    fi;
    if not (IsPosInt(A) or IsList(A)) then
        Error("The number of symbols of the input alphabet must be a positive integer or a string");
    fi;

    if IsPosInt(A) then
        a := A;
    else
        a := ShallowCopy(A);
        A := Length(a);
    fi;

    if T = "det" then
        transitions := [];
        for i in [1 .. A] do
            transitions[i] := SSortedList(List([1 .. Q], i -> Random([0 .. Q])));
        od;
        return(Automaton(T, Q, a, transitions, [Random([1 .. Q])], SSortedList(List([1 .. Q], j -> Random([1 .. Q])))));
    elif T = "nondet" then
        transitions := [];
        for i in [1 .. A] do
            transitions[i] := List([1 .. Q], i -> SSortedList(List([1 .. Random([0 .. Q])], j -> Random([1 .. Q]))));
        od;
        return(Automaton(T, Q, a, transitions, SSortedList(List([1 .. Random([1 .. Q])], j -> Random([1 .. Q]))), SSortedList(List([1 .. Q], j -> Random([1 .. Q])))));
    else
        transitions := [];
        for i in [1 .. A+1] do
            transitions[i] := List([1 .. Q], i -> SSortedList(List([1 .. Random([0 .. Q])], j -> Random([1 .. Q]))));
        od;
        if IsInt(a) then
            return(Automaton(T, Q, a+1, transitions, SSortedList(List([1 .. Random([1 .. Q])], j -> Random([1 .. Q]))), SSortedList(List([1 .. Q], j -> Random([1 .. Q])))));
        else
            if jascii[Position(jascii, '@')] in a then
                Error("Please choose an alphabet, without the character '@'");
            fi;
            return(Automaton(T, Q, Concatenation(a, [jascii[Position(jascii, '@')]]), transitions, SSortedList(List([1 .. Random([1 .. Q])], j -> Random([1 .. Q]))), SSortedList(List([1 .. Q], j -> Random([1 .. Q])))));
        fi;
    fi;
end);


#############################################################################
##
#M  String( <A> ) . . . . . . . . . . . outputs the definition of an automaton as a string
##
InstallMethod( String,
        "Automaton to string",
        true,
        [IsAutomatonObj and IsAutomatonRep], 0,
        function( A )
    return Concatenation("Automaton(\"", String(A!.type), "\",", String(A!.states), ",\"", AlphabetOfAutomatonAsList(A), "\",", String(A!.transitions), ",", String(A!.initial), ",", String(A!.accepting), ");;");
end);

    
############################################################################
##
#M Methods for the comparison operations for automata. 
##
InstallMethod( \=,
        "for two automata",
        #    IsIdenticalObj,
        [ IsAutomatonObj and IsAutomatonRep, 
          IsAutomatonObj and IsAutomatonRep,  ], 
        0,
        function( x, y ) 
    return(String(x) = String(y));

end );

InstallMethod( \<,
        "for two automata",
        #    IsIdenticalObj,
        [ IsAutomatonObj and IsAutomatonRep, 
          IsAutomatonObj and IsAutomatonRep,  ], 
        0,
        function( x, y ) 
    return(String(x) < String(y)); 
end );



#E
##
    
