#############################################################################
##
#A  testall.tst        automata package                   
##                                                    
##  (based on the corresponding file of the 'example' package, 
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
gap> Automaton("det",3,2,[ [ 0, 3, 0 ], [ 2, 3, 0 ] ],[ 3 ],[ 1, 3 ]);;
gap> Print(String(last));
Automaton("det",3,"ab",[ [ 0, 3, 0 ], [ 2, 3, 0 ] ],[ 3 ],[ 1, 3 ]);;

gap> RationalExpression("aUba*","ab");
aUba*

#
#############################################################################
# Some more elaborated tests
gap> a := Automaton("det",5,"abcdefghijklmnopqrst",[ [ 0, 1, 2, 3, 0 ], [ 2, 4, 5, 0, 0 ], [ 0, 1, 3, 4, 0 ], [ 1, 2, 4, 0, 0 ], [ 1, 3, 4, 0, 0 ], [ 0, 1, 2, 5, 0 ], [ 0, 1, 2, 5, 0 ], [ 0, 3, 5, 0, 0 ], [ 0, 1, 2, 4, 0 ], [ 1, 2, 4, 0, 0 ], [ 0, 1, 5, 0, 0 ], [ 1, 4, 5, 0, 0 ], [ 2, 4, 5, 0, 0 ], [ 0, 1, 2, 4, 5 ], [ 0, 2, 0, 0, 0 ], [ 2, 3, 5, 0, 0 ], [ 1, 2, 3, 4, 0 ], [ 0, 2, 4, 5, 0 ], [ 1, 2, 3, 5, 0 ], [ 0, 1, 5, 0, 0 ] ],[ 5 ],[ 1, 3, 4, 5 ]);;
gap> AlphabetOfAutomaton(a);
20
gap> AlphabetOfAutomatonAsList(a);
"abcdefghijklmnopqrst"
gap> AutToRatExp(a);
n*

#############################################################################
#############################################################################
# Examples from the manual
# (These examples use at least a function from each file)

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

#
gap> aut:=Automaton("det",4,"01",[[3,,3,4],[3,4,0,4]],[1],[4]);
< deterministic automaton on 2 letters with 4 states >
gap> Display(aut);
   |  1  2  3  4
-----------------
 0 |  3     3  4
 1 |  3  4     4
Initial state:   [ 1 ]
Accepting state: [ 4 ]

#
gap> ndaut:=Automaton("nondet",4,2,[[3,[1,2],3,0],[3,4,0,[2,3]]],[1],[4]);
< non deterministic automaton on 2 letters with 4 states >
gap> Display(ndaut);
   |  1       2          3       4
-----------------------------------------
 a | [ 3 ]   [ 1, 2 ]   [ 3 ]
 b | [ 3 ]   [ 4 ]              [ 2, 3 ]
Initial state:   [ 1 ]
Accepting state: [ 4 ]

gap> x:=Automaton("epsilon",3,"01@",[[,[2],[3]],[[1,3],,[1]],[[1],[2],
> [2]]],[2],[2,3]);
< epsilon automaton on 3 letters with 3 states >
gap> Display(x);
   |  1          2       3
------------------------------
 0 |            [ 2 ]   [ 3 ]
 1 | [ 1, 3 ]           [ 1 ]
 @ | [ 1 ]      [ 2 ]   [ 2 ]
Initial state:    [ 2 ]
Accepting states: [ 2, 3 ]

gap> aut:=Automaton("det",16,2,[[4,0,0,6,3,1,4,8,7,4,3,0,6,1,6,0],
> [3,4,0,0,6,1,0,6,1,6,1,6,6,4,8,7,4,5]],[1],[4]);
< deterministic automaton on 2 letters with 16 states >
gap> Display(aut);
1    a   4
1    b   3
2    b   4
4    a   6
5    a   3
5    b   6
6    a   1
6    b   1
7    a   4
8    a   8
8    b   6
9    a   7
9    b   1
10   a   4
10   b   6
11   a   3
11   b   1
12   b   6
13   a   6
13   b   6
14   a   1
14   b   4
15   a   6
15   b   8
16   b   7
Initial state:   [ 1 ]
Accepting state: [ 4 ]
gap> 

#
gap> x:=Automaton("det",3,2,[ [ 0, 2, 0 ], [ 0, 1, 0 ] ],[ 3 ],[ 2 ]);;
gap> IsAutomaton(x);
true

#
gap> x:=Automaton("det",3,2,[ [ 0, 2, 0 ], [ 0, 1, 0 ] ],[ 3 ],[ 2 ]);;
gap> IsDeterministicAutomaton(x);
true

gap> y:=Automaton("nondet",3,2,[[,[1,3],],[,[2,3],[1,3]]],[1,2],[1,3]);;
gap> IsNonDeterministicAutomaton(y);
true

gap> z:=Automaton("epsilon",2,2,[[[1,2],],[[2],[1]]],[1,2],[1,2]);;
gap> IsEpsilonAutomaton(z);
true

gap> x:=Automaton("det",3,2,[ [ 0, 2, 0 ], [ 0, 1, 0 ] ],[ 3 ],[ 2 ]);;
gap> String(x);
"Automaton(\"det\",3,\"ab\",[ [ 0, 2, 0 ], [ 0, 1, 0 ] ],[ 3 ],[ 2 ]);;"
gap> Print(String(x));
Automaton("det",3,"ab",[ [ 0, 2, 0 ], [ 0, 1, 0 ] ],[ 3 ],[ 2 ]);;

gap> z:=Automaton("epsilon",2,2,[[[1,2],],[[2],[1]]],[1,2],[1,2]);;
gap> Print(String(z));
Automaton("epsilon",2,"a@",[ [ [ 1, 2 ], [ ] ], [ [ 2 ], [ 1 ] ] ],[ 1, 2 ],[ \
1, 2 ]);;

