
-- Manager a simple List of File objects

&define FAIL(txt) LET m_fail_reason = txt RETURN FALSE

PUBLIC TYPE file RECORD
		fileId INTEGER,
		fileName STRING,
		fileType INTEGER,
		fileOSId INTEGER,
		fileVerMajor SMALLINT,
		fileVerMinor SMALLINT,
		fileVerPatch STRING
	END RECORD
DEFINE m_fail_reason STRING
DEFINE m_file file
DEFINE m_files DYNAMIC ARRAY OF FILE
----------------------------------------------------------------------------------------------------
FUNCTION (this file) init( l_file file ) RETURNS ()
	LET this.* = l_file.*
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this file) add( ) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	IF this.fileType IS NULL THEN FAIL("fileType NULL") END IF
	IF this.fileName IS NULL THEN FAIL("fileName NULL") END IF

	IF this.fileID != 0 THEN FAIL("id not 0") END IF

	FOR x = 1 TO m_files.getLength()
		IF m_files[x].fileType = this.fileType
		AND m_files[x].fileName = this.fileName THEN
			FAIL("Record already exists")
		END IF
	END FOR
	CALL m_files.appendElement()
	LET this.fileId = m_files.getLength()
	LET m_files[ m_files.getLength() ].* = this.*
	LET m_file.* = this.*
	RETURN TRUE
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this file) getById(l_id INTEGER) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	INITIALIZE this TO NULL
	INITIALIZE m_file TO NULL
	FOR x = 1 TO m_files.getLength()
		IF m_files[x].fileId = l_id THEN 
			LET this.* = m_files[x].*
			LET m_file.* = this.*
			RETURN TRUE
		END IF
	END FOR
	FAIL("Not Found")
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this file) existsID(l_id INTEGER) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	FOR x = 1 TO m_files.getLength()
		IF m_files[x].fileId = l_id THEN RETURN TRUE END IF
	END FOR
	FAIL("Not Found")
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this file) getError() RETURNS STRING
	RETURN m_fail_reason
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this file) getLength() RETURNS INTEGER
	RETURN m_files.getLength()
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this file) display()
	DISPLAY BY NAME this.*
END FUNCTION