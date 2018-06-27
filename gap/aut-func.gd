#############################################################################
##
#W  aut-func.gd                          Manuel Delgado <mdelgado@fc.up.pt>
#W                                       Jose Morais    <josejoao@fc.up.pt>
##
##  This file contains functions that perform operations on automata
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##

#############################################################################
##
#F  EpsilonToNFA(A)
##
##  <A> is an automaton with epsilon-transitions. Returns an NFA
##  recognizing the same language.
##
DeclareGlobalFunction( "EpsilonToNFA" );

#############################################################################
##
#F  EpsilonCompactedAut(aut)
##
##  Returns the compacted epsilon automaton.
##
DeclareGlobalFunction( "EpsilonCompactedAut" );


#############################################################################
##
#F  
##
##  EpsilonToNFASet(aut)
##
DeclareGlobalFunction( "EpsilonToNFASet" );


#############################################################################
##
#F  EpsilonToNFABlist(aut)
##
##  
##
DeclareGlobalFunction( "EpsilonToNFABlist" );


#############################################################################
##
#F  ReducedNFA(aut)
##
##  
##
DeclareGlobalFunction( "ReducedNFA" );



#############################################################################
##
#F  NFAtoDFA(A)
##
##  Given an NFA, computes the equivalent DFA, using the powerset construction,
##  according to the algorithm presented in the report of the AMoRE program.
##  The returned automaton is dense deterministic
##
DeclareGlobalFunction( "NFAtoDFA" );
DeclareSynonym("SubSetAutomaton", NFAtoDFA);

#############################################################################
##
#F  UsefulAutomaton(A)
##
##  Given an automaton A, outputs a dense DFA B whose states are all reachable
##  and such that L(B) = L(A)
##
DeclareGlobalFunction( "UsefulAutomaton" );

#############################################################################
##
#F  MinimalizedAut(A)
##
##  Given an automaton A = (Q, sigma, delta, q0, F), this function computes the
##  minimal DFA B = (Q', sigma, delta', q0', F') such that L(B) = L(A).
##
DeclareGlobalFunction( "MinimalizedAut" );
DeclareSynonym("MinimalizeDDAutomaton", MinimalizedAut);

DeclareAttribute("MinimalAutomaton", IsAutomatonObj);

#############################################################################
#F  AreEquivAut(A1,A2)
##
##  Tests if the automata <A1> and <A2> are equivalent. This means that the
##  corresponding minimal automata are isomorphic.
##
DeclareGlobalFunction( "AreEquivAut" );
DeclareSynonym("AreEqualLang", AreEquivAut);
#############################################################################
##
#F  AccessibleStates(aut,p)
##
##  Computes the list of states of the non deterministic automaton aut 
##  which are accessible from state p 
##
DeclareGlobalFunction( "AccessibleStates" );

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
DeclareGlobalFunction( "AccessibleAutomaton" );

#############################################################################
##
#F  ProductAutomaton(A1,A2)
##
##  Note: (p,q)->(p-1)m+q is a bijection from n*m to mn.
##  A1 and A2 are deterministic automata
##
DeclareGlobalFunction( "ProductAutomaton" );

#############################################################################
##
#F  IntersectionLanguage(A1,A2)
##
##  The same as IntersectionAutomaton; accepts both automata or rational 
##  expressions as arguments
##
DeclareGlobalFunction( "IntersectionLanguage" );
DeclareSynonym("IntersectionAutomaton", IntersectionLanguage);


#############################################################################
##
#F  FuseSymbolsAut(aut, n1, n2)
##
##  
##
DeclareGlobalFunction( "FuseSymbolsAut" );


#############################################################################
##
#F AutomatonAllPairsPaths(A)
##
## Given an automaton A, with n states, outputs a n x n matrix P,
## such that P[i][j] is the list of simple paths from state i to
## state j in A.
DeclareGlobalFunction("AutomatonAllPairsPaths");

#E