gap> RandomAutomaton("det",5,"ac");;
gap> RandomAutomaton("nondet",3,["a","b","c"]);;
gap> RandomAutomaton("epsilon",2,"abc");;
gap> RandomAutomaton("epsilon",2,2);;
gap> a:=RandomTransformation(3);;
gap> b:=RandomTransformation(3);;
gap> aut:=RandomAutomaton("det",4,[a,b]);;

gap> aut:=Automaton("det",4,2,[[3,,3,4],[3,4,0,]],[1],[4]);;
gap> AlphabetOfAutomaton(aut);
2

gap> aut:=Automaton("det",4,2,[[3,,3,4],[3,4,0,]],[1],[4]);;
gap> TransitionMatrixOfAutomaton(aut);
[ [ 3, 0, 3, 4 ], [ 3, 4, 0, 0 ] ]

gap> aut:=Automaton("det",4,2,[[3,,3,4],[3,4,0,]],[1],[4]);;
gap> InitialStatesOfAutomaton(aut);
[ 1 ]

gap> aut:=Automaton("det",4,2,[[3,,3,4],[3,4,0,]],[1],[4]);;
gap> SetInitialStatesOfAutomaton(aut,4);
gap> InitialStatesOfAutomaton(aut);
[ 4 ]
gap> SetInitialStatesOfAutomaton(aut,[2,3]);
gap> InitialStatesOfAutomaton(aut);
[ 2, 3 ]

gap> aut:=Automaton("det",4,2,[[3,,3,4],[3,4,0,]],[1],[4]);;
gap> FinalStatesOfAutomaton(aut);
[ 4 ]

gap> aut:=Automaton("det",4,2,[[3,,3,4],[3,4,0,]],[1],[4]);;
gap> FinalStatesOfAutomaton(aut);
[ 4 ]
gap> SetFinalStatesOfAutomaton(aut,2);
gap> FinalStatesOfAutomaton(aut);
[ 2 ]

gap> aut:=Automaton("det",4,2,[[3,,3,4],[3,4,0,]],[1],[4]);;
gap> NumberStatesOfAutomaton(aut);
4

gap> x:=Automaton("det",3,2,[ [ 0, 2, 0 ], [ 0, 1, 0 ] ],[ 3 ],[ 2 ]);;
gap> y:=Automaton("det",3,2,[ [ 2, 0, 0 ], [ 1, 3, 0 ] ],[ 3 ],[ 2, 3 ]);;
gap> x=y;
false
gap> Size(Set([y,x,x]));
2

gap> aut:=Automaton("det",4,2,[[3,,3,4],[3,4,0,]],[1],[4]);;
gap> IsDenseAutomaton(aut);                                 
false

gap> aut:=Automaton("det",3,2,[[1,2,1],[2,1,3]],[1],[2]);;
gap> IsRecognizedByAutomaton(aut,"bbb");
true

gap> aut:=Automaton("det",3,"01",[[1,2,1],[2,1,3]],[1],[2]);;
gap> IsRecognizedByAutomaton(aut,"111");
true

gap> x:=Automaton("det",3,2,[ [ 0, 1, 3 ], [ 0, 1, 2 ] ],[ 2 ],[ 1 ]);;
gap> IsInverseAutomaton(x);
true

gap> x:=Automaton("det",3,2,[[ 0, 1, 3 ],[ 0, 1, 2 ]],[ 2 ],[ 1 ]);;Display(x);
   |  1  2  3
--------------
 a |     1  3
 b |     1  2
Initial state:   [ 2 ]
Accepting state: [ 1 ]
gap> AddInverseEdgesToInverseAutomaton(x);Display(x);
   |  1  2  3
--------------
 a |     1  3
 b |     1  2
 A |  2     3
 B |  2  3
Initial state:   [ 2 ]
Accepting state: [ 1 ]

gap> x:=Automaton("det",3,2,[ [ 0, 1, 2 ], [ 0, 1, 3 ] ],[ 2 ],[ 2 ]);;
gap> IsReversibleAutomaton(x);
true

gap> aut:=Automaton("det",4,2,[[3,,3,4],[2,4,4,]],[1],[4]);;
gap> IsDenseAutomaton(aut);
false
gap> y:=NullCompletionAutomaton(aut);;Display(y);
   |  1  2  3  4  5
--------------------
 a |  3  5  3  4  5
 b |  2  4  4  5  5
Initial state:   [ 1 ]
Accepting state: [ 4 ]

gap> x:=Automaton("det",3,2,[ [ 2, 3, 3 ], [ 1, 2, 3 ] ],[ 1 ],[ 2, 3 ]);;
gap> ListSinkStatesAut(x);
[  ]
gap> y:=Automaton("det",3,2,[ [ 2, 3, 3 ], [ 1, 2, 3 ] ],[ 1 ],[ 2 ]);;
gap> ListSinkStatesAut(y);
[ 3 ]

gap> y:=Automaton("det",3,2,[[ 2, 3, 3 ],[ 1, 2, 3 ]],[ 1 ],[ 2 ]);;Display(y);
   |  1  2  3
--------------
 a |  2  3  3
 b |  1  2  3
Initial state:   [ 1 ]
Accepting state: [ 2 ]
gap> x := RemovedSinkStates(y);Display(x);
< deterministic automaton on 2 letters with 2 states >
   |  1  2
-----------
 a |  2
 b |  1  2
Initial state:   [ 1 ]
Accepting state: [ 2 ]

gap> y:=Automaton("det",3,2,[ [ 2, 3, 3 ], [ 1, 2, 3 ] ],[ 1 ],[ 2 ]);;
gap> z:=ReversedAutomaton(y);;Display(z);
   |  1       2       3
------------------------------
 a |         [ 1 ]   [ 2, 3 ]
 b | [ 1 ]   [ 2 ]   [ 3 ]
Initial state:   [ 2 ]
Accepting state: [ 1 ]

