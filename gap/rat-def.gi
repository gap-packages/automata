#############################################################################
##
#W  rat-def.gi                         Manuel Delgado <mdelgado@fc.up.pt>
#W                                    Jose Morais    <josejoao@fc.up.pt>
##
##
##
#Y  Copyright (C)  2004,  CMUP, Universidade do Porto, Portugal
##
##
##          Rational Expressions
##
##  RatExpOnnLetters( n, operation, list )
##
## Constructs a rational expression on n letters.
##
## The name of the operation is "product", "union" or "star"
##  list is a list (with one element in the case of "star") of rational
## expressions or a list consisting of an integer when the rational
## expression is a single letter.
##
##  Example
##
## r:=RatExpOnnLetters(2,"union",[RatExpOnnLetters(2,[],[1]),
##                       RatExpOnnLetters(2,[],[2])]);
##  (Due to the function PrintObj that follows, GAP writes  aUb )
##
## ProductRatExp(r,r);
##  GAP writes (aUb)(aUb)
##
## UnionRatExp(StarRatExp(r),ProductRatExp(r,StarRatExp(r)));
##  GAP writes (aUb)*U(aUb)(aUb)*
##
## The empty word is the rational expression:
##  RatExpOnnLetters(5,[],[]);
##  GAP writes empty set
##  (5 may be replaced by any natural number)
## The empty set is considered a rational expression:
## RatExpOnnLetters(n,[],"empty_set");
############################################################################
DeclareRepresentation( "IsRationalExpressionRep", IsComponentObjectRep,
        [ "op", "list_exp" ] );


############################################################################
InstallGlobalFunction( RatExpOnnLettersObj, function( Fam, ratexpression )
    return Objectify( NewType( Fam, IsRatExpOnnLettersObj and
                   IsRationalExpressionRep and IsAttributeStoringRep),  ratexpression );
end );

############################################################################
##
#GF RatExpOnnLetters
##
## Constructs a rational expression on n letters. See example above.
##
InstallGlobalFunction( RatExpOnnLetters, function( n, operation, list )

    local   k,  F,  l,  exp,  list_exp,  R;

    if not (operation = "product" or operation = "union" or
            operation = "star" or operation = [ ]) then
        Error("Wrong operation given in RatExpOnnLetters");
    fi;

    if not (IsPosInt( n ) or IsList(n)) then
      Error( "<n> must be a positive integer or a list" );
    fi;

    if operation = "star" then
        if not IsRationalExpression(list) then
            Error("The star must be on a rational expression");
        fi;
    elif not IsList(list) then
        Error("list must be a list");
    elif operation = [] then
        if not(list = [ ] or list = "empty_set" or (Length(list)=1
                   and IsPosInt(list[1]))) then
            Error("list must be the empty list, a list of one positive integer or \"empty_set\"");
        fi;
    elif  not  ForAll(list, x -> IsPosInt(x) or IsRationalExpression(x)) then
        Error("list must be a list of positive integers/rational expressions");
    fi;

    if operation <> []  and operation <> "star" then
        for k in [1..Length(list)] do
            if IsPosInt(list[k]) then
                list[k] := RatExpOnnLetters(n, [ ], [k]);
            fi;
        od;
    fi;

    if operation = [] and Length(list) > 1 and list <> "empty_set" then
        Error("When <operation> is [], the third argument must be the empty list, a list of length 1 or \"empty_list\"");
    fi;

    # Construct the family of rational expressions on n letters.
    if IsInt(n) then
        F:= NewFamily( Concatenation( "RatExp", String(n), "Letters" ),
                    IsRatExpOnnLettersObj );
    else
        F:= NewFamily( Concatenation( "RatExp", String(Length(n)), "Letters" ),
                    IsRatExpOnnLettersObj );
    fi;

    # Install the data.
    if IsPosInt(n) then
        F!.alphabet := n;
        if n < 27 then
           F!.alphabet2 := List([1..n], i -> jascii[68+i]);
        else
           F!.alphabet2 := List([1..n], i -> Concatenation("a", String(i)));
        fi;
    else
        #        l := SSortedList(n);
        l := n;
        if '@' in l then
            Error("'@' must not be in the alphabet");
        fi;
        F!.alphabet := Length(l);
        F!.alphabet2 := l;
    fi;

    exp := rec(op := operation,
               list_exp := list );
    R := RatExpOnnLettersObj( F, exp );

    # Return the rational expression.
    return R;
end );

