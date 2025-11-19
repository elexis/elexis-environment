#!/bin/bash
#
# Configure Solr for Elexis
# https://lucidworks.com/post/securing-solr-tips-tricks-and-other-things-you-really-need-to-know/
#
SOLR_BASEURL="http://solr:8983"

T="[SOLR] "
echo "$T $(date)"

STATUS=0
while [ $STATUS -ne 200 ]; do
    echo -n "$T Waiting for solr ..."
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" --user SolrAdmin:${ADMIN_PASSWORD} $SOLR_BASEURL/solr/el-encounters/admin/ping || true)
    sleep 2
    echo " http status is [$STATUS]"
done

# Configure ELEXIS-SERVER User 
# https://solr.apache.org/guide/8_11/basic-authentication-plugin.html#add-a-user-or-edit-a-password
echo "$T Assert ELEXIS-SERVER user ..." 
curl -s --user SolrAdmin:${ADMIN_PASSWORD} $SOLR_BASEURL/solr/admin/authentication -H 'Content-type:application/json' -d '{"set-user": { "basic": {"ELEXIS-SERVER":"'$X_EE_SOLR_ELEXIS_SERVER_PASSWORD'"}}}'

# https://solr.apache.org/guide/8_11/rule-based-authorization-plugin.html#manage-permissions
echo "$T Assert ELEXIS-SERVER has indexer role ..." 
curl -s --user SolrAdmin:${ADMIN_PASSWORD} $SOLR_BASEURL/solr/admin/authorization -H 'Content-type:application/json' -d '{"set-user-role": {"basic": {"ELEXIS-SERVER": ["indexer", "user"] }}}'
