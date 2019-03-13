IMPORT FGL oss
IMPORT FGL fts
IMPORT FGL files

DEFINE m_oss oss
DEFINE m_fts fts
DEFINE m_files files
MAIN
-- Setup test data for OS's
	IF NOT m_oss.add("Linux","64bit","212") THEN DISPLAY m_oss.getError() END IF
	IF NOT m_oss.add("Linux","64bit","219") THEN DISPLAY m_oss.getError() END IF
	IF NOT m_oss.add("Linux","32bit","212") THEN DISPLAY m_oss.getError() END IF
	IF NOT m_oss.add("Linux","arm32","212") THEN DISPLAY m_oss.getError() END IF
	IF NOT m_oss.add("Windows","64bit","140") THEN DISPLAY m_oss.getError() END IF
	IF NOT m_oss.add("Genero","Any","310") THEN DISPLAY m_oss.getError() END IF
	IF NOT m_oss.add("Genero","Any","320") THEN DISPLAY m_oss.getError() END IF

-- Setup test data for File Types
	IF NOT m_fts.add("Genero Installer") THEN DISPLAY m_fts.getError() END IF
	IF NOT m_fts.add("Genero Archive") THEN DISPLAY m_fts.getError() END IF
	IF NOT m_fts.add("RPM") THEN DISPLAY m_fts.getError() END IF
	IF NOT m_fts.add("GPaas Package") THEN DISPLAY m_fts.getError() END IF

-- Setup test data for Files
	CALL m_files.init( m_oss, m_fts ) -- pass in our OSs and Types
	IF NOT m_files.add( "fgl-3.20.02.run", 1, 1, 3, 20, "02" ) THEN DISPLAY m_files.getError() END IF
	IF NOT m_files.add( "fgl-3.20.03.run", 1, 1, 3, 20, "03" ) THEN DISPLAY m_files.getError() END IF
	IF NOT m_files.add( "fgl-3.20.02.run", 1, 4, 3, 20, "02" ) THEN DISPLAY m_files.getError() END IF
	IF NOT m_files.add( "fgl-3.20.03.run", 1, 4, 3, 20, "03" ) THEN DISPLAY m_files.getError() END IF
	IF NOT m_files.add( "gas-3.20.02.run", 1, 1, 3, 20, "02" ) THEN DISPLAY m_files.getError() END IF
	IF NOT m_files.add( "gas-3.20.02.run", 1, 1, 3, 20, "02" ) THEN DISPLAY m_files.getError() END IF
	IF NOT m_files.add( "gre-3.20.02.run", 1, 1, 3, 20, "02" ) THEN DISPLAY m_files.getError() END IF
	IF NOT m_files.add( "helloworld-310.gar", 2, 6, 3, 10, "00" ) THEN DISPLAY m_files.getError() END IF
	IF NOT m_files.add( "helloworld-320.gar", 2, 7, 3, 20, "00" ) THEN DISPLAY m_files.getError() END IF
	IF NOT m_files.add( "ifx_12.10.rpm", 3, 1, 12, 10, "EC10" ) THEN DISPLAY m_files.getError() END IF

	DISPLAY "OSs:",m_oss.count, " Types:", m_fts.count, " Files:", m_files.count

	CALL m_fts.saveToDisk("../data/fts.json")
	CALL m_oss.saveToDisk("../data/oss.json")
	CALL m_files.saveToDisk("../data/files.json")

END MAIN