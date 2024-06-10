# setup snapshots
clustername_abbreviatedraw=$(terraform output clustername_abbreviated)
clustername_abbreviated=${clustername_abbreviatedraw//\"/}
bucketname="$clustername_abbreviated-snapshots"
echo "setting up snapshot repo for $bucketname"
curl --insecure -XPUT "https://elastic:$kibana_password@$k2.bc.googleusercontent.com:9200/_snapshot/snapshots" -H "kbn-xsrf: reporting" -H "Content-Type: application/json" -d'
{
  "type": "gcs",
  "settings": {
    "bucket": "'$bucketname'"
  }
}'
