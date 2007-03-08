############################################################################
##
#W  aut-basics.gi                        Manuel Delgado <mdelgado@fc.up.pt>
#W                                      Jose Morais    <josejoao@fc.up.pt>
##
#H  @(#)$Id: aut-basics.gi,v 1.10 $
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
#############################################################################
##
##  This file contains some basic functions or generic methods involving 
## automata.
##
#############################################################################
##
#F  IsDeterministicAutomaton(A)
##
##  Tests if A is a deterministic automaton
##
InstallGlobalFunction(IsDeterministicAutomaton, function(A)
    return IsAutomatonObj(A) and A!.type = "det";
end);
#############################################################################
##
#F  IsNonDeterministicAutomaton(A)
##
##  Tests if A is a non deterministic automaton
##
InstallGlobalFunction(IsNonDeterministicAutomaton, function(A)
    return IsAutomatonObj(A) and A!.type = "nondet";
end);
#############################################################################
##
#F  IsEpsilonAutomaton(A)
##
##  Tests if A is an automaton with epsilon transitions
##
InstallGlobalFunction(IsEpsilonAutomaton, function(A)
    return IsAutomatonObj(A) and A!.type = "epsilon";
end);
#############################################################################
##
#F  AlphabetOfAutomaton(A)
##
##  Returns the alphabet of the automaton
##
InstallGlobalFunction(AlphabetOfAutomaton,
        function( A )
    if not IsAutomaton(A) then
        Error("The argument must be an automaton");
    fi;
    return(ShallowCopy(FamilyObj(A)!.alphabet));
end);
#############################################################################
##
#F  AlphabetOfAutomatonAsList(A)
##
##  Returns the alphabet of the automaton as a list.
##  If the alphabet of the automaton is an integer
##  less than 27 it returns the list "abcd....",
##  otherwise returns [ "a1", "a2", "a3", "a4", ... ].
##
InstallGlobalFunction(AlphabetOfAutomatonAsList,
        function( A )
    local a;
    if not IsAutomaton(A) then
        Error("The argument must be an automaton");
    fi;
    a := ShallowCopy(FamilyObj(A)!.alphabet);
    if IsInt(a) then
        if a < 27 then
            return(List([1..a], i -> jascii[68+i]));
        else
            return(List([1..a], i -> Concatenation("a", String(i))));
        fi;
    fi;
    return(a);
end);
#############################################################################
##
#F TransitionMatrixOfAutomaton(A)
##
## returns the transition matrix of the automaton
##
InstallGlobalFunction(TransitionMatrixOfAutomaton,
        function( A )
    if not IsAutomaton(A) then
        Error("The argument must be an automaton");
    fi;
    return(A!.transitions);
end);
#############################################################################
##
#F InitialStatesOfAutomaton(A)
##
## returns the initial states of the automaton
##
InstallGlobalFunction(InitialStatesOfAutomaton,
        function( A )
    if not IsAutomaton(A) then
        Error("The argument must be an automaton");
    fi;
    return(ShallowCopy(A!.initial));
end);
#############################################################################
##
#F SetInitialStatesOfAutomaton(A)
##
## Sets the initial states of the automaton
##
InstallGlobalFunction(SetInitialStatesOfAutomaton,
        function( A, I )
    if not IsAutomaton(A) then
        Error("The first argument must be an automaton");
    fi;
    if IsInt(I) then
        if not (I > 0 and I <= A!.states) then
            Error("The second argument must be a list of positive integers (or just a positive integer) <= ", A!.states);
        fi;
        A!.initial := [I];
        return;
    fi;
    if not (IsList(I) and ForAll(I, i->IsPosInt(i)) and ForAll(I, i-> i <= A!.states)) then
        Error("The second argument must be a list of positive integers (or just a positive integer) <= ", A!.states);
    fi;
    A!.initial := ShallowCopy(I);
end);
#############################################################################
##
#F FinalStatesOfAutomaton(A)
##
## returns the final states of the automaton
##
InstallGlobalFunction(FinalStatesOfAutomaton,
        function( A )
    if not IsAutomaton(A) then
        Error("The argument must be an automaton");
    fi;
    return(ShallowCopy(A!.accepting));
end);
#############################################################################
##
#F SetFinalStatesOfAutomaton(A, F)
##
## Sets the final states of the automaton
##
InstallGlobalFunction(SetFinalStatesOfAutomaton,
        function( A, F )
    if not IsAutomaton(A) then
        Error("The first argument must be an automaton");
    fi;
    if IsInt(F) then
        if not (F > 0 and F <= A!.states) then
            Error("The second argument must be a list of positive integers (or just a positive integer) <= ", A!.states);
        fi;
        A!.accepting := [F];
        return;
    fi;
    if not (IsList(F) and ForAll(F, i->IsPosInt(i)) and ForAll(F, i-> i <= A!.states)) then
        Error("The second argument must be a list of positive integers <= ", A!.states);
    fi;
    A!.accepting := ShallowCopy(F);
end);
#############################################################################
##
#A NumberStatesOfAutomaton(A)
##
## returns the number of states of the automaton
##
InstallGlobalFunction(NumberStatesOfAutomaton,
        function( A )
    if not IsAutomaton(A) then
        Error("The argument must be an automaton");
    fi;
    return(A!.states);
end);


