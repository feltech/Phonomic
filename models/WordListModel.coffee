Database = require '../Database'
squel = require 'squel'

module.exports = class WordListModel
	constructor: ()->
	create: ()->
	get: ()->
	update: ()->
	remove: ()->
	list: (field, value)->
		sql = squel.select().from('Words')
			.field('ID')
			.field('Roman')
			.field('Native')
			.field('Phonetic')
			.field('Languages')
			.field("levenshtein(LOWER(Roman), LOWER('#{value}')) AS Dist")
			.where("levenshtein(LOWER(Roman), LOWER('#{value}')) < CHAR_LENGTH('#{value}')")
			.order('Dist')
			.limit(100)
			.toString()
		
			
#		sql = "SELECT *, levenshtein(LOWER(Roman), LOWER('#{text}')) AS Dist FROM 
#				(SELECT * FROM Words WHERE SOUNDEX(Roman) LIKE CONCAT(SOUNDEX('#{text}'),'%')) AS ReducedList 
#				WHERE levenshtein(LOWER(Roman), LOWER('#{text}')) < CHAR_LENGTH('#{text}')/2+1
#				ORDER BY Dist";
#		sql = "SELECT *, levenshtein(LOWER(Roman), LOWER('#{text}')) AS Dist FROM Words
#				WHERE levenshtein(LOWER(Roman), LOWER('#{text}')) < CHAR_LENGTH('#{text}')
#				ORDER BY Dist LIMIT 100"#;
		return Database.Instance().query(sql)
			