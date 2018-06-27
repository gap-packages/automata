############################################################################
##
#W  sgpslinks.gd                        Manuel Delgado <mdelgado@fc.up.pt>
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
DeclareGlobalFunction( "TransitionSemigroup" );
###########################################################################
##
#F  SyntacticSemigroupAut
##  Computes the syntactic semigroup of a deterministic automaton
## (i.e. the transition semigroup of the equivalent minimal automaton) 
##
DeclareGlobalFunction( "SyntacticSemigroupAut" );
###########################################################################
##
#F  SyntacticSemigroupLang(rat)
##
##  Computes the syntactic semigroup of the rational language given by the 
##  rational expression rat.
##
DeclareGlobalFunction( "SyntacticSemigroupLang" );
