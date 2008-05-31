############################################################################
##
#W  aut-def.gd                        Manuel Delgado <mdelgado@fc.up.pt>
#W                                    Jose Morais    <josejoao@fc.up.pt>
##
#H  @(#)$Id: aut-def.gd,v 1.11 $
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
#############################################################################
##
##  This file declares the category of automata.
##
#############################################################################
##
#C IsAutomatonObj    . . . . . .  automata
##

DeclareCategory( "IsAutomatonObj", IsObject );
DeclareCategoryCollections( "IsAutomatonObj" );

#############################################################################
##
#F  Automaton(Type, Size, SizeAlphabet, TransitionTable, ListInitial, 
##                 ListAccepting)
##
##  Returns an automaton. The meaning of each of the arguments above is clear.
##
DeclareGlobalFunction( "Automaton" );
#############################################################################

#############################################################################
##
#F  IsAutomaton(A)
##
##  Tests if A is an automaton
##
DeclareGlobalFunction( "IsAutomaton" );

#############################################################################
##
#F  RandomAutomaton(T, Q, A)
##
##  Given the type T, number of states Q and number of the input alphabet
##  symbols A, this function returns a pseudo random automaton with those
##  parameters.
##
DeclareGlobalFunction( "RandomAutomaton" );


#E
