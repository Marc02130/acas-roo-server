declare
v_sql LONG;
begin

v_sql:='CREATE TABLE "STRUCTURE"
(
  "ID" NUMBER(19,0) NOT NULL ENABLE,
  "CODE_NAME" VARCHAR2(255 CHAR) NOT NULL ENABLE,
  "MOL_STRUCTURE" CLOB NOT NULL ENABLE,
  "SMILES" VARCHAR2(1000 CHAR) NOT NULL ENABLE,
  "IGNORED" NUMBER(1,0) NOT NULL ENABLE,
  "RECORDED_BY" VARCHAR2(255 CHAR) NOT NULL ENABLE,
  "RECORDED_DATE" TIMESTAMP (6) NOT NULL ENABLE,
  "MODIFIED_BY" VARCHAR2(255 CHAR),
  "MODIFIED_DATE" TIMESTAMP (6),
  "LS_TRANSACTION" NUMBER(19,0),
  "VERSION" NUMBER(10,0),
 PRIMARY KEY ("ID"),
 UNIQUE ("CODE_NAME")
)';
execute immediate v_sql;

v_sql:='CREATE SEQUENCE  "STRUCTURE_PKSEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE'
execute immediate v_sql;

v_sql:='CREATE INDEX "STRUCTURE_MOL_STRUCTURE_IDX" ON "STRUCTURE" ("MOL_STRUCTURE")';
execute immediate v_sql;

v_sql:='CREATE INDEX "STRUCTURE_SMILES_IDX" ON "STRUCTURE" ("SMILES")'
execute immediate v_sql;


EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
        NULL; -- suppresses ORA-00955 exception
      ELSE
         RAISE;
      END IF;
END; 
/