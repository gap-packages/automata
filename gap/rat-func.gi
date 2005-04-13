#############################################################################
##
#W  rat-func.gi                         Manuel Delgado <mdelgado@fc.up.pt>
##                                      Jose Morais <jjoao@netcabo.pt>
##
##  This file contains functions that perform tests on automata
##
#H  @(#)$Id: rat-func.gi,v 1.06 $
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##

#############################################################################
#F  IsEmptyLang(<L>)
##
##  Tests if the language <L> is empty.
##  <L> must be in the category IsRatExpOnnLettersObj.
##
InstallGlobalFunction(IsEmptyLang, function(L)
    local aut;
    
    if IsRatExpOnnLettersObj(L) then
        aut := RatExpToAut(L);
    elif IsAutomaton(L) then
        aut := MinimalAutomaton(L);
    else
        Error("The argument to IsEmptyLang must be a rational expression or an automaton");
    fi;    
    return(aut!.accepting = []);
end);

#############################################################################
#F  IsFullLang(<L>)
##
##  Tests if the language <L> is {alphabet}*.
##  <L> must be in the category IsRatExpOnnLettersObj.
##
InstallGlobalFunction(IsFullLang, function(L)
    local aut;
    
    if IsRatExpOnnLettersObj(L) then
        aut := RatExpToAut(L);
    elif IsAutomaton(L) then
        aut := MinimalAutomaton(L);
    else
        Error("The argument to IsEmptyLang must be a rational expression or an automaton");
    fi; 
    return(aut!.states=1 and ForAll(aut!.transitions, i -> i = [1]));
end);

#############################################################################
#F  IsContainedLang(<L1>,<L2>)
##
##  Tests if the language given through the rational expression or the 
##  automaton <L1> is contained in the language given through the rational 
## expression or the automaton <L2>.
##
## (For the correction of the algorithm, see the AMoRE manual, pg 124.)
##
InstallGlobalFunction(IsContainedLang, function(L1,L2)
    local acc, A1, A2, p, q, s, n1, n2, n, P, alph1, alph2;
    
    if not ((IsRationalExpression(L1) or IsAutomaton(L1)) and 
            (IsRationalExpression(L2) or IsAutomaton(L2))) then
        Error("The arguments to IsContainedLang must be rational expressions or automata");
    fi;
    if IsAutomaton(L1) then
        alph1 := AlphabetOfAutomaton(L1);
    else
        alph1 := AlphabetRatExp(L1);
    fi;
    if IsAutomaton(L2) then
        alph2 := AlphabetOfAutomaton(L2);
    else
        alph2 := AlphabetRatExp(L2);
    fi;
    
    if alph1 <> alph2 then
        Print("The languages given are not over the same alphabet","\n");
        return(false);
    fi;
    if IsAutomaton(L1) then
        A1 := L1;
    else
        A1 := RatExpToAut(L1);
    fi;
    if IsAutomaton(L2) then
        A2 := L2;
    else
        A2 := RatExpToAut(L2);
    fi;
 
    P := ProductAutomaton(A1,A2);
    acc := AccessibleStates(P);
    n1 := A1!.states;
    n2 := A2!.states;
    n := n1 * n2;
    for s in acc do
        if RemInt(s,n2) <> 0 then
            p := QuoInt(s,n2)+1;
            q := RemInt(s,n2);
        elif RemInt(s,n2) = 0 then
            p := QuoInt(s,n2);
            q := n2;
        fi;              ## s corrensponds to (p,q) via a certain bijection 
                         ## (used in ProductAutomaton)
        if  p in A1!.accepting and not q in A2!.accepting then
            return false;
        fi;
        
    od;
    return(true);
end);

