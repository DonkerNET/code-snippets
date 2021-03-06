with fs
as
(
    select database_id, type, size * 8.0 / 1024 size
    from sys.master_files
)
select
	*,
	(dt.DataFileSizeMB + dt.LogFileSizeMB) AS TotalSizeMB
from (
	select 
		[name] AS [Name],
		(select sum(size) from fs where type = 0 and fs.database_id = db.database_id) DataFileSizeMB,
		(select sum(size) from fs where type = 1 and fs.database_id = db.database_id) LogFileSizeMB
	from sys.databases db
) dt
order by dt.DataFileSizeMB desc