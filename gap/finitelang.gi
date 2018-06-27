############################################################################
##
#W  finitelang.gi                        Manuel Delgado <mdelgado@fc.up.pt>
#W                                       Jose Morais    <josejoao@fc.up.pt>
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
#############################################################################

#############################################################################
##
#F IsFiniteRegularLanguage(L)
##
## The argument is an automaton or a rational expression
## and this function returns true if the argument
## is a finite regular language and false otherwise.
##
InstallGlobalFunction(IsFiniteRegularLanguage, function(L)
    if not (IsAutomaton(L) or IsRatExpOnnLettersObj(L)) then
        Error("The argument must be an automaton or a rational expression");
    fi;
    
    if IsRatExpOnnLettersObj(L) then
        L := RatExpToAut(L);
    fi;
    L := RemovedSinkStates(MinimalAutomaton(L));
    return(AutoIsAcyclicGraph(UnderlyingGraphOfAutomaton(L)));
end);


#############################################################################
##
#F FiniteRegularLanguageToListOfWords(L)
##
## Given a finite regular language (as an automaton or a rational expression),
## outputs the recognized language as a list of words.
##
InstallGlobalFunction(FiniteRegularLanguageToListOfWords, function(A)
    local   path2re,  res,  alph,  str,  P,  lp,  i,  j,  p;
#    local i, j, p, str, alph, B, G, lp, res, path2re;
    
    
    path2re := function(p)
        local   expr,  q,  i,  flag,  q2,  expr2,  a,  e;
        
        expr := [""];
        q := p[1];
        for i in [2..Length(p)] do
            flag := false;
            q2 := p[i];
            expr2 := List(expr, x -> ShallowCopy(x));
            for a in [1..A!.alphabet] do
                if q2 = A!.transitions[a][q] then
                    if flag then
                        expr := Concatenation(expr, List(expr2, x -> Concatenation(x, [alph[a]])));
                    else
                        expr := List(expr, x -> Concatenation(x, [alph[a]]));
                        flag := true;
                    fi;
                fi;
            od;
            q := q2;
        od;
        for e in expr do
            Add(res, ShallowCopy(e));
        od;
    end;
    #=======================================================
    
   
    if not (IsAutomaton(A) or IsRatExpOnnLettersObj(A)) then
        Error("The argument must be a finite regular language given as an automaton or a rational expression");
    fi;
    if IsRatExpOnnLettersObj(A) then
        A := RatExpToAut(A);
    fi;
    A := RemovedSinkStates(MinimalAutomaton(A));
    if not AutoIsAcyclicGraph(UnderlyingGraphOfAutomaton(A)) then
        Error("The argument must be a finite regular language given as an automaton or a rational expression");
    fi;
    
    
    res := [];
    alph := AlphabetOfAutomatonAsList(A);

    str := "";
    P := AutomatonAllPairsPaths(A);
    lp := [];
    for i in A!.initial do
        for j in A!.accepting do
            Append(lp, ShallowCopy(P[i][j]));
        od;
    od;
    
    for p in lp do
        path2re(p);
    od;
    if IsRecognizedByAutomaton(A, "") then
        Add(res, "");
    fi;
    return(res);
end);



#############################################################################
##
#F ListOfWordsToAutomaton(alph, L)
##
## Given an alphabet <A>alph</A> (a list) and a list of
## words <A>L</A> (a list of lists), outputs an automaton
## that recognizes the given list of words.
##
InstallGlobalFunction(ListOfWordsToAutomaton, function(alph, L)
    local   oalph,  l,  w;
    
    if not IsList(alph) then
        Error("The first argument must be a list");
    fi;
    if not IsList(L) then
        Error("The second argument must be a list of lists");
    fi;
    if not ForAll(L, e -> IsList(e)) then
        Error("The second argument must be a list of lists");
    fi;
    
    oalph := Set(alph);
    if not ForAll(L, e -> ForAll(e, c -> c in oalph)) then
        Error("Found a letter in a word that is not in the alphabet");
    fi;
    
    l := [];
    for w in L do
        if w = [] then
            Add(l, RatExpOnnLetters(alph, [], []));
        else
            Add(l, 
                RatExpOnnLetters(alph, 
                        "product", 
                        List(w, c -> RatExpOnnLetters(alph, [], [Position(alph, c)]))));
        fi;
    od;
    return(RatExpToAut(RatExpOnnLetters(alph, "union", l)));
end);

#E
