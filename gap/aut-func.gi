#############################################################################
##
#W  aut-func.gi                             Manuel Delgado <mdelgado@fc.up.pt>
#W                                          Steve Linton <sal@dcs.st-and.ac.uk>
#W                                          Jose Morais <josejoao@fc.up.pt>
##
##  This file contains functions that perform operations on automata
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
#############################################################################


BindGlobal("ComplementDA", da -> Automaton("det",da!.states, AlphabetOfAutomatonAsList(da), da!.transitions,
        da!.initial, Difference([1..da!.states], da!.accepting)));

InfoAutomataSL:=NewInfoClass("InfoAutomataSL");
SetInfoLevel(InfoAutomataSL,0);

#############################################################################
##
#F  EpsilonToNFA(A)
##
##  <A> is an automaton with epsilon-transitions. Returns an NFA
##  recognizing the same language.
##
InstallGlobalFunction(EpsilonToNFA, function(A)

    if not IsAutomatonObj(A) then
        Error("The argument to EpsilonToNFA must be an automaton");
    fi;
    if not A!.type = "epsilon" then
        Error("The argument to EpsilonToNFA must be an 'epsilon' automaton");
    fi;
    if A!.alphabet = 1 then
        return(Automaton("nondet", 1, 1, [[]], [1], []));
    fi;
    return(EpsilonToNFABlist(A));
end);


#############################################################################
##
#F  EpsilonCompactedAut(aut)
##
##  Returns the compacted epsilon automaton.
##
InstallGlobalFunction(EpsilonCompactedAut, function(aut)
    local   n,  parts,  partmap,  m,  p,  x,  tm,  r,  i;

    if not IsAutomatonObj(aut) then
        Error("The argument to EpsilonCompactedAut must be an automaton");
    fi;
    if not aut!.type = "epsilon" then
        Error("The argument to EpsilonCompactedAut must be an 'epsilon' automaton");
    fi;
    n := aut!.states;
    parts := Set(GraphStronglyConnectedComponents(aut!.transitions[aut!.alphabet]));
    if Length(parts) = n then
        Info(InfoAutomataSL,1,"Epsilon compacted ",aut!.states," no improvement");
        return aut;
    fi;
    partmap := [];
    m := Length(parts);
    for p in [1..m] do
        for x in parts[p] do
            partmap[x] := p;
        od;
    od;
    tm := List(aut!.transitions, t->
               List(parts, p-> Set(partmap{Union(t{p})})));
    r := tm[Length(tm)];
    for i in [1..m] do
        RemoveSet(r[i],i);
    od;
    Info(InfoAutomataSL,1,"Epsilon compacted from ",aut!.states," to ",Length(parts));
    return Automaton("epsilon", Length(parts), AlphabetOfAutomatonAsList(aut), tm,
                   Set(partmap{aut!.initial}), Set(partmap{aut!.accepting}));
end);


#############################################################################
##
#F  
##
##  EpsilonToNFASet(aut)
##
InstallGlobalFunction(EpsilonToNFASet, function(aut)
    local   eclos,  i,  comb,  n,  newet,  t;

    if not IsAutomatonObj(aut) then
        Error("The argument to EpsilonToNFASet must be an automaton");
    fi;
    if not aut!.type = "epsilon" then
        Error("The argument to EpsilonToNFASet must be an 'epsilon' automaton");
    fi;

    eclos := List(aut!.transitions[aut!.alphabet],ShallowCopy);
    for i in [1..aut!.states] do
        AddSet(eclos[i],i);
    od;
    comb := function(dig1,dig2)
        return List(dig1, x-> Union(dig2{x}));
    end;
    n := 1;
    while n < aut!.states do
        Info(InfoAutomataSL,3,"n = ",n," total size ",Sum(eclos, Length));
        newet := comb(eclos, eclos);
        n := n+n;
        if newet = eclos then
            break;
        else
            eclos := newet;
        fi;
    od;
    Info(InfoAutomataSL,2,"Finished Computing Closures, total size ",
         Sum(eclos, Length));
    t := List([1..aut!.alphabet-1], a -> List(aut!.transitions[a], x -> Union(eclos{x})));
    #    return Automaton("nondet",aut!.states, aut!.alphabet-1, t,
    return Automaton("nondet",aut!.states, AlphabetOfAutomatonAsList(aut){[1..AlphabetOfAutomaton(aut)-1]}, t,
                   Union(eclos{aut!.initial}), 
                   Filtered([1..aut!.states], i->
                           ForAny(eclos[i],x->x in aut!.accepting)));
end);


