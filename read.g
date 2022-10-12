#############################################################################
##
#W  read.g                            Manuel Delgado <mdelgado@fc.up.pt>
#W                                    Jose Morais    <josejoao@fc.up.pt>
##
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
##  Read the installation files.
##
DeclareInfoClass("InfoViz");
DeclareInfoClass("InfoAutomataViz");
#DeclareInfoClass("InfoAutomataSL");
ReadPackage( "automata", "gap/splash_from_Viz.g" );

ReadPackage( "automata", "gap/aut-def.gi" );
ReadPackage( "automata", "gap/aut-basics.gi" );
ReadPackage( "automata", "gap/aut-func.gi" );
ReadPackage( "automata", "gap/aut-rat.gi" );
#
ReadPackage( "automata", "gap/digraphs.gi" );
ReadPackage( "automata", "gap/drawgraph.gi" );
ReadPackage( "automata", "gap/automata-display.gi" );
ReadPackage( "automata", "gap/foldings.gi" );
ReadPackage( "automata", "gap/miscellaneous.gi" );
#
ReadPackage( "automata", "gap/rat-def.gi" );
ReadPackage( "automata", "gap/rat-func.gi" );
#

#
ReadPackage( "automata", "gap/sgpslinks.gi" );

ReadPackage( "automata", "gap/finitelang.gi" );
#
ReadPackage( "automata", "gap/aut-utils.gi");


#E  read.g  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