############################################################################
##
#F RatExpToString(r)
##
InstallGlobalFunction( RatExpToString, function( r, count )
    local   A,  i,  hasUnion,  xstr,  xout,  str,  e,  ret,  flag;

    if not IsRatExpOnnLettersObj(r) then
        Error("The argument to RatExpToString must be a rational expression");
    fi;


    A := [];
    if IsChar(AlphabetOfRatExpAsList(r)[1]) then
        for i in AlphabetOfRatExpAsList(r) do
            Add(A, [i]);
        od;
    else
        for i in AlphabetOfRatExpAsList(r) do
            Add(A, i);
        od;
    fi;

    # Tests if a rational expression has a union rational subexpression
    hasUnion := function(r)
        if r!.op = [] then
            return(false);
        elif r!.op = "star" then
            return(false);
        elif r!.op = "union" then
            return(true);
        else
            return(ForAny(r!.list_exp, e -> hasUnion(e)));
        fi;
    end;

    if r!.list_exp = "empty_set" then
        return(["empty_set", count]);
    elif r!.op = [] then
        count := count + 1;
        if r!.list_exp = [] then
            return(["@", count]);
        else
            if IsString(A[r!.list_exp[1]]) then
                return([String(ShallowCopy(A[r!.list_exp[1]])), count]);
            else
                xstr := "";
                xout := OutputTextString( xstr, false );
                PrintTo( xout, ShallowCopy(A[r!.list_exp[1]]));
                CloseStream( xout );
                return([xstr, count]);
            fi;
        fi;
    elif r!.op = "product" then
        str := "";
        for e in r!.list_exp do
            ret := RatExpToString(e, count);
            count := ret[2];
            if hasUnion(e) then
                str := Concatenation(str, "(", ret[1], ")");
            else
                str := Concatenation(str, ret[1]);
            fi;
        od;
        return([str, count]);
    elif r!.op = "union" then
        flag := false;
        str := "";
        for e in r!.list_exp do
            ret := RatExpToString(e, count);
            count := ret[2];
            if e!.op = "union" then
                if str = "" then
                    str := ret[1];
                else
                    str := Concatenation(str, "U", ret[1]);
                fi;
            else
                if str = "" then
                    str := ret[1];
                else
                    str := Concatenation(str, "U", ret[1]);
                fi;
            fi;
        od;
        return([str, count]);
    else
        if r!.list_exp!.op = [] then  # This is star of a single letter
            ret := RatExpToString(r!.list_exp, count);
            return([Concatenation(ret[1], "*"), ret[2]]);
        else
            ret := RatExpToString(r!.list_exp, count);
            return([Concatenation("(", ret[1], ")*"), ret[2]]);
        fi;
    fi;
end);


#######################################################################
##
#M  PrintObj(R)
##
## Is used to display a rational expression <R> in a form that is readable by
## a human being
##
InstallMethod( PrintObj,
"for rational expressions",
true,
[ IsRatExpOnnLettersObj and IsRationalExpressionRep ], 0,
function(r)
    local ret, string;

    ret := RatExpToString(r, 0);
    string := ret[1];
    Setter(SizeRatExp)(r,ret[2]);
    Print(string);
end );

