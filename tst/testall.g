LoadPackage("automata");
dir := DirectoriesPackageLibrary("automata", "tst");
TestDirectory(dir, rec(exitGAP := true, testOptions:=rec(compareFunction := "uptowhitespace")) );

FORCE_QUIT_GAP(1);
