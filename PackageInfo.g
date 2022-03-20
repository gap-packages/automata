SetPackageInfo( rec(

PackageName := "Automata",
Subtitle := "A package on automata",
Version := "1.15",
Date := "20/03/2022", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec(
    LastName      := "Delgado",
    FirstNames    := "Manuel",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "mdelgado@fc.up.pt",
    WWWHome       := "https://cmup.fc.up.pt/cmup/mdelgado/",
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
README_URL       := Concatenation(~.PackageWWWHome, "README.md"),
PackageInfoURL   := Concatenation(~.PackageWWWHome, "PackageInfo.g"),
SourceRepository := rec(
  Type := "git",
  URL := "https://github.com/gap-packages/automata"
),
IssueTrackerURL  := Concatenation( ~.SourceRepository.URL, "/issues" ),
ArchiveURL       := Concatenation( ~.SourceRepository.URL,
                                  "/releases/download/v", ~.Version,
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
  LongTitle := "Automata, a GAP package for finite state automata",
#  Autoload  := true
),


Dependencies := rec(
  GAP := ">=4.8",
  NeededOtherPackages := [],
  SuggestedOtherPackages := [["GAPDoc", ">= 1.2"]],
##  ExternalConditions := [["Graphviz","https://www.graphviz.org/"],["Evince","http://www.gnome.org/projects/evince/"]]

),

AvailabilityTest := ReturnTrue,

Autoload := false,

TestFile := "tst/testall.g",

Keywords := ["Automata", "Rational Expressions"]


));