#############################################################################
##
#F  EpsilonToNFABlist(aut)
##
##  
##
InstallGlobalFunction(EpsilonToNFABlist, function(aut)
    local   index,  eclos,  i,  comb,  n,  newet,  t,  al;

    index := [1..aut!.states];
    eclos := List(aut!.transitions[aut!.alphabet],x->BlistList(index,x));
    for i in [1..aut!.states] do
        eclos[i][i] := true;
    od;
    comb := function(dig1,dig2)
        return List(dig1, row -> UnionBlist(ListBlist(dig2,row)));
    end;
    n := 1;
    while n < aut!.states do
        Info(InfoAutomataSL,3,"n = ",n," total size ",Sum(eclos, Length));
        newet := comb(eclos, eclos);
        n := n+n;
        if newet = eclos then
            break;
        else
            eclos := newet;
        fi;
    od;
    eclos := List(eclos, x->ListBlist(index,x));
    Info(InfoAutomataSL,2,"Finished Computing Closures, total size ",
         Sum(eclos, Length));
    t := List([1..aut!.alphabet-1], a -> List(aut!.transitions[a], x -> Union(eclos{x})));
    al := AlphabetOfAutomatonAsList(aut);
    Unbind(al[Length(al)]);
    return Automaton("nondet",aut!.states, al, t,
                   Union(eclos{aut!.initial}), 
                   Filtered([1..aut!.states], i->
                           ForAny(eclos[i],x->x in aut!.accepting)));
end);


#############################################################################
##
#F  ReducedNFA(aut)
##
##  
##
InstallGlobalFunction(ReducedNFA, function(aut)
    local   removeFromList,  n,  m,  alph,  a1,  a2,  partn,  partmap,  
            links,  head,  count,  nparts,  x,  itrans,  t,  it,  i,  j,  p,  
            a,  splitself,  pi,  k,  q,  x1,  x2,  tm,  ra;

    if not IsAutomatonObj(aut) then
        Error("The argument to ReducedNFA must be an automaton");
    fi;
    if not aut!.type = "nondet" then
        Error("The argument to ReducedNFA must be a NFA");
    fi;
    removeFromList := function(i)
        if IsBound(links[i]) then
            if head = i then
                head := links[i][1];
            fi;
            links[links[i][1]][2] := links[i][2];
            links[links[i][2]][1] := links[i][1];
            Unbind(links[i]);
            count := count -1;
            if count = 0 then
                head := 0;
            fi;
        fi;
    end;
    n := aut!.states;
    if n = 1 then
        return aut;
    fi;
    m := aut!.alphabet;
    alph := AlphabetOfAutomatonAsList(aut);
    a1 := Set(aut!.accepting);
    a2 := Difference([1..n], a1);
    if Length(a1) = 0 or Length(a2) = 0 then
        partn := [[1..n]];
        partmap := List([1..n],One);
        links := [[1,1]];
        head := 1;
        count := 1;
        nparts := 1;
    else
        partn := [a1,a2];
        partmap := [];
        links := [[2,2],[1,1]];
        head := 1;
        count := 2;

        for x in a1 do
            partmap[x] := 1;
        od;
        for x in a2 do
            partmap[x] := 2;
        od;
        nparts := 2;
    fi;
    itrans := [];
    for t in aut!.transitions do
        it := List([1..n],i->[]);
        for i in [1..n] do
            for x in t[i] do
                AddSet(it[x],i);
            od;
        od;
        Add(itrans, it);
    od;

    while count > 0 do
        j := head;
        p := partn[j];
        removeFromList(j);

        for a in [1..m] do
            splitself := false;
            pi := Union(itrans[a]{p});
            for k in Set(partmap{pi}) do
                q := partn[k];
                if Length(q) > 1 then
                    x1 := Intersection(q,pi);
                    if Size(x1) <> 0 and Size(x1) <> Size(q) then
                        x2 := Difference(q,x1);
                        if Length(x2) < Length(x1) then
                            x := x1;                        
                            x1 := x2;
                            x2 := x;
                        fi;
                        partn[k] := x2;
                        nparts := nparts + 1;
                        partn[nparts] := x1;
                        for x in x1 do
                            partmap[x] := nparts;
                        od;

                        removeFromList(k);

                        if head = 0 then
                            head := nparts;
                            links[nparts] := [k,k];
                            links[k] := [nparts,nparts];
                        else
                            links[k] := [nparts,links[head][2]];
                            links[nparts] := [head,k];
                            links[links[head][2]][1] := k;
                            links[head][2] := nparts;
                        fi;
                        count := count+2;
                        if k = j then
                            splitself := true;
                        fi;
                    fi;
                fi;
            od;
            if splitself then
                break;
            fi;
        od;
    od;
    tm := List([1..m], a->
               List(partn, p->Set(partmap{aut!.transitions[a][p[1]]})));

    ra :=  Automaton("nondet", Length(partn), alph, tm,
                   Set(partmap{aut!.initial}),
                   Filtered([1..Length(partn)], i->partn[i][1] in aut!.accepting));
    Info(InfoAutomataSL,1,"Reduced ",aut!.states," to ",Length(partn));
    Assert(2,AreEquivAut(aut, ra));
    return ra;

end);