#############################################################################
##
#F  RationalExpression(arg)
##
##  Given the number of alphabet symbols and a string (S) returns
##  the rational expression represented by S
##
InstallGlobalFunction(RationalExpression, function(arg)
    local i, I0, S0, RationalExp, processPowers;


#	This function parses a string and replaces a^n by aaa.. (n times)
	processPowers := function(S)
		local S2, lc, i, j, k, num;

		if S = [] then
			return [];
		fi;
		lc := S[1];		# The last character read
		S2 := [lc];		# The converted string
		i := 2;
		while IsBound(S[i]) do
			if S[i] = '^' and IsBound(S[i+1]) and IsDigitChar(S[i+1]) then
				j := i + 1;
				num := [];
#				Get the power
				while IsBound(S[j]) and IsDigitChar(S[j]) do
					Add(num, S[j]);
					j := j + 1;
				od;
				num := Int(num);
				for k in [2..num] do
					Add(S2, lc);
				od;
				i := j - 1;
			else
				Add(S2, S[i]);
			fi;
			lc := S[i];
			i := i + 1;
		od;
		return S2;
	end;
##	End of processPowers()  --


    if Length(arg) = 0 then
        Error("Please specify a rational expression as a string");
    elif IsBound(arg[2]) then
        I0 := arg[2];
        S0 := processPowers(arg[1]);
        if not ((IsPosInt(I0) or IsString(I0)) and IsString(S0)) then
            Error("The arguments to RationalExpression must be a string [and a positive integer or a string]");
        fi;
        if IsString(I0) then
            if '@' in I0 or '*' in I0 or '(' in I0 or ')' in I0 or 'U' in I0 then
                Error("'@', '*', '(', ')' and 'U' must not be in the alphabet");
            fi;
#            I0 := SSortedList(I0);
        else
            if Length(SSortedList(Concatenation(S0, "U*()@"))) > I0+5 then
                Error("The expression contains more different letters than the alphabet");
            fi;
        fi;
    else
        I0 := [];
        S0 := processPowers(arg[1]);
        if S0 = "@" then
            Error("When defining @, please specify the alphabet");
        fi;
        for i in S0 do
            if not (i = '@' or i = '*' or i = 'U' or i = '(' or i = ')') then
                AddSet(I0, i);
            fi;
        od;
    fi;


    RationalExp := function(S, I)
        local i, op, ord, I0, S0,
              getTopOp, buildStar, buildProduct,
              sub_exps, union_inds, star_inds, union_sub_exps;

        if S = "" or S = "@" then
            return(RatExpOnnLetters(I, [], []));
        elif S = "empty_set" then
            return(RatExpOnnLetters(I, [], "empty_set"));
        elif Length(S) = 1 then
            if IsInt(I) then
                ord := Ord(S[1]) - Ord('a') + 1;
            else
                ord := Position(I, S[1]);
                if ord = fail then
                    Error(Concatenation("Letter of expression not in alphabet: ", S[1]));
                fi;
            fi;
            return(RatExpOnnLetters(I, [], [ord]));
        fi;
        sub_exps       := [];
        union_inds     := [];
        star_inds      := [];
        union_sub_exps := [];

##  This functions returns the "top" most operation of the given
##  expression
##  getTopOp("aaUab*") returns "union"
##  getTopOp("(bUa)*") returns "star"
##  getTopOp("(bUa)*b") returns "product"
##
##  it also fills the array sub_exps with the sub expressions,
##  union_inds with the indexes in sub_exps of the positions of
##  the U symbols
##  and star_inds with the indexes in sub_exps of the positions
##  of the * symbols
        getTopOp := function(e)
            local i, c, stack, istack, star, nonstar, union, len, sub;

            if e = "" or Length(e) = 1 then
                return([]);
            else
                stack   := [];
                istack  := 0;
                star    := false;
                nonstar := false;
                union   := false;
                len     := Length(e);
                sub     := [];
                for i in [1 .. len] do
                    c := e[i];
                    if c = '(' then
                        if istack > 0 then
                            Add(sub, c);
                        fi;
                        istack := istack + 1;
                        stack[istack] := c;
                    elif c = ')' then
                        if istack > 0 then
                            istack := istack - 1;
                            if istack = 0 then
                                if i < len - 1 then
                                    nonstar := true;
                                fi;
                                Add(sub_exps, String(sub));
                                sub := [];
                            else
                                Add(sub, c);
                            fi;
                        else
                            Error("Mismatched parenthesis");
                        fi;
                    elif istack = 0 then
                        if c = 'U' then
                            union := true;
                            Add(union_inds, Length(sub_exps) + 1);
                        elif c = '*' then
                            star  := true;
                            Add(star_inds, Length(sub_exps) + 1);
                        else
                            Add(sub_exps, [c]);
                        fi;
                    else
                        Add(sub, c);
                    fi;
                od;
                if istack > 0 then
                    Error("Mismatched parenthesis");
                fi;
                if union then
                    return("union");
                elif star and ((e[1] = '(' and e[len-1] = ')' and nonstar = false) or (len = 2)) then
                    return("star");
                else
                    return("product");
                fi;
            fi;
        end;
##  End of getTopOp()  --

##  This function scans the array sub_exps and replaces
##  all the strings that are meant to be star expressions
##  by the corresponding star rational subexpression
        buildStar := function()
            local i;

            if not star_inds = [] then
                for i in star_inds do
                    if i-1 > 0 then
                        if IsString(sub_exps[i-1]) then
                            sub_exps[i-1] := RatExpOnnLetters(I, "star", RationalExp(sub_exps[i-1], I));
                        else
                            Error("Malformed expression");
                        fi;
                    else
                        Error("Malformed expression");
                    fi;
                od;
            fi;
        end;
##  End of buildStar()  --

##  When the "top" most operation is "union", this functions
##  groups the product subexpressions of the union, building
##  the list union_sub_exps to be used in
##  RatExpOnnLetters(I, "union", union_sub_exps
        buildProduct := function()
            local i, j, k, list, len;

            list := [];
            j    := 1;
            len  := Length(sub_exps);
            for i in union_inds do
                if i > len then
                    Error("Malformed expression");
                fi;
                for k in [j .. i-1] do
                    Add(list, sub_exps[k]);
                od;
                if Length(list) = 1 then
                    Add(union_sub_exps, list[1]);
                else
                    Add(union_sub_exps, RatExpOnnLetters(I, "product", list));
                fi;
                j := i;
                list := [];
            od;
            for k in [j .. len] do
                Add(list, sub_exps[k]);
            od;
            if Length(list) = 1 then
                Add(union_sub_exps, list[1]);
            else
                Add(union_sub_exps, RatExpOnnLetters(I, "product", list));
            fi;
        end;
##  End of buildProduct()  --

        op := getTopOp(S);
        buildStar();
        if op = "star" then
            return(sub_exps[1]);
        elif op = "product" then
            for i in [1 .. Length(sub_exps)] do
                if IsString(sub_exps[i]) then
                    sub_exps[i] := RationalExp(sub_exps[i], I);
                fi;
            od;
            return(RatExpOnnLetters(I, "product", sub_exps));
        else    # op = "union"
            for i in [1 .. Length(sub_exps)] do
                if IsString(sub_exps[i]) then
                    sub_exps[i] := RationalExp(sub_exps[i], I);
                fi;
            od;
            buildProduct();
            return(RatExpOnnLetters(I, "union", union_sub_exps));
        fi;
    end;

    return(RationalExp(S0, I0));
end);


