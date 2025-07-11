DO
$$
DECLARE
    rec record;
BEGIN
    FOR rec IN
        SELECT
            n.nspname AS table_schema,
            c.relname AS table_name,
            a.attname AS column_name,
            s.seqrelid::regclass::text AS sequence_name,
            format(
                'SELECT setval(''%I'', COALESCE(MAX(%I), 0) + 1) FROM %I.%I',
                s.seqrelid::regclass,
                a.attname,
                n.nspname,
                c.relname
            ) AS reset_sql,
            format(
                'LOCK TABLE %I.%I IN SHARE',
                n.nspname,
                c.relname
            ) AS lock_sql
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        JOIN pg_attribute a ON a.attrelid = c.oid
        JOIN pg_depend d ON d.refobjid = c.oid AND d.refobjsubid = a.attnum
        JOIN pg_class s ON s.oid = d.objid
        WHERE a.attidentity <> ''
          AND c.relkind = 'r'
    LOOP
        RAISE NOTICE 'Resetting sequence for %.%.%', rec.table_schema, rec.table_name, rec.column_name;
        EXECUTE rec.lock_sql; -- lock table
        EXECUTE rec.reset_sql; -- reset sequence
        COMMIT;
    END LOOP;
END;
$$;