#############################################################################
##
#F  NFAtoDFA(A)
##
##  Given an NFA, computes the equivalent DFA, using the powerset construction,
##  according to the algorithm presented in the report of the AMoRE program.
##  The returned automaton is dense deterministic
##
InstallGlobalFunction(NFAtoDFA, function(A)
    local   HashSet,  initstate,  states,  sstates,  Aaccept,  accepting,  m,  
            trans,  Atrans,  r,  i,  reported,  st,  a,  nst,  he;

    if not IsAutomatonObj(A) then
        Error("The argument to NFAtoDFA must be an automaton");
    fi;
    if A!.type = "det" then
        return(A);
    elif A!.type = "epsilon" then
        A := EpsilonToNFA(A);
    fi;

    HashSet := s->HashKeyBag(s,57,0,4+4*Length(s));

    initstate := Immutable(Set(A!.initial));
    states := [initstate];
    sstates := SparseHashTable(HashSet);
    Aaccept := Set(A!.accepting);
    AddHashEntry(sstates,initstate,1);
    if ForAny(initstate, x->x in Aaccept) then
        accepting := [1];
    else
        accepting := [];
    fi;
    m := A!.alphabet;
    trans := List([1..m], i->[]);

    Atrans := A!.transitions;
    for r in Atrans do
        for i in [1..Length(r)] do
            if not IsSet(r[i]) then
                r[i] := Set(r[i]);
            fi;
        od;
    od;
    reported := 0;
    i := 1;
    while i <= Length(states) do
        if Length(states)-reported > 100000 then
            Info(InfoAutomataSL,2,"Processing ",i," out of ",Length(states));
            reported := Length(states);
        fi;
        st := states[i];
        for a in [1..m] do
            r := Atrans[a];
            nst := Union(r{st});
            MakeImmutable(nst);
            he := GetHashEntry(sstates,nst);
            if he = fail then
                Add(states,nst);
                he := Length(states);
                if ForAny(nst, x->x in Aaccept) then
                    Add(accepting,he);
                fi;
                AddHashEntry(sstates,nst,he);
            fi;
            trans[a][i] := he;
        od;
        i := i+1;
    od;
    Info(InfoAutomataSL,1,"Determinized ",A!.states," to ",Length(states));
    return Automaton("det",Length(states),AlphabetOfAutomatonAsList(A),trans,
                   [1],accepting);
end);

#############################################################################
##
#F  UsefulAutomaton(A)
##
##  Given an automaton A, outputs a dense DFA B whose states are all reachable
##  and such that L(B) = L(A)
##
InstallGlobalFunction(UsefulAutomaton, function(A)
    local   fifo,  R,  q,  a,  q1,  map,  i,  T,  newacc;

    if not IsAutomatonObj(A) then
        Error("The argument to UsefulAutomaton must be an automaton");
    fi;
    if A!.type = "epsilon" then
        A := NFAtoDFA(EpsilonToNFA(A));
    elif A!.type = "nondet" then
        A := NFAtoDFA(A);
    fi;
    A := NullCompletionAut(A);

    if A!.initial = [] then
        Error("The automaton must have an initial state");
    fi;

    fifo     := ShallowCopy(A!.initial);
    R := BlistList([1..A!.states],A!.initial);

    for q in fifo do
        for a in [1 .. A!.alphabet] do
            q1 := A!.transitions[a][q];
            if not R[q1] then
                R[q1] := true;
                Add(fifo,q1);

            fi;
        od;
    od;

    if Length(fifo) < A!.states then
        map := [];
        i   := 1;
        for q in [1..A!.states] do
            if R[q] then
                map[q] := i;
                i := i + 1;
            fi;
        od;
        T := [];
        for a in [1 .. A!. alphabet] do
            T[a] := [];
            for q in [1 .. A!.states] do
                if R[q] then
                    T[a][map[q]] := map[A!.transitions[a][q]];
                fi;
            od;
        od;
        newacc := Filtered(A!.accepting, q->R[q]);
        return(Automaton("det", Length(fifo),
                      AlphabetOfAutomatonAsList(A), T, [map[A!.initial[1]]], map{newacc}));  
    else        return(A);
fi;
end);

