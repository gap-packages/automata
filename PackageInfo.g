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
                   "Manuel Delgado\n",
                   "Departamento de Matemática\n",
                   "Faculdade de Ciências\n",
                   "Rua do Campo Alegre, 687\n",
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
    Email         := "sal@dcs.st-and.ac.uk",
    WWWHome       := "http://www.dcs.st-and.ac.uk/~sal/",
    PostalAddress := Concatenation( [
                   "Steve Linton\n",
                   "School of Computer Science,\n",
                   "University of St. Andrews,\n",
                   "North Haugh,\n",
                   "St. Andrews,\n", 
                   "Fife,\n",
                   "KY16 9SS,\n",
                   "SCOTLAND\n"] ),
    Place         := "St. Andrews",
    Institution   := "School of Computer Science, University of St. Andrews"       
  ),
  rec( 
    LastName      := "Morais",
    FirstNames    := "Jose",
    IsAuthor      := true,
#    IsMaintainer  := false,
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

Keywords := ["Automata", "Rational Expressions"]

));