#############################################################################
##
#F  CopyAutomaton(A)
##
##  Returns a copy of the automaton A.
##
InstallGlobalFunction(CopyAutomaton, function ( A )
    if not IsAutomatonObj(A) then
        Error("The argument must be an automaton");
    fi;
    return Automaton( ShallowCopy( A!.type ), A!.states,
                   AlphabetOfAutomaton(A), StructuralCopy( A!.transitions ), 
                   ShallowCopy( A!.initial ),
                   ShallowCopy( A!.accepting ) );
end);

#############################################################################
##
#F  NullCompletionAutomaton(aut)
##
##  Given an incomplete deterministic automaton returns a deterministic 
##  automaton completed with a new null state. 
##
InstallGlobalFunction(NullCompletionAutomaton, function(aut)
    local b, i, j, t, x, y;
    
    if not IsAutomatonObj(aut) then
        Error("The argument must be an automaton");
    fi;
    if not aut!.type = "det" then
        Error("<aut> must be deterministic");
    fi;
    
    t := [];
    if IsDenseAutomaton(aut) then
        return aut;
    fi;
    b := aut!.states + 1;
    for i in [1 .. aut!.alphabet] do
        t[i] := Concatenation(aut!.transitions[i], [b]);
        for j in [1 .. b] do
            if t[i][j] = 0 then
                t[i][j] := b;
            fi;
        od;
    od;
    return Automaton("det", b, AlphabetOfAutomaton(aut), t, aut!.initial, aut!.accepting);
end);


#############################################################################
##
#F  ListPermutedAutomata(A)
##
##  Given an automaton, returns a list of automata with permuted states
##  
InstallGlobalFunction(ListPermutedAutomata, function(A)
    local perms,    # List of permutations
          perm,     # Permutation
          T,        # Transition function of the permuted automaton
          list,     # List of the permuted automata
          a, q, s;
    
    if not IsAutomatonObj(A) then
        Print("The argument to PermutedAutomata must be an automaton\n");
        return;
    fi;
    if A!.type = "epsilon" then
        list := [];                           # List of the permuted automata
        perms := PermutationsOfN(A!.states);  # Compute the list of permutations
        for perm in perms do                  # For each permutation compute the permuted automaton
            T := [];    # New transition function
            for a in [1 .. A!.alphabet] do
                T[a] := [];
                for q in [1 .. A!.states] do
                    if A!.transitions[a][q] = [] then
                        T[a][perm[q]] := [];
                    else
                        T[a][perm[q]] := List(A!.transitions[a][q], s -> perm[s]);
                    fi;
                od;
            od;
            Add(list, Automaton("epsilon", A!.states, AlphabetOfAutomaton(A), T, List(A!.initial, q -> perm[q]), List(A!.accepting, q -> perm[q])));
        od;
    elif A!.type = "nondet" then
        list := [];                           # List of the permuted automata
        perms := PermutationsOfN(A!.states);  # Compute the list of permutations
        for perm in perms do                  # For each permutation compute the permuted automaton
            T := [];    # New transition function
            for a in [1 .. A!.alphabet] do
                T[a] := [];
                for q in [1 .. A!.states] do
                    if A!.transitions[a][q] = [] then
                        T[a][perm[q]] := [];
                    else
                        T[a][perm[q]] := List(A!.transitions[a][q], s -> perm[s]);
                    fi;
                od;
            od;
            Add(list, Automaton("nondet", A!.states, AlphabetOfAutomaton(A), T, List(A!.initial, q -> perm[q]), List(A!.accepting, q -> perm[q])));
        od;
    else
        list := [];                           # List of the permuted automata
        perms := PermutationsOfN(A!.states);  # Compute the list of permutations
        for perm in perms do                  # For each permutation compute the permuted automaton
            T := [];    # New transition function
            for a in [1 .. A!.alphabet] do
                T[a] := [];
                for q in [1 .. A!.states] do
                    if A!.transitions[a][q] = 0 then
                        T[a][perm[q]] := 0;
                    else
                        T[a][perm[q]] := perm[A!.transitions[a][q]];
                    fi;
                od;
            od;
            Add(list, Automaton("det", A!.states, AlphabetOfAutomaton(A), T, [perm[A!.initial[1]]], List(A!.accepting, q -> perm[q])));
        od;
    fi;
    return(list);
end);

