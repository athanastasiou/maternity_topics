CREATE TABLE DetailsSentences AS (SELECT * FROM 'OUT_InfrasThemeDetails_EXPORTED_data_embeddings.csv' LIMIT 1);
ALTER TABLE DetailsSentences DROP COLUMN embedding;
ALTER TABLE DetailsSentences ADD COLUMN embedding DOUBLE[384];
DELETE FROM DetailsSentences;
COPY DetailsSentences FROM 'OUT_InfrasThemeDetails_EXPORTED_data_embeddings.csv';