gap> y:=Automaton("det",4,2,[[2,3,4,2],[0,0,0,1]],[1],[3]);;Display(y);
   |  1  2  3  4
-----------------
 a |  2  3  4  2
 b |           1
Initial state:   [ 1 ]
Accepting state: [ 3 ]
gap> Display(PermutedAutomaton(y, [3,2,4,1]));
   |  1  2  3  4
-----------------
 a |  2  4  2  1
 b |  3
Initial state:   [ 3 ]
Accepting state: [ 4 ]

gap> x:=Automaton("det",3,2,[ [ 0, 2, 3 ], [ 1, 2, 3 ] ],[ 1 ],[ 2, 3 ]);;
gap> ListPermutedAutomata(x);
[ < deterministic automaton on 2 letters with 3 states >, 
  < deterministic automaton on 2 letters with 3 states >, 
  < deterministic automaton on 2 letters with 3 states >, 
  < deterministic automaton on 2 letters with 3 states >, 
  < deterministic automaton on 2 letters with 3 states >, 
  < deterministic automaton on 2 letters with 3 states > ]

gap> x:=Automaton("det",3,2,[[ 1, 2, 0 ],[ 0, 1, 2 ]],[2],[1, 2]);;Display(x);
   |  1  2  3
--------------
 a |  1  2
 b |     1  2
Initial state:    [ 2 ]
Accepting states: [ 1, 2 ]
gap> Display(NormalizedAutomaton(x));
   |  1  2  3
--------------
 a |  1     3
 b |  3  1
Initial state:    [ 1 ]
Accepting states: [ 3, 1 ]

gap> x:=Automaton("det",3,2,[ [ 1, 2, 0 ], [ 0, 1, 2 ] ],[ 2 ],[ 1, 2 ]);;
gap> y:=Automaton("det",3,2,[ [ 0, 1, 3 ], [ 0, 0, 0 ] ],[ 1 ],[ 1, 2, 3 ]);;
gap> UnionAutomata(x,y);
< non deterministic automaton on 2 letters with 6 states >
gap> Display(last);
   |  1       2       3       4    5       6
------------------------------------------------
 a | [ 1 ]   [ 2 ]                [ 4 ]   [ 6 ]
 b |         [ 1 ]   [ 2 ]
Initial states:   [ 2, 4 ]
Accepting states: [ 1, 2, 4, 5, 6 ]

gap> x := Automaton("det",3,"ab",[ [ 0, 1, 2 ], [ 1, 3, 0 ] ],[ 1 ],[ 1, 2 ]);;
gap> Display(x);
   |  1  2  3  
--------------
 a |     1  2  
 b |  1  3     
Initial state:    [ 1 ]
Accepting states: [ 1, 2 ]
gap> y := Automaton("det",3,"ab",[ [ 0, 1, 2 ], [ 0, 2, 0 ] ],[ 2 ],[ 1, 2 ]);;
gap> Display(y);
   |  1  2  3  
--------------
 a |     1  2  
 b |     2     
Initial state:    [ 2 ]
Accepting states: [ 1, 2 ]
gap> z:=ProductAutomaton(x, y);;Display(z);
   |  1  2  3  4  5  6  7  8  9  
--------------------------------
 a |              1  2     4  5  
 b |     2        8              
Initial state:    [ 2 ]
Accepting states: [ 1, 2, 4, 5 ]

gap> a1:=ListOfWordsToAutomaton("ab",["aa","bb"]);
< deterministic automaton on 2 letters with 5 states >

gap> a2:=ListOfWordsToAutomaton("ab",["a","b"]);
< deterministic automaton on 2 letters with 3 states >

gap> ProductOfLanguages(a1,a2);
< deterministic automaton on 2 letters with 5 states >

gap> FAtoRatExp(last);
(bbUaa)(aUb)

gap> aut := Automaton("det",10,2,[[7,5,7,5,4,9,10,9,10,9],
> [8,6,8,9,9,1,3,1,9,9]],[2],[6,7,8,9,10]);;
gap> s := TransitionSemigroup(aut);;       
gap> Size(s);                                                                  
30

gap> x:=Automaton("det",3,2,[ [ 1, 2, 0 ], [ 0, 1, 2 ] ],[ 2 ],[ 1, 2 ]);;
gap> S:=SyntacticSemigroupAut(x);;
gap> Size(S);
3

gap> rat := RationalExpression("a*ba*ba*(@Ub)");;
gap> S:=SyntacticSemigroupLang(rat);;
gap> Size(S);
7

#rational
gap> RationalExpression("abUc");
abUc
gap> RationalExpression("ab*Uc");
ab*Uc
gap> RationalExpression("001U1*");
001U1*
gap> RationalExpression("001U1*","012");
001U1*

gap> RatExpOnnLetters(2,"star",RatExpOnnLetters(2,"product",
> [RatExpOnnLetters(2,[],[1]),RatExpOnnLetters(2,"union",
> [RatExpOnnLetters(2,[],[1]),RatExpOnnLetters(2,[],[2])])]));      
(a(aUb))*

gap> RatExpOnnLetters(2,[],[]);         
@
gap> RatExpOnnLetters(2,[],"empty_set");
empty_set

gap> RandomRatExp(2);;
gap> RandomRatExp("01");;
gap> RandomRatExp("01");;
gap> RandomRatExp("01",7);;

gap> a:=RationalExpression("0*1(@U0U1)");
0*1(@U0U1)
gap> SizeRatExp(a);
5

gap> r := RationalExpression("1(0U1)U@");
1(0U1)U@
gap> IsRatExpOnnLettersObj(r) and IsRationalExpressionRep(r);
true
gap> IsRationalExpression(RandomRatExp("01"));
true

gap> r:=RationalExpression("a*(ba*U@)");
a*(ba*U@)
gap> AlphabetOfRatExp(r);
2
gap> r:=RationalExpression("1*(01*U@)");
1*(01*U@)
gap> AlphabetOfRatExp(r);
2
gap> a:=Transformation( [ 1, 1, 3 ] );;
gap> b:=Transformation( [ 1, 1, 2 ] );;
gap> r:=RandomRatExp([a,b]);;
gap> AlphabetOfRatExp(r);
2

