############################################################################
##
#W  digraphs.gd                        Manuel Delgado <mdelgado@fc.up.pt>
#W                                   Jose Morais    <jjoao@netcabo.pt>
##
#H  @(#)$Id: digraphs.gi,v 1.02 $
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
##
##
#############################################################################
##
#F RandomDiGraph(n)
##
## Produces a "random" digraph with n vertices
##
DeclareGlobalFunction( "RandomDiGraph" );
#############################################################################
##
#F AutoVertexDegree(DG,v)
##
## Computes the degree of a vertex of a directed graph
##
DeclareGlobalFunction( "AutoVertexDegree" );
#############################################################################
##
#F VertexInDegree(DG,v)
##
## Computes the in degree of a vertex of a directed graph
##
DeclareGlobalFunction( "VertexInDegree" );
#############################################################################
##
#F VertexOutDegree(DG,v)
##
## Computes the out degree of a vertex of a directed graph
##
DeclareGlobalFunction( "VertexOutDegree" );
#############################################################################
##
#F  ReversedGraph(G)
##
## Computes the reversed graph of the directed graph G. It is the graph 
## obtained from G by reversing the edges.
##
DeclareGlobalFunction( "ReversedGraph" );
############################################################################
## 
#F AutoConnectedComponents(G)
##
## We say that a digraph is connected when for every pair of vertices there 
## is a path consisting of directed or reversed edges from one vertex to 
## the other.
##
## Computes a list of the connected components of the digraph
##
DeclareGlobalFunction( "AutoConnectedComponents" );
#############################################################################
##
#F  GraphStronglyConnectedComponents(G)
##
## Produces the strongly connected components of the digraph G 
##
DeclareGlobalFunction( "GraphStronglyConnectedComponents" );
#############################################################################
##
#F  UnderlyingMultiGraphOfAutomaton(A)
##
## "A" is an automaton. The output is the underlying directed multi-graph.
##
DeclareGlobalFunction( "UnderlyingMultiGraphOfAutomaton" );
#############################################################################
##
#F  UnderlyingGraphOfAutomaton(A)
##
## "A" is an automaton. The output is the underlying directed graph.
##
DeclareGlobalFunction( "UnderlyingGraphOfAutomaton" );
#############################################################################
##
#F DiGraphToRelation(D)
##
## returns the relation corresponding to the digraph???????????????
##
DeclareGlobalFunction( "DiGraphToRelation" );

#############################################################################
##
#F  MSccAutomaton(A)
##
## Produces an automaton where, in each strongly connected component,
## edges labeled by inverses are added.
## 
## This construction is usefull in Finite Semigroup Theory
##
DeclareGlobalFunction( "MSccAutomaton" );


#E
