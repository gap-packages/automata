#############################################################################
##
#W  drawgraph.gd      GAP library     Manuel Delgado <mdelgado@fc.up.pt>
##
#H  @(#)$Id: drawgraph.gd,v 1.10 $
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##

############################################################################
##
#V  DrawingsExtraFormat
##
##  This variable holds a string which is a dot output format.
##  If it is different from "none", any drawing will generate also
##  an output in this format.
##
BindGlobal( "DrawingsExtraFormat", "none" );

############################################################################
##
#V  DrawingsListOfExtraFormats
##
##  This variable holds a list of possible dot output formats.
##
BindGlobal( "DrawingsListOfExtraFormats", ["dia", "fig", "gd", "gd2", "gif", "hpgl", "jpg", "mif", "mp", "pcl", "pic", "plain", "plain-ext", "png", "ps", "ps2", "svg", "svgz", "vrml", "vtx", "wbmp", "none"]);

############################################################################
##
#F  SetDrawingsExtraFormat(f)
##
##  This function sets the value of DrawingsExtraFormat to <f>.
##
DeclareGlobalFunction( "SetDrawingsExtraFormat" );

############################################################################
##
#F  dotAutomaton( <A>, fich ) . . . . . . . . . Prepares a file in the DOT
## language to draw the automaton A using dot
##
DeclareGlobalFunction( "dotAutomaton" );

#############################################################################
##
#F  DrawAutomaton( <A>, fich ) . . . . . . .  produces a ps file with the
## automaton A using the dot language and stops after showing it
##
DeclareGlobalFunction( "DrawAutomaton" );

#############################################################################
##
#F  dotGraph( <G>, fich ) . . . . . . . . . . . Prepares a file in the DOT
## language to draw the graph G using dot
##
DeclareGlobalFunction( "dotGraph" );

#############################################################################
##
#F  DrawGraph( <G>, fich ) . . . . . . . . . . .  produces a ps file with the
## Graph A using the dot language and stops after showing it
##
DeclareGlobalFunction( "DrawGraph" );

############################################################################
##
#F  dotAutomata( [ <A> , <B> ] )  . . . . . . . . Prepares a file in the DOT
## language to draw the automaton B and showing the automaton A as a 
## subautomaton.
##
DeclareGlobalFunction( "dotAutomata" );

#############################################################################
##
#F  DrawAutomata( <A>, fich ) . . . . . . . . . . .  produces a ps file with the
## automaton A using the dot language and stops after showing it
##
DeclareGlobalFunction( "DrawAutomata" );
#############################################################################
##
#F DrawSCCAutomaton( <A>, fich ) . . . . . . . .  produces a ps file with the
## automaton A using the dot language. The strongly connected components are 
## emphasized.
##
DeclareGlobalFunction( "DrawSCCAutomaton" );

#E
