DELETE T
FROM
(
SELECT *
, duplicate = ROW_NUMBER() OVER (
              PARTITION BY Employee_Id
              ORDER BY (SELECT NULL)
            )
FROM tbChecklistCategory_Master
) AS T
WHERE duplicate > 1 ;