#############################################################################
##
#F  PermutedAutomaton(A, perm)
##
##  Given an automaton and a list representing a permutation of the states
##  outputs the permuted automaton.
##
InstallGlobalFunction(PermutedAutomaton, function(A, perm)
    local a, q, len, T, list;
    
    if not IsAutomatonObj(A) then
        Print("The argument to PermutedAutomaton must be an automaton\n");
        return;
    fi;
    if not (A!.states = Length(perm) and Set(perm) = [1 .. A!.states]) then
        Error("The list must represent a permutation of the states of the automaton");
    fi;
    len  := 0;
    list := [];
    T := [];  # New transition function
    if A!.type = "det" then
        for a in [1 .. A!.alphabet] do
            T[a] := [];
            for q in [1 .. A!.states] do
                if A!.transitions[a][q] = 0 then
                    T[a][perm[q]] := 0;
                else
                    T[a][perm[q]] := perm[A!.transitions[a][q]];
                fi;
            od;
        od;
        return(Automaton("det", A!.states, AlphabetOfAutomaton(A), T, [perm[A!.initial[1]]], List(A!.accepting, q -> perm[q])));
    elif A!.type = "nondet" then
        for a in [1 .. A!.alphabet] do
            T[a] := [];
            for q in [1 .. A!.states] do
                if A!.transitions[a][q] = [] then
                    T[a][perm[q]] := [];
                else
                    T[a][perm[q]] := List(A!.transitions[a][q], x->perm[x]);
                fi;
            od;
        od;
        return(Automaton("nondet", A!.states, AlphabetOfAutomaton(A), T, List(A!.initial, q -> perm[q]), List(A!.accepting, q -> perm[q])));
    else
        for a in [1 .. A!.alphabet] do
            T[a] := [];
            for q in [1 .. A!.states] do
                if A!.transitions[a][q] = [] then
                    T[a][perm[q]] := [];
                else
                    T[a][perm[q]] := List(A!.transitions[a][q], x->perm[x]);
                fi;
            od;
        od;
        return(Automaton("epsilon", A!.states, AlphabetOfAutomaton(A), T, List(A!.initial, q -> perm[q]), List(A!.accepting, q -> perm[q])));
    fi;
    
end);

