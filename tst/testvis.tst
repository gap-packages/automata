#############################################################################
##
#A  newvis.tst        automata package                   
##
## Follows the tests of the visualisations of automata in testall.tst

gap> START_TEST("automata package: newvis.tst");

gap> LoadPackage("automata",false);
true
gap> x:=Automaton("det",3,2,[ [ 2, 3, 0 ], [ 0, 1, 2 ] ],[ 1 ],[ 1, 2, 3 ]);;
gap> DotStringForDrawingAutomaton(x);
"//dot\ndigraph Automaton {\n\trankdir=LR layout=dot node [shape=circle] \n\t1 [label=1, shape=doublecircle]\n\t2 [label=2, shape=doub\
lecircle]\n\t3 [label=3, shape=doublecircle]\n\tin1 [label=\"\", shape=none]\n\tin1 -> 1\n\t1 -> 2 [label=\"a\"]\n\t2 -> 3 [label=\"a\
\"]\n\t2 -> 1 [label=\"b\"]\n\t3 -> 2 [label=\"b\"]\n}\n"
gap> Display(last);
//dot
digraph Automaton {
	rankdir=LR layout=dot node [shape=circle]
	1 [label=1, shape=doublecircle]
	2 [label=2, shape=doublecircle]
	3 [label=3, shape=doublecircle]
	in1 [label="", shape=none]
	in1 -> 1
	1 -> 2 [label="a"]
	2 -> 3 [label="a"]
	2 -> 1 [label="b"]
	3 -> 2 [label="b"]
}