#######################################################################
##
#M  String(R)
##
##  Outputs a rational expression as a string
##
InstallMethod( String,
"for rational expressions",
true,
[ IsRatExpOnnLettersObj and IsRationalExpressionRep ], 0,
function(r)
    local ret, string;
    ret := RatExpToString(r, 0);
    string := ret[1];
    Setter(SizeRatExp)(r,ret[2]);
    return(string);
end );

#############################################################################
##
#F  RandomRatExp(arg)
##
##  Given the number of symbols of the alphabet and (possibly) a factor m,
##  returns a pseudo random rational expression over that alphabet.
##
InstallGlobalFunction(RandomRatExp, function(arg)
    local aut, m, n;

    if Length(arg) = 0 then
        Error("Please specify the number of letters of the alphabet of the rational expression or a string");
    fi;
    n := arg[1];
    if not (IsPosInt( n ) or IsList(n)) then
        Error( "The argument must be a positive integer or a string" );
    fi;
    if IsString(n) then
        if '@' in n then
            Error("@ must not be in the alphabet");
        fi;
    fi;
    if IsBound(arg[2]) then
        m := arg[2];
    else
        m := 1;
    fi;
    aut := RandomAutomaton("det", (Runtime() mod (m*7)) + 2, n);
    return(FAtoRatExp(aut));
end);