#############################################################################
##
#F  IsDenseAutomaton(A)
##
##  Tests whether a deterministic automaton is complete
##
InstallGlobalFunction(IsDenseAutomaton, function(A)
    local n;
      
    if not IsDeterministicAutomaton(A) then
        Error("<A> must be a deterministic automaton");
    fi;
        
    return(ForAll(A!.transitions, n -> IsDenseList(n) and 
              ForAll(n,IsPosInt)));
end);
#############################################################################
##
#F IsInverseAutomaton
##
## Tests whether a deterministic automaton is inverse, i.e. each letter of 
## the alphabet induces a partial injective function on the vertices.
##
InstallGlobalFunction(IsInverseAutomaton,function(aut)
    local  i, L, T;
    if not IsDeterministicAutomaton(aut) then
        Error("<A> must be a deterministic automaton");
    fi;
    
    T := StructuralCopy(aut!.transitions); 
    for L in T do 
        for i in [1..Length(L)] do
            if L[i] = 0 then
                Unbind(L[i]);
            fi;
        od;
        if  Length(Compacted(L))<> Length(Set(L)) then
            return false;
        fi;
    od;
    return true;
end);
#############################################################################
##
#F IsPermutationAutomaton
##
## Tests whether a deterministic automaton is a permutation automaton, 
## i.e. each letter of the alphabet induces a permutation on the vertices.
##
InstallGlobalFunction(IsPermutationAutomaton,function(aut)
    local  i, L, T;
    if not IsDeterministicAutomaton(aut) then
        Error("<A> must be a deterministic automaton");
    fi;
    
    T := StructuralCopy(aut!.transitions); 
    for L in T do 
        for i in [1..Length(L)] do
            if L[i] = 0 then
                return false;
            fi;
        od;
        if  aut!.states <> Length(Set(L)) then
            return false;
        fi;
    od;
    return true;
end);

#############################################################################
#F  ListSinkStatesAut(A)
##
##  Returns the list of sink states of the automaton A.
##  q is said to be a sink state iff it is not initial nor accepting and
##  for all a in A!.alphabet A!.transitions[a][q] = q 
##  
##  <A> must be an automaton.
##
##
InstallGlobalFunction(ListSinkStatesAut, function(A)
    local i, j, list;
    
    if not IsAutomatonObj(A) then
        Error("The argument to ListSinkStatesAut must be an automaton");
    fi;
    list := [];
    if A!.type = "det" then
        for j in [1 .. A!.states] do
            if ForAll([1 .. A!.alphabet], i -> A!.transitions[i][j] = 0 or A!.transitions[i][j] = j) then
                Add(list, j);
            fi;
        od;
    elif A!.type = "nondet" then
        for j in [1 .. A!.states] do
            if ForAll([1 .. A!.alphabet], i -> A!.transitions[i][j] = [] or A!.transitions[i][j] = [j]) then
                Add(list, j);
            fi;
        od;
    else
        return(ListSinkStatesAut(EpsilonToNFA(A)));
    fi;
    list := Difference(list, A!.initial);
    list := Difference(list, A!.accepting);
    return(list);
end);

#############################################################################
##
#F  RemovedSinkStates(A)
##
##  Removes the sink states of the automaton A
##
InstallGlobalFunction(RemovedSinkStates, function(A)
    local s, I, F, q, a, i, T, t, Q, acc, len;
    
    if not IsDeterministicAutomaton(A) then
        Error("The argument must be a deterministic automaton");
    fi;
    
    A := CopyAutomaton(A);
    s := ListSinkStatesAut(A);
    T := StructuralCopy(A!.transitions);
    acc := Difference([1 .. A!.states], s);
    F := [];
    for i in A!.accepting do
        Add(F, Position(acc, i));
    od;
    I := Position(acc, A!.initial[1]);
    len := A!.states;
    for i in s do
        for q in Difference([1 .. A!.states], [i]) do
            for a in [1 .. A!.alphabet] do
                t := A!.transitions[a][q];
                if q < i then
                    if t = i then
                        T[a][q] := 0;
                    elif t < i then
                        T[a][q] := t;
                    else
                        T[a][q] := t-1;
                    fi;
                else
                    if t = i then
                        T[a][q-1] := 0;
                    elif t < i then
                        T[a][q-1] := t;
                    else
                        T[a][q-1] := t-1;
                    fi;
                fi;
            od;
        od;
        for a in [1 .. A!.alphabet] do
            Unbind(T[a][len]);
        od;
        len := len - 1;
    od;
    A!.states := Length(acc);
    A!.transitions := T;
    A!.initial := [I];
    A!.accepting := F;
    return(A);
end);


