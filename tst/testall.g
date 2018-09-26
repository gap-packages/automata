LoadPackage("automata");
dir := DirectoriesPackageLibrary("automata", "tst");
TestDirectory(dir, rec(exitGAP := true) );

FORCE_QUIT_GAP(1);
