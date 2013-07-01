Database = require '../Database'
squel = require 'squel'

module.exports = class WordDAO
	constructor: ()->
	create: (data)->
		sql = squel.insert().into('Words')
			.set('Roman', data.Roman || "")
			.set('Native', data.Native)
			.set('Phonetic', data.Phonetic || "")
			.set('Languages', data.Languages || "")
			.toString()
		return Database.Instance().query(sql).then (result)-> 
			sql = squel.select().from('Words')
				.field('ID')
				.field('Roman')
				.field('Native')
				.field('Phonetic')
				.field('Languages')
				.where("ID = #{result.insertId}")
				.limit(1)
				.toString()
			return Database.Instance().query(sql)
		.then (result)->
				console.log "WordDAO.create. #{JSON.stringify(result)}"
				return result?[0]
	
	get: ()->
	update: (data)->
		sql = squel.update().table('Words')
			.set('Roman', data.Roman || "")
			.set('Native', data.Native)
			.set('Phonetic', data.Phonetic || "")
			.set('Languages', data.Languages || "")
			.where("ID = #{data.ID}")
			.toString()
		return Database.Instance().query(sql).then -> 
			sql = squel.select().from('Words')
				.field('ID')
				.field('Roman')
				.field('Native')
				.field('Phonetic')
				.field('Languages')
				.where("ID = #{data.ID}")
				.limit(1)
				.toString()
			return Database.Instance().query sql
		.then (result)->
			console.log "WordDAO.update. #{JSON.stringify(result)}"
			return result?[0]
		
		
		
	remove: ()->
	list: (field, value)->
		value = unescape(value)
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
				sql.field("levenshtein_utf(Phonetic, '#{value}') AS Dist")
					.where("levenshtein_utf(Phonetic, '#{value}') < #{value?.length}")
			else
				sql.field("levenshtein(LOWER(Roman), LOWER('#{value}')) AS Dist")
					.where("levenshtein(LOWER(Roman), LOWER('#{value}')) < CHAR_LENGTH('#{value}')")
						
		sql = sql.order('Dist').limit(100).toString()
		
			
#		sql = "SELECT *, levenshtein(LOWER(Roman), LOWER('#{text}')) AS Dist FROM 
#				(SELECT * FROM Words WHERE SOUNDEX(Roman) LIKE CONCAT(SOUNDEX('#{text}'),'%')) AS ReducedList 
#				WHERE levenshtein(LOWER(Roman), LOWER('#{text}')) < CHAR_LENGTH('#{text}')/2+1
#				ORDER BY Dist";

		return Database.Instance().query(sql)
			