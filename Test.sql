--List Trigger status in Sybase ASE 15.7
SELECT
    trig.name AS trigger_name,
    OBJECT_NAME(trig.parent_obj) AS table_name,
    trig.crdate AS creation_date,
    CASE
        WHEN (trig.sysstat & 2048) = 2048 THEN 'Disabled'
        ELSE 'Enabled'
    END AS trigger_state
FROM
    sysobjects trig
WHERE
    trig.type = 'TR'
ORDER BY
    table_name,
    trigger_name;