#########################################################################
##
#M  SizeRatExp(r)
##
##  Computes the size of the rational expression r
##
##
InstallMethod(SizeRatExp,
        "size of RatExp",
        [IsRatExpOnnLettersObj],
        function( r )
    local   count,  e;

    if not IsRatExpOnnLettersObj(r) then
        Error("The argument to RatExpToString must be a rational expression");
    fi;
    count := 0;
    if r!.list_exp = "empty_set" then
        return(0);
    elif r!.op = [] then
        return(1);
    elif r!.op = "product" or r!.op = "union" then
        for e in r!.list_exp do
            count := count + SizeRatExp(e);
        od;
        return(count);
    else
        return(SizeRatExp(r!.list_exp));
    fi;
end);

#########################################################################
##
#M  AlphabetOfRatExp(r)
##
##  Returns the number of symbols in the alphabet of the rational expression r
##
##
InstallGlobalFunction(AlphabetOfRatExp, function( R )
    return(ShallowCopy(FamilyObj(R)!.alphabet));
end);


#############################################################################
##
#F  AlphabetOfRatExpAsList(R)
##
##  Returns the alphabet of the rational expression as a list.
##  If the alphabet of the rational expression is given by means of an integer
##  less than 27 it returns the list "abcd....",
##  otherwise returns [ "a1", "a2", "a3", "a4", ... ].
##
InstallGlobalFunction(AlphabetOfRatExpAsList, function( R )
    if not IsRatExpOnnLettersObj(R) then
        Error("The argument must be a rational expression");
    fi;
    return(ShallowCopy(FamilyObj(R)!.alphabet2));
end);

############################################################################
##
#F IsRationalExpression
##
InstallGlobalFunction(IsRationalExpression, function(R)
    return IsRatExpOnnLettersObj(R) and IsRationalExpressionRep(R);
end);
############################################################################
##
#M Methods for the comparison operations.
##
InstallMethod( \=,
    "for two rational sets",
    ReturnTrue,
        [ IsRatExpOnnLettersObj and IsRationalExpressionRep,
          IsRatExpOnnLettersObj and IsRationalExpressionRep,  ],
    0,
        function( L1, L2 )
    return( AlphabetOfRatExp(L1) = AlphabetOfRatExp(L2) and L1!.op = L2!.op and L1!.list_exp = L2!.list_exp );
end );

InstallMethod( \<,
        "for two rational expressions",
            #    IsIdenticalObj,
        true,
        [ IsRatExpOnnLettersObj and IsRationalExpressionRep,
          IsRatExpOnnLettersObj and IsRationalExpressionRep,  ],
        0,
        function( x, y )
    if x = y then
        return(false);
    elif x!.list_exp = "empty_set" then
        return(true);
    elif x!.op = [] and y!.op = [] and not y!.list_exp = "empty_set" then
        return(x!.list_exp < y!.list_exp);
    elif x!.op = [] and (y!.op = "star" or y!.op = "product" or y!.op = "union") then
        return(true);
    elif x!.op = "star" and (y!.op = "product" or y!.op = "union") then
        return(true);
    elif x!.op = "product" and y!.op = "union" then
        return(true);
    elif x!.op = y!.op then
        return(x!.list_exp < y!.list_exp);
    else
        return(false);
    fi;
end );

##
#E







