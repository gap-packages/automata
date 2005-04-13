############################################################################
##
#W  aut-basics.gi                        Manuel Delgado <mdelgado@fc.up.pt>
#W                                      Jose Morais    <jjoao@netcabo.pt>
##
#H  @(#)$Id: aut-basics.gi,v 1.06 $
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
InstallMethod(AlphabetOfAutomaton,
        "Returns the alphabet of the automaton",
        [IsAutomatonObj],
        function( A )
    
    return(FamilyObj(A)!.alphabet);
end);
#############################################################################
##
#A TransitionMatrixOfAutomaton(A)
##
## returns the transition matrix of the automaton
##
InstallMethod(TransitionMatrixOfAutomaton,
        "Returns the transition matrix of the automaton",
        [IsAutomatonObj],
        function( A )
    return(A!.transitions);
end);
#############################################################################
##
#A InitialStatesOfAutomaton(A)
##
## returns the initial states of the automaton
##
InstallMethod(InitialStatesOfAutomaton,
        "Returns the initial states of the automaton",
        [IsAutomatonObj],
        function( A )
    return(A!.initial);
end);
#############################################################################
##
#A FinalStatesOfAutomaton(A)
##
## returns the final states of the automaton
##
InstallMethod(FinalStatesOfAutomaton,
        "Returns the final states of the automaton",
        [IsAutomatonObj],
        function( A )
    return(A!.accepting);
end);
#############################################################################
##
#A NumberStatesOfAutomaton(A)
##
## returns the number of states of the automaton
##
InstallMethod(NumberStatesOfAutomaton,
        "Returns the final states of the automaton",
        [IsAutomatonObj],
        function( A )
    return(A!.states);
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
    return Automaton("det", b, ShallowCopy(FamilyObj(aut)!.alphabet), t, aut!.initial, aut!.accepting);
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
            Add(list, Automaton("epsilon", A!.states, FamilyObj(A)!.alphabet, T, List(A!.initial, q -> perm[q]), List(A!.accepting, q -> perm[q])));
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
            Add(list, Automaton("nondet", A!.states, FamilyObj(A)!.alphabet, T, List(A!.initial, q -> perm[q]), List(A!.accepting, q -> perm[q])));
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
            Add(list, Automaton("det", A!.states, FamilyObj(A)!.alphabet, T, [perm[A!.initial[1]]], List(A!.accepting, q -> perm[q])));
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
        return(Automaton("det", A!.states, FamilyObj(A)!.alphabet, T, [perm[A!.initial[1]]], List(A!.accepting, q -> perm[q])));
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
        return(Automaton("nondet", A!.states, FamilyObj(A)!.alphabet, T, List(A!.initial, q -> perm[q]), List(A!.accepting, q -> perm[q])));
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
        return(Automaton("epsilon", A!.states, FamilyObj(A)!.alphabet, T, List(A!.initial, q -> perm[q]), List(A!.accepting, q -> perm[q])));
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
        
    if ForAll(A!.transitions, n -> IsDenseList(n) and 
              ForAll(n,IsPosInt)) then
        return true;
    else
        return false;
    fi;
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
#F  RemoveSinkStates(A)
##
##  Removes the sink states of the automaton A
##
InstallGlobalFunction(RemoveSinkStates, function(A)
    local s, I, F, q, a, i, T, t, Q, acc, len;
    
    if not IsDeterministicAutomaton(A) then
        Error("The argument must be a deterministic automaton");
    fi;
    
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
#    return(A);
#    return(Automaton("det", Length(acc), AlphabetOfAutomaton(A), T, [I], F));
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
    if not IsString(arg[2]) then
        Error("The second argument must be a string");
    fi;
    A := MinimalAutomaton(arg[1]);
    w := arg[2];
    alph := AlphabetOfAutomaton(A);
    for a in w do
        if not a in alph then
            return(false);
        fi;
    od;
    
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

#E



