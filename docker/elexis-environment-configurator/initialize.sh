#!/bin/sh
set -e

rocketchatsetting()
{
  java -jar RocketchatSetting.jar -u http://rocketchat:3000/chat -l ${ADMIN_USERNAME} -p ${ADMIN_PASS} -v $@
}

echo "===[Rocketchat]=== Organization Settings"
rocketchatsetting API_Enable_Rate_Limiter_Limit_Calls_Default 30
rocketchatsetting Organization_Name ${LDAP_ORGANISATION}
rocketchatsetting Site_Name ${LDAP_ORGANISATION}
rocketchatsetting Organization_Type enterprise
rocketchatsetting Industry healthcarePharmaceutical
rocketchatsetting Server_Type privateTeam
rocketchatsetting Show_Setup_Wizard completed

echo "===[Rocketchat]=== LDAP Settings"
rocketchatsetting LDAP_BaseDN ${LDAP_BASE_DN}
rocketchatsetting LDAP_Host ldap
rocketchatsetting LDAP_User_Search_Field uid
rocketchatsetting LDAP_Authentication_UserDN cn=${LDAP_READONLY_USER_USERNAME},${LDAP_BASE_DN}
rocketchatsetting LDAP_Authentication_Password readonly
rocketchatsetting LDAP_Authentication true
rocketchatsetting LDAP_Sync_User_Data true
rocketchatsetting LDAP_User_Search_Field uid,mail
rocketchatsetting LDAP_Enable true