############################################################################
#F  AreDisjointLang(<L1>,<L2>)
##
##  Tests if the languages given through the rational expression or the 
##  automaton <L1> and the language given through the rational 
## expression or the automaton <L2> are disjoint.
##
InstallGlobalFunction(AreDisjointLang, function(L1,L2)
    local acc, A1, A2, p, q, s, n1, n2, n, P, alph1, alph2;
    
    if not ((IsRationalExpression(L1) or IsAutomaton(L1)) and 
            (IsRationalExpression(L2) or IsAutomaton(L2))) then
        Error("The arguments to IsContainedLangRatExp must be rational expressions or automata");
    fi;
    if IsAutomaton(L1) then
        alph1 := AlphabetOfAutomaton(L1);
    else
        alph1 := AlphabetRatExp(L1);
    fi;
    if IsAutomaton(L2) then
        alph2 := AlphabetOfAutomaton(L2);
    else
        alph2 := AlphabetRatExp(L2);
    fi;
    
    if alph1 <> alph2 then
        Print("The languages given are not over the same alphabet","\n");
        return(false);
    fi;
    if IsAutomaton(L1) then
        A1 := L1;
    else
        A1 := RatExpToAut(L1);
    fi;
    if IsAutomaton(L2) then
        A2 := L2;
    else
        A2 := RatExpToAut(L2);
    fi;
 
    P := ProductAutomaton(A1,A2);
    acc := AccessibleStates(P);
    if Intersection(acc,P!.accepting) = [] then
        return true;
    fi;
    return false;
end);


##########################################################################
## 
#F  ProductRatExp(a,b)
##
##  Produces the product of two rational expressions over the same alphabet
##

InstallGlobalFunction(ProductRatExp,  function(a, b)
    local empty;
    if not (IsRatExpOnnLettersObj(a) and IsRatExpOnnLettersObj(b)) then
        Error("<a> and <b> must be rational expressions");
    elif not FamilyObj(a)!.alphabet2 = FamilyObj(b)!.alphabet2 then
        Error("<a> and <b> must be on the same alphabet");
    fi;
    
    empty := RatExpOnnLetters(FamilyObj(a)!.alphabet2, [], "empty_set");
    if a!.list_exp = "empty_set" or b!.list_exp = "empty_set" then
        return empty;
    fi;
    
    
    if a!.list_exp = [] then
        return b; 
    elif b!.list_exp = [] then
        return a;
    fi;
     
    if a!.op = "product" and b!.op = "product" then
        return RatExpOnnLetters(FamilyObj(a)!.alphabet2,"product", 
                       Concatenation(a!.list_exp, b!.list_exp )); 
    elif a!.op = "product" then   
        return RatExpOnnLetters(FamilyObj(a)!.alphabet2,"product", 
                       Concatenation(a!.list_exp, [b] )); 
    elif b!.op = "product" then   
        return RatExpOnnLetters(FamilyObj(a)!.alphabet2,"product", 
                       Concatenation( [a], b!.list_exp)); 
    else
        return RatExpOnnLetters(FamilyObj(a)!.alphabet2,"product", [a, b]);
    fi;        
end);

#########################################################################
## 
#F  UnionRatExp(a,b) 
##
##  Produces the union of two rational expressions over the same alphabet
##
InstallGlobalFunction(UnionRatExp, function(a, b)
    local alist, alistrat, blist, blistrat, c, list, n, ss;
    if not (IsRatExpOnnLettersObj(a) and IsRatExpOnnLettersObj(b)) then
        Error("<a> and <b> must be rational expressions");
    elif not FamilyObj(a)!.alphabet2 = FamilyObj(b)!.alphabet2 then
        Error("<a> and <b> must be on the same alphabet");
    fi;
    if a!.list_exp = "empty_set" then
        return(b);
    elif b!.list_exp = "empty_set" then
        return(a);
    else
        return(RatExpOnnLetters(FamilyObj(a)!.alphabet2,"union",[a,b]));
    fi;
end); 


#######################################################################
##
#F  StarRatExp(a)
##  
##  Produces the star of a rational expression
##
InstallGlobalFunction(StarRatExp, function(a)
    if not IsRatExpOnnLettersObj(a) then
        Error("<a> must be rational expressions");
    fi;
    if a!.op = "star" then
        return a;
        else
        return RatExpOnnLetters(FamilyObj(a)!.alphabet2,"star", a);
    fi;
end);


#######################################################################


#E