#############################################################################
##
#F  IsRecognizedByAutomaton(A, word, alphabet)
##
##  Tests if a given word is recognized by the given automaton
##
InstallGlobalFunction(IsRecognizedByAutomaton, function(arg)
    local A, w, alph,
          i, c, a, s, x;
    
    if Length(arg) < 2 then
        Error("Please supply an automaton and a string");
    fi;
    if not IsAutomatonObj(arg[1]) then
        Error("The first argument must be an automaton");
    fi;
    if not IsList(arg[2]) then
        Error("The second argument must be a list");
    fi;
    A := MinimalAutomaton(arg[1]);
    w := arg[2];
    alph := AlphabetOfAutomaton(A);
    if IsList(alph) then
        for a in w do
            if not a in alph then
                return(false);
            fi;
        od;
    else
        if alph < 22 then
            alph := "abcdefghijklmnopqrstu";
        else
            alph := List([1..alph], k -> Concatenation("a", String(k)));
        fi;
    fi;

    s := A!.initial[1];
    for c in w do
        a := Position(alph, c);
        if a = 0 or a > A!.alphabet then
            return(false);
        fi;
        s := A!.transitions[a][s];
    od;
    if s in A!.accepting then
        return(true);
    else
        return(false);
    fi;
end);

#############################################################################
##
#F  NormalizedAutomaton(A)
##
##  Returns the equivalent automaton but the initial state is numbered 1
##  and the final states have the last numbers
##
InstallGlobalFunction(NormalizedAutomaton, function(A)
    local X, s, r, q, p, i, j, m, n, comp_list;
    
    if not IsAutomaton(A) then
        Error("The argument must be a deterministic automaton");
    fi;
    if not IsDeterministicAutomaton(A) then
        Error("The argument must be a deterministic automaton");
    fi;
    
    comp_list := function(ls, re)# auxiliar function 
        # ls is a list with holes with length q; 
        # re is a list
        # with as many elements as the holes in ls
        # which may occur at the end of the list
        local h, i, k, n;
        h := Filtered([1 .. q], n -> not IsBound(ls[n]));
        k := 1;
        for i in h do
            ls[i] := re[k];
            Unbind(re[k]);
            k := k + 1;
        od;
        ls := Concatenation(ls,Compacted(re));
        return ls;
    end;
    
    q := A!.states;
    p := [];
    r := A!.initial[1];
    X := ShallowCopy(A!.accepting);
    X := Difference(X, A!.initial);
    n := Length(X);
    s := Difference(Difference([1 .. q], A!.initial), A!.accepting);
    p[r] := 1;
    for j in [1 .. n] do
        p[X[j]] := q - n +j;
    od;
    s := [2..q-n];
    return(PermutedAutomaton(A, comp_list(p, s)));
end);

#############################################################################
##
#F  UnionAutomata(A, B)
##
## Produces the disjoint union of the automata A and B
##
InstallGlobalFunction(UnionAutomata, function(A, B)
    local QA, i, a, T, I, F;
    
    if not (IsAutomatonObj(A) and IsAutomatonObj(B)) then
        Error("The arguments must be two automata");
    fi;
    if A!.type = "nondet" then
        A := NFAtoDFA(A);
    fi;
    if A!.type = "epsilon" then
        A := NFAtoDFA(EpsilonToNFA(A));
    fi;
    if B!.type = "nondet" then
        B := NFAtoDFA(B);
    fi;
    if B!.type = "epsilon" then
        B := NFAtoDFA(EpsilonToNFA(B));
    fi;
    if not AlphabetOfAutomaton(A) = AlphabetOfAutomaton(B) then
        Error("The arguments must be two automata over the same alphabet");
    fi;
    
    QA := A!.states;
    T := StructuralCopy(A!.transitions);
    for a in [1 .. B!.alphabet] do
        for i in [1 .. B!.states] do
            if B!.transitions[a][i] = 0 then
                T[a][QA + i] := 0;
            else
                T[a][QA + i] := QA + B!.transitions[a][i];
            fi;
        od;
    od;    
    I := ShallowCopy(A!.initial);
    Add(I, QA + B!.initial[1]);
    F := ShallowCopy(A!.accepting);
    for i in B!.accepting do
        Add(F, QA + i);
    od;
    return(Automaton("nondet", QA + B!.states, AlphabetOfAutomaton(A), T, I, F));
end);

