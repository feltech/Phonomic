Database = require '../Database'

module.exports = class WordListModel
	constructor: ()->
	create: ()->
	get: ()->
	update: ()->
	remove: ()->
	list: (text)->
#		sql = "SELECT *, levenshtein(LOWER(Roman), LOWER('#{text}')) AS Dist FROM 
#				(SELECT * FROM Words WHERE SOUNDEX(Roman) LIKE CONCAT(SOUNDEX('#{text}'),'%')) AS ReducedList 
#				WHERE levenshtein(LOWER(Roman), LOWER('#{text}')) < CHAR_LENGTH('#{text}')/2+1
#				ORDER BY Dist";
		sql = "SELECT *, levenshtein(LOWER(Roman), LOWER('#{text}')) AS Dist FROM Words
				WHERE levenshtein(LOWER(Roman), LOWER('#{text}')) < CHAR_LENGTH('#{text}')
				ORDER BY Dist LIMIT 100";
		return Database.Instance().query(sql)
			