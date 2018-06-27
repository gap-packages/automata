############################################################################
##
#W  aut-rat.gi                        Manuel Delgado <mdelgado@fc.up.pt>
#W                                      Jose Morais    <josejoao@fc.up.pt>
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
#############################################################################
##
##  This file contains functions involving automata and rational expressions
##
##
#############################################################################
##
#F  FAtoRatExp(A)
##
##  From a finite automaton, computes the equivalent rational expression,
##  using the state elimination algorithm.
##
InstallGlobalFunction(FAtoRatExp, function(A)
    local T,             # Transition function of the GTG
          WT,            # Weighted transition function of the GTG
          Nout,          # Number of edges going out to distinct vertices
          Nin,           # Number of edges coming in from distinct vertices
          Invertices,    # The numbers of the vertices that have a transition into i
          Outvertices,   # The numbers of the vertices that have a transition from i
          Inv,
          Outv,
          Q,             # The number of states of the GTG without counting q0 and qf
          q0, qf,        # The two extra states of the GTG
          WL,
          V,
          computeGTG,
          destroyLoop,
          destroyState,
          computeWeight,
          computeBest,   # Returns the state whose removal augments less the wheight of WT
          flag,
          i, r,
          alph; #alphabet of the automaton
    
    if not IsAutomatonObj(A) then
        Error("The argument to FAtoRatExp must be an automaton");
    fi;
    alph := AlphabetOfAutomatonAsList(A);
    if A!.type = "epsilon" then
        Unbind(alph[Length(alph)]);
    fi;
            
    T  := [];  # Transition function of the GTG
    WT := [];
    WL := [];
    Nout := [];
    Nin := [];
    Q  := A!.states;
    q0 := A!.states + 1;
    qf := A!.states + 2;
    for i in [1 .. qf] do
        Nin[i] := 0;
    od;
    Nout[q0] := 0;  # Value not used but saves tests
    Nout[qf] := 0;  # Value not used but saves tests
    Invertices  := [];
    Outvertices := [];
    for i in [1 .. Q+2] do
        Invertices[i]  := [];
        Outvertices[i] := [];
    od;
            
    ##  Function that computes the GTG (generalized transition graph)
    ##  associated with the given FA.
    computeGTG := function()
#        local   p,  q,  list,  c,  a,  list2,  x;
        local list,  # List of alphabet symbols
              list2,
              x,
              a,     # Alphabet symbol
              c,     # Counter
              p, q;  # States
        
        if A!.type = "nondet" then
            for p in [1 .. A!.states] do
                T[p] := [];
                WT[p] := [];
                Nout[p] := 0;
                for q in [1 .. A!.states] do
                    list := [];
                    c := 0;
                    for a in [1 .. A!.alphabet] do
                        if q in A!.transitions[a][p] then
                            Add(list, a);
                            c := c + 1;
                            if not q = p then
                                AddSet(Invertices[q], p);
                                AddSet(Outvertices[p], q);
                            fi;
                        fi;
                    od;
                    if list = [] then
                        T[p][q] := 0;  # 0 means the empty_set
                        WT[p][q] := -1;
                    elif IsBound(list[2]) then
                        T[p][q] := RatExpOnnLetters(alph, "union", List(list, a -> RatExpOnnLetters(alph, [], [a])));
                        WT[p][q] := c;
                        if not p = q then
                            Nout[p] := Nout[p] + 1;
                            Nin[q] := Nin[q] + 1;
                        fi;
                    else
                        T[p][q] := RatExpOnnLetters(alph, [], list);
                        WT[p][q] := c;
                        if not p = q then
                            Nout[p] := Nout[p] + 1;
                            Nin[q] := Nin[q] + 1;
                        fi;
                    fi;
                od;
            od;
        elif A!.type = "epsilon" then
            for p in [1 .. A!.states] do
                T[p] := [];
                WT[p] := [];
                Nout[p] := 0;
                for q in [1 .. A!.states] do
                    list := [];
                    c := 0;
                    for a in [1 .. A!.alphabet-1] do
                        if q in A!.transitions[a][p] then
                            Add(list, a);
                            c := c + 1;
                            if not q = p then
                                AddSet(Invertices[q], p);
                                AddSet(Outvertices[p], q);
                            fi;
                        fi;
                    od;
                    a := A!.alphabet;
                    if q in A!.transitions[a][p] then
                        Add(list, 0);
                        if not q = p then
                            AddSet(Invertices[q], p);
                            AddSet(Outvertices[p], q);
                        fi;
                    fi;
                    if list = [] then
                        T[p][q] := 0;  # 0 means the empty_set
                        WT[p][q] := -1;
                    elif IsBound(list[2]) then
                        list2 := [];
                        for x in list do
                            if x = 0 then
                                    Add(list2, RatExpOnnLetters(alph, [], []));
                           else
                                    Add(list2, RatExpOnnLetters(alph, [], [x]));
                            fi;
                        od;
                            T[p][q] := RatExpOnnLetters(alph, "union", list2);
                        WT[p][q] := c;
                        if not p = q then
                            Nout[p] := Nout[p] + 1;
                            Nin[q] := Nin[q] + 1;
                        fi;
                    else
                        if list = [0] then
                                T[p][q] := RatExpOnnLetters(alph, [], []);
                        else
                                T[p][q] := RatExpOnnLetters(alph, [], list);
                        fi;
                        WT[p][q] := c;
                        if not p = q then
                            Nout[p] := Nout[p] + 1;
                            Nin[q] := Nin[q] + 1;
                        fi;
                    fi;
                od;
            od;
        else
            for p in [1 .. A!.states] do
                T[p] := [];
                WT[p] := [];
                Nout[p] := 0;
                for q in [1 .. A!.states] do
                    list := [];
                    c := 0;
                    for a in [1 .. A!.alphabet] do
#                    for a in alph do
                        if q = A!.transitions[a][p] then  # The only difference to the nondeterministic case
                            Add(list, a);
                            c := c + 1;
                            if not q = p then
                                AddSet(Invertices[q], p);
                                AddSet(Outvertices[p], q);
                            fi;
                        fi;
                    od;
                    if list = [] then
                        T[p][q] := 0;  # 0 means the empty_set
                        WT[p][q] := -1;
                    elif IsBound(list[2]) then
                        T[p][q] := RatExpOnnLetters(alph, "union", List(list, a -> RatExpOnnLetters(alph, [], [a])));
                        WT[p][q] := c;
                        if not p = q then
                            Nout[p] := Nout[p] + 1;
                            Nin[q] := Nin[q] + 1;
                        fi;
                    else
                        T[p][q] := RatExpOnnLetters(alph, [], list);
                        WT[p][q] := c;
                        if not p = q then
                            Nout[p] := Nout[p] + 1;
                            Nin[q] := Nin[q] + 1;
                        fi;
                    fi;
                od;
            od;
        fi;
        T[q0] := []; T[qf] := [];
        WT[q0] := []; WT[qf] := [];
        for p in [1 .. A!.states] do
            T[p][q0] := 0;
            WT[p][q0] := -1;
            if p in A!.accepting then
                if A!.type = "epsilon" then
                        T[p][qf] := RatExpOnnLetters(alph, [], []);
                else
                    T[p][qf] := RatExpOnnLetters(alph, [], []);
                fi;
                WT[p][qf] := 0;
                Nout[p] := Nout[p] + 1;
                AddSet(Invertices[qf], p);
                AddSet(Outvertices[p], qf);
            else
                T[p][qf] := 0;
                WT[p][qf] := -1;
            fi;
        od;
        for q in [1 .. A!.states] do
            if q in A!.initial then
                if A!.type = "epsilon" then
                        T[q0][q] := RatExpOnnLetters(alph, [], []);
                else
                    T[q0][q] := RatExpOnnLetters(alph, [], []);
                fi;
                WT[q0][q] := 0;
                Nin[q] := Nin[q] + 1;
                AddSet(Invertices[q], q0);
                AddSet(Outvertices[q0], q);
            else
                T[q0][q] := 0;
                WT[q0][q] := -1;
            fi;
            T[qf][q] := 0;
            WT[qf][q] := -1;
        od;
        T[q0][q0] := 0; T[q0][qf] := 0; T[qf][q0] := 0; T[qf][qf] := 0;
        WT[q0][q0] := -1; WT[q0][qf] := -1; WT[qf][q0] := -1; WT[qf][qf] := -1;
    end;
    ##  End of computeGTG()  --
    
    ##  Function that deletes a loop in the GTG
    destroyLoop := function(n)
        local q;
        
        if not T[n][n] = 0 then
            for q in [1 .. n-1] do
                if T[n][q] = 0 then
                elif T[n][q]!.list_exp = [] then
                    T[n][q] := StarRatExp(T[n][n]);
                    WT[n][q] := WT[n][n];
                else
                    T[n][q] := ProductRatExp(StarRatExp(T[n][n]), T[n][q]);
                    WT[n][q] := WT[n][n] + WT[n][q];
                fi;
            od;
            for q in [n+1 .. Q+2] do
                if T[n][q] = 0 then
                elif T[n][q]!.list_exp = [] then
                    T[n][q] := StarRatExp(T[n][n]);
                    WT[n][q] := WT[n][n];
                else
                    T[n][q] := ProductRatExp(StarRatExp(T[n][n]), T[n][q]);
                    WT[n][q] := WT[n][n] + WT[n][q];
                fi;
            od;
            T[n][n] := 0;
            WT[n][n] := -1;
        fi;
    end;
    ##  End of destroyLoop()  --
    
    
    ##  Function that deletes a state in the GTG
    destroyState := function(n)
        local p, q;
        
        for p in Invertices[n] do
            for q in Outvertices[n] do
                if T[p][q] = 0 then
                    T[p][q] := ProductRatExp(T[p][n], T[n][q]);
                    WT[p][q] := WT[p][n] + WT[n][q];
                else
                    T[p][q] := UnionRatExp(ProductRatExp(T[p][n], T[n][q]), T[p][q]);
                    if WT[p][q] = 0 then
                        WT[p][q] := WT[p][n] + WT[n][q] + 1;
                    else
                        WT[p][q] := WT[p][n] + WT[n][q] + WT[p][q];
                    fi;
                fi;
            od;
        od;
        for p in [1 .. n-1] do
            for q in [n .. Q+1] do
                T[p][q] := T[p][q+1];
                WT[p][q] := WT[p][q+1];
            od;
        od;
        for p in [n .. Q+1] do
            T[p] := T[p+1];
            WT[p] := WT[p+1];
            for q in [n .. Q+1] do
                T[p][q] := T[p][q+1];
                WT[p][q] := WT[p][q+1];
            od;
        od;
        Q := Q - 1;
        for p in [1 .. Q+2] do
            Nout[p] := 0;  Nin[p] := 0;
            Invertices[p] := [];  Outvertices[p] := [];
        od;
        for p in [1 .. Q+2] do
            for q in [1 .. p-1] do
                if WT[p][q] >= 0 then
                    Nout[p] := Nout[p] + 1;
                    Nin[q] := Nin[q] + 1;
                    AddSet(Invertices[q], p);
                    AddSet(Outvertices[p], q);
                fi;
            od;
            for q in [p+1 .. Q+2] do
                if WT[p][q] >= 0 then
                    Nout[p] := Nout[p] + 1;
                    Nin[q] := Nin[q] + 1;
                    AddSet(Invertices[q], p);
                    AddSet(Outvertices[p], q);
                fi;
            od;
        od;
    end;
    ##  End of destroyState()  --
    
    
    computeWeight := function(i)
        local w, p, q;
        

        w := 0;
        for p in Invertices[i] do
            w := w + WT[p][i] * (Nout[i] - 1);
        od;
        if WT[i][i] = -1 then  # Do nothing, there is no loop
        else
            w := w + WT[i][i] * (Nout[i] * Nin[i] - 1);
        fi;
        for q in Outvertices[i] do
            w := w + WT[i][q] * (Nin[i] - 1);
        od;
        return(w);
    end;
    ##  End of computeWeight()  --
    
    
    computeBest := function()
        local   i;
        
        if WL = [] then
            for i in [1 .. Q] do
                AddSet(WL, [computeWeight(i),i]);
            od;
        else
            for i in Inv do
                AddSet(WL, [computeWeight(i),i]);
            od;
            for i in Outv do
                AddSet(WL, [computeWeight(i),i]);
            od;
        fi;
        return(WL[1][2]);
    end;
    ##  End of computeBest()  --
            
            
    
    computeGTG();
    flag := true;
    while flag do
        flag := false;
        for i in [1 .. Q] do
            if Nout[i] = 0 then
                destroyLoop(i);
                destroyState(i);
                flag := true;
                break;
            fi;
        od;
    od;
    flag := true;
    while flag do
        flag := false;
        for i in [1 .. Q] do
            if Nin[i] = 0 then
                destroyLoop(i);
                destroyState(i);
                flag := true;
                break;
            fi;
        od;
    od;
    while Q > 0 do
        V := computeBest();
        i := 1;
        while IsBound(WL[i]) do
            if WL[i][2] = V then
                Unbind(WL[i]);
            elif WL[i][2] > V then
                if WL[i][2] in Invertices[V] or WL[i][2] in Outvertices[V] then
                    Unbind(WL[i]);
                else
                    WL[i][2] := WL[i][2] - 1;
                fi;
            else
                if WL[i][2] in Invertices[V] or WL[i][2] in Outvertices[V] then
                    Unbind(WL[i]);
                fi;
            fi;
            i := i + 1;
        od;
        WL := Compacted(WL);
        Inv := Difference(Invertices[V], [Q+1,Q+2]);
        Outv := Difference(Outvertices[V], [Q+1,Q+2]);
        i := 1;
        while IsBound(Inv[i]) do
            if Inv[i] > V then
                Inv[i] := Inv[i] - 1;
            fi;
            i := i + 1;
        od;
        i := 1;
        while IsBound(Outv[i]) do
            if Outv[i] > V then
                Outv[i] := Outv[i] - 1;
            fi;
            i := i + 1;
        od;
        destroyLoop(V);
        destroyState(V);
    od;
    
    if T[1][2] = 0 then
        if A!.type = "epsilon" then
            r := RatExpOnnLetters(alph, [], "empty_set");
        else
            r := RatExpOnnLetters(alph, [], "empty_set");
        fi;
        Setter(SizeRatExp)(r,0);
        return(r);
    else
        r := T[1][2];
        if WT[1][2] = 0 then
            Setter(SizeRatExp)(r,1);
        else
            Setter(SizeRatExp)(r,WT[1][2]);
        fi;
        return(r);
    fi;
end);




