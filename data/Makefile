# Layout the queries because there is code re-use and we don't want to be debugging for ever.
_detail_query = SELECT Reference, Organisation, Theme, Sentence, array_cosine_similarity(embedding,CAST([$(q)] AS DOUBLE[384])) as Score from InfrasThemeDetails join DetailsSentences on InfrasThemeDetails.ID=DetailsSentences.DatID where Score>=$(T) order by Reference ASC,Score DESC

_summary_query = SELECT Details.Reference as Reference, any_value(Round), count(Details.Reference) as Relevant_Sentences, any_value(Details.Organisation) as Organisation, list_distinct(array_agg(Details.Theme)) as Themes, mean(score) AS Score FROM ($(_detail_query)) as Details JOIN InfrasThemeDetails on Details.Reference = InfrasThemeDetails.Reference group by Details.Reference order by Score desc,  Relevant_Sentences desc

# Default value for T. Notice no default value for q, because we want it to fail if the user does not provide a query.
T = 0.39

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

explore: maternitydb.duckdb
	duckdb maternitydb.duckdb

clean:
	rm maternitydb.duckdb
	rm OUT*.csv
	rm InfrasThemeDetails_EXPORTED.csv

search_detail:
	@duckdb -csv maternitydb.duckdb -s "$(_detail_query)"

search_summary:
	@duckdb -csv maternitydb.duckdb -s "$(_summary_query)"

# Summary results
AccessAndExperience_Summary.csv: add_embeddings 
	make search_summary T=0.39 q=`echo "equal access to maternity and neonatal care particularly for black, asian and minoritised ethnic groups and those living in areas of high depravation"|txtembed -` > AccessAndExperience_Summary.csv 

SafetyAndQualityInPerinatalAndNeonatalCare_Summary.csv: add_embeddings
	make search_summary T=0.39 q=`echo "improving maternity and neonatal safety particularly for black, asian and minoritised ethnic groups and those living in areas of high deprivation"|txtembed -` > SafetyAndQualityInPerinatalAndNeonatalCare_Summary.csv

MaternalAndMentalHealth_Summary.csv: add_embeddings
	make search_summary T=0.39 q=`echo "early detection, trauma-informed interventions, and culturally responsive support throughout the maternity care pathway particularly for Black, Asian, and minority ethnic women, migrant populations, and those in socioeconomically deprived areas."|txtembed -` > MaternalAndMentalHealth_Summary.csv

PreconceptionAndInterconceptionHealth_Summary.csv: add_embeddings
	make search_summary T=0.39 q=`echo "optimise maternal and neonatal health before and between pregnancies, ensuring that inequalities in health status at conception do not drive disparities in birth outcomes. "|txtembed -` > PreconceptionAndInterconceptionHealth_Summary.csv


MaternalAndNeonatalHealthRisksAndDiscovery_Summary.csv: add_embeddings
	make search_summary T=0.39 q=`echo "addressing modifiable maternal and neonatal health risks across pregnancy, birth, and the postnatal period, ensuring that disparities in long-term maternal and infant health outcomes are effectively reduced"|txtembed -` > MaternalAndNeonatalHealthRisksAndDiscovery_Summary.csv

# Detail searches
AccessAndExperience.csv: add_embeddings
	make search_detail T=0.39 q=`echo "equal access to maternity and neonatal care particularly for black, asian and minoritised ethnic groups and those living in areas of high depravation"|txtembed -` > AccessAndExperience.csv 

SafetyAndQualityInPerinatalAndNeonatalCare.csv: add_embeddings
	make search_detail T=0.39 q=`echo "improving maternity and neonatal safety particularly for black, asian and minoritised ethnic groups and those living in areas of high deprivation"|txtembed -` > SafetyAndQualityInPerinatalAndNeonatalCare.csv

MaternalAndMentalHealth.csv: add_embeddings
	make search_detail T=0.39 q=`echo "early detection, trauma-informed interventions, and culturally responsive support throughout the maternity care pathway particularly for Black, Asian, and minority ethnic women, migrant populations, and those in socioeconomically deprived areas."|txtembed -` > MaternalAndMentalHealth.csv

PreconceptionAndInterconceptionHealth.csv: add_embeddings
	make search_detail T=0.39 q=`echo "optimise maternal and neonatal health before and between pregnancies, ensuring that inequalities in health status at conception do not drive disparities in birth outcomes. "|txtembed -` > PreconceptionAndInterconceptionHealth.csv


MaternalAndNeonatalHealthRisksAndDiscovery.csv: add_embeddings
	make search_detail T=0.39 q=`echo "addressing modifiable maternal and neonatal health risks across pregnancy, birth, and the postnatal period, ensuring that disparities in long-term maternal and infant health outcomes are effectively reduced"|txtembed -` > MaternalAndNeonatalHealthRisksAndDiscovery.csv

subject_specific_search: AccessAndExperience.csv SafetyAndQualityInPerinatalAndNeonatalCare.csv MaternalAndMentalHealth.csv PreconceptionAndInterconceptionHealth.csv MaternalAndNeonatalHealthRisksAndDiscovery.csv AccessAndExperience_Summary.csv SafetyAndQualityInPerinatalAndNeonatalCare_Summary.csv MaternalAndMentalHealth_Summary.csv PreconceptionAndInterconceptionHealth_Summary.csv MaternalAndNeonatalHealthRisksAndDiscovery_Summary.csv

extract_pes:
	python extract_PES.py

convert_pes:
	./convertPES.sh

pes:extract_pes convert_pes

