
-- Manager a simple List of OSs

&define FAIL(txt) LET fail_reason = txt RETURN FALSE

PUBLIC TYPE os RECORD
		osId INTEGER,
		osType STRING,
		osVersion STRING
	END RECORD
PUBLIC DEFINE m_os os
DEFINE fail_reason STRING
DEFINE oos DYNAMIC ARRAY OF os
----------------------------------------------------------------------------------------------------
FUNCTION (this os) add( ) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET fail_reason = ""
	IF this.osType IS NULL THEN FAIL("osType NULL") END IF
	IF this.osVersion IS NULL THEN FAIL("osVersion NULL") END IF
	IF this.osId != 0 THEN FAIL("id not 0") END IF
	FOR x = 1 TO oos.getLength()
		IF oos[x].osType = this.osType
		AND oos[x].osVersion = this.osVersion THEN
			FAIL("Record already exists")
		END IF
	END FOR
	CALL oos.appendElement()
	LET this.osId = oos.getLength()
	LET oos[ oos.getLength() ].* = this.*
	RETURN TRUE
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this os) getById(l_id INTEGER) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET fail_reason = ""
	INITIALIZE this TO NULL
	INITIALIZE m_os TO NULL
	FOR x = 1 TO oos.getLength()
		IF oos[x].osId = l_id THEN 
			LET this.* = oos[x].*
			LET m_os.* = this.*
			RETURN TRUE
		END IF
	END FOR
	LET fail_reason = "Not Found"
	RETURN FALSE
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this os) existsID(l_id INTEGER) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET fail_reason = ""
	FOR x = 1 TO oos.getLength()
		IF oos[x].osId = l_id THEN RETURN TRUE END IF
	END FOR
	LET fail_reason = "Not Found"
	RETURN FALSE
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this os) find(l_fld STRING, l_txt STRING) RETURNS BOOLEAN
	DEFINE x SMALLINT
	LET fail_reason = ""
	INITIALIZE this TO NULL
	INITIALIZE m_os TO NULL
	FOR x = 1 TO oos.getLength()
		CASE l_fld.toLowerCase()
			WHEN "ostype" 
				IF oos[x].osType MATCHES l_txt THEN	LET this.* = oos[x].* EXIT FOR	END IF
			WHEN "osversion" 
				IF oos[x].osVersion MATCHES l_txt THEN LET this.* = oos[x].* EXIT FOR END IF
			OTHERWISE FAIL("Invalid Field")
		END CASE
	END FOR
	IF this.osId IS NOT NULL THEN
		LET m_os.* = this.*
 		RETURN TRUE
	END IF
	LET fail_reason = "Not Found"
	RETURN FALSE
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this os) getError() RETURNS STRING
	RETURN fail_reason
END FUNCTION
----------------------------------------------------------------------------------------------------
FUNCTION (this os) getLength() RETURNS INTEGER
	RETURN oos.getLength()
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