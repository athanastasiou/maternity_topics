maternitydb.duckdb:
	duckdb maternitydb.duckdb < init_db.sql

InfrasThemeDetails_EXPORTED.csv: maternitydb.duckdb
	duckdb maternitydb.duckdb -s "COPY (SELECT * FROM InfrasThemeDetails) TO 'InfrasThemeDetails_EXPORTED.csv'"

init_db: maternitydb.duckdb

OUT_InfrasThemeDetails_EXPORTED_data.csv: InfrasThemeDetails_EXPORTED.csv
	txttok InfrasThemeDetails_EXPORTED.csv ID Details -m 80 > OUT_InfrasThemeDetails_EXPORTED_data.csv

OUT_InfrasThemeDetails_EXPORTED_data_embeddings.csv: OUT_InfrasThemeDetails_EXPORTED_data.csv
	txtembed OUT_InfrasThemeDetails_EXPORTED_data.csv -c Sentence > OUT_InfrasThemeDetails_EXPORTED_data_embeddings.csv

add_embeddings: OUT_InfrasThemeDetails_EXPORTED_data_embeddings.csv
	duckdb maternitydb.duckdb < import_embeddings.sql

clean:
	rm maternitydb.duckdb

search:
	@duckdb -csv maternitydb.duckdb -s "SELECT Reference, Organisation, Theme, Sentence, array_cosine_similarity(embedding,CAST([$(q)] AS DOUBLE[384])) as u from InfrasThemeDetails join DetailsSentences on InfrasThemeDetails.ID=DetailsSentences.DatID order by u desc"

explore: maternitydb.duckdb
	duckdb maternitydb.duckdb
