DECLARE @UserName VARCHAR(50) = 'mina noshy wahba abdraba';

DECLARE @UserNameXML XML = CAST('<d>' + REPLACE(@UserName, ' ', '</d><d>') + '</d>' AS XML);

DECLARE @Result VARCHAR(8000) = '';

SELECT @Result = @Result + LEFT(T.split.value('.', 'nvarchar(max)'),1)

FROM @UserNameXML.nodes('/d') T(split)

SET @Result = UPPER(@Result)

SELECT @Result