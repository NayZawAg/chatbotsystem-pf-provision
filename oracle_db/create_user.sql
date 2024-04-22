
sqlplus system/Stg-Nemo1234#@stg-acc-omotenashi-db:1521/STGACCOMOTENASHI.a553282.oraclecloud.internal
; 本番は、Nemo1234#

CREATE USER stgomotenashi IDENTIFIED BY B4f4uU294RTHc;
GRANT DBA TO stgomotenashi;
GRANT connect, resource TO stgomotenashi;
GRANT CREATE DATABASE LINK TO stgomotenashi;

CREATE USER stganon IDENTIFIED BY iiZah7buf2at8;
GRANT DBA TO stganon;
GRANT connect, resource TO stganon;
GRANT CREATE DATABASE LINK TO stganon;
GRANT SELECT ANY SEQUENCE TO stganon;

sqlplus system/Stg-Nemo1234#@stg-acc-omotenashi-db:1521/ACCTEST.a553282.oraclecloud.internal

CREATE USER testacc IDENTIFIED BY testacc#;
GRANT DBA TO testacc;
GRANT connect, resource TO testacc;

CREATE USER stganon IDENTIFIED BY stganon#;
GRANT DBA TO stganon;
GRANT connect, resource TO stganon;
GRANT SELECT ANY SEQUENCE TO stganon;

; 解析サーバ
sqlplus system/Stg-Nemo1234#@stg-ana-omotenashi-db:1521/STGANAOMOTENASHI.a553282.oraclecloud.internal
CREATE USER staging IDENTIFIED BY oiJ5cohthail;
GRANT DBA TO staging;
GRANT connect, resource TO staging;

sqlplus system/Stg-Nemo1234#@ana-omotenashi-db:1521/ANAOMOTENASHI.a553282.oraclecloud.internal
CREATE USER prdana IDENTIFIED BY eethoofeoJau7Sie;
GRANT DBA TO prdana;
GRANT connect, resource TO prdana;

