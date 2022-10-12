#############################################################################
##
##
#W  miscellaneous.gi                      Manuel Delgado <mdelgado@fc.up.pt>
#W                                        Jose Morais    <josejoao@fc.up.pt>
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
#############################################################################
##
##
#############################################################################
##
#############################################################################
##
#F  PermutationsOfN(NN)
##
##  Given an integer NN, returns a list of lists that are 
##  the integers from 1 to NN permuted.
##
#############################################################################
##  /*===================================================================*/
##  /* C program for distribution from the Combinatorial Object Server.  */
##  /* Generate permutations by transposing adjacent elements            */
##  /* via the Steinhaus-Johnson-Trotter algorithm.  This is             */
##  /* the same version used in the book "Combinatorial Generation."     */
##  /* Both the permutation (in one-line notation) and the positions     */
##  /* being transposed (as a 2-cycle) are output.                       */
##  /* The program can be modified, translated to other languages, etc., */
##  /* so long as proper acknowledgement is given (author and source).   */  
##  /* Programmer: Frank Ruskey, 1995.                                   */
##  /* The latest version of this program may be found at the site       */
##  /* http://sue.uvic.ca/~cos/inf/perm/PermInfo.html                    */
##  /*===================================================================*/
##  
##
InstallGlobalFunction(PermutationsOfN, function(NN)
    local   count,  p,  pi,  dir,  PrintPerm,  PrintTrans,  Move,  Perm,  
            permList,  i;
    
    count := 0;
    p     := []; pi := []; dir := [];
    
    
    PrintPerm := function()
        local i, perm;
        
        perm := [];
        for i in [1 .. NN] do
            # Print(p[i]); 
            Add(perm, p[i]);
        od;
        Add(permList, perm);
    end;
    
    PrintTrans := function(x, y)
        Print("(", x, " ", y, ")\n");
    end;
    
    Move := function(x, d)
        local z;
        
        # PrintTrans(pi[x], pi[x]+d);
        z := p[pi[x]+d];
        p[pi[x]] := z;
        p[pi[x]+d] := x;
        pi[z] := pi[x];
        pi[x] := pi[x]+d;
    end;
    
    Perm := function(n)
        local i;
        
        if n > NN then
            PrintPerm();
        else
            Perm(n+1);
            for i in [1 .. n-1] do
                Move(n, dir[n]);
                Perm(n+1);
            od;
            dir[n] := 0 - dir[n];
        fi;
    end;
    
    permList := [];
    for i in [1 .. NN] do
        dir[i] := -1;
        p[i]   := i;
        pi[i]  := i;
    od;
    Perm(1);
    return(permList);
end);

#############################################################################
##
#F  RandomizeRandomState()
##
##  Put StateRandom in a state that depends on the time of the calling
##  of the function, providing thus a more probably
##  different output for RandomAutomaton. In fact, the probability
##  of RandomAutomaton("det",3,2) output the same result between
##  two different GAP sessions is 1/factor. We defined factor = 521,
##  but it can be raised, only at the expence of delay in the start
##  of the GAP session.
##
InstallGlobalFunction(RandomizeRandomState, function()
    local factor, path, date, seed, i, a;
    
    factor := 1024;;
    path   := DirectoriesSystemPrograms();;
    date   := Filename( path, "date" );;
    seed := "";; a := OutputTextString(seed,true);;
    Process( DirectoryCurrent(), date, InputTextNone(), a, ["+%s"] );;
    CloseStream(a);;
    Unbind(seed[Length(seed)]);;
    seed := Int(seed) mod factor;;
    for i in [1 .. seed] do
        Random([1..factor]);;
    od;
end);

#############################################################################
##
#V  jascii
##
##  A pseudo ascci character table
##
InstallValue(jascii, SSortedList(" !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¸º»ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÑÒÓÔÕÖ×ÙÚÛÜàáâãäåçèéêëìíîïñòóôõö÷ùúûü\n\\\r\t"));
MakeImmutable(jascii);
        
#############################################################################
##
#F  Ord(c)
##
##  Returns the pseudo ascii code of character c
##
InstallGlobalFunction(Ord, function(c)
    if not IsChar(c) then
        Error("The argument to Ord must be a char");
    else
       return(Position(jascii, c));
    fi;
end);
