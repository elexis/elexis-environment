#!/bin/bash
source keycloak_functions.sh
#
# Assert Browser Conditional Otp flow exists and is set as default
#
T="$S (browser dynamic otp flow)"
BROWSER_COND_OTP_FLOW_ID=$($KCADM get authentication/flows -r ElexisEnvironment --format csv --fields id,alias,description --noquotes | grep ,EE\ browser | cut -d "," -f1)
if [ ! -z $BROWSER_COND_OTP_FLOW_ID ]; then
    echo "$T remove existing ... "
    $KCADM update realms/ElexisEnvironment -s browserFlow='browser' # otherwise removal fails
    $KCADM delete authentication/flows/$BROWSER_COND_OTP_FLOW_ID -r ElexisEnvironment
fi

echo "$T create flow ... "
BROWSER_COND_OTP_FLOW_ID=$($KCADM create authentication/flows -r ElexisEnvironment -s alias='EE browser dynamic otp' -s providerId=basic-flow -s description='browser based authentication with conditional otp' -s topLevel=true -i)
EXECUTION_ID=$($KCADM create authentication/flows/EE%20browser%20dynamic%20otp/executions/execution -r ElexisEnvironment -s provider=auth-cookie -i)
$KCADM update authentication/flows/EE%20browser%20dynamic%20otp/executions -r ElexisEnvironment -s id=$EXECUTION_ID -f keycloak/browser_cond_otp_flow_cookie.json
echo "$T create [EE Browser Dynamic Otp Forms] sub flow ..."
SUB_FLOW_ID=$($KCADM create authentication/flows/EE%20browser%20dynamic%20otp/executions/flow -r ElexisEnvironment -s alias='EE Browser Dynamic Otp Forms' -s type='basic-flow' -i)
EXECUTION_ID=$($KCADM get authentication/flows/EE%20browser%20dynamic%20otp/executions -r ElexisEnvironment --format csv --noquotes | grep $SUB_FLOW_ID | cut -d "," -f1)
$KCADM update authentication/flows/EE%20browser%20dynamic%20otp/executions -r ElexisEnvironment -s id=$EXECUTION_ID -s flowId=$SUB_FLOW_ID -f keycloak/browser_cond_otp_flow_subflow.json
EXECUTION_ID=$($KCADM create authentication/flows/EE%20Browser%20Dynamic%20Otp%20Forms/executions/execution -r ElexisEnvironment -s provider=auth-username-password-form -i)
$KCADM update authentication/flows/EE%20browser%20dynamic%20otp/executions -r ElexisEnvironment -s id=$EXECUTION_ID -f keycloak/browser_cond_otp_flow_subflow_userpass.json
EXECUTION_ID=$($KCADM create authentication/flows/EE%20Browser%20Dynamic%20Otp%20Forms/executions/execution -r ElexisEnvironment -s provider=auth-conditional-otp-form -i)
$KCADM update authentication/flows/EE%20browser%20dynamic%20otp/executions -r ElexisEnvironment -s id=$EXECUTION_ID -f keycloak/browser_cond_otp_flow_subflow_condotp.json
$KCADM create authentication/executions/$EXECUTION_ID/config -r ElexisEnvironment -f keycloak/browser_cond_otp_flow_subflow_condotp_config.json
echo "$T create custom step for browser version check ..."
EXECUTION_ID=$($KCADM create authentication/flows/EE%20Browser%20Dynamic%20Otp%20Forms/executions/execution -r ElexisEnvironment -s provider=conditional-browser-outdated -i)
$KCADM update authentication/flows/EE%20browser%20dynamic%20otp/executions -r ElexisEnvironment -s id=$EXECUTION_ID -f keycloak/browser_cond_otp_flow_version_checker.json
echo "$T setting as default browser flow ..."
$KCADM update realms/ElexisEnvironment -s browserFlow='EE browser dynamic otp'