gap> r:=RationalExpression("(aUb)((aUb)(bU@)U@)U@");
(aUb)((aUb)(bU@)U@)U@
gap> AlphabetOfRatExpAsList(r);
"ab"
gap> r:=RationalExpression("1*(0U@)");
1*(0U@)
gap> AlphabetOfRatExpAsList(r);
"01"
gap> r:=RationalExpression("(((a8Ua10Ua11Ua22Ua23Ua25Ua28)(a5Ua6Ua14Ua16Ua17Ua19)*((a4Ua8Ua11Ua27Ua28)(a5Ua13Ua15Ua29)*a9Ua1Ua2Ua10Ua12Ua18Ua20Ua22Ua23Ua24Ua25Ua30)Ua3(a5Ua13Ua15Ua29)*a9)((a9Ua13Ua15Ua21)(a5Ua6Ua14Ua16Ua17Ua19)*((a4Ua8Ua11Ua27Ua28)(a5Ua13Ua15Ua29)*a9Ua1Ua2Ua10Ua12Ua18Ua20Ua22Ua23Ua24Ua25Ua30)U(a1Ua2Ua7Ua10Ua12Ua17Ua18Ua22)(a5Ua13Ua15Ua29)*a9Ua5Ua6Ua14Ua19Ua26Ua29)*(a9Ua13Ua15Ua21)(a5Ua6Ua14Ua16Ua17Ua19)*(a7Ua9Ua13Ua15Ua21Ua26Ua29)U(a8Ua10Ua11Ua22Ua23Ua25Ua28)(a5Ua6Ua14Ua16Ua17Ua19)*(a7Ua9Ua13Ua15Ua21Ua26Ua29)U(a1Ua4Ua6Ua7Ua9Ua12Ua13Ua14Ua15Ua16Ua21Ua26Ua29)(a5Ua17Ua18Ua20Ua24Ua25Ua27Ua30)*(a11Ua22)Ua2Ua5Ua17Ua18Ua19Ua20Ua24Ua27Ua30)*(((a8Ua10Ua11Ua22Ua23Ua25Ua28)(a5Ua6Ua14Ua16Ua17Ua19)*((a4Ua8Ua11Ua27Ua28)(a5Ua13Ua15Ua29)*a9Ua1Ua2Ua10Ua12Ua18Ua20Ua22Ua23Ua24Ua25Ua30)Ua3(a5Ua13Ua15Ua29)*a9)((a9Ua13Ua15Ua21)(a5Ua6Ua14Ua16Ua17Ua19)*((a4Ua8Ua11Ua27Ua28)(a5Ua13Ua15Ua29)*a9Ua1Ua2Ua10Ua12Ua18Ua20Ua22Ua23Ua24Ua25Ua30)U(a1Ua2Ua7Ua10Ua12Ua17Ua18Ua22)(a5Ua13Ua15Ua29)*a9Ua5Ua6Ua14Ua19Ua26Ua29)*((a9Ua13Ua15Ua21)(a5Ua6Ua14Ua16Ua17Ua19)*((a4Ua8Ua11Ua27Ua28)(a5Ua13Ua15Ua29)*((a1Ua2Ua7Ua14Ua18Ua19)(a13Ua15Ua29)*U@)Ua3(a13Ua15Ua29)*)U(a1Ua2Ua7Ua10Ua12Ua17Ua18Ua22)(a5Ua13Ua15Ua29)*((a1Ua2Ua7Ua14Ua18Ua19)(a13Ua15Ua29)*U@)U(a8Ua11Ua16Ua20Ua23Ua24Ua25Ua27)(a13Ua15Ua29)*)U(a8Ua10Ua11Ua22Ua23Ua25Ua28)(a5Ua6Ua14Ua16Ua17Ua19)*((a4Ua8Ua11Ua27Ua28)(a5Ua13Ua15Ua29)*((a1Ua2Ua7Ua14Ua18Ua19)(a13Ua15Ua29)*U@)Ua3(a13Ua15Ua29)*)Ua3(a5Ua13Ua15Ua29)*((a1Ua2Ua7Ua14Ua18Ua19)(a13Ua15Ua29)*U@)U(a1Ua4Ua6Ua7Ua9Ua12Ua13Ua14Ua15Ua16Ua21Ua26Ua29)(a5Ua17Ua18Ua20Ua24Ua25Ua27Ua30)*U@)");;
gap> AlphabetOfRatExp(r);
11

#aut-vs-rat.xml
gap> x:=Automaton("det",4,2,[[ 0, 1, 2, 3 ],[ 0, 1, 2, 3 ]],[ 3 ],[ 1, 3, 4 ]);;
gap> FAtoRatExp(x);
(aUb)(aUb)U@
gap> aut:=Automaton("det",4,"xy",[[ 0, 1, 2, 3 ],[ 0, 1, 2, 3 ]],[ 3 ],[ 1, 3, 4 ]);;
gap> FAtoRatExp(aut);
(xUy)(xUy)U@

gap> r:=RationalExpression("aUab");
aUab
gap> Display(RatExpToNDAut(r));
   |  1    2       3    4
--------------------------------
 a |                   [ 1, 2 ]
 b |      [ 3 ]
Initial state:    [ 4 ]
Accepting states: [ 1, 3 ]
gap> r:=RationalExpression("xUxy"); 
xUxy
gap> Display(RatExpToNDAut(r));    
   |  1    2       3    4
--------------------------------
 x |                   [ 1, 2 ]   
 y |      [ 3 ]                   
Initial state:    [ 4 ]
Accepting states: [ 1, 3 ]

gap> r:=RationalExpression("@U(aUb)(aUb)");
@U(aUb)(aUb)
gap> Display(RatExpToAut(r));
   |  1  2  3  4
