/** 
  The purpose of this code is to list a set of PostgreSQL's objects as:
  'ORDINARY TABLE' => pg_class.relkind='r',
  'VIEW' => pg_class.relkind='v',
  'MATERIALIZED VIEW' => pg_class.relkind='m',
  'INDEX' => pg_class.relkind='i',
  'SEQUENCE' => pg_class.relkind='S',
  'COMPOSITE TYPE' => pg_class.relkind='c',
  'TOAST TABLE' => pg_class.relkind='t',
  'FOREIGN TABLE' => pg_class.relkind='f',
  'FUNCTION' => pg_proc
  
  REFERENCES:
  pg_catalog.pg_class         => https://www.postgresql.org/docs/9.3/catalog-pg-class.html
  pg_catalog.pg_namespace     => https://www.postgresql.org/docs/9.3/catalog-pg-namespace.html
  pg_catalog.pg_proc          => https://www.postgresql.org/docs/current/catalog-pg-proc.html
**/

SELECT
	pn.nspname, pc.relname, 
  CASE 
    WHEN pc.relkind='r' THEN 'ORDINARY TABLE' 
    WHEN pc.relkind='v' THEN 'VIEW' 
    WHEN pc.relkind='m' THEN 'MATERIALIZED VIEW' 
    WHEN pc.relkind='i' THEN 'INDEX'
    WHEN pc.relkind='S' THEN 'SEQUENCE'
    WHEN pc.relkind='c' THEN 'COMPOSITE TYPE'
    WHEN pc.relkind='t' THEN 'TOAST TABLE'
    WHEN pc.relkind='f' THEN 'FOREIGN TABLE'
    ELSE 'DESCONHECIDO' 
  END::varchar AS object_type
FROM
	pg_catalog.pg_class pc
	JOIN pg_catalog.pg_namespace pn ON pn.oid=pc.relnamespace
WHERE
	pn.nspname NOT IN('pg_catalog', 'information_schema') AND pc.relkind IN('r', 'v', 'm')
UNION
SELECT 
	pn.nspname, pp.proname, 'FUNCTION'::varchar AS object_type
FROM 
	pg_proc pp
	JOIN pg_namespace pn ON pn.oid=pp.pronamespace
WHERE
	pn.nspname NOT IN('pg_catalog', 'information_schema');
