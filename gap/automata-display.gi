#############################################################################
##
#W  automata-display.gi      GAP library     Manuel Delgado <mdelgado@fc.up.pt>

##########################################################################
##########################################################################
##
# The aim of this function is to "splash" an image directly from the dot code.
# To this effect, it adds a preamble and makes a call to the Viz Splash function.
# To avoid forcing the user to install the Viz package (under development), a copy of the Viz Splash function is included in the file "splash_from_viz.g" of this package

InstallGlobalFunction(Automata_Splash,
        function(arg)
  local  opt, dotstr;
  
  opt := First(arg, IsRecord);
  dotstr := First(arg, IsString);
  
    Splash(dotstr,opt);  
end);

###########################################################################
##
#F DrawGraph
##
## Displays the graph.
##
InstallGlobalFunction(DrawGraph, function(G)
  local  dotstr;
  dotstr := DotStringForDrawingGraph(G);
  Splash(dotstr);

  end);
#############################################################################
##
#F  DrawAutomaton( arg ) 
##  Displays an automaton
##
InstallGlobalFunction(DrawAutomaton, function(arg)
  local  dotstr;
  dotstr := CallFuncList(DotStringForDrawingAutomaton,arg);
  Splash(dotstr);

  end);
#############################################################################
##
#F  DrawSubAutomaton( A,B ) 
##  Displays automaton B and showing A as a subautomaton.
##
InstallGlobalFunction(DrawSubAutomaton, function(A,B)
  local  dotstr;
  dotstr := DotStringForDrawingSubAutomaton(A,B);
  Splash(dotstr);

  end);
#############################################################################
##
#F  DrawSCCAutomaton( arg ) 
##  Displays an automaton
##
InstallGlobalFunction(DrawSCCAutomaton, function(arg)
  local dotstr;
  dotstr := CallFuncList(DotStringForDrawingSCCAutomaton,arg);
  Splash(dotstr);

  end);
