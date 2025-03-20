InfrasThemeDetails_complete.csv: HRCThemes.csv  InfrasThemeDetails.csv
	tail -n +2 HRCThemes.csv| cat InfrasThemeDetails.csv - > InfrasThemeDetails_complete.csv
	
maternitydb.duckdb: InfrasThemeDetails_complete.csv
	duckdb maternitydb.duckdb < init_db.sql

InfrasThemeDetails_EXPORTED.csv: maternitydb.duckdb
	duckdb maternitydb.duckdb -s "COPY (SELECT * FROM InfrasThemeDetails) TO 'InfrasThemeDetails_EXPORTED.csv'"

init_db: maternitydb.duckdb

OUT_InfrasThemeDetails_EXPORTED_data.csv: InfrasThemeDetails_EXPORTED.csv
	txttok InfrasThemeDetails_EXPORTED.csv ID Details -m 160 > OUT_InfrasThemeDetails_EXPORTED_data.csv

OUT_InfrasThemeDetails_EXPORTED_data_embeddings.csv: OUT_InfrasThemeDetails_EXPORTED_data.csv
	txtembed OUT_InfrasThemeDetails_EXPORTED_data.csv -c Sentence > OUT_InfrasThemeDetails_EXPORTED_data_embeddings.csv

add_embeddings: OUT_InfrasThemeDetails_EXPORTED_data_embeddings.csv
	duckdb maternitydb.duckdb < import_embeddings.sql

clean:
	rm maternitydb.duckdb

search:
	@duckdb -csv maternitydb.duckdb -s "SELECT Reference, Organisation, Theme, Sentence, array_cosine_similarity(embedding,CAST([$(q)] AS DOUBLE[384])) as Score from InfrasThemeDetails join DetailsSentences on InfrasThemeDetails.ID=DetailsSentences.DatID where Score>=$(T) order by Reference ASC,Score DESC;"

AccessAndExperience.csv: add_embeddings
	make search T=0.39 q=`echo "equal access to maternity and neonatal care particularly for black, asian and minoritised ethnic groups and those living in areas of high depravation"|txtembed -` > AccessAndExperience.csv 

SafetyAndQualityInPerinatalAndNeonatalCare.csv: add_embeddings
	make search T=0.39 q=`echo "improving maternity and neonatal safety particularly for black, asian and minoritised ethnic groups and those living in areas of high deprivation"|txtembed -` > SafetyAndQualityInPerinatalAndNeonatalCare.csv

MaternalAndMentalHealth.csv: add_embeddings
	make search T=0.39 q=`echo "early detection, trauma-informed interventions, and culturally responsive support throughout the maternity care pathway particularly for Black, Asian, and minority ethnic women, migrant populations, and those in socioeconomically deprived areas."|txtembed -` > MaternalAndMentalHealth.csv

PreconceptionAndInterconceptionHealth.csv: add_embeddings
	make search T=0.39 q=`echo "optimise maternal and neonatal health before and between pregnancies, ensuring that inequalities in health status at conception do not drive disparities in birth outcomes. "|txtembed -` > PreconceptionAndInterconceptionHealth.csv


MaternalAndNeonatalHealthRisksAndDiscovery.csv: add_embeddings
	make search T=0.39 q=`echo "addressing modifiable maternal and neonatal health risks across pregnancy, birth, and the postnatal period, ensuring that disparities in long-term maternal and infant health outcomes are effectively reduced"|txtembed -` > MaternalAndNeonatalHealthRisksAndDiscovery.csv

subject_specific_search: AccessAndExperience.csv SafetyAndQualityInPerinatalAndNeonatalCare.csv MaternalAndMentalHealth.csv PreconceptionAndInterconceptionHealth.csv MaternalAndNeonatalHealthRisksAndDiscovery.csv


explore: maternitydb.duckdb
	duckdb maternitydb.duckdb

##@duckdb -csv maternitydb.duckdb -s "SELECT Reference, Organisation, Theme, Sentence, array_cosine_similarity(embedding,CAST([$(q)] AS DOUBLE[384])) as Score from InfrasThemeDetails join DetailsSentences on InfrasThemeDetails.ID=DetailsSentences.DatID order by Score desc, Reference"
