CREATE TABLE InfrasThemeDetails AS (SELECT * FROM 'InfrasThemeDetails_complete.csv');
CREATE SEQUENCE seq_infrathemesdetails START 1;
ALTER TABLE InfrasThemeDetails ADD COLUMN ID INTEGER DEFAULT nextval('seq_infrathemesdetails');
COPY (SELECT * FROM InfrasThemeDetails) TO 'InfrasThemeDetails_EXPORTED.csv'