########################################################################
##
#F  MinimalKnownRatExp(A)
##
##  Returns the minimal known rat exp equivalent to the given automaton
##
InstallMethod(MinimalKnownRatExp,"for finite automata", true,
              [IsAutomatonObj and IsAutomatonRep], 0,
        function(A)
    return([FAtoRatExp(A)]);
end);

#############################################################################
##
#F  RatExpToNDAut(R)
##
##  Given a rational expression R, computes an equivalent NFA using
##  the Glushkov algorithm.
##
InstallGlobalFunction(RatExpToNDAut, function(R)
    local r, n, map, mark, markToRExp, alphabet, al2,
          F, delta, q, fol,
          i, j,
          epsInLRatExp, compFirst, compLast, compFollow, isOnlyEpsilon, isOnlyEmptySet;
    
    if not IsRationalExpression(R) then
        Error("The argument to RatExpToNDAut must be a rational expression");
    fi;
    map      := [];
    n        := 1;
    alphabet := FamilyObj(R)!.alphabet;
    al2 := AlphabetOfRatExpAsList(R);
    
    
    isOnlyEpsilon := function(R)
        if R!.op = [] then
            if R!.list_exp = [] then
                return(true);
            else
                return(false);
            fi;
        elif R!.op = "star" then
            return(isOnlyEpsilon(R!.list_exp));
        else
            return(ForAll(R!.list_exp, x -> isOnlyEpsilon(x)));
        fi;
        
    end;
    
    
    isOnlyEmptySet := function(R)
        if R!.op = [] then
            if R!.list_exp = "empty_set" then
                return(true);
            else
                return(false);
            fi;
        elif R!.op = "star" then
            return(isOnlyEmptySet(R!.list_exp));
        else
            return(ForAll(R!.list_exp, x -> isOnlyEmptySet(x)));
        fi;
        
    end;
    
    # Empty word
    if isOnlyEpsilon(R) then
        delta := [];
        for i in [1 .. alphabet] do
            delta[i] := [[]];
        od;
        return(Automaton("nondet", 1, al2, delta, [1], [1]));
    fi;
    
    # Empty Set
    if isOnlyEmptySet(R) then
        delta := [];
        for i in [1 .. alphabet] do
            delta[i] := [[]];
        od;
        return(Automaton("nondet", 1, al2, delta, [1], []));
    fi;
        
    ##  Tests whether epsilon is in the language L(r)
    epsInLRatExp := function(r)
        if r!.op = [] then
            if r!.list_exp = [] then
                return(true);
            else
                return(false);
            fi;
        elif r!.op = "star" then
            return(true);
        elif r!.op = "union" then
            return(ForAny(r!.list_exp, i -> epsInLRatExp(i)));
        else  # op = "product"
            return(ForAll(r!.list_exp, i -> epsInLRatExp(i)));
        fi;
    end;
        
    ##  For a rational expression r over {alphabet}, computes the set first(r) where
    ##  first(r)={a belongs to {alphabet}| there exists v belonging to {alphabet}* :
    ##            av belongs to L(r)}
    compFirst := function(r)
        local r1, l;
    
        if r!.op = [] then
            if Length(r!.list_exp) = 1 then
                return(ShallowCopy(r!.list_exp));
            elif r!.list_exp = [] or r!.list_exp = "empty_set" then
                return([]);
            fi;
        elif r!.op = "union" then
            l := [];
            for r1 in r!.list_exp do
                UniteSet(l, compFirst(r1));
            od;
            return(l);
        elif r!.op = "product" then
            l := [];
            for r1 in r!.list_exp do
                UniteSet(l, compFirst(r1));
                if not epsInLRatExp(r1) then
                    return(l);
                fi;
            od;
            return(l);
        else # op = "star"
            return(compFirst(r!.list_exp));
        fi;
    end;

    ##  For a rational expression r over {alphabet}, computes the set last(r) where
    ##  last(r)={a belongs to {alphabet}| there exists v belonging to {alphabet}* :
    ##            va belongs to L(r)}
    compLast := function(r)
        local r1, l;
    
        if r!.op = [] then
            if Length(r!.list_exp) = 1 then
                return(ShallowCopy(r!.list_exp));
            elif r!.list_exp = [] or r!.list_exp = "empty_set" then
                return([]);
            fi;
        elif r!.op = "union" then
            l := [];
            for r1 in r!.list_exp do
                UniteSet(l, compLast(r1));
            od;
            return(l);
        elif r!.op = "product" then
            l := [];
            for r1 in Reversed(r!.list_exp) do
                UniteSet(l, compLast(r1));
                if not epsInLRatExp(r1) then
                    return(l);
                fi;
            od;
            return(l);
        else    # op = "star"
            return(compLast(r!.list_exp));
        fi;
    end;

    ##  R is a rational expression on distinct symbols q1,...,qn
    ##  computes followR(qi), returning the array Fol where
    ##  Fol[i] = followR(qi) where for b belonging to the alphabet of R
    ##  followR(b)={a belongs to {alphabet}| there exist u, v belonging
    ##              to {alphabet}* : ubav belongs to L(R)}
    ##
    ##  Must be called as compFollow(R, [], [])
    ##
    compFollow := function(R, f, Fol)
        local r, i, j, k, f2, len, first, list;
        
        if R!.op = [] then
            if Length(R!.list_exp) = 1 then
                Fol[R!.list_exp[1]] := ShallowCopy(f);
                return(Fol);
            elif R!.list_exp = [] or R!.list_exp = "empty_set" then
                return(Fol);
            fi;        
        elif R!.op = "product" then
            len := Length(R!.list_exp);
            Fol := compFollow(R!.list_exp[len], f, Fol);
            for i in [2 .. len] do
                j := len - i + 1;
                first := compFirst(R!.list_exp[j+1]);
                if epsInLRatExp(R!.list_exp[j+1]) then
                    UniteSet(f, first);
                    Fol := compFollow(R!.list_exp[j], f, Fol);
                else
                    f := ShallowCopy(first);
                    Fol := compFollow(R!.list_exp[j], first, Fol);
                fi;
            od;
            return(Fol);
        elif R!.op = "union" then
            list := List([1 .. Length(R!.list_exp)], i -> ShallowCopy(f));
            k := 1;
            for r in R!.list_exp do
                Fol := compFollow(r, list[k], Fol);
                k := k + 1;
            od;
            return(Fol);
        else  # op = "star"
            f2 := ShallowCopy(f);
            UniteSet(f2, compFirst(R!.list_exp));
            Fol := compFollow(R!.list_exp, f2, Fol);
            return(Fol);
        fi;
    end;

        
    ##  Given a rational expression rexp over {alphabet}, returns a list
    ##  that represents the structure of rexp with all distinct symbols q1 .. qn
    ##  for example if rexp = ab, mark(rexp) returns
    ##  [ "product", [ [ [  ], [ 1 ] ], [ [  ], [ 2 ] ] ] ]
    ##
    ##  mark(bUab) returns
    ##  [ "union", [ [ [  ], [ 1 ] ], [ "product", [ [ [  ], [ 2 ] ], [ [  ], [ 3 ] ] ] ] ] ]
    ##
    ##  mark((bUab)*) returns
    ##  [ "star", [ [ "union", [ [ [  ], [ 1 ] ], [ "product", [ [ [  ], [ 2 ] ], [ [  ], [ 3 ] ] ] ] ] ] ] ]
    ##
    ##  it also builds a mapping (map) from {q1 .. qn} -> {alphabet}
    mark := function(rexp)
        local r, el;
        
        if rexp!.op = [] then
            if Length(rexp!.list_exp) = 1 then
                map[n] := rexp!.list_exp[1];
                n := n+1;
                return([[],[n-1]]);
            elif rexp!.list_exp = [] or rexp!.list_exp = "empty_set" then
                return([]);
            fi;
        elif rexp!.op = "product" then
            el := [];
            for r in rexp!.list_exp do
                Add(el, mark(r));
            od;
            return(["product", el]);
        elif rexp!.op = "union" then
            el := [];
            for r in rexp!.list_exp do
                Add(el, mark(r));
            od;
            return(["union", el]);
        else     # op = "star"
            return(["star", [mark(rexp!.list_exp)]]);
        fi;
    end;
    
    r := mark(R);
    n := n-1;
        
    ##  Returns the rational expression represented by the output
    ##  of the previous function mark(rexp)
    markToRExp := function(L)
        local r, list;
        
#        
#        if L = [] then
#            return(RatExpOnnLetters(alphabet, [], []));
#        elif L[1] = [] then
#            return(RatExpOnnLetters(n, [], L[2]));
#        elif L[1] = "star" then
#            return(RatExpOnnLetters(n, "star", markToRExp(L[2][1])));
#        else # op = "product" or op = "union"
#            list := [];
#            for r in L[2] do
#                Add(list, markToRExp(r));
#            od;
#            return(RatExpOnnLetters(n, L[1], list));
#        fi;
        
        if L = [] then
            return(RatExpOnnLetters(al2, [], []));
        elif L[1] = [] then
            return(RatExpOnnLetters(al2, [], L[2]));
        elif L[1] = "star" then
            return(RatExpOnnLetters(al2, "star", markToRExp(L[2][1])));
        else # op = "product" or op = "union"
            list := [];
            for r in L[2] do
                Add(list, markToRExp(r));
            od;
            return(RatExpOnnLetters(al2, L[1], list));
        fi;
    end;
    
    r := markToRExp(r);

    # The initial state
    n := n+1;
    
    F := compLast(r);

    delta := [];
    i := 1;
    while i <= alphabet do
        j := 1;
        delta[i] := [];
        while j <= n do
            delta[i][j] := [];
            j := j + 1;
        od;
        i := i + 1;
    od;
        
        
    for q in compFirst(r) do
        Add(delta[map[q]][n], q);
    od;
    fol := compFollow(r, [], []);
    for i in [1 .. n-1] do
        for q in fol[i] do
            Add(delta[map[q]][i], q);
        od;
    od;
    if epsInLRatExp(r) then
        return(Automaton("nondet", n, al2, delta, [n], Union(F, [n])));
    else
        return(Automaton("nondet", n, al2, delta, [n], F));
    fi;
end);

#############################################################################
##
#F  RatExpToAut(R)
##
##  Given a rational expression R, uses  RatExpToNDAut to compute the 
##  equivalent NFA and then returns the equivalent minimal DFA
##
InstallGlobalFunction(RatExpToAut, function(r)
    return(MinimalAutomaton(RatExpToNDAut(r)));
end);

#E
##
