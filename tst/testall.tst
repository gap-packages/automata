#############################################################################
##
#A  testall.tst        automata package                   
##                                                    
##  (based on the cooresponding file of the 'example' package, 
##   by Alexander Konovalov) 
##
##  To create a test file, place GAP prompts, input and output exactly as
##  they must appear in the GAP session. Do not remove lines containing 
##  START_TEST and STOP_TEST statements.
##
##  The first line starts the test. START_TEST reinitializes the caches and 
##  the global random number generator, in order to be independent of the 
##  reading order of several test files. Furthermore, the assertion level 
##  is set to 2 by START_TEST and set back to the previous value in the 
##  subsequent STOP_TEST call.
##
##  The argument of STOP_TEST may be an arbitrary identifier string.
## 
gap> START_TEST("automata package: testall.tst");

# Note that you may use comments in the test file
# and also separate parts of the test by empty lines

# First load the package without banner (the banner must be suppressed to 
# avoid reporting discrepancies in the case when the package is already 
# loaded)
gap> LoadPackage("automata",false);
true

# Check that the data are consistent  

#############################################################################
# Some more elaborated tests


#############################################################################
#############################################################################
# Examples from the manual
# (These examples use at least a funtion from each file)

#automata.xml
#
gap> aut:=Automaton("det",4,2,[[3,,3,4],[3,4,0,4]],[1],[4]);
< deterministic automaton on 2 letters with 4 states >
gap> Display(aut);
   |  1  2  3  4
-----------------
 a |  3     3  4
 b |  3  4     4
Initial state:   [ 1 ]
Accepting state: [ 4 ]


gap> STOP_TEST( "testall.tst", 10000 );
## The first argument of STOP_TEST should be the name of the test file.
## The number is a proportionality factor that is used to output a 
## "GAPstone" speed ranking after the file has been completely processed.
## For the files provided with the distribution this scaling is roughly 
## equalized to yield the same numbers as produced by the test file 
## tst/combinat.tst. For package tests, you may leave it unchnaged. 

#############################################################################
##
#E