#############################################################################
##
#F  MinimalizedAut(A)
##
##  Given an automaton A = (Q, sigma, delta, q0, F), this function computes the
##  minimal DFA B = (Q', sigma, delta', q0', F') such that L(B) = L(A).
##  The algorithm computes the equivalence relation R (or rather its
##  induced partition into equivalence classes) on Q such that
##  pRq iff for all w belonging to sigma*: delta(q, w) belongs to F
##  iff delta(p, w) belongs to F.
##
##  Q'  = Q/R
##  q0' = [q0]
##  F'  = {[f]| f belongs to F}
##  delta'([q], a) = [delta(q, a)] for all q belonging to Q and
##
##
InstallGlobalFunction(MinimalizedAut, function(aut)
    local   n,  m,  a1,  a2,  partn,  partmap,  x,  itrans,  t,  it,  i,  
            qlinks,  qstarts,  qcount,  a,  c,  ci,  j,  p,  x1,  x2,  tm,  
            mma;

    if not IsAutomatonObj(aut) then
        Error("The argument to MinimalizedAut must be an automaton");
    fi;
    aut := UsefulAutomaton(aut);
    Info(InfoAutomataSL, 3, "A: ",aut,"\n");
    n := aut!.states;
    if n = 1 then
        return aut;
    fi;
    m := aut!.alphabet;
    a1 := Set(aut!.accepting);
    a2 := Difference([1..n], a1);
    if Length(a1) = 0 or Length(a2) = 0 then
        partn := [[1..n]];
        partmap := List([1..n],One);
    else

        if Length(a2) < Length(a1) then
            x := a1;
            a1 := a2;
            a2 := x;
        fi;
        partn := [a1,a2];
        partmap := [];
        for x in a1 do
            partmap[x] := 1;
        od;

        for x in a2 do
            partmap[x] := 2;
        od;

        itrans := [];
        for t in aut!.transitions do
            it := [];
            for i in [1..n] do
                x := t[i];
                if IsBound(it[x]) then
                    Add(it[t[i]],i);
                else
                    it[x] := [i];
                fi;
            od;
            for i in [1..n] do
                if IsBound(it[i]) then
                    Sort(it[i]);
                fi;
            od;
            Add(itrans, it);
        od;

        qlinks := List([1..m], i->[0]);
        qstarts := List([1..m], i->1);
        qcount := m;

        while qcount > 0 do
            Info(InfoAutomataSL, 3, "P: ",partn,"\n");
            for a in [1..m] do
                if qstarts[a] <> 0 then
                    break;
                fi;
            od;
            i := qstarts[a];
            qstarts[a] := qlinks[a][i];
            qcount := qcount -1;
            Unbind(qlinks[a][i]);
            c := partn[i];
            ci := [];
            it := itrans[a];
            for x in c do
                if IsBound(it[x]) then
                    Append(ci,it[x]);
                fi;
            od;
            Set(ci);
            if Size(ci) = 0 or
               Size(ci) = n then
                continue;
            fi;
            Info(InfoAutomataSL,3,"C: ",ci,"\n");
            for j in Set(partmap{ci}) do
                p := partn[j];
                if Length(p) > 1 then
                    x1 := Intersection(p,ci);
                    if Length(x1) <> 0 and Length(x1) <> Length(p) then
                        x2 := Difference(p,x1);
                        if Length(x2) < Length(x1) then
                            x := x1;
                            x1 := x2;
                            x2 := x;
                        fi;
                        partn[j] := x2;
                        Add(partn,x1);
                        for x in x1 do
                            partmap[x] := Length(partn);
                        od;
                        for a in [1..m] do
                            qlinks[a][Length(partn)] := qstarts[a];
                            qstarts[a] := Length(partn);
                        od;
                        qcount := qcount +m;
                    fi;
                fi;
            od;
        od;
    fi;
    tm := List([1..m], a->
               List(partn, p->partmap[aut!.transitions[a][p[1]]]));

    mma :=  Automaton("det", Length(partn), AlphabetOfAutomatonAsList(aut), tm,
                    [partmap[aut!.initial[1]]],
                    Filtered([1..Length(partn)], i->partn[i][1] in aut!.accepting));
    Info(InfoAutomataSL,1,"Minimized ",aut!.states," to ",Length(partn));
    #Assert(2,AreEquivAut(aut, mma));
    #    Assert(2,mma!.states = MinimalAutomaton(aut)!.states);
    return NullCompletionAut(mma);
end);