-----------------
 a |  3  1  3  2
 b |  3  1  3  2
Initial state:    [ 4 ]
Accepting states: [ 1, 4 ]
gap> r:=RationalExpression("@U(0U1)(0U1)");
@U(0U1)(0U1)
gap> Display(RatExpToAut(r));              
   |  1  2  3  4  
-----------------
 0 |  3  1  3  2  
 1 |  3  1  3  2  
Initial state:    [ 4 ]
Accepting states: [ 1, 4 ]

gap> r := RationalExpression("empty_set");
empty_set
gap> IsEmptyLang(r);
true
gap> r := RationalExpression("aUb");
aUb
gap> IsEmptyLang(r);
false

gap> r:=RationalExpression("aUb");
aUb
gap> IsFullLang(r);
false
gap> r:=RationalExpression("(aUb)*");
(aUb)*
gap> IsFullLang(r);
true

gap> x := Automaton("det",4,"ab",[ [ 0, 1, 3, 4 ], [ 0, 1, 2, 0 ] ],[ 2 ],[ 1, 2, 3, 4 ] );;
gap> y := Automaton("det",4,"ab",[ [ 1, 3, 4, 0 ], [ 0, 3, 4, 0 ] ],[ 3 ],[ 1, 3, 4 ]);;
gap> z := Automaton("det",4,"ab",[ [ 0, 4, 0, 0 ], [ 1, 3, 4, 0 ] ],[ 2 ],[ 1, 3, 4 ]);;
gap> AreEquivAut(x, y);
true
gap> AreEquivAut(x, z);
false
gap> a:=RationalExpression("(aUb)*ab*");
(aUb)*ab*
gap> b:=RationalExpression("(aUb)*");
(aUb)*
gap> AreEqualLang(a, b);
false
gap> a:=RationalExpression("(bUa)*");
(bUa)*
gap> AreEqualLang(a, b);
true
gap> x:=RationalExpression("(1U0)*");
(1U0)*
gap> AreEqualLang(a, x);  
The given languages are not over the same alphabet
false

gap> r:=RationalExpression("aUab");
aUab
gap> s:=RationalExpression("a","ab");
a
gap> IsContainedLang(s,r);
true
gap> IsContainedLang(r,s);
false

gap> r:=RationalExpression("aUab");;
gap> s:=RationalExpression("a","ab");;
gap> AreDisjointLang(r,s);
false

#aut-func.xml
gap> x := Automaton("epsilon",3,"ab@",[ [ [ 3 ], [ 1 ], [ 1, 2 ] ], [ [ ], [ ], [ 1, 3 ] ], [ [ 1, 3 ], [ 1 ], [ 3 ] ] ],[ 1, 2, 3 ],[ 1, 3 ]);;
gap> Display(x);
   |  1          2       3
---------------------------------
 a | [ 3 ]      [ 1 ]   [ 1, 2 ]   
 b |                    [ 1, 3 ]   
 @ | [ 1, 3 ]   [ 1 ]   [ 3 ]      
Initial states:   [ 1, 2, 3 ]
Accepting states: [ 1, 3 ]
gap> Display(EpsilonToNFA(x));
   |  1       2          3
------------------------------------
 a | [ 3 ]   [ 1, 3 ]   [ 1 .. 3 ]   
 b |                    [ 1, 3 .. 3 ]      
Initial states:   [ 1 .. 3 ]
Accepting states: [ 1, 2, 3 ]

gap> x := Automaton("epsilon",3,"ab@",[ [ [ ], [ 1 ], [ 1 ] ], [ [ 2 ], [ ], [ ] ], [ [ 2 ], [ 1, 2, 3 ], [ 1, 3 ] ] ],[ 3 ],[ 2, 3 ]);;
gap> Display(x);
   |  1       2             3
------------------------------------
 a |         [ 1 ]         [ 1 ]      
 b | [ 2 ]                            
 @ | [ 2 ]   [ 1, 2, 3 ]   [ 1, 3 ]   
Initial state:    [ 3 ]
Accepting states: [ 2, 3 ]
gap> Display(EpsilonCompactedAut(x));
   |  1
-----------
 a | [ 1 ]   
 b | [ 1 ]   
 @ |         
Initial state:   [ 1 ]
Accepting state: [ 1 ]

gap> x := Automaton("nondet",5,"ab",[ [ [ 2, 5 ], [ 2, 5 ], [ 4 ], [ 5 ], [ 3 ] ], [ [ 1 , 2 ], [ 1, 2, 3, 4 ], [ 1, 2, 3, 5 ], [ 2, 5 ], [ 2, 3 ] ] ],[ 1 ],[ 2, 3, 5 ]);;
gap> Display(x);
   |  1          2                3                4          5
----------------------------------------------------------------------
 a | [ 2, 5 ]   [ 2, 5 ]         [ 4 ]            [ 5 ]      [ 3 ]      
 b | [ 1, 2 ]   [ 1, 2, 3, 4 ]   [ 1, 2, 3, 5 ]   [ 2, 5 ]   [ 2, 3 ]   
Initial state:    [ 1 ]
Accepting states: [ 2, 3, 5 ]
gap> Display(ReducedNFA(x));
   |  1          2          3                4                5
----------------------------------------------------------------------
 a | [ 3 ]      [ 1 ]      [ 2 ]            [ 1, 4 ]         [ 1, 4 ]   
 b | [ 3, 4 ]   [ 1, 4 ]   [ 1, 3, 4, 5 ]   [ 2, 3, 4, 5 ]   [ 4, 5 ]   
Initial state:    [ 5 ]
Accepting states: [ 1, 3, 4 ]

#finitelang.xml
gap> r:=RationalExpression("b*(aU@)");;
gap> IsFiniteRegularLanguage(last);
false
gap> r:=RationalExpression("aUbU@");;
gap> IsFiniteRegularLanguage(last);
true

