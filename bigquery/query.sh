# make service account
# export PROJECT_ID=$(gcloud info --format='value(config.project)')

# gcloud iam service-accounts create bigquery-qwiklab --display-name "bigquery service account"

# gcloud projects add-iam-policy-binding $PROJECT_ID \
#    --member serviceAccount:bigquery-qwiklab@$PROJECT_ID.iam.gserviceaccount.com --role roles/bigquery.dataViewer --role roles/bigquery.user

# make instance
# serviceaccount : bigquery-qwiklab

# make query.py

echo "
from google.auth import compute_engine
from google.cloud import bigquery

credentials = compute_engine.Credentials(
    service_account_email='YOUR_SERVICE_ACCOUNT')

query = '''
SELECT
  year,
  COUNT(1) as num_babies
FROM
  publicdata.samples.natality
WHERE
  year > 2000
GROUP BY
  year
'''

client = bigquery.Client(
    project='YOUR_PROJECT_ID',
    credentials=credentials)
print(client.query(query).to_dataframe())
" > query.py


# customize
sed -i -e "s/YOUR_PROJECT_ID/$(gcloud config get-value project)/g" query.py
sed -i -e "s/YOUR_SERVICE_ACCOUNT/bigquery-qwiklab@$(gcloud config get-value project).iam.gserviceaccount.com/g" query.py