########################################################################
##
#F  MinimalAutomaton(A)
##
##  Minimalizes the automaton A
##
InstallMethod(MinimalAutomaton,"for finite automata", true,
        [IsAutomatonObj and IsAutomatonRep], 0,
        function(A)
    return MinimalizedAut(A);
end);
#############################################################################
#F  AreEquivAut(A1,A2)
##
##  Tests if the automata <A1> and <A2> are equivalent. This means that the
##  corresponding minimal automata are isomorphic.
##
InstallGlobalFunction(AreEquivAut, function(A1, A2)
    local   I1,  I2,  bijection,  dom,  range,  see_this_time,  
            see_next_time,  q,  a,  p2,  p1;

    if IsAutomaton(A1) then
        A1 := MinimalAutomaton(A1);
    elif IsRationalExpression(A1) then
        A1 := RatExpToAut(A1);
    else
        Error("The arguments must be rational expressions or automata");
    fi;
    if IsAutomaton(A2) then
        A2 := MinimalAutomaton(A2);
    elif IsRationalExpression(A2) then
        A2 := RatExpToAut(A2);
    else
        Error("The arguments must be rational expressions or automata");
    fi;
    if not AlphabetOfAutomatonAsList(A1) = AlphabetOfAutomatonAsList(A2) then
        Print("The given languages are not over the same alphabet","\n");
        return(false);
    fi;
    if A1!.states <> A2!.states then
        return(false);
    fi;
    if not Length(A1!.accepting) = Length(A2!.accepting) then
        return(false);
    fi;

    I1 := A1!.initial[1];
    I2 := A2!.initial[1];
    bijection     := [];
    dom           := List([1 .. A1!.states], s -> false);
    range         := List([1 .. A2!.states], s -> false);
    bijection[I1] := I2;
    dom[I1]       := true;
    range[I2]     := true;
    see_this_time := [I1];
    see_next_time := [];
    while IsBound(see_this_time[1]) do
        for q in see_this_time do
            for a in [1 .. A1!.alphabet] do
                p2 := A2!.transitions[a][bijection[q]];
                p1 := A1!.transitions[a][q];
                if dom[p1] then
                    if bijection[p1] <> p2 then
                        return(false);
                    fi;
                else
                    if range[p2] then
                        return(false);
                    fi;
                    bijection[p1] := p2;
                    dom[p1]  := true;
                    range[p2]:= true;
                    Add(see_next_time, p1);
                fi;
            od;
        od;
        see_this_time := List(see_next_time, s -> s);
        see_next_time := [];
    od;
    return(Set(List(A1!.accepting, x -> bijection[x])) = Set(A2!.accepting));
end);

#############################################################################
##
#F  AccessibleStates(aut[,p])
##
##  Computes the list of states of  the automaton aut 
##  which are accessible from state p. When p is not given, returns the 
##  states  which are accessible from any initial state.
##
InstallGlobalFunction(AccessibleStates, function(arg)
    local   aut,  newacc,  acc,  N,  a,  q;

    aut := arg[1];
    if not IsAutomaton(aut) then
        Error(" aut must be an automaton");
    fi;

    if not(aut!.type = "det" or aut!.type = "nondet") then
        Error(" aut must be a deterministic or nondeterministic automaton");
    fi;

    if IsBound(arg[2]) then
        if IsPosInt(arg[2]) then
            newacc:= [arg[2]];
        else
            Error("p must be a positive integer");
        fi;
    else
        newacc:= aut!.initial;
    fi;

    acc := [];           #list of accessible states

    while newacc <> [] do  
        N := [];
        acc := Union(acc, newacc);    
        for a in [1 .. aut!.alphabet] do
            for q in newacc do
                N := Union(N, Flat([aut!.transitions[a][q]]));
            od;
        od;
        newacc := Difference(N, Union(acc,[0]));
    od;

    return acc;
end);


