echo "setting up api key"
curl --insecure -XPUT "https://elastic:$kibana_password@$k2.bc.googleusercontent.com:9200/_security/api_key" -H "kbn-xsrf: reporting" -H "Content-Type: application/json" -d'
{
  "name": "rally"
}'
