############################################################################
##
#W  aut-basics.gd                        Manuel Delgado <mdelgado@fc.up.pt>
#W                                       Jose Morais    <josejoao@fc.up.pt>
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
#############################################################################
##
##  This file declares some basic functions involving automata.
##
#############################################################################
##
#F  IsDeterministicAutomaton(A)
##
##  Tests if A is a deterministic automaton
##
DeclareGlobalFunction( "IsDeterministicAutomaton" );
#############################################################################
##
#F  IsNonDeterministicAutomaton(A)
##
##  Tests if A is a non deterministic automaton
##
DeclareGlobalFunction( "IsNonDeterministicAutomaton" );
#############################################################################
##
#F  IsEpsilonAutomaton(A)
##
##  Tests if A is an automaton with epsilon transitions
##
DeclareGlobalFunction( "IsEpsilonAutomaton" );
#############################################################################
##
#F AlphabetOfAutomaton(A)
##
## returns the number of symbols in the alphabet of the automaton
##
DeclareGlobalFunction("AlphabetOfAutomaton");
#############################################################################
##
#F  AlphabetOfAutomatonAsList(A)
##
##  Returns the alphabet of the automaton as a list.
##
##  Note that when the alphabet of the automaton is given as an integer 
##  (meaning the number of symbols) less than 27 it returns the list "abcd....".
##  If the alphabet is given by means of an integer greater than 27, the 
##  function returns [ "a1", "a2", "a3", "a4", ... ].
##
DeclareGlobalFunction("AlphabetOfAutomatonAsList");
#############################################################################
##
#F TransitionMatrixOfAutomaton(A)
##
## returns the transition matrix of the automaton
##
DeclareGlobalFunction("TransitionMatrixOfAutomaton");
#############################################################################
#############################################################################
##
#F InitialStatesOfAutomaton(A)
##
## returns the initial states of the automaton
##
DeclareGlobalFunction("InitialStatesOfAutomaton");
#############################################################################
#############################################################################
##
#F SetInitialStatesOfAutomaton(A)
##
## Sets the initial states of the automaton
##
DeclareGlobalFunction("SetInitialStatesOfAutomaton");
#############################################################################
#############################################################################
##
#F FinalStatesOfAutomaton(A)
##
## returns the final states of the automaton
##
DeclareGlobalFunction("FinalStatesOfAutomaton");
#############################################################################
#############################################################################
##
#F SetFinalStatesOfAutomaton(A)
##
## Sets the final states of the automaton
##
DeclareGlobalFunction("SetFinalStatesOfAutomaton");
#############################################################################
#############################################################################
##
#F NumberStatesOfAutomaton(A)
##
## returns the number of states of the automaton
##
DeclareGlobalFunction("NumberStatesOfAutomaton");
#############################################################################
#############################################################################
##
#F  CopyAutomaton(A)
##
##  Returns a copy of the automaton A.
##
DeclareGlobalFunction("CopyAutomaton");
#############################################################################
##
#F  NullCompletionAutomaton(aut)
##
##  Given a incomplete deterministic automaton returns a deterministic 
##  automaton completed with a new null state. 
##
DeclareGlobalFunction( "NullCompletionAutomaton" );
#############################################################################
DeclareSynonym("NullCompletionAut",NullCompletionAutomaton );
#############################################################################
##
#F  IsDenseAutomaton(A)
##
##  Tests whether a deterministic automaton is complete
##
DeclareGlobalFunction( "IsDenseAutomaton" );
#############################################################################
##
#F IsInverseAutomaton
##
## Tests whether a deterministic automaton is inverse, i.e. each letter of 
## the alphabet induces a partial injective function on the vertices.
##
DeclareGlobalFunction( "IsInverseAutomaton" );
#############################################################################
##
#F IsPermutationAutomaton
##
## Tests whether a deterministic automaton is a permutation automaton, 
## i.e. each letter of the alphabet induces a permutation on the vertices.
##
DeclareGlobalFunction( "IsPermutationAutomaton" );
#############################################################################
#############################################################################
##
#F  ListPermutedAutomata(A)
##
##  Given an automaton, returns a list of automata with permuted states
##
DeclareGlobalFunction( "ListPermutedAutomata" );

#############################################################################
##
#F  PermutedAutomaton(A, perm)
##
##  Given an automaton and a list representing a permutation of the states
##  outputs the permuted automaton.
##
DeclareGlobalFunction( "PermutedAutomaton" );

#############################################################################
##
#F  ListSinkStatesAut(A)
##
##  Returns the list of sink states of the automaton A.
##  q is said to be a sink state iff it is not initial nor accepting and
##  for all a in A!.alphabet A!.transitions[a][q] = q 
##
##  <A> must be an automaton.
##
DeclareGlobalFunction( "ListSinkStatesAut" );

#############################################################################
##
#F  RemoveSinkStates(A)
##
##  Removes the sink states of the automaton A
##
DeclareGlobalFunction( "RemovedSinkStates" );


#############################################################################
##
#F  IsRecognizedByAutomaton(A, word, alphabet)
##
##  Tests if a given word is recognized by the given automaton
## (The alphabet may or not be present.)
##
DeclareGlobalFunction( "IsRecognizedByAutomaton" );

#############################################################################
##
#F  NormalizedAutomaton(A)
##
##  Returns the equivalent automaton but the initial state is numbered 1
##  and the final states have the last numbers
##
DeclareGlobalFunction( "NormalizedAutomaton" );


#############################################################################
##
#F  UnionAutomata(A, B)
##
## Produces the disjoint union of the automata A and B
##
DeclareGlobalFunction( "UnionAutomata" );

#############################################################################
##
#F  ReversedAutomaton(A)
##
##  Returns the automaton obtained from A by reversing its edges and
##  switching the accepting and initial states
##
DeclareGlobalFunction( "ReversedAutomaton" );

#############################################################################
##
#F  IsReversibleAutomaton(A)
##
##  Tests if the given automaton is reversible in the sense
##  that the reversed automaton might be regarded as deterministic
##  automaton
##
DeclareGlobalFunction( "IsReversibleAutomaton" );


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
DeclareGlobalFunction("ProductOfLanguages");
        