#############################################################################
##
#F  AccessibleAutomaton(aut)
##
##  If "aut" is a deterministic automaton, not necessarily dense, an 
##  equivalent dense deterministic accessible automaton is returned. 
##
##  If "aut" is not deterministic with a single initial state, an equivalent 
##  accessible automaton is returned.
##
InstallGlobalFunction(AccessibleAutomaton, function(aut)
    local   A,  L,  acc,  newacc,  N,  a,  q,  TR,  nt,  newtable,  qqa,  qa,  
            n1,  n2,  newnewtable,  r,  s,  i,  p,  init,  f;

    if not IsAutomatonObj(aut) then
        Error("The argument must be an automaton");
    fi;
    if aut!.type = "det" then 
        return UsefulAutomaton(aut);
    elif aut!.type = "nondet" then
        A := aut;
    else
        Error(" aut must be a deterministic or nondeterministic automaton");
    fi;

    L := A!.alphabet;
    acc := [];           #list of accessible states
    newacc:= A!.initial;

    while newacc <> [] do  
        N := [];
        acc := Union(acc, newacc);    
        for a in [1 .. L] do
            for q in newacc do
                if q <> 0 then ## remember that 0 is used to indicate that 
                    ## there is no transition, in case the 
                    ## automaton is not dense
                    N := Union(N, A!.transitions[a][q]);
                fi;

            od;
        od;
        newacc := Difference(N, acc);
    od;
    acc := Filtered(acc, n -> IsPosInt(n)); 

    ###delete the columns corresponding to inaccessible states
    TR := TransposedMat(A!.transitions);
    nt := TR{acc};
    newtable := TransposedMat(nt);         

    ### unbind the entries corresponding to non accessible states
    for qqa in newtable do
        for qa in qqa do
            if not qa = 0 then
                for q in qa do
                    if not (q in acc  or q = 0) then    
                        Unbind(qa[q]);
                        #qa[q] := 0;
                    fi;
                od;
            fi;
            Set(qa);
        od;
    od;
    n1 := Length(newtable);
    n2 := Length(newtable[1]);
    newnewtable := NullMat(n1,n2);
    for r in [1 .. n1] do
        for s in [1 .. n2] do
            #            newnewtable[r][s] := [0];
            newnewtable[r][s] := [];
        od;
    od;
    for r in [1 .. n1] do
        for s in [1 .. n2] do
            for i in [1..Length(newtable[r][s])] do
                if newtable[r][s][i] <> 0 then
                    newnewtable[r][s][i] := Position(acc, newtable[r][s][i]);
                fi;

            od;
        od;
    od;

    p := Intersection(A!.initial, acc);
    init := [];
    for i in p do
        Add(init, Position(acc, i));
    od;
    q := Intersection(A!.accepting, acc);
    f := [];
    for i in q do
        Add(f, Position(acc, i));
    od;

    return Automaton(A!.type, Length(acc), L, newnewtable, 
                   init, f);
end);

#############################################################################
##
#F  ProductAutomaton(A1,A2)
##
##  Note: (p,q)->(p-1)m+q is a bijection from n*m to mn.
##  A1 and A2 are deterministic autamata
##
InstallGlobalFunction(ProductAutomaton, function(A1,A2)
    local   a,  n1,  n2,  n,  T1,  T2,  T,  fin,  init,  s,  p,  q,  i,  pi,  
            qi;

    if not IsAutomatonObj(A1) then
        Error("The first argument must be a deterministic automaton");
    fi;
    if not IsAutomatonObj(A2) then
        Error("The second argument must be a deterministic automaton");
    fi;
    if not A1!.type = "det" then
        Error("The first argument must be a deterministic automaton");
    fi;
    if not A2!.type = "det" then
        Error("The second argument must be a deterministic automaton");
    fi;
    a := A1!.alphabet;
    if not AlphabetOfAutomatonAsList(A1) = AlphabetOfAutomatonAsList(A2) then
        Error("A1 and A2 must have the same alphabet");
    fi;
    n1 := A1!.states;
    n2 := A2!.states;
    n := n1 * n2;
    T1 := A1!.transitions;
    T2 := A2!.transitions;
    T := NullMat(a,n);
    fin := [];
    init := [];
    for s in [1..n] do
        if RemInt(s,n2) <> 0 then
            p := QuoInt(s,n2)+1;
            q := RemInt(s,n2);
        elif RemInt(s,n2) = 0 then
            p := QuoInt(s,n2);
            q := n2;
        fi;              ## s corresponds to (p,q) via the bijection above
        for i in [1..a] do
            if IsBound(T1[i][p]) and T1[i][p] <> 0 and IsBound(T2[i][q])
               and T2[i][q] <> 0 then
                pi := T1[i][p];
                qi := T2[i][q];
                T[i][s] := (pi - 1)*n2 +qi;
            fi;
        od;
    od;
    if A1!.accepting <> [] and A2!.accepting <> [] then
        for p in A1!.accepting do
            for q in A2!.accepting do
                Add(fin, (p-1)*n2+q);
            od;
        od;
    fi;
    if A1!.initial <> [] and A2!.initial <> [] then
        for p in A1!.initial do
            for q in A2!.initial do
                Add(init, (p-1)*n2+q);
            od;
        od;
    fi;

    return Automaton("det",n,AlphabetOfAutomatonAsList(A1),T,init,fin);
end);


