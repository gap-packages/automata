#######################################################################
InstallGlobalFunction(AutomataTest,
        function()
  Test(Concatenation(PackageInfo("automata")[1]!.
          InstallationPath, "/tst/testall.tst"), rec( compareFunction := "uptowhitespace" ));
end);
