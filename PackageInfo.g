SetPackageInfo( rec(

PackageName := "Automata",
Subtitle := "A package on automata",
Version := "1.13dev",
Date := "19/11/2011",

Persons := [
  rec(
    LastName      := "Delgado",
    FirstNames    := "Manuel",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "mdelgado@fc.up.pt",
    WWWHome       := "http://www.fc.up.pt/cmup/mdelgado/",
    PostalAddress := Concatenation( [
                   "Departamento de Matemática - Faculdade de Ciências\n",
                   "Porto\n",
                   "Portugal" ] ),
    Place         := "Porto",
    Institution   := "Faculdade de Ciências"
  ),
  rec(
    LastName      := "Linton",
    FirstNames    := "Steve",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "steve.linton@st-andrews.ac.uk",
    WWWHome       := "http://www-groups.dcs.st-and.ac.uk/~sal/",
    PostalAddress := Concatenation(
                       "School of Computer Science\n",
                       "University of St Andrews\n",
                       "Jack Cole Building, North Haugh\n",
                       "St Andrews, Fife, KY16 9SX\n",
                       "United Kingdom" ),
    Place         := "St. Andrews",
    Institution   := "School of Computer Science, University of St. Andrews"
  ),
  rec(
    LastName      := "Morais",
    FirstNames    := "José João",
    IsAuthor      := true,
    IsMaintainer  := false,
#    Email         := "josejoao@fc.up.pt",
#    WWWHome       := "",
#    PostalAddress := Concatenation( [
#                       "Jose Morais\n",
#                       "Departamento de Matemática Pura\n",
#                   "Faculdade de Ciências\n",
#                   "Rua do Campo Alegre, 687\n",
#                   "Porto\n",
#                   "Portugal" ] ),
    PostalAddress := "No address known"
#    Place         := "Porto",
#    Institution   := "Faculdade de Ciências"

  ),

],

Status := "accepted",
CommunicatedBy := "Edmund Robertson (St. Andrews)",
AcceptDate := "09/2004",

PackageWWWHome   := "https://gap-packages.github.io/automata/",
README_URL       := Concatenation(~.PackageWWWHome, "README"),
PackageInfoURL   := Concatenation(~.PackageWWWHome, "PackageInfo.g"),
SourceRepository := rec(
  Type := "git",
  URL := "https://github.com/gap-packages/automata"
),
IssueTrackerURL  := Concatenation( ~.SourceRepository.URL, "/issues" ),
ArchiveURL       := Concatenation( ~.SourceRepository.URL,
                                  "releases/download/v", ~.Version,
                                  "/automata-", ~.Version),
ArchiveFormats   := ".tar.gz .tar.bz2",

AbstractHTML :=
   "The <span class=\"pkgname\">Automata</span> package, as its name suggests, is package with algorithms to deal with automata.",

PackageDoc := rec(
  BookName  := "Automata",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "",
  Autoload  := true
),


Dependencies := rec(
  GAP := ">=4.8",
  NeededOtherPackages := [],
  SuggestedOtherPackages := [["GAPDoc", ">= 1.2"]],
  ExternalConditions := [["Graphviz","http://www.graphviz.org/"],["Evince","http://www.gnome.org/projects/evince/"]]

),

AvailabilityTest := ReturnTrue,

Autoload := false,

#TestFile := "tst/testall.g",

Keywords := ["Automata", "Rational Expressions"],

AutoDoc := rec(
    TitlePage := rec(
        Copyright := """
&copyright; 2004 by Manuel Delgado, Steve Linton and José Morais <P/>
We adopt the copyright regulations of &GAP; as detailed in the
copyright notice in the &GAP; manual.
""",
        Colophon := """
This work started in 1998, when the first author was in the
LIAFA at the University of Paris 7, in a post-doc.
Encouraged by J. E. Pin, he began the implementation in &GAP;3 of
an algorithm obtained some time before to answer a question from the realm
of Finite Semigroups proposed by J. Almeida. It is now part of a separate
package: <C>finsemi</C>. <P/>

The first version of this package on automata was prepared by the first author
who gave it the form of a &GAP; share package.
In a second version, prepared by the first and third authors,
many functions have been added and the performance of many of the existing
ones has been improved. Further important improvements, specially concerning performance,
have been achieved when the second author joined the group.
<P/>

Since Version 1.12, the package is maintained by the first two authors.

Bug reports, suggestions and comments are, of course, welcome. Please use our
email addresses to this effect.
""",
        Acknowledgements := """
The first author wishes to acknowledge Cyril Nicaud and Paulo Varandas for
their help in programming some functions of the very first version of this
package. He wishes also to acknowledge useful discussions and comments by
Cyril Nicaud, Vítor H. Fernandes, Jean-Eric Pin and Jorge Almeida.
<P/>
The first author also acknowledges support of FCT through CMUP
and the FCT and POCTI Project POCTI/32817/MAT/2000 which is funded in
cooperation with the European Community Fund FEDER.
<P/>
The third author acknowledges financial support of FCT and the POCTI program
through a scholarship given by Centro de Matemática da Universidade do Porto.
<P/>

The authors would like to thank Mark Kambites for his contribution in finding
bugs and making suggestions for the improvement of this package.
<P/>
<P/>
<P/>
Concerning the mantainment:
<P/>
<P/>
The first author was/is (partially) supported by the FCT project
PTDC/MAT/65481/2006 and also by the <E>Centro de Matemática da Universidade do
Porto</E> (CMUP), funded by the European Regional Development Fund through the
program COMPETE and by the Portuguese Government through the FCT - Fundação
para a Ciência e a Tecnologia under the project PEst-C/MAT/UI0144/2011.
""",

    )
),

));