#############################################################################
##
#F  IntersectionLanguage(A1,A2)
##
##  The same as IntersectionAutomaton; accepts both automata or rational 
##  expressions as arguments
##
InstallGlobalFunction(IntersectionLanguage, function(a1,a2)
    local  HashPair, ht, init, states, m, s1, s2, t1, t2, t, i, st, a, x, y, nst, he,   finals, p, q, numofinitst,m1,m2;

    if IsAutomaton( a1 )  then
    	;
    elif IsRationalExpression( a1 )  then
    	a1 := RatExpToAut( a1 );
    else
    	Error( "The first argument must be an automaton or a rational expression" );
    fi;
    if IsAutomaton( a2 )  then
    	;
    elif IsRationalExpression( a2 )  then
    	a2 := RatExpToAut( a2 );
    else
    	Error( "The second argument must be an automaton or a rational expression" );
    fi;

    if a1!.type = "epsilon" then
    	m1 := AlphabetOfAutomaton(a1)-1;
    else    
    	m1 := AlphabetOfAutomaton(a1);
    fi;
    if a2!.type = "epsilon" then
    	m2 := AlphabetOfAutomaton(a2)-1;
    else    
    	m2 := AlphabetOfAutomaton(a2);
    fi;
    if m1 <> m2 then
    	Error( "The arguments must be two automata over the same alphabet" );
    fi;

    if a1!.type <> "epsilon" then
    	a1 := Automaton("epsilon", a1!.states, a1!.alphabet+1, Concatenation(a1!.transitions,   [ListWithIdenticalEntries(a1!.states,[])]), a1!.initial, a1!.accepting);
    fi;
    if a2!.type <> "epsilon" then
    	a2 := Automaton("epsilon", a2!.states, a2!.alphabet+1, Concatenation(a2!.transitions,   [ListWithIdenticalEntries(a2!.states,[])]), a2!.initial, a2!.accepting);
    fi;

    HashPair := function ( s )
    	return HashKeyBag( s, 57, 0, 3*GAPInfo.BytesPerVariable );
    end;
    ht := SparseHashTable( HashPair );
    init := [ ];
    for s1 in a1!.initial do
    	for s2 in a2!.initial do
    		Add(init, [ s1, s2 ]);
    		AddHashEntry( ht, [ s1, s2 ], Length( init ) );
    	od;
    od;

    numofinitst:=Length(init);

    states := init;
    m := a1!.alphabet;
    i := 1;
    t1 := a1!.transitions;
    t2 := a2!.transitions;
    t := List( [ 1 .. m ], x -> [  ] );

    while i <= Length( states ) do
    	st := states[i];
    	for a in [ 1 .. m ]  do
            t[a][i] := [ ];
    		if a = m then
    			for x in t1[a][st[1]] do
    				nst := [ x, st[2] ];
    				MakeImmutable( nst );
    				he := GetHashEntry( ht, nst );
    				if he = fail  then
    					Add( states, nst );
    					he := Length( states );
    					AddHashEntry( ht, nst, he );
    				fi;
    				Add(t[a][i], he);
    			od;
    			for x in t2[a][st[2]] do
    				nst := [ st[1], x ];
    				MakeImmutable( nst );
    				he := GetHashEntry( ht, nst );
    				if he = fail  then
    					Add( states, nst );
    					he := Length( states );
    					AddHashEntry( ht, nst, he );
    				fi;
    				Add(t[a][i], he);
    			od;
    		else
    	        for x in t1[a][st[1]] do
        	        for y in t2[a][st[2]] do
            	        nst := [ x, y ];
                	    MakeImmutable( nst );
    					he := GetHashEntry( ht, nst );
                       	if he = fail  then
    	                    Add( states, nst );
        	                he := Length( states );
            	            AddHashEntry( ht, nst, he );
                        fi;
                    	Add(t[a][i], he);
    	            od;
       	        od;
    		fi;
    	od;
    	i := i + 1;
    od;
    finals := [  ];
    for p in a1!.accepting  do
    	for q in a2!.accepting  do
            he := GetHashEntry( ht, [ p, q ] );
            if he <> fail then
                AddSet( finals, he );
            fi;
    	od;
    od;

    init := [ ];
    for s1 in a1!.initial do
    	for s2 in a2!.initial do
    		he := GetHashEntry( ht, [ s1, s2 ] );
    		if he <> fail then
    			Add( init, he );
    		fi;
    	od;
    od;

    return Automaton( "epsilon", Length( states ), AlphabetOfAutomatonAsList( a1 ), t, [ 1 .. numofinitst ], finals );

end );



