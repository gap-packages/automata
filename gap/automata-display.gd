#############################################################################
##
#W  automata-display.gd      GAP library     Manuel Delgado <mdelgado@fc.up.pt>

##########################################################################
##
#F automata_Splash
##
## The aim of this function is to "splash" an image directly from the dot code.
## To this effect, it adds a preamble and makes a call to the Viz Splash function.
## To avoid forcing the user to install the Viz package (under development), a copy 
## of the Viz Splash function is included in the file "splash_from_viz.g" of this package
###########################################################################
DeclareGlobalFunction("Automata_Splash");
#############################################################################
##
#F  DrawGraph( <G>, fich ) 
## Displays the graph.
##
DeclareGlobalFunction( "DrawGraph" );
#############################################################################
##
#F  DrawAutomaton( arg ) 
##  Displays an automaton
##
DeclareGlobalFunction( "DrawAutomaton" );
#############################################################################
##
#F  DrawSubAutomata( A,B ) 
##  Displays automaton B and showing A as a subautomaton.
##
DeclareGlobalFunction( "DrawSubAutomaton" );
#############################################################################
##
#F DrawSCCAutomaton( <A> ) 
## Displays an automaton with its strongly connected components emphasized (is like a 
## synonym to DrawAutomaton with the appropriate arguments)
##
##
DeclareGlobalFunction( "DrawSCCAutomaton" );
