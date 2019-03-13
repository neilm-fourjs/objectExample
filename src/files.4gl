
-- Manage a simple List of File objects

&define FAIL(txt) LET m_fail_reason = txt RETURN FALSE
IMPORT FGL oss
PUBLIC TYPE file RECORD
		fileId INTEGER,
		fileName STRING,
		fileTypeId INTEGER,
		fileOSId INTEGER,
		fileOSText STRING,
		fileVerMajor SMALLINT,
		fileVerMinor SMALLINT,
		fileVerPatch STRING,
		fileVersion STRING
	END RECORD
PUBLIC TYPE files RECORD
	list DYNAMIC ARRAY OF file,
	count SMALLINT,
	current SMALLINT
END RECORD
PUBLIC DEFINE m_file FILE
DEFINE m_fail_reason STRING
DEFINE m_oss oss
----------------------------------------------------------------------------------------------------
FUNCTION (this files) init( l_oss oss )
	LET m_oss = l_oss
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this files) clearList()
	CALL this.list.clear()
	LET this.count = 0
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this files) add(
		l_fileName STRING,
		l_fileTypeId INTEGER,
		l_fileOSId INTEGER,
		l_fileVerMajor SMALLINT,
		l_fileVerMinor SMALLINT,
		l_fileVerPatch STRING
 ) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""

	LET m_file.fileId = 0
	LET m_file.fileName = l_fileName
	LET m_file.fileTypeId = l_fileTypeId
	LET m_file.fileOSId = l_fileOSId
	LET m_file.fileOSText =  m_oss.getTypeText(l_fileOSId)
	LET m_file.fileVerMajor = l_fileVerMajor
	LET m_file.fileVerMinor = l_fileVerMinor
	LET m_file.fileVerPatch = l_fileVerPatch
	LET m_file.fileVersion = SFMT("%1.%2.%3",l_fileVerMajor, l_fileVerMinor, l_fileVerPatch)

	IF m_file.fileTypeId IS NULL THEN FAIL("fileType NULL") END IF
	IF m_file.fileName IS NULL THEN FAIL("fileName NULL") END IF

	FOR x = 1 TO this.list.getLength()
		IF this.list[x].fileTypeId = m_file.fileTypeId
		AND this.list[x].fileName = m_file.fileName
		AND this.list[x].fileOSId = m_file.fileOSId THEN
			FAIL("Record already exists")
		END IF
	END FOR

	CALL this.list.appendElement()
	LET this.count = this.list.getLength()
	LET m_file.fileId = this.count
	LET this.current = this.count
	LET this.list[this.count].* = m_file.*
	RETURN TRUE
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this files) selectByID(l_id INTEGER) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	FOR x = 1 TO this.count
		IF this.list[x].fileId = l_id THEN
			LET this.current = x
			LET m_file.* = this.list[x].*
			RETURN TRUE
		END IF
	END FOR
	FAIL("Not Found")
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this files) update() RETURNS ()
	LET this.list[ this.current ].* = m_file.*
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this files) existsID(l_id INTEGER) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	FOR x = 1 TO this.list.getLength()
		IF this.list[x].fileId = l_id THEN RETURN TRUE END IF
	END FOR
	FAIL("Not Found")
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this files) getError() RETURNS STRING
	RETURN m_fail_reason
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this files) display(x SMALLINT)
	DISPLAY BY NAME this.list[ x ].*
END FUNCTION
----------------------------------------------------------------------------------------------------
DIALOG file_input()
	INPUT BY NAME m_file.* ATTRIBUTES(WITHOUT DEFAULTS)
	END INPUT
END DIALOG