<?php
/**
 * Since that value is hardcoded in that config file and in Nextcloud additional config files always take priority over config.php.
 * https://github.com/nextcloud/docker/issues/2329#issuecomment-2437640247
 * https://github.com/nextcloud/user_oidc
 */
$CONFIG = array (
    'user_oidc' => [
        'login_validation_azp_check' => false,
        'selfencoded_bearer_validation_azp_check' => false,
    ]
);