############################################################################
##
#W  finitelang.gd                        Manuel Delgado <mdelgado@fc.up.pt>
#W                                       Jose Morais    <josejoao@fc.up.pt>
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
#############################################################################

#############################################################################
##
#F IsFiniteRegularLanguage(L)
##
## The argument is an automaton or a rational expression
## and this function returns true if the argument
## is a finite regular language and false otherwise.
##
DeclareGlobalFunction( "IsFiniteRegularLanguage" );


#############################################################################
##
#F FiniteRegularLanguageToListOfWords(L)
##
## Given a finite regular language (as an automaton or a rational expression),
## outputs the recognized language as a list of words.
##
DeclareGlobalFunction( "FiniteRegularLanguageToListOfWords" );


#############################################################################
##
#F ListOfWordsToAutomaton(alph, L)
##
## Given an alphabet <A>alph</A> (a list) and a list of
## words <A>L</A> (a list of lists), outputs an automaton
## that recognizes the given list of words.
##
DeclareGlobalFunction("ListOfWordsToAutomaton");
        