#############################################################################
##
#F  FuseSymbolsAut(aut, n1, n2)
##
##  
##
InstallGlobalFunction(FuseSymbolsAut, function(aut, n1, n2)
    local   tm,  ntm,  i,  row,  a,  j,  alph;

    if not IsAutomatonObj(aut) then
        Error("The first argument to FuseSymbolsAut must be an automaton");
    fi;
    tm := aut!.transitions;
    ntm := [];
    for i in [1..Length(tm)] do
        if i = n1 then
            row := List([1..aut!.states], s->Set(tm{[n1,n2]}[s]));
            Add(ntm,row);
        elif i <> n2 then
            row := List(tm[i], x->[x]);
            Add(ntm,row);
        fi;
    od;
    for a in [1..aut!.alphabet-1] do
        for i in [1..aut!.states] do
            row := Flat(ntm[a][i]);
            for j in [1..Length(row)] do
                if row[j] = 0 then
                    Unbind(row[j]);
                fi;
            od;
            ntm[a][i] := Set(Compacted(row));
        od;
    od;
    alph := AlphabetOfAutomatonAsList(aut);
    Unbind(alph[n2]);
    alph := Compacted(alph);
#    Error(",,");
    return Automaton("nondet",aut!.states, alph, ntm,
                   aut!.initial, aut!.accepting);
end);


#############################################################################
##
#F AutomatonAllPairsPaths(A)
##
## Given an automaton A, with n states, outputs a n x n matrix P,
## such that P[i][j] is the list of simple paths from state i to
## state j in A.
InstallGlobalFunction(AutomatonAllPairsPaths, function(A)
    local   pathClosure,  BFS,  G,  V,  paths,  visited,  i,  j;

    pathClosure := function(list)
        local i, j, p, len, len2, lenx, list2, list3, listx, flag;

        list2 := [];
        i := 1;
        while IsBound(list[i]) do
            if i = 1 then
            else
                Add(list2, list[i]);
            fi;
            i := i + 1;
        od;
        len := i-1;
        len2 := i-2;
        list3 := ShallowCopy(list2);
        Unbind(list3[len2]);
        AddSet(paths[list[1]][list[len]], list);
        for i in [1..V] do
            for p in paths[i][list[1]] do
                if not p = [] then
                    if p[1] in list3 then
                        continue;
                    fi;
                    flag := true;
                    j := 2;
                    while IsBound(p[j]) do
                        if p[j] in list2 then
                            flag := false;
                            break;
                        fi;
                        j := j+1;
                    od;
                    if flag and not p[1] = p[j-1] then
                        listx := Concatenation(p, list2);
                        if not listx in paths[listx[1]][listx[len2+j-1]] then
                            pathClosure(listx);
                        fi;

                    fi;
                fi;
            od;
        od;
        list2 := Concatenation([list[1]], list3);
        for i in [1..V] do
            for p in paths[list[len]][i] do
                if not p = [] then
                    lenx := Length(p);
                    flag := true;
                    for j in [1..lenx-1] do
                        if p[j] in list2 then
                            flag := false;
                            break;
                        fi;
                    od;
                    if flag and not p[1] = p[lenx] then
                        if p[lenx] in list3 then
                            continue;
                        fi;
                        listx := Concatenation(list2, p);
                        if not listx in paths[listx[1]][listx[len2+lenx]] then
                            pathClosure(listx);
                        fi;
                    fi;
                fi;
            od;
        od;
    end;
    ## End of pathClosure()  --


    BFS := function(v)
        local   w;

        if not visited[v] then
            visited[v] := true;
            for w in G[v] do
                pathClosure([v,w]);
            od;
            for w in G[v] do
                BFS(w);
            od;
        fi;
    end;
    ##  End of BFS()  --
    #==============================================


    if not IsAutomaton(A) then
        Error("The argument must be an automaton");
    fi;

    G := UnderlyingGraphOfAutomaton(A);
    V := Length(G);
    paths := [];
    visited := [];
    for i in [1..V] do
        paths[i] := [];
        visited[i] := false;
        for j in [1..V] do
            paths[i][j] := [];
        od;
    od;
    BFS(A!.initial[1]);

    return(paths);
end);


#E
##
