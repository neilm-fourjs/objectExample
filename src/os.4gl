
-- Manager a simple List of OS objects.

&define FAIL(txt) LET m_fail_reason = txt RETURN FALSE

PUBLIC TYPE os RECORD
		osId INTEGER,
		osType STRING,
		osVersion STRING
	END RECORD
DEFINE m_fail_reason STRING
DEFINE m_os os
DEFINE m_oss DYNAMIC ARRAY OF os
----------------------------------------------------------------------------------------------------
FUNCTION (this os) add( ) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	IF this.osType IS NULL THEN FAIL("osType NULL") END IF
	IF this.osVersion IS NULL THEN FAIL("osVersion NULL") END IF
	IF this.osId != 0 THEN FAIL("id not 0") END IF
	FOR x = 1 TO m_oss.getLength()
		IF m_oss[x].osType = this.osType
		AND m_oss[x].osVersion = this.osVersion THEN
			FAIL("Record already exists")
		END IF
	END FOR
	CALL m_oss.appendElement()
	LET x = m_oss.getLength()
	LET this.osId = x
	LET m_oss[x].* = this.*
	LET m_os.* = this.*
	RETURN TRUE
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this os) selectByID(l_id INTEGER) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	INITIALIZE this TO NULL
	INITIALIZE m_os TO NULL
	FOR x = 1 TO m_oss.getLength()
		IF m_oss[x].osId = l_id THEN 
			LET this.* = m_oss[x].*
			LET m_os.* = this.*
			RETURN TRUE
		END IF
	END FOR
	FAIL("Not Found")
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this os) existsID(l_id INTEGER) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	FOR x = 1 TO m_oss.getLength()
		IF m_oss[x].osId = l_id THEN RETURN TRUE END IF
	END FOR
	FAIL("Not Found")
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this os) find(l_fld STRING, l_txt STRING) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET m_fail_reason = ""
	INITIALIZE this TO NULL
	INITIALIZE m_os TO NULL
	FOR x = 1 TO m_oss.getLength()
		CASE l_fld.toLowerCase()
			WHEN "ostype" 
				IF m_oss[x].osType MATCHES l_txt THEN	LET this.* = m_oss[x].* EXIT FOR	END IF
			WHEN "osversion" 
				IF m_oss[x].osVersion MATCHES l_txt THEN LET this.* = m_oss[x].* EXIT FOR END IF
			OTHERWISE FAIL("Invalid Field")
		END CASE
	END FOR
	IF this.osId IS NOT NULL THEN
		LET m_os.* = this.*
 		RETURN TRUE
	END IF
	FAIL("Not Found")
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this os) getError() RETURNS STRING
	RETURN m_fail_reason
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this os) getLength() RETURNS INTEGER
	RETURN m_oss.getLength()
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this os) display()
	DISPLAY BY NAME this.*
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this os) showWindow()
	OPEN WINDOW w_os WITH FORM "os"
	CALL this.display()
	MENU
		ON ACTION close EXIT MENU
		ON ACTION back EXIT MENU
	END MENU
	CLOSE WINDOW w_os
END FUNCTION
----------------------------------------------------------------------------------------------------
DIALOG updt()
	INPUT BY NAME m_os.* ATTRIBUTES(WITHOUT DEFAULTS)
	END INPUT
END DIALOG