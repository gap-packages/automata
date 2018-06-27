############################################################################
##
#W  sgpslinks.gi                        Manuel Delgado <mdelgado@fc.up.pt>
#W                                      Jose Morais    <josejoao@fc.up.pt>
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
##
##
#############################################################################
##
##  This file contains some links between automata and semigroups.
##
##
############################################################################
##
#F  TransitionSemigroup(aut)
##
##  Computes the transition semigroup of a deterministic automaton
##
InstallGlobalFunction(TransitionSemigroup, function(aut)
    local   g,  tr,  i;
    
    if not IsAutomaton(aut) then
        Error("the argument must be an automaton");
    fi;
    if not aut!.type = "det" then
        Error("<A> must be deterministic");
    fi;
    g := [];
    tr := NullCompletionAut(aut)!.transitions;
    for i in tr do
        g := Concatenation(g, [Transformation(i)]);
    od;
    return Semigroup( g );
end);

###########################################################################
##
#F  SyntacticSemigroupAut
##  Computes the syntactic semigroup of a deterministic automaton
## (i.e. the transition semigroup of the equivalent minimal automaton) 
##
InstallGlobalFunction(SyntacticSemigroupAut, function(aut)
    local   g,  A,  tr,  i;
    
    if not IsAutomaton(aut) then
        Error("the argument must be an automaton");
    fi;
    if not aut!.type = "det" then
        Error("<aut> must be deterministic");
    fi;
    g := [];
    A := MinimalizedAut(NullCompletionAut(aut));
    if A!.accepting = [] then
        return fail;
    fi;
    tr := A!.transitions;
    for i in tr do
        g := Concatenation(g, [Transformation(i)]);
    od;
    return Semigroup( g );
end);
###########################################################################
##
#F  SyntacticSemigroupLang(rat)
##
##  Computes the syntactic semigroup of the rational language given by the 
##  rational expression rat.
##
##
InstallGlobalFunction(SyntacticSemigroupLang, function(rat)
    return SyntacticSemigroupAut(RatExpToAut(rat));
end);

#E
