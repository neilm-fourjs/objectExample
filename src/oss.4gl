
-- Manage a simple List of OS objects.
IMPORT util
&define FAIL(txt) LET m_fail_reason = txt RETURN FALSE

PUBLIC TYPE os RECORD
		osId INTEGER,
		osType STRING,
		osBits STRING,
		osLibVer STRING
	END RECORD
PUBLIC TYPE oss RECORD
	list DYNAMIC ARRAY OF os,
	count SMALLINT,
	current SMALLINT
END RECORD
DEFINE m_fail_reason STRING
DEFINE m_os os
----------------------------------------------------------------------------------------------------
FUNCTION (this oss) add(l_osType STRING, l_osBits STRING, l_osLibVer STRING ) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	LET m_os.osId = 0
	LET m_os.osType = l_osType
	LET m_os.osBits = l_osBits
	LET m_os.osLibVer = l_osLibVer

	IF m_os.osType IS NULL THEN FAIL("osType NULL") END IF
	IF m_os.osBits IS NULL THEN FAIL("osBits NULL") END IF
	IF m_os.osId != 0 THEN FAIL("id not 0") END IF
	FOR x = 1 TO this.count
		IF this.list[x].osType = m_os.osType
		AND this.list[x].osBits = m_os.osBits
		AND this.list[x].osLibVer = m_os.osLibVer THEN
			FAIL("Record already exists")
		END IF
	END FOR
	CALL this.list.appendElement()
	LET this.count = this.list.getLength()
	LET m_os.osId = this.count
	LET this.current = this.count
	LET this.list[x].* = m_os.*

	RETURN TRUE
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this oss) selectByID(l_id INTEGER) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	INITIALIZE m_os TO NULL
	FOR x = 1 TO this.count
		IF this.list[x].osId = l_id THEN 
			LET this.current = x
			LET m_os.* = this.list[x].*
			RETURN TRUE
		END IF
	END FOR
	FAIL("Not Found")
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this oss) existsID(l_id INTEGER) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	FOR x = 1 TO this.count
		IF this.list[x].osId = l_id THEN RETURN TRUE END IF
	END FOR
	FAIL("Not Found")
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this oss) getTypeText(x SMALLINT) RETURNS STRING
	RETURN SFMT("%1 %2 %3", this.list[x].osType, this.list[x].osBits, this.list[x].osLibVer)
END FUNCTION
----------------------------------------------------------------------------------------------------
-- Find 1st instance of 
FUNCTION (this oss) find(l_fld STRING, l_txt STRING) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	INITIALIZE m_os TO NULL
	FOR x = 1 TO this.count
		CASE l_fld.toLowerCase()
			WHEN "ostype" 
				IF this.list[x].osType MATCHES l_txt THEN	LET m_os.* = this.list[x].* EXIT FOR	END IF
			WHEN "osversion" 
				IF this.list[x].osBits MATCHES l_txt THEN LET m_os.* = this.list[x].* EXIT FOR END IF
			OTHERWISE FAIL("Invalid Field")
		END CASE
	END FOR
	IF m_os.osId IS NOT NULL THEN
 		RETURN TRUE
	END IF
	FAIL("Not Found")
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this oss) getError() RETURNS STRING
	RETURN m_fail_reason
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this oss) display(x SMALLINT) RETURNS ()
	DISPLAY BY NAME this.list[x].*
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this oss) showWindow() RETURNS ()
	OPEN WINDOW w_os WITH FORM "os"
	CALL this.display(this.current)
	MENU
		ON ACTION close EXIT MENU
		ON ACTION back EXIT MENU
	END MENU
	CLOSE WINDOW w_os
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this oss) update() RETURNS ()
	LET this.list[ this.current ].* = m_os.*
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this oss) saveToDisk(l_fileName STRING) RETURNS ()
	DEFINE l_file TEXT
	LOCATE l_file IN FILE l_fileName
	LET l_file = util.JSONObject.fromFGL( this ).toString()
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this oss) loadFromDisk(l_fileName STRING) RETURNS ()
	DEFINE l_file TEXT
	LOCATE l_file IN FILE l_fileName
	CALL util.JSON.parse( l_file, this )
END FUNCTION
----------------------------------------------------------------------------------------------------
DIALOG os_input()
	INPUT BY NAME m_os.* ATTRIBUTES(WITHOUT DEFAULTS)
	END INPUT
END DIALOG