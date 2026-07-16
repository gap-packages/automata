SetPackageInfo( rec(

PackageName := "Automata",
Subtitle := "A package on automata",
Version := "1.17",
Date := "16/07/2026", # dd/mm/yyyy format
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
                   "CMUP, Departamento de Matemática\n",
                   "Faculdade de Ciências, Universidade do Porto\n",
                   "Rua do Campo Alegre s/n\n",
                   "4169-007 Porto\n",
                   "Portugal" ] ),
    Place         := "Porto",
    Institution   := "Faculdade de Ciências"
  ),
  rec(
    LastName      := "Hoffmann",
    FirstNames    := "Ruth",
    IsAuthor      := false,
    IsMaintainer  := true,
    Email         := "rh347@st-andrews.ac.uk",
    WWWHome       := "https://research-portal.st-andrews.ac.uk/en/persons/ruth-hoffmann",
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
    LastName      := "Linton",
    FirstNames    := "Steve",
    IsAuthor      := true,
    IsMaintainer  := false,
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
  HTMLStart := "doc/chap0_mj.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Automata, a GAP package for finite state automata",
),


Dependencies := rec(
  GAP := ">=4.9",
  NeededOtherPackages := [],
  SuggestedOtherPackages := [],
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

Keywords := ["Automata", "Rational Expressions"]


));
