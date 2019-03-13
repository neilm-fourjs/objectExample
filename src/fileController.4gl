
IMPORT FGL os

DEFINE m_os os

DEFINE m_files DYNAMIC ARRAY OF RECORD
		fileId INTEGER,
		fileName STRING,
		fileOSId INTEGER,
		fileOSText STRING
	END RECORD

MAIN
	CALL newOS("CentOS","6")
	CALL newOS("CentOS","7")
	CALL newOS("CentOS","7") -- test rejecting duplicate record
	CALL newOS("Ubuntu","18.10")
	CALL newFile("MyFile1.tgz",1)
	CALL newFile("MyFile2.tgz",2)
	CALL newFile("MyFile3.tgz",1)
	CALL newFile("MyFile4.tgz",3)
	CALL newFile("MyFile4.tgz",4)

	DISPLAY "OS array len:",m_os.getLength(), " File array len:", m_files.getLength()

	OPEN FORM f FROM "fileController"
	DISPLAY FORM F

	DISPLAY ARRAY m_files TO arr.*
		BEFORE ROW
			DISPLAY BY NAME m_files[ arr_curr() ].*
			IF NOT m_os.getById( m_files[ arr_curr() ].fileOSId ) THEN
				ERROR m_os.getError()
			END IF
			CALL m_os.display()
		ON ACTION showOS
			CALL m_os.showWindow()
		ON ACTION upd
			CALL updateFile(arr_curr())
	END DISPLAY

END MAIN
----------------------------------------------------------------------------------------------------
FUNCTION updateFile(x SMALLINT)
	DIALOG ATTRIBUTE(UNBUFFERED)
		INPUT BY NAME m_files[ x ].* ATTRIBUTES(WITHOUT DEFAULTS)
		END INPUT
		SUBDIALOG os.updt
		ON ACTION CLOSE EXIT DIALOG
		ON ACTION back EXIT DIALOG
	END DIALOG
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION newFile( l_name STRING, l_os INTEGER)
	CALL m_files.appendElement()
	LET m_files[ m_files.getLength() ].fileId =  m_files.getLength()
	LET m_files[ m_files.getLength() ].fileName = l_name
	LET m_files[ m_files.getLength() ].fileOSId = l_os
	IF m_os.getById( l_os ) THEN
		LET m_files[ m_files.getLength() ].fileOSText = m_os.osType," ",m_os.osVersion
	ELSE
		LET m_files[ m_files.getLength() ].fileOSText = "OS Not Found!"
	END IF
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION newOS( l_type STRING, l_version STRING)
	LET m_os.osId = 0
	LET m_os.osType = l_type
	LET m_os.osVersion = l_version
	IF NOT m_os.add() THEN
		DISPLAY SFMT("Insert of %1 %2 Failed %3",l_type,l_version,m_os.getError())
	ELSE
		DISPLAY SFMT("Insert of %1 %2 Okay id is %3",l_type,l_version, m_os.osId)
	END IF
END FUNCTION