#############################################################################
##
#F  ReversedAutomaton(A)
##
##  Returns the automaton obtained from A by reversing its edges and
##  switching the accepting and initial states
##
InstallGlobalFunction(ReversedAutomaton, function(A)
    local q, s, u, a, T;
    
    if not IsAutomatonObj(A) then
        Error("The argument must be an automaton");
    fi;
    T := [];
    for a in [1 .. A!.alphabet] do
        T[a] := [];
        for q in [1 .. A!.states] do
            T[a][q] := [];
        od;
    od;
    for a in [1 .. A!.alphabet] do
        for q in [1 .. A!.states] do
            s := A!.transitions[a][q];
            if IsList(s) then
                for u in s do
                    if IsPosInt(u) then
                        Add(T[a][u], q);
                    fi;
                od;
            elif IsPosInt(s) then
                Add(T[a][s], q);
            fi;
        od;
    od;
    return(Automaton("nondet", A!.states, AlphabetOfAutomaton(A), T, ShallowCopy(A!.accepting), ShallowCopy(A!.initial)));
end);


#############################################################################
##
#F  IsReversibleAutomaton(A)
##
##  Tests if the given automaton is reversible in the sense
##  that the reversed automaton might be regarded as deterministic
##  automaton
##
InstallGlobalFunction(IsReversibleAutomaton, function(A)
    local B, q, a;
    
    if not IsAutomatonObj(A) then
        Error("The argument must be an automaton");
    fi;
    if not A!.type = "det" then
        Print("The automaton is not deterministic");
        return(false);
    fi;
    if Length(A!.accepting) > 1 then
        Print("The automaton has more than one accepting state");
        return(false);
    fi;
    if Length(A!.accepting) < 1 then
        Print("The automaton has less than one accepting state");
        return(false);
    fi;
    B := ReversedAutomaton(A);
    for a in [1 .. B!.alphabet] do
        for q in [1 .. B!.states] do
            if Length(B!.transitions[a][q]) > 1 then
                return(false);
            fi;
        od;
    od;
    return(true);
end);





#############################################################################
##
#F ProductOfLanguages(a1, a2)
##
## Given two regular languages (as automata or rational expressions),
## returns an automaton that recognizes the concatenation of the given 
## languages, that is, the set of words <M>uv</M> such that
## <M>u</M> belongs to the first language and <M>v</M>
## belongs to the second language.
##
InstallGlobalFunction(ProductOfLanguages, function(a1, a2)
    local a, q, s, T, A;
    
    if IsAutomaton(a1) then
        a1 := MinimalAutomaton(a1);
    elif IsRationalExpression(a1) then
        a1 := RatExpToAut(a1);
    else
        Error("The first argument must be an automaton or a rational expression");
    fi;
    if IsAutomaton(a2) then
        a2 := MinimalAutomaton(a2);
    elif IsRationalExpression(a2) then
        a2 := RatExpToAut(a2);
    else
        Error("The second argument must be an automaton or a rational expression");
    fi;
    
    if not AlphabetOfAutomaton(a1) = AlphabetOfAutomaton(a2) then
        Error("A1 and A2 must have the same alphabet");
    fi;
    
    a1 := RemovedSinkStates(a1);
    a2 := RemovedSinkStates(a2);
    
    T := List(a1!.transitions, l -> List(l, q -> [q]));
    
    for a in [1..a2!.alphabet] do
        for q in [1..a2!.states] do
            if a2!.transitions[a][q] = 0 then
                Add(T[a], []);
            else
                Add(T[a], [a2!.transitions[a][q] + a1!.states]);
            fi;
        od;
    od;
    
    Add(T, List([1..a1!.states+a2!.states], i -> []));
    
    for q in a1!.accepting do
        for s in a2!.initial do
            Add(T[a1!.alphabet + 1][q], a1!.states + s);
        od;
    od;
    
    A := Automaton("epsilon", a1!.states + a2!.states, 
                 a1!.alphabet + 1,
                 T,
                 ShallowCopy(a1!.initial),
                 List(a2!.accepting, q -> q + a1!.states));

    A := MinimalAutomaton(A);
    A := RemovedSinkStates(A);
    FamilyObj(A)!.alphabet := AlphabetOfAutomaton(a1);
    return(A);
end);

#E



