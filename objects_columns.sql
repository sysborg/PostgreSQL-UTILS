/**
  The purpose of this code is to list columns of as set of PostgreSQL's objects as:
  
  'ORDINARY TABLE' => pg_class.relkind='r',
  'VIEW' => pg_class.relkind='v',
  'MATERIALIZED VIEW' => pg_class.relkind='m',
  'INDEX' => pg_class.relkind='i',
  'SEQUENCE' => pg_class.relkind='S',
  'COMPOSITE TYPE' => pg_class.relkind='c',
  'TOAST TABLE' => pg_class.relkind='t',
  'FOREIGN TABLE' => pg_class.relkind='f'
  
  REFERENCES:
  pg_catalog.pg_class         => https://www.postgresql.org/docs/9.3/catalog-pg-class.html
  pg_catalog.pg_namespace     => https://www.postgresql.org/docs/9.3/catalog-pg-namespace.html
  pg_catalog.pg_attribute     => https://www.postgresql.org/docs/current/catalog-pg-attribute.html
  pg_catalog.pg_type          => https://www.postgresql.org/docs/14/catalog-pg-type.html
  
  For this version precision of columns are only available for view and table. I will continuos to improve this QUERY and knowledge to all kind of precision in any of the objects
  can be reached.
  **/
  
SELECT
	pn.nspname, pc.relname, att.attname, att.attcollation, att.atttypmod, att.attnotnull, att.atthasdef, pgt.typname, pgt.typcategory, isc.udt_name,
	isc.character_maximum_length, isc.character_octet_length, isc.numeric_precision, isc.numeric_precision_radix, isc.numeric_scale,
	isc.datetime_precision, isc.interval_precision
FROM
	pg_class pc
	JOIN pg_namespace pn ON pn.oid=pc.relnamespace
	JOIN pg_attribute att ON att.attrelid=pc.oid
	JOIN pg_type pgt ON pgt.oid=att.atttypid
	LEFT JOIN information_schema.columns isc ON isc.table_schema=pn.nspname AND isc.table_name=pc.relname AND isc.column_name=att.attname
WHERE
	att.attnum>0 AND NOT att.attisdropped AND pn.nspname NOT IN('pg_catalog', 'information_schema') AND
	pn.nspname='schema_name' AND pc.relname='object_name'
