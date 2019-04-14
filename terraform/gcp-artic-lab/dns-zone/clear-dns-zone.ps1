set-content -Encoding UTF8 -Value "" records.yml
gcloud dns record-sets import -z $args[0] --delete-all-existing records.yml
rm records.yml