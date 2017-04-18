SELECT 
  [schema] = s.name
, [table] = t.name
, p.partition_id
, p.partition_number
, p.data_compression_desc
, allocation_type = au.type_desc
, [filegroup] = FILEGROUP_NAME(au.data_space_id)
, [Rows] = SUM(ps.row_count)
FROM sys.tables AS t
INNER JOIN sys.schemas AS s
  ON s.schema_id = t.schema_id
INNER JOIN sys.dm_db_partition_stats AS ps
  ON ps.object_id = t.object_id
    AND ps.index_id <= 1
INNER JOIN sys.partitions AS p
  ON p.object_id = ps.object_id
    AND p.partition_id = ps.partition_id
INNER JOIN sys.allocation_units AS au
  ON au.container_id = p.partition_id
    AND au.total_pages > 0
WHERE t.name LIKE '%%'
GROUP BY 
  s.name
, t.name
, p.partition_number
, p.partition_id
, p.data_compression_desc
, au.type_desc
, au.data_space_id
HAVING SUM(ps.row_count) > 0
ORDER BY [schema], [table], p.partition_number;

SELECT 
  pf.name
, pf.function_id
, pf.type_desc
, pf.boundary_value_on_right
, prv.boundary_id
, prv.value
FROM sys.partition_functions AS pf
INNER JOIN sys.partition_range_values AS prv
  ON prv.function_id = pf.function_id
WHERE pf.name = 'pfMonthly'
  AND prv.boundary_id BETWEEN 60 AND 62