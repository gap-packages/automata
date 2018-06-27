############################################################################
##
#W  aut-rat.gd                        Manuel Delgado <mdelgado@fc.up.pt>
#W                                      Jose Morais    <josejoao@fc.up.pt>
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
#############################################################################
##
##  This file declares functions involving automata and rational expressions
##
#############################################################################
##
#F  FAtoRatExp(A)
##
##  From a finite automaton, computes the equivalent rational expression,
##  using the state elimination algorithm.
##
DeclareGlobalFunction( "FAtoRatExp" );
DeclareSynonym("AutomatonToRatExp", FAtoRatExp);
DeclareSynonym("AutToRatExp", FAtoRatExp);

DeclareAttribute("MinimalKnownRatExp", IsAutomatonObj, "mutable");

#############################################################################
##
#F  RatExpToNDAut(R)
##
##  Given a rational expression R, computes an equivalent NFA using
##  the Glushkov algorithm.
##
DeclareGlobalFunction( "RatExpToNDAut" );
#############################################################################
##
#F  RatExpToAut(R)
##
##  Given a rational expression R, uses  RatExpToNDAut to compute the 
##  equivalent NFA and then returns the equivalent minimal DFA
##
DeclareGlobalFunction( "RatExpToAut" );

DeclareSynonym( "RatExpToAutomaton", RatExpToAut );
