#############################################################################
##
#W  init.g                            Manuel Delgado <mdelgado@fc.up.pt>
#W                                    Jose Morais    <jjoao@netcabo.pt>
##
##
#H  @(#)$Id: init.g,v 1.05 $
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##

# announce the package version
DeclareAutoPackage("automata", "1.05", ReturnTrue);

# install the documentation
DeclarePackageAutoDocumentation( "automata", "doc" );


#############################################################################
##
#R  Read the actual code.
##
ReadPackage( "automata", "gap/aut-def.gd" );
ReadPackage( "automata", "gap/aut-basics.gd" );
ReadPackage( "automata", "gap/aut-func.gd" );
ReadPackage( "automata", "gap/aut-rat.gd" );
#
ReadPackage( "automata", "gap/digraphs.gd" );
ReadPackage( "automata", "gap/drawgraph.gd" );
ReadPackage( "automata", "gap/foldings.gd" );
ReadPackage( "automata", "gap/miscelaneous.gd" );
#
ReadPackage( "automata", "gap/rat-def.gd" );
ReadPackage( "automata", "gap/rat-func.gd" );
#

#
ReadPackage( "automata", "gap/sgpslinks.gd" );

#E  init.g  . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
