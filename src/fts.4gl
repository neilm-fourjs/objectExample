
-- Manage a simple List of File Type objects.
IMPORT util
&define FAIL(txt) LET m_fail_reason = txt RETURN FALSE

PUBLIC TYPE ft RECORD
		ftId INTEGER,
		ftText STRING
	END RECORD
PUBLIC TYPE fts RECORD
	list DYNAMIC ARRAY OF ft,
	count SMALLINT,
	current SMALLINT
END RECORD
DEFINE m_fail_reason STRING
DEFINE m_ft ft
----------------------------------------------------------------------------------------------------
FUNCTION (this fts) add(l_ftText STRING ) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	LET m_ft.ftId = 0
	LET m_ft.ftText = l_ftText

	IF m_ft.ftText IS NULL THEN FAIL("ftText NULL") END IF
	IF m_ft.ftId != 0 THEN FAIL("id not 0") END IF
	FOR x = 1 TO this.count
		IF this.list[x].ftText = m_ft.ftText THEN
			FAIL("Record already exists")
		END IF
	END FOR
	CALL this.list.appendElement()
	LET this.count = this.list.getLength()
	LET m_ft.ftId = this.count
	LET this.current = this.count
	LET this.list[x].* = m_ft.*

	RETURN TRUE
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this fts) selectByID(l_id INTEGER) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	INITIALIZE m_ft TO NULL
	FOR x = 1 TO this.count
		IF this.list[x].ftId = l_id THEN 
			LET this.current = x
			LET m_ft.* = this.list[x].*
			RETURN TRUE
		END IF
	END FOR
	FAIL("Not Found")
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this fts) existsID(l_id INTEGER) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	FOR x = 1 TO this.count
		IF this.list[x].ftId = l_id THEN RETURN TRUE END IF
	END FOR
	FAIL("Not Found")
END FUNCTION
----------------------------------------------------------------------------------------------------
-- Find 1st instance of 
FUNCTION (this fts) find(l_fld STRING, l_txt STRING) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	INITIALIZE m_ft TO NULL
	FOR x = 1 TO this.count
		CASE l_fld.toLowerCase()
			WHEN "ftText" 
				IF this.list[x].ftText MATCHES l_txt THEN	LET m_ft.* = this.list[x].* EXIT FOR	END IF
			OTHERWISE FAIL("Invalid Field")
		END CASE
	END FOR
	IF m_ft.ftId IS NOT NULL THEN
 		RETURN TRUE
	END IF
	FAIL("Not Found")
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this fts) getError() RETURNS STRING
	RETURN m_fail_reason
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this fts) display(x SMALLINT) RETURNS ()
	DISPLAY BY NAME this.list[x].*
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this fts) update() RETURNS ()
	LET this.list[ this.current ].* = m_ft.*
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this fts) saveToDisk(l_fileName STRING) RETURNS ()
	DEFINE l_file TEXT
	LOCATE l_file IN FILE l_fileName
	LET l_file = util.JSONObject.fromFGL( this ).toString()
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this fts) loadFromDisk(l_fileName STRING) RETURNS ()
	DEFINE l_file TEXT
	LOCATE l_file IN FILE l_fileName
	CALL util.JSON.parse( l_file, this )
END FUNCTION
----------------------------------------------------------------------------------------------------
DIALOG ft_input()
	INPUT BY NAME m_ft.* ATTRIBUTES(WITHOUT DEFAULTS)
	END INPUT
END DIALOG