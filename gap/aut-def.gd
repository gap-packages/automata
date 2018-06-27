############################################################################
##
#W  aut-def.gd                        Manuel Delgado <mdelgado@fc.up.pt>
#W                                    Jose Morais    <josejoao@fc.up.pt>
##
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
#F  Automaton(Type, Size, Alphabet, TransitionTable, ListInitial, 
##                 ListAccepting)
##
##  Returns an automaton. 
##  The Alphabet may be given as a list of symbols (e.g. "xy" or "01")
##  or as an integer, representing its size. In the latter case, the alphabet
##  is taken as "abc..." (or "a_1,a_2,a_3,..." for an alphabet of more than 
##  26 symbols.
##  The meaning of the other arguments is clear.
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
