## acc
```
$ sqlplus / as sysdba

SQL> GRANT CREATE SESSION, SET CONTAINER TO c##stgomotenashi IDENTIFIED BY B4f4uU294RTHc CONTAINER = ALL;

SQL> BEGIN
DVSYS.CONFIGURE_DV (
dvowner_uname => 'c##stgomotenashi',
dvacctmgr_uname	=> 'c##stgomotenashi');
END;
/

SQL> @?/rdbms/admin/utlrp.sql

SQL>  select object_name, object_type , status from dba_objects where status <> 'VALID' order by 1,2;

SQL> conn c##stgomotenashi
SQL> EXECUTE DBMS_MACADM.ENABLE_DV;

SQL> conn / as sysdba
SQL> shutdown immediate
SQL> startup

$ sqlplus / as sysdba
SQL> SELECT PARAMETER, VALUE FROM V$OPTION WHERE PARAMETER in ('Oracle Database Vault', 'Oracle Label Security');

SQL> conn c##stgomotenashi@STGACCOMOTENASHI
SQL> EXECUTE DBMS_MACADM.ENABLE_DV;

SQL> conn / as sysdba
SQL> alter pluggable database STGACCOMOTENASHI close immediate;
SQL> alter pluggable database STGACCOMOTENASHI OPEN;

$ sqlplus / as sysdba
SQL> ALTER SESSION SET CONTAINER=STGACCOMOTENASHI;
SQL> SELECT PARAMETER, VALUE FROM V$OPTION WHERE PARAMETER in ('Oracle Database Vault', 'Oracle Label Security');

```

```
 sqlplus stgomotenashi/B4f4uU294RTHc@stg-acc-omotenashi-db:1521/STGACCOMOTENASHI.a553282.oraclecloud.internal @view.sql
 ```

### staging
```
itamae ssh -h stg-acc-omotenashi-db roles/acc.rb
```

### production
```
itamae ssh -h acc-omotenashi-db roles/acc.rb
```