gap> r:=RationalExpression("aaUx(aUb)");   
aaUx(aUb)
gap>  FiniteRegularLanguageToListOfWords(r);
[ "aa", "xa", "xb" ]

gap> ListOfWordsToAutomaton("ab",["aaa","bba",""]);
< deterministic automaton on 2 letters with 6 states >
gap> FAtoRatExp(last);
(bbUaa)aU@

#graphs.xml
gap> G:= [ [ 1 ], [ 1, 2, 4 ], [  ], [ 1, 2, 3 ] ];;
gap> VertexInDegree(G,2);
2

gap> G:=[ [ 1 ], [ 1, 2, 4 ], [  ], [ 1, 2, 3 ] ];;
gap> VertexOutDegree(G,2);
3

gap> G:=[ [ 1 ], [ 1, 2, 4 ], [  ], [ 1, 2, 3 ] ];;
gap> AutoVertexDegree(G,2);
5

gap> G:=[ [  ], [ 4 ], [ 2 ], [ 1, 4 ] ];;
gap> ReversedGraph(G);
[ [ 4 ], [ 3 ], [  ], [ 2, 4 ] ]

gap> G:=[ [  ], [ 1, 4, 5, 6 ], [  ], [ 1, 3, 5, 6 ], [ 2, 3 ], [ 2, 4, 6 ] ];;
gap> AutoConnectedComponents(G);
[ [ 1, 2, 3, 4, 5, 6 ] ]

gap> G:=[ [  ], [ 4 ], [  ], [ 4, 6 ], [  ], [ 1, 4, 5, 6 ] ];;
gap> Set(GraphStronglyConnectedComponents(G));
[ [ 1 ], [ 2 ], [ 3 ], [ 5 ], [ 6, 4 ] ]

gap> a := Automaton("det",3,"ab",[ [ 0, 3, 0 ], [ 1, 2, 3 ] ],[ 1 ],[ 1 ]);;
gap> Display(a);
   |  1  2  3  
--------------
 a |     3     
 b |  1  2  3  
Initial state:   [ 1 ]
Accepting state: [ 1 ]
gap> UnderlyingMultiGraphOfAutomaton(a);
[ [ 1 ], [ 3, 2 ], [ 3 ] ]

gap> a := Automaton("det",3,"ab",[ [ 2, 3, 0 ], [ 0, 1, 3 ] ],[ 2 ],[ 1, 2, 3 ]);;
gap> Display(a);
   |  1  2  3  
--------------
 a |  2  3     
 b |     1  3  
Initial state:    [ 2 ]
Accepting states: [ 1, 2, 3 ]
gap> UnderlyingGraphOfAutomaton(a);
[ [ 2 ], [ 1, 3 ], [ 3 ] ]

gap> G:=[ [  ], [  ], [ 4 ], [ 4 ] ];;
gap> DiGraphToRelation(G);
[ [ 3, 4 ], [ 4, 4 ] ]

gap> a := Automaton("det",3,"ab",[ [ 0, 2, 0 ], [ 1, 2, 0 ] ],[ 3 ],[ 1, 3 ]);;
gap> Display(a);
   |  1  2  3  
--------------
 a |     2     
 b |  1  2     
Initial state:    [ 3 ]
Accepting states: [ 1, 3 ]
gap> MSccAutomaton(a);
< deterministic automaton on 4 letters with 3 states >
gap> Display(last);
   |  1  2  3  
--------------
 a |     2     
 b |  1  2     
 A |     2     
 B |  1  2     
Initial state:    [ 3 ]
Accepting states: [ 1, 3 ]

gap> G := [ [  ], [ 3 ], [ 2 ] ];;
gap> AutoIsAcyclicGraph(last);
false

#drawings.xml
gap> x:=Automaton("det",3,2,[ [ 2, 3, 0 ], [ 0, 1, 2 ] ],[ 1 ],[ 1, 2, 3 ]);;
gap> DotStringForDrawingAutomaton(x);
"digraph  Automaton{\n\"1\" -> \"2\" [label=\"a\",color=red];\n\"2\" -> \"3\" \
[label=\"a\",color=red];\n\"2\" -> \"1\" [label=\"b\",color=blue];\n\"3\" -> \
\"2\" [label=\"b\",color=blue];\n\"1\" [shape=triangle,peripheries=2, style=fi\
lled, fillcolor=white];\n\"2\" [shape=doublecircle, style=filled, fillcolor=wh\
ite];\n\"3\" [shape=doublecircle, style=filled, fillcolor=white];\n}\n"
gap> Print(last);
digraph  Automaton{
"1" -> "2" [label="a",color=red];
"2" -> "3" [label="a",color=red];
"2" -> "1" [label="b",color=blue];
"3" -> "2" [label="b",color=blue];
"1" [shape=triangle,peripheries=2, style=filled, fillcolor=white];
"2" [shape=doublecircle, style=filled, fillcolor=white];
"3" [shape=doublecircle, style=filled, fillcolor=white];
}
gap> Print(DotStringForDrawingAutomaton(x,["st 1", "2", "C"]));
digraph  Automaton{
"st 1" -> "2" [label="a",color=red];
"2" -> "C" [label="a",color=red];
"2" -> "st 1" [label="b",color=blue];
"C" -> "2" [label="b",color=blue];
"st 1" [shape=triangle,peripheries=2, style=filled, fillcolor=white];
"2" [shape=doublecircle, style=filled, fillcolor=white];
"C" [shape=doublecircle, style=filled, fillcolor=white];
}
gap> Print(DotStringForDrawingAutomaton(x,["st 1", "2", "C"],[[2],[1,3]]));
digraph  Automaton{
"st 1" -> "2" [label="a",color=red];
"2" -> "C" [label="a",color=red];
"2" -> "st 1" [label="b",color=blue];
"C" -> "2" [label="b",color=blue];
"st 1" [shape=triangle,peripheries=2, style=filled, fillcolor=burlywood];
"2" [shape=doublecircle, style=filled, fillcolor=brown];
"C" [shape=doublecircle, style=filled, fillcolor=burlywood];
}

gap> A := Automaton("nondet",5,"abc",[ [ [ 2, 3 ], [ 5 ], [ 1, 4, 5 ], [ 1, 5 ], [ 3, 4 ] ], [ [ 1, 4, 5 ], [ ], [ 1 ], [ 1, 3, 5 ], [ 1, 2, 5 ] ], [ [ ], [ 2, 4, 5 ], [ 1, 3, 5 ], [ ], [ 2, 3, 4 ] ] ],[ ],[ 2, 3, 4 ]);;
gap> B := Automaton("nondet",5,"abc",[ [ [ 2, 3 ], [ 5 ], [ 1, 4, 5 ], [ 1, 5 ], [ 3, 4 ] ], [ [ 1, 4, 5 ], [ ], [ 1 ], [ 1, 3, 5 ], [ 1, 2, 5 ] ], [ [ 1, 4, 5 ], [ 2, 4, 5 ], [ 1, 3, 5 ], [ 2, 3, 4, 5 ], [ 2, 3, 4 ] ] ],[ 3, 4, 5 ],[ 2, 3, 4 ]);;
gap> Print(DotStringForDrawingSubAutomaton(A,B));
digraph  Automaton {
1 -> 2 [label="a",color=red];
1 -> 3 [label="a",color=red];
1 -> 1 [label="b",color=blue];
1 -> 4 [label="b",color=blue];
1 -> 5 [label="b",color=blue];
1 -> 1 [label="c",color=green,style = dotted];
1 -> 4 [label="c",color=green,style = dotted];
1 -> 5 [label="c",color=green,style = dotted];
2 -> 5 [label="a",color=red];
2 -> 2 [label="c",color=green];
2 -> 4 [label="c",color=green];
2 -> 5 [label="c",color=green];
3 -> 1 [label="a",color=red];
3 -> 4 [label="a",color=red];
3 -> 5 [label="a",color=red];
3 -> 1 [label="b",color=blue];
3 -> 1 [label="c",color=green];
3 -> 3 [label="c",color=green];
3 -> 5 [label="c",color=green];
4 -> 1 [label="a",color=red];
4 -> 5 [label="a",color=red];
4 -> 1 [label="b",color=blue];
4 -> 3 [label="b",color=blue];
4 -> 5 [label="b",color=blue];
4 -> 2 [label="c",color=green,style = dotted];
4 -> 3 [label="c",color=green,style = dotted];
4 -> 4 [label="c",color=green,style = dotted];
4 -> 5 [label="c",color=green,style = dotted];
5 -> 3 [label="a",color=red];
5 -> 4 [label="a",color=red];
5 -> 1 [label="b",color=blue];
5 -> 2 [label="b",color=blue];
5 -> 5 [label="b",color=blue];
5 -> 2 [label="c",color=green];
5 -> 3 [label="c",color=green];
5 -> 4 [label="c",color=green];
3 [shape=triangle,color=gray];
4 [shape=triangle,color=gray];
5 [shape=triangle,color=gray];
2 [shape=doublecircle];
3 [shape=doublecircle];
4 [shape=doublecircle];
1 [shape=circle];
}

gap> G := [[1,2,3],[5],[3,4],[1],[2,5]];
[ [ 1, 2, 3 ], [ 5 ], [ 3, 4 ], [ 1 ], [ 2, 5 ] ]
gap> Print(DotStringForDrawingGraph(G));
digraph Graph__{
1 -> 1 [style=bold, color=black];
1 -> 2 [style=bold, color=black];
1 -> 3 [style=bold, color=black];
2 -> 5 [style=bold, color=black];
3 -> 3 [style=bold, color=black];
3 -> 4 [style=bold, color=black];
4 -> 1 [style=bold, color=black];
5 -> 2 [style=bold, color=black];
5 -> 5 [style=bold, color=black];
1 [shape=circle];
2 [shape=circle];
3 [shape=circle];
4 [shape=circle];
5 [shape=circle];
}

gap> rcg := Automaton("det",6,"ab",[ [ 3, 3, 6, 5, 6, 6 ], [ 4, 6, 2, 6, 4, 6 ] ], [ ],[ ]);;
gap> Print(DotStringForDrawingSCCAutomaton(rcg));
digraph  Automaton{
"1" -> "3" [label="a",color=red,style = dotted];
"2" -> "3" [label="a",color=red];
"3" -> "6" [label="a",color=red,style = dotted];
"4" -> "5" [label="a",color=red];
"5" -> "6" [label="a",color=red,style = dotted];
"6" -> "6" [label="a",color=red,style = dotted];
"1" -> "4" [label="b",color=blue,style = dotted];
"2" -> "6" [label="b",color=blue,style = dotted];
"3" -> "2" [label="b",color=blue];
"4" -> "6" [label="b",color=blue,style = dotted];
"5" -> "4" [label="b",color=blue];
"6" -> "6" [label="b",color=blue,style = dotted];
"1" [shape=circle, style=filled, fillcolor=white];
"2" [shape=circle, style=filled, fillcolor=white];
"3" [shape=circle, style=filled, fillcolor=white];
"4" [shape=circle, style=filled, fillcolor=white];
"5" [shape=circle, style=filled, fillcolor=white];
"6" [shape=circle, style=filled, fillcolor=white];
}

#foldings.xml
gap> L:=[2,"abA","bbabAB"];;
gap> GeneratorsToListRepresentation(L);
[ 2, [ 1, 2, 3 ], [ 2, 2, 1, 2, 3, 4 ] ]

gap> K:=[2,[1,2,3],[2,2,1,2,3,4]];;
gap> ListToGeneratorsRepresentation(K);
[ 2, "abA", "bbabAB" ]

