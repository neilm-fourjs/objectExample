
IMPORT FGL oss
IMPORT FGL fts
IMPORT FGL files

MAIN
	DEFINE l_oss oss
	DEFINE l_fts fts
	DEFINE l_files files

-- Setup test data for OS's
	CALL l_oss.loadFromDisk("../data/oss.json")
-- Setup test data for File Types
	CALL l_fts.loadFromDisk("../data/fts.json")
-- Setup test data for Files
	CALL l_files.init( l_oss, l_fts ) -- pass in our OSs and Types
	CALL l_files.loadFromDisk("../data/files.json")

	DISPLAY "OSs:",l_oss.count, " Types:", l_fts.count, " Files:", l_files.count
	OPEN FORM f FROM "fileController"
	DISPLAY FORM F

	DISPLAY ARRAY l_files.list TO arr.* ATTRIBUTES(UNBUFFERED, ACCEPT=FALSE)
		BEFORE ROW
			LET l_files.current = arr_curr()
			CALL l_files.display( l_files.current )
			IF l_fts.selectByID( l_files.list[l_files.current].fileTypeId ) THEN
				CALL l_fts.display( l_fts.current )
			END IF
			IF l_oss.selectByID( l_files.list[l_files.current].fileOSId ) THEN
				CALL l_oss.display( l_oss.current )
			END IF
		ON ACTION showOS
			CALL l_oss.showWindow()
		ON ACTION upd
			IF l_files.selectByID( arr_curr() ) THEN
				IF updateFile() THEN -- update objects
					CALL l_files.update()
					CALL l_fts.update()
					CALL l_oss.update()
				END IF
			END IF
	END DISPLAY

END MAIN
----------------------------------------------------------------------------------------------------
-- Update the record screen records
FUNCTION updateFile()
	DIALOG ATTRIBUTE(UNBUFFERED)
		SUBDIALOG files.file_input
		SUBDIALOG fts.ft_input
		SUBDIALOG oss.os_input
		ON ACTION close LET int_flag = TRUE EXIT DIALOG
		ON ACTION cancel LET int_flag = TRUE EXIT DIALOG
		ON ACTION accept LET int_flag = FALSE EXIT DIALOG
	END DIALOG
	RETURN NOT int_flag
END FUNCTION