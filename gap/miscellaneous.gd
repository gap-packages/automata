#############################################################################
##
##
#W  miscellaneous.gd                      Manuel Delgado <mdelgado@fc.up.pt>
#W                                        Jose Morais    <josejoao@fc.up.pt>
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
#############################################################################
##
##
#############################################################################
##
#############################################################################
##
#F  PermutationsOfN(NN)
##
##  Given an integer NN, returns a list of lists that are 
##  the integers from 1 to NN permuted.
##
DeclareGlobalFunction( "PermutationsOfN" );
#############################################################################
##
#F  RandomizeRandomState()
##
##  Put StateRandom in a state that depends on the time of the calling
##  of the function, providing thus a more probably
##  different output for RandomAutomaton. In fact, the probability
##  of RandomAutomaton("det",3,2) output the same result between
##  two different GAP sessions is 1/factor. We defined factor = 521,
##  but it can be raised, only at the expense of delay in the start
##  of the GAP session.
##
DeclareGlobalFunction( "RandomizeRandomState" );

#############################################################################
##
#V  jascii
##
##  A pseudo ascci character table
##
DeclareGlobalVariable( "jascii" );

#############################################################################
##
#F  Ord(c)
##
##  Returns the pseudo ascii code of character c
##
DeclareGlobalFunction( "Ord" );
  
#E
