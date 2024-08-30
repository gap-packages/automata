LoadPackage( "AutoDoc" );
AutoDoc(rec( scaffold := rec( MainPage := false ),
             gapdoc := rec( main := "AutMan.xml" )));
PrintTo("version", GAPInfo.PackageInfoCurrent.Version);
#
QUIT;
