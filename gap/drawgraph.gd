#############################################################################
##
#W  drawgraph.gd      GAP library     Manuel Delgado <mdelgado@fc.up.pt>
#W                                     Jose Morais    <josejoao@fc.up.pt>
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##

#############################################################################
##
#V This is temporary!
## 
DeclareGlobalVariable( "colors" );

#========================================================================
# This function parses the arguments for the functions DrawAutomaton and DrawSCCAutomaton.
#------------------------------------------------------------------------
DeclareGlobalFunction( "AUX__parseDrawAutArgs" );

#========================================================================
# This function writes the .dot file specifying a graph.
# It is used by DrawAutomaton and DrawSCCAutomaton.
#------------------------------------------------------------------------
DeclareGlobalFunction( "WriteDotFileForGraph" );

#############################################################################
##
#F  DotStringForDrawingGraph( <G> ) . . . . . . . . . . . 
## outputs a string consisting of dot code for a graph
##
DeclareGlobalFunction( "DotStringForDrawingGraph" );
#############################################################################
##
#F  DotStringForDrawingAutomaton( <G> ) . . . . . . . . . . . 
## outputs a string consisting of dot code for a graph
##
DeclareGlobalFunction( "DotStringForDrawingAutomaton" );
############################################################################
##
#F DotStringForDrawingTwoAutomata( [ <A> , <B> ] )  . . . . . . . . Prepares a file in the DOT
## language to draw the automaton B and showing the automaton A as a 
## subautomaton.
##
DeclareGlobalFunction( "AUX__DotStringForDrawingSubAutomaton" );
DeclareGlobalFunction( "DotStringForDrawingSubAutomaton" );

#############################################################################
##
#F DotStringForDrawingSCCAutomaton( <A> ) . . . . . . . . Prepares a file in the DOT language
## to draw automaton A using the dot language. The strongly connected components are 
## emphasized.
##
DeclareGlobalFunction( "DotStringForDrawingSCCAutomaton" );