gap> DotStringForDrawingAutomaton(x,["st 1", "2", "C"]);
"//dot\ndigraph Automaton {\n\trankdir=LR layout=dot node [shape=circle] \n\t1 [label=\"st 1\", shape=doublecircle]\n\t2 [label=2, sha\
pe=doublecircle]\n\t3 [label=C, shape=doublecircle]\n\tin1 [label=\"\", shape=none]\n\tin1 -> 1\n\t1 -> 2 [label=\"a\"]\n\t2 -> 3 [lab\
el=\"a\"]\n\t2 -> 1 [label=\"b\"]\n\t3 -> 2 [label=\"b\"]\n}\n"
gap> DotStringForDrawingAutomaton(x,["st 1", "2", "C"],[[2],[1,3]]);
"//dot\ndigraph Automaton {\n\trankdir=LR layout=dot node [shape=circle] \n\t1 [fillcolor=blue, label=\"st 1\", shape=doublecircle, st\
yle=filled]\n\t2 [fillcolor=red, label=2, shape=doublecircle, style=filled]\n\t3 [fillcolor=blue, label=C, shape=doublecircle, style=f\
illed]\n\tin1 [label=\"\", shape=none]\n\tin1 -> 1\n\t1 -> 2 [label=\"a\"]\n\t2 -> 3 [label=\"a\"]\n\t2 -> 1 [label=\"b\"]\n\t3 -> 2 [\
label=\"b\"]\n}\n"
gap> A := Automaton("nondet",5,"abc",[ [ [ 2, 3 ], [ 5 ], [ 1, 4, 5 ], [ 1, 5 ], [ 3, 4 ] ], [ [ 1, 4, 5 ], [ ], [ 1 ], [ 1, 3, 5 ], [ 1, 2, 5 ] ], [ [ ], [ 2, 4, 5 ], [ 1, 3, 5 ], [ ], [ 2, 3, 4 ] ] ],[ ],[ 2, 3, 4 ]);;
gap> B := Automaton("nondet",5,"abc",[ [ [ 2, 3 ], [ 5 ], [ 1, 4, 5 ], [ 1, 5 ], [ 3, 4 ] ], [ [ 1, 4, 5 ], [ ], [ 1 ], [ 1, 3, 5 ], [ 1, 2, 5 ] ], [ [ 1, 4, 5 ], [ 2, 4, 5 ], [ 1, 3, 5 ], [ 2, 3, 4, 5 ], [ 2, 3, 4 ] ] ],[ 3, 4, 5 ],[ 2, 3, 4 ]);;
gap> DotStringForDrawingSubAutomaton(A,B);
"//dot\ndigraph Automaton {\n\tsize=\"8,5\" rankdir=LR layout=dot \n\tin3 [label=\"\", shape=none]\n\t3 [color=gray, shape=doublecircl\
e]\n\tin3 -> 3\n\tin4 [label=\"\", shape=none]\n\t4 [color=gray, shape=doublecircle]\n\tin4 -> 4\n\tin5 [label=\"\", shape=none]\n\t5 \
[color=gray]\n\tin5 -> 5\n\t2 [shape=doublecircle]\n\t1\n\t1 -> 2 [label=\"a\"]\n\t1 -> 3 [label=\"a\"]\n\t1 -> 1 [label=\"b\"]\n\t1 -\
> 4 [label=\"b\"]\n\t1 -> 5 [label=\"b\"]\n\t1 -> 1 [label=\"c\", style=dotted]\n\t1 -> 4 [label=\"c\", style=dotted]\n\t1 -> 5 [label\
=\"c\", style=dotted]\n\t2 -> 5 [label=\"a\"]\n\t2 -> 2 [label=\"c\"]\n\t2 -> 4 [label=\"c\"]\n\t2 -> 5 [label=\"c\"]\n\t3 -> 1 [label\
=\"a\"]\n\t3 -> 4 [label=\"a\"]\n\t3 -> 5 [label=\"a\"]\n\t3 -> 1 [label=\"b\"]\n\t3 -> 1 [label=\"c\"]\n\t3 -> 3 [label=\"c\"]\n\t3 -\
> 5 [label=\"c\"]\n\t4 -> 1 [label=\"a\"]\n\t4 -> 5 [label=\"a\"]\n\t4 -> 1 [label=\"b\"]\n\t4 -> 3 [label=\"b\"]\n\t4 -> 5 [label=\"b\
\"]\n\t4 -> 2 [label=\"c\", style=dotted]\n\t4 -> 3 [label=\"c\", style=dotted]\n\t4 -> 4 [label=\"c\", style=dotted]\n\t4 -> 5 [label\
=\"c\", style=dotted]\n\t5 -> 3 [label=\"a\"]\n\t5 -> 4 [label=\"a\"]\n\t5 -> 1 [label=\"b\"]\n\t5 -> 2 [label=\"b\"]\n\t5 -> 5 [label\
=\"b\"]\n\t5 -> 2 [label=\"c\"]\n\t5 -> 3 [label=\"c\"]\n\t5 -> 4 [label=\"c\"]\n}\n"
gap> G := [[1,2,3],[5],[3,4],[1],[2,5]];;
gap> DotStringForDrawingGraph(G);
"//dot\ndigraph Graph_ {\n\tsize=\"8,5\" rankdir=LR layout=dot node [shape = circle] \n\t1\n\t1 -> 1\n\t2\n\t1 -> 2\n\t3\n\t1 -> 3\n\t\
5\n\t2 -> 5\n\t3 -> 3\n\t4\n\t3 -> 4\n\t4 -> 1\n\t5 -> 2\n\t5 -> 5\n}\n"
gap> rcg := Automaton("det",6,"ab",[ [ 3, 3, 6, 5, 6, 6 ], [ 4, 6, 2, 6, 4, 6 ] ], [ ],[ ]);;
gap> DotStringForDrawingSCCAutomaton(rcg);
"//dot\ndigraph Automaton {\n\trankdir=LR layout=dot node [shape=circle] \n\t1 [label=1]\n\t2 [label=2]\n\t3 [label=3]\n\t4 [label=4]\
\n\t5 [label=5]\n\t6 [label=6]\n\t1 -> 3 [label=\"a\", style=dotted]\n\t2 -> 3 [label=\"a\"]\n\t3 -> 6 [label=\"a\", style=dotted]\n\t\
4 -> 5 [label=\"a\"]\n\t5 -> 6 [label=\"a\", style=dotted]\n\t6 -> 6 [label=\"a\", style=dotted]\n\t1 -> 4 [label=\"b\", style=dotted]\
\n\t2 -> 6 [label=\"b\", style=dotted]\n\t3 -> 2 [label=\"b\"]\n\t4 -> 6 [label=\"b\", style=dotted]\n\t5 -> 4 [label=\"b\"]\n\t6 -> 6\
 [label=\"b\", style=dotted]\n}\n"
gap>