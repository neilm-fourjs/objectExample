
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

-- File Types
	IF NOT m_fts.add("Genero Installer") THEN DISPLAY m_fts.getError() END IF
	IF NOT m_fts.add("Genero Archive") THEN DISPLAY m_fts.getError() END IF
	IF NOT m_fts.add("RPM") THEN DISPLAY m_fts.getError() END IF
	IF NOT m_fts.add("GPaas Package") THEN DISPLAY m_fts.getError() END IF

-- Setup test data for Files
	CALL m_files.init( m_oss, m_fts )
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

	DISPLAY "OS array len:",m_oss.count, " File array len:", m_files.count

	OPEN FORM f FROM "fileController"
	DISPLAY FORM F

	DISPLAY ARRAY m_files.list TO arr.* ATTRIBUTES(UNBUFFERED, ACCEPT=FALSE)
		BEFORE ROW
			LET m_files.current = arr_curr()
			CALL m_files.display( m_files.current )
			IF m_fts.selectByID( m_files.list[m_files.current].fileTypeId ) THEN
				CALL m_fts.display( m_fts.current )
			END IF
			IF m_oss.selectByID( m_files.list[m_files.current].fileOSId ) THEN
				CALL m_oss.display( m_oss.current )
			END IF
			DISPLAY "File:",m_files.current," OS:",m_oss.current
		ON ACTION showOS
			CALL m_oss.showWindow()
		ON ACTION upd
			IF m_files.selectByID( arr_curr() ) THEN
				CALL updateFile()
			END IF
	END DISPLAY

END MAIN
----------------------------------------------------------------------------------------------------
-- Update the files record
FUNCTION updateFile()
	DIALOG ATTRIBUTE(UNBUFFERED)
		SUBDIALOG files.file_input
		SUBDIALOG fts.ft_input
		SUBDIALOG oss.os_input
		ON ACTION close LET int_flag = TRUE EXIT DIALOG
		ON ACTION cancel LET int_flag = TRUE EXIT DIALOG
		ON ACTION accept LET int_flag = FALSE EXIT DIALOG
	END DIALOG
	IF NOT int_flag THEN
		CALL m_files.update()
		CALL m_fts.update()
		CALL m_oss.update()
	END IF
END FUNCTION