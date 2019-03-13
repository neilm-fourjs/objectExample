
IMPORT FGL oss
IMPORT FGL fts
IMPORT FGL files

DEFINE m_oss oss
DEFINE m_fts fts
DEFINE m_files files
MAIN
-- Setup test data for OS's
	CALL m_oss.loadFromDisk("../data/oss.json")
-- Setup test data for File Types
	CALL m_fts.loadFromDisk("../data/fts.json")
-- Setup test data for Files
	CALL m_files.init( m_oss, m_fts ) -- pass in our OSs and Types
	CALL m_files.loadFromDisk("../data/files.json")

	DISPLAY "OSs:",m_oss.count, " Types:", m_fts.count, " Files:", m_files.count
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