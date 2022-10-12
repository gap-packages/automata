############################################################################
##
#W  digraphs.gi                        Manuel Delgado <mdelgado@fc.up.pt>
#W                                     Steve Linton   <sal@dcs.st-and.ac.uk>
#W                                     Jose Morais    <josejoao@fc.up.pt>
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
##
##
#############################################################################
##
##  This file contains some generic methods directed graphs.
##
##
## A directed graph with n vertices is represented as a list of lists.
##
## Example: G := [[2,4],[3],[1,4],[]];
##
## Length(G) is the number of vertices of G. G[i] is the list of endpoints
## of the edges beginning in vertex i.
##
#############################################################################
##
#F RandomDiGraph(n)
##
## Produces a "random" digraph with n vertices
##
##
InstallGlobalFunction(RandomDiGraph, function(n)
    local   G,  i,  r,  k;

    if not IsPosInt(n) then
        Error("The number of vertices must be a positive integer");
    fi;
    G := [];
    for i in [1 .. n] do
        r := Random([1..n]);
        
        k := Random(Concatenation(NullMat(r,r)[1],[0..n]));
        G[i] := SSortedList(List([1 .. k], i -> Random([1 .. n])));
    od;
    return G;
end);
 
#############################################################################
##
#F AutoVertexDegree(DG,v)
##
## Computes the degree of a vertex of a directed graph
##
##
InstallGlobalFunction(AutoVertexDegree, function(DG,v)
    return(VertexInDegree(DG,v) + VertexOutDegree(DG,v));
end);

#############################################################################
##
#F VertexInDegree(DG,v)
##
## Computes the in degree of a vertex of a directed graph
##
##
InstallGlobalFunction(VertexInDegree, function(G,v)
    local   d,  l,  n,  i;
    
    if not IsList(G) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
    if not ForAll(G, el -> IsList(el)) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
    if not ForAll(G, el -> ForAll(el, x -> IsPosInt(x))) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
    d := 0;
    for l in G do
        n := 0;
        if v in l then
            for i in l do
                if i = v then
                    n:= n+1;
                fi;
            od;
            d := d + n;
        fi;
    od;
    return(d);
end);

#############################################################################
##
#F VertexOutDegree(DG,v)
##
## Computes the out degree of a vertex of a directed graph
##
##
InstallGlobalFunction(VertexOutDegree, function(G,v)
    if not IsList(G) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
    if not ForAll(G, el -> IsList(el)) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
    if not ForAll(G, el -> ForAll(el, x -> IsPosInt(x))) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
    return(Length(G[v]));
end);


#############################################################################
##
#F  ReversedGraph(G)
##
## Computes the reversed graph of the directed graph G. It is the graph 
## obtained from G by reversing the edges.
##
InstallGlobalFunction(ReversedGraph, function(G)
    local GR, p, V,
          leaving_v;  #local function (computes the list of vertices that
    
    if not IsList(G) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
    if not ForAll(G, el -> IsList(el)) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
    if not ForAll(G, el -> ForAll(el, x -> IsPosInt(x))) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
    
    # can be reached from v by an edge in the reversed graph)
    V := Length(G);
    GR := [];
    leaving_v := function(vert)
        local Lv, v;
        Lv := [];
        for v in [1..V] do
            if vert in G[v] then
                Add (Lv, v);
            fi;
        od;
        return Lv;
    end;
    for p in [1..V] do
        Add(GR, leaving_v(p));
    od;
    return GR;
end);
############################################################################
## 
#F AutoConnectedComponents(G)
##
## We say that a digraph is connected when for every pair of vertices there 
## is a path consisting of directed or reversed edges from one vertex to 
## the other.
##
## Computes a list of the connected components of the digraph
##
##
InstallGlobalFunction(AutoConnectedComponents, function(G)
    local acc, cC, i, j, fl,
          n, # number of vertices
          uG, # undirected graph (an edge of the undirected graph may be
              #                 seen as a pair of edges of the directed graph)
          visit,
          dfs;
   
    if not IsList(G) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
    if not ForAll(G, el -> IsList(el)) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
    if not ForAll(G, el -> ForAll(el, x -> IsPosInt(x))) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
   
    cC := [];
    fl := [];
    if Flat(G)=[] then                ##md
        n := Length(G);
    else
        n := Maximum(Length(G),Maximum(Flat(G)));
    fi;
    uG := StructuralCopy(G);
    while Length(uG) < n do
        Add(uG,[]);
    od;
    for i in [1..n] do
        for j in uG[i] do
            UniteSet(uG[j],[i]);
        od;
    od;                            ##md
   
   
    visit := [];          # mark the vertices an unvisited
    for i in [1..n] do
        visit[i] := 0;
    od;
   
    dfs := function(v) #recursive call to Depth First Search
        local w;
        visit[v] := 1;
        for w in uG[v] do
            if visit[w] = 0 then
                dfs(w);
            fi;
        od;
    end;
   
    for i in [1..n] do
        if not i in fl then
            dfs(i);
            # vertices which are accessible from i
            #(which is the connected component of i)
            acc := Filtered([1..n], i -> visit[i] = 1 and not i in fl);
            Add(cC,acc);
            UniteSet(fl, acc);
        fi;
    od;
    return cC;
end);

#############################################################################
##
#F  GraphStronglyConnectedComponents(G)
##
## Produces the strongly connected components of the digraph G 
##
InstallGlobalFunction(GraphStronglyConnectedComponents, function(dg)
    local   V,  val,  stack,  now,  comps,  visit,  i;
    
    if not IsList(dg) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
    if not ForAll(dg, el -> IsList(el)) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
    if not ForAll(dg, el -> ForAll(el, x -> IsPosInt(x))) then
        Error("The first argument must be a list of lists of positive integers");
    fi;

    
  #  SetRecursionTrapInterval(0);
  #  SetRecursionTrapInterval(6);
    V := Length(dg);
    val := [];
    stack := [];
    now := 0;
    comps := [];
    visit := function(k)
        local m,min,t,comp,l,x;
        now := now+1;
        val[k] := now;
        min := now;
        Add(stack,k);
        for t in dg[k] do
            if not IsBound(val[t]) then
                m := visit(t);
                if m < min then
                    min := m;
                fi;
            else 
                m := val[t];
                if m < min then 
                    min := m;
                fi;
            fi;
        od;
        if min = val[k] then
            comp := [];
            repeat
                l := Length(stack);
                x := stack[l];
                val[x] := V+1;
                Add(comp, x);
                Unbind(stack[l]);
            until x = k;
            Add(comps, comp);
        fi;

        return min;
    end;
    for i in [1..V] do
        if not IsBound(val[i]) then
            visit(i);
        fi;
    od;
    SetRecursionTrapInterval(5000);
    return comps;
end);

        
#############################################################################
##
#F  UnderlyingMultiGraphOfAutomaton(A)
##
## "A" is an automaton. The output is the underlying directed multi-graph.
##
InstallGlobalFunction(UnderlyingMultiGraphOfAutomaton, function(A)
    local   n,  T,  G,  Tr,  i;
    
    if not IsAutomatonObj(A) then
        Error("The argument must be an automaton");
    fi;
    n := A!.states;
    T := A!.transitions;
    G := [];
    Tr := TransposedMat(T);

    for i in [1..n] do
        G[i] := Flat(Filtered(Flat(Tr[i]), x-> x<>0));
    od;
    return G;
end);
         
#############################################################################
##
#F  UnderlyingGraphOfAutomaton(A)
##
## "A" is an automaton. The output is the underlying directed graph.
##
InstallGlobalFunction(UnderlyingGraphOfAutomaton, function(A)
    local   n,  T,  G,  Tr,  i;

    if not IsAutomatonObj(A) then
        Error("The argument must be an automaton");
    fi;
    n := A!.states;
    T := A!.transitions;
    G := [];
    Tr := TransposedMat(T);

    for i in [1..n] do
        G[i] := Set(Flat(Filtered(Flat(Tr[i]), x-> x<>0)));
    od;
    return G;
end);
       
#############################################################################
##
#F DiGraphToRelation(D)
##
## returns the relation corresponding to the digraph
##
InstallGlobalFunction(DiGraphToRelation, function(D)
    local   R,  i,  j;
    
    if not IsList(D) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
    if not ForAll(D, el -> IsList(el)) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
    if not ForAll(D, el -> ForAll(el, x -> IsPosInt(x))) then
        Error("The first argument must be a list of lists of positive integers");
    fi;
    R := [];
    for i in [1..Length(D)] do
        for j in D[i] do
            Append(R,[[i,j]]);
        od;
    od;
    return R;
end);
 
#############################################################################
##
#F  MSccAutomaton(A)
##
## Produces an automaton where, in each strongly connected component,
## edges labeled by inverses are added.
## 
## This construction is useful in Finite Semigroup Theory
##
InstallGlobalFunction(MSccAutomaton, function(A)
    local   a,  CC,  na,  ns,  T,  t,  s,  CCs,  e,  TT,  alph,  i;
    
    if not IsAutomatonObj(A) then
        Error("The argument must be an automaton");
    fi;
    a := AlphabetOfAutomatonAsList(A);
    if not (Intersection(a, List([1..Length(a)], i -> jascii[68+i])) = a or 
      Intersection(a,List([1..Length(a)], i -> Concatenation("a", String(i)))) = a) then
        Error("The automaton must be defined over the alphabet abc...");
    fi;
    CC := GraphStronglyConnectedComponents(UnderlyingGraphOfAutomaton(A));
    na := A!.alphabet;
    ns := A!.states;
    T := StructuralCopy(A!.transitions);
    t := NullMat(na,ns);
    for a in [1..na] do
        for s in [1..ns] do
            CCs := Filtered(CC, c -> s in c)[1];
            for e in CCs do
                if T[a][e] = s then
                    if t[a][s] = 0 then
                        t[a][s] := e;
                    elif IsList(t[a][s]) then
                        Add(t[a][s],e);
                    else
                        t[a][s] := [t[a][s],e];
                    fi;
                fi;
            od;
        od;
    od;
    TT := Concatenation(T,t);
    #    Print(A);
    alph := "";
    for i in [1 .. A!.alphabet] do
        alph := Concatenation(alph, [jascii[68+i]]);
    od;
    for i in [1 .. A!.alphabet] do
        alph := Concatenation(alph, [jascii[68+i-32]]);
    od;
    if ForAll(t,n->ForAll(n,IsInt)) then
        return Automaton("det",ns,alph,TT,A!.initial,A!.accepting);
    else
        return Automaton("nondet",ns,alph,TT,A!.initial,A!.accepting);
    fi;
end);


#############################################################################
##
#F AutoIsAcyclicGraph(G)
##
## The argument is a graph's list of adjacencies
## and this function returns true if the argument
## is an acyclic graph and false otherwise.
##
InstallGlobalFunction(AutoIsAcyclicGraph, function(G)
    local   DFS,  dag,  n,  visited,  finished,  v;
    
    DFS := function(v)
        local w;
        
        visited[v] := true;
        for w in G[v] do
            if not visited[w] then
                DFS(w);
            elif not finished[w] then
                dag := false;
            fi;
        od;
        finished[v] := true;
    end;
    # ================================
    
    dag := true;
    n := Length(G);
    visited := [];
    finished := [];
    for v in [1..n] do
        visited[v] := false;
        finished[v] := false;
    od;
    for v in [1..n] do
        if not visited[v] then
            DFS(v);
        fi;  
    od;
    return(dag);
end);


#E
