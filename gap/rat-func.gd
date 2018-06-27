#############################################################################
##
#W  rat-func.gd                         Manuel Delgado <mdelgado@fc.up.pt>
##                                      Jose Morais <josejoao@fc.up.pt>
##
##  This file declares functions that perform tests on the languages
##  of automata.
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##


#############################################################################
##
#F  CopyRatExp(r)
##
##  Returns a new rational expression, which is a copy
##  of the argument.
##
DeclareGlobalFunction( "CopyRatExp" );

#############################################################################
##
#F  IsEmptyLang(<L>)
##
##  Returns true if <L> is the empty language, false otherwise.
##  <L> must be in the category IsRatExpOnnLettersObj.
##
DeclareGlobalFunction( "IsEmptyLang" );

#############################################################################
##
#F  IsFullLang(<L>)
##
##  Returns true if <L> is {alphabet}*, false otherwise.
##  <L> must be in the category IsRatExpOnnLettersObj.
##
DeclareGlobalFunction( "IsFullLang" );

#############################################################################
##
#F  IsContainedLang(<L1>,<L2>)
##
##  Returns true if language <L1> is contained in language <L2>.
##  <L1> and <L2>  must be in the category IsRatExpOnnLettersObj.
##
DeclareGlobalFunction( "IsContainedLang" );

#############################################################################
##
#F  AreDisjointLang(<L1>,<L2>)
##
##  Returns true if languages <L1> and <L2> are disjoint.
##  <L1> and <L2>  must be in the category IsRatExpOnnLettersObj.
##
DeclareGlobalFunction( "AreDisjointLang" );

##########################################################################
## 
#F  ProductRatExp(a,b)
##
##  Produces the product of two rational expressions over the same alphabet
##
DeclareGlobalFunction( "ProductRatExp" );

#########################################################################
## 
#F  UnionRatExp(a,b) 
##
##  Produces the union of two rational expressions over the same alphabet
##
DeclareGlobalFunction( "UnionRatExp" );

#######################################################################
##
#F  StarRatExp(a)
##  
##  Produces the star of a rational expression
##
DeclareGlobalFunction( "StarRatExp" );


DeclareGlobalFunction("SimplifiedUnionRatExp");

#E
