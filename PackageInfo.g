SetPackageInfo( rec(

PackageName := "Automata",
Subtitle := "A package on automata",
Version := "1.13",
Date := "19/11/2011",

ArchiveURL := 
          "http://www.fc.up.pt/cmup/mdelgado/automata/automata-1.13",

ArchiveFormats := ".tar.gz",
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

README_URL := 
  "http://www.fc.up.pt/cmup/mdelgado/automata/README",
PackageInfoURL := 
  "http://www.fc.up.pt/cmup/mdelgado/automata/PackageInfo.g",

AbstractHTML := 
   "The <span class=\"pkgname\">Automata</span> package, as its name suggests, is package with algorithms to deal with automata.",

PackageWWWHome := "http://www.fc.up.pt/cmup/mdelgado/automata",
               
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
  GAP := ">=4.4",
  NeededOtherPackages := [],
  SuggestedOtherPackages := [["GAPDoc", ">= 1.2"]],
  ExternalConditions := [["Graphviz","http://www.graphviz.org/"],["Evince","http://www.gnome.org/projects/evince/"]]
                      
),

AvailabilityTest := ReturnTrue,

BannerString := Concatenation( 
  "----------------------------------------------------------------\n",
  "Loading  Automata ", ~.Version, "\n",
#  "by ", ~.Persons[1].FirstNames, " ", ~.Persons[1].LastName,
#        " (", ~.Persons[1].WWWHome, ")\n",
#  "   ", ~.Persons[2].FirstNames, " ", ~.Persons[2].LastName,
#        " (", ~.Persons[2].WWWHome, ")\n",
#  "   ", ~.Persons[3].FirstNames, " ", ~.Persons[3].LastName,"\n",
#        " (", ~.Persons[3].WWWHome, ")\n",                
  "For help, type: ?Automata: \n",
  "----------------------------------------------------------------\n" ),

Autoload := false,

#TestFile := "tst/testall.g",

Keywords := ["Automata", "Rational Expressions"]

));
