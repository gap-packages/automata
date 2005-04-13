#############################################################################
##
#W  rat-def.gd                         Manuel Delgado <mdelgado@fc.up.pt>
#W                                    Jose Morais    <jjoao@netcabo.pt>
##
##
#H  @(#)$Id: rat-def.gd,v 1.06 $
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
##
##          Rational Expressions
######################################################################
DeclareCategory( "IsRatExpOnnLettersObj", IsObject );
DeclareCategoryCollections( "IsRatExpOnnLettersObj" );

DeclareGlobalFunction( "RatExpOnnLettersObj" );
DeclareGlobalFunction( "RatExpOnnLetters" );


############################################################################
##
#F IsRationalExpression(R)
##
DeclareGlobalFunction( "IsRationalExpression" );

############################################################################
##
#F RatExpToString(R)
##
DeclareGlobalFunction( "RatExpToString" );


#############################################################################
##
#F  RationalExpression(I, S)
##
##  Given the number of alphabet symbols (I) and a string (S) returns
##  the rational expression represented by S
##
DeclareGlobalFunction( "RationalExpression" );

#############################################################################
##
#F  RandomRatExp(arg)
##
##  Given the number of symbols of the alphabet and (possibly) a factor m,
##  returns a pseudo random rational expression over that alphabet.
##
DeclareGlobalFunction( "RandomRatExp" );

#############################################################################
##
#A SizeRatExp(A)
##
## returns the size of the rational expression
##
DeclareAttribute("SizeRatExp", IsRatExpOnnLettersObj);


#############################################################################
##
#A AlphabetRatExp(A)
##
## returns the alphabet of the rational expression
##
DeclareAttribute("AlphabetRatExp", IsRatExpOnnLettersObj);


DeclareAttribute("StringRatExp", IsRatExpOnnLettersObj);


#E
