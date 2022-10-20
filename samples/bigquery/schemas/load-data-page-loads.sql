LOAD DATA INTO `%PROJECT%.%DATASET%.%PREFIX%-page-loads`
FROM FILES (
  format = 'CSV',
  field_delimiter = '\t',
  skip_leading_rows = 1,
  uris = ['gs://%BUCKET%/%FILE%.tsv'])
;