gap> W:=[2,"bbbAB","abAbA"];;
gap> A:=FlowerAutomaton(W);
< non deterministic automaton on 2 letters with 9 states >
gap> Display(A);
   |  1          2       3       4    5       6       7    8       9
---------------------------------------------------------------------
 a | [ 6, 9 ]                        [ 4 ]                [ 7 ]
 b | [ 2, 5 ]   [ 3 ]   [ 4 ]                [ 7 ]        [ 9 ]
Initial state:   [ 1 ]
Accepting state: [ 1 ]

gap> B := FoldFlowerAutomaton(A);
< deterministic automaton on 2 letters with 7 states >
gap> Display(B);
   |  1  2  3  4  5  6  7
--------------------------
 a |  5  4              6
 b |  2  3  4     6     5
Initial state:   [ 1 ]
Accepting state: [ 1 ]

gap> L:=[2,"bbbAB","AbAbA"];;
gap> SubgroupGenToInvAut(L);
< deterministic automaton on 2 letters with 8 states >
gap> Display(last);
   |  1  2  3  4  5  6  7  8
-----------------------------
 a |  8  4        1     6
 b |  2  3  4     6     8
Initial state:   [ 1 ]
Accepting state: [ 1 ]

gap> A:=Automaton("det",4,2,[ [ 3, 4, 0, 0 ], [ 2, 3, 4, 0 ] ],[ 1 ],[ 1 ]);;
gap> G := GeodesicTreeOfInverseAutomaton(A);
< deterministic automaton on 2 letters with 4 states >
gap> Display(G);
   |  1  2  3  4
-----------------
 a |  3
 b |  2     4
Initial state:   [ 1 ]
Accepting state: [ 1 ]

gap> NW := InverseAutomatonToGenerators(A);
[ 2, "baBA", "bbA" ]

gap> a1:=RationalExpression("(bUcUd)*ab*");
(bUcUd)*ab*
gap> a2:=RationalExpression("(acUd)*(aU@)");
(acUd)*(aU@)
gap> IntersectionAutomaton(a1,a2);
Error, The arguments must be two automata over the same alphabet

gap> a2:=RationalExpression("(acUd)*(aUb)");
(acUd)*(aUb)
gap> IntersectionAutomaton(a1,a2);
< epsilon automaton on 5 letters with 9 states >

gap> UnionAutomata(a1,a2);
Error, The arguments must be two automata
gap> a1:=RatExpToAut(RationalExpression("(bUcU@)*ab*"));
< deterministic automaton on 3 letters with 3 states >
gap> a2:=RatExpToAut(RationalExpression("(acUd)*(@Ub)"));
< deterministic automaton on 4 letters with 4 states >
gap> UnionAutomata(a1,a2);
Error, The arguments must be two automata over the same alphabet

gap> a1:=RatExpToAut(RationalExpression("(bUcU@)*ab*"));
< deterministic automaton on 3 letters with 3 states >
gap> a2:=RatExpToAut(RationalExpression("(acUd)*(@Ub)"));
< deterministic automaton on 4 letters with 4 states >
gap> UnionAutomata(a1,a2);
Error, The arguments must be two automata over the same alphabet

gap> x:=Automaton("epsilon",3,"01@",[[,[2],[3]],[[1,3],,[1]],[[1],[2],[2]]],[2],[2,3]);;
gap> y:=Automaton("epsilon",3,"01@",[ [ [ 3 ], [ 1 ], [ 1, 2 ] ], [ [ ], [ ], [ 1, 3 ] ], [ [ 1, 3 ], [ 1 ], [ 3 ] ] ],[ 1, 2, 3 ],[ 1, 3 ]);;
gap> UnionAutomata(x,y);
< epsilon automaton on 3 letters with 6 states >
gap> IntersectionAutomaton(x,y);
< epsilon automaton on 3 letters with 3 states >

gap> x:=Automaton("det",3,2,[ [ 0, 2, 0 ], [ 0, 1, 0 ] ],[ 3 ],[ 2 ]);;
gap> y:=Automaton("nondet",3,2,[[,[1,3],],[,[2,3],[1,3]]],[1,2],[1,3]);;
gap> UnionAutomata(x,y);
< non deterministic automaton on 2 letters with 6 states >
gap> UnionAutomata(y,x);
< non deterministic automaton on 2 letters with 6 states >
gap> IntersectionAutomaton(x,y);
< epsilon automaton on 3 letters with 2 states >
gap> IntersectionAutomaton(y,x);
< epsilon automaton on 3 letters with 2 states >

gap> x:=Automaton("epsilon",3,"01@",[[,[2],[3]],[[1,3],,[1]],[[1],[2],[2]]],[2],[2,3]);;
gap> y:=Automaton("nondet",3,2,[[,[1,3],],[,[2,3],[1,3]]],[1,2],[1,3]);;
gap> UnionAutomata(x,y);
< epsilon automaton on 3 letters with 6 states >
gap> UnionAutomata(y,x);
< epsilon automaton on 3 letters with 6 states >
gap> IntersectionAutomaton(x,y);
< epsilon automaton on 3 letters with 3 states >
gap> IntersectionAutomaton(y,x);
< epsilon automaton on 3 letters with 3 states >

gap> x:=Automaton("epsilon",3,"01@",[[,[2],[3]],[[1,3],,[1]],[[1],[2],[2]]],[2],[2,3]);;
gap> y:=Automaton("det",3,2,[ [ 0, 2, 0 ], [ 0, 1, 0 ] ],[ 3 ],[ 2 ]);;
gap> UnionAutomata(x,y);
< epsilon automaton on 3 letters with 6 states >
gap> UnionAutomata(y,x);
< epsilon automaton on 3 letters with 6 states >
gap> IntersectionAutomaton(x,y);
< epsilon automaton on 3 letters with 1 states >
gap> IntersectionAutomaton(y,x);
< epsilon automaton on 3 letters with 1 states >


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
