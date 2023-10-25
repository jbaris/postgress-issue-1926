set schema 'public';

CREATE TABLE "TEMP"(
    "ID" VARCHAR(100),
	"PARAM" TEXT);

CREATE OR REPLACE PROCEDURE TEST_REFCURSOR(INOUT my_cursor REFCURSOR = 'rs_resultone')
LANGUAGE plpgsql
AS $$
BEGIN
OPEN my_cursor FOR Select * from "TEMP";
END;
$$;