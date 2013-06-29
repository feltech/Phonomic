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
		
		switch field
			when 'Roman'
				sql.field("levenshtein(LOWER(Roman), LOWER('#{value}')) AS Dist")
					.where("levenshtein(LOWER(Roman), LOWER('#{value}')) < CHAR_LENGTH('#{value}')")
			when 'Native'
				sql.field("levenshtein(LOWER(Native), LOWER('#{value}')) AS Dist")
					.where("levenshtein(LOWER(Native), LOWER('#{value}')) < CHAR_LENGTH('#{value}')")
			when 'Phonetic'
				sql.field("levenshtein(LOWER(Phonetic), LOWER('#{value}')) AS Dist")
					.where("levenshtein(LOWER(Phonetic), LOWER('#{value}')) < CHAR_LENGTH('#{value}')")
			else
				sql.field("levenshtein(LOWER(Roman), LOWER('#{value}')) AS Dist")
					.where("levenshtein(LOWER(Roman), LOWER('#{value}')) < CHAR_LENGTH('#{value}')")
						
		sql = sql.order('Dist').limit(100).toString()
		
			
#		sql = "SELECT *, levenshtein(LOWER(Roman), LOWER('#{text}')) AS Dist FROM 
#				(SELECT * FROM Words WHERE SOUNDEX(Roman) LIKE CONCAT(SOUNDEX('#{text}'),'%')) AS ReducedList 
#				WHERE levenshtein(LOWER(Roman), LOWER('#{text}')) < CHAR_LENGTH('#{text}')/2+1
#				ORDER BY Dist";

		return Database.Instance().query(sql)
			