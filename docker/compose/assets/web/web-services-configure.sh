#!/bin/sh
envsubst </template/eenv.properties.json.template >/usr/share/nginx/html/eenv.properties.json
envsubst </template/elexisweb-env-config.json.template >/usr/share/nginx/html/env-config.json
echo "" >/etc/nginx/modules.conf
echo "" >/etc/nginx/wg_modules.conf
echo "" >/etc/nginx/ext_modules.conf

if [ $ENABLE_ELEXIS_SERVER == "true" ]; then
    echo 'include conf/elexis-server.conf;' >>/etc/nginx/modules.conf
    case $WG_ACCESS_ELEXIS_SERVER in *wg*) echo 'include conf/elexis-server-ext.conf;' >>/etc/nginx/wg_modules.conf ;; esac
    case $WG_ACCESS_ELEXIS_SERVER in *pub*) echo 'include conf/elexis-server-ext.conf;' >>/etc/nginx/ext_modules.conf ;; esac
fi

if [ $ENABLE_MYELEXIS_SERVER == "true" ]; then
    echo 'include conf/myelexis-server.conf;' >>/etc/nginx/modules.conf
fi

if [ $ENABLE_BOOKSTACK == "true" ]; then
    echo 'include conf/bookstack.conf;' >>/etc/nginx/modules.conf
    case $WG_ACCESS_BOOKSTACK in *wg*) echo 'include conf/bookstack.conf;' >>/etc/nginx/wg_modules.conf ;; esac
    case $WG_ACCESS_BOOKSTACK in *pub*) echo 'include conf/bookstack.conf;' >>/etc/nginx/ext_modules.conf ;; esac
fi

if [ $ENABLE_MATRIX == "true" ]; then
    # $ENABLE_MATRIX_FEDERATION is considered when creating homeserver.yaml
    # Matrix has to go before Nextcloud to catch .wellknown/matrix urls first
    echo 'include conf/matrix.conf;' >>/etc/nginx/modules.conf
    case $WG_ACCESS_MATRIX in *wg*) echo 'include conf/matrix-ext.conf;' >>/etc/nginx/wg_modules.conf ;; esac
    case $WG_ACCESS_MATRIX in *pub*) echo 'include conf/matrix-ext.conf;' >>/etc/nginx/ext_modules.conf ;; esac
fi

if [ $ENABLE_NEXTCLOUD == "true" ]; then
    echo 'include conf/nextcloud.conf;' >>/etc/nginx/modules.conf
    echo 'include conf/code-server.conf;' >>/etc/nginx/modules.conf
    case $WG_ACCESS_NEXTCLOUD in *wg*) echo 'include conf/nextcloud.conf;' >>/etc/nginx/wg_modules.conf ;; esac
    case $WG_ACCESS_NEXTCLOUD in *wg*) echo 'include conf/code-server-ext.conf;' >>/etc/nginx/ext_modules.conf ;; esac
    case $WG_ACCESS_NEXTCLOUD in *pub*) echo 'include conf/nextcloud.conf;' >>/etc/nginx/ext_modules.conf ;; esac
    case $WG_ACCESS_NEXTCLOUD in *pub*) echo 'include conf/code-server-ext.conf;' >>/etc/nginx/ext_modules.conf ;; esac
fi

if [ $ENABLE_SOLR == "true" ]; then
    echo 'include conf/solr.conf;' >>/etc/nginx/modules.conf
fi

if [ $ENABLE_OCRMYPDF == "true" ]; then
    echo 'include conf/ocrmypdf.conf;' >>/etc/nginx/modules.conf
fi

if [ $ENABLE_ELEXIS_WEB == "true" ]; then
    echo 'include conf/elexis-web.conf;' >>/etc/nginx/modules.conf
    case $WG_ACCESS_ELEXIS_WEB in *wg*) echo 'include conf/elexis-web.conf;' >>/etc/nginx/wg_modules.conf ;; esac
    case $WG_ACCESS_ELEXIS_WEB in *pub*) echo 'include conf/elexis-web.conf;' >>/etc/nginx/ext_modules.conf ;; esac
fi

if [ $ENABLE_GUACAMOLE == "true" ]; then
    echo 'include conf/guacamole.conf;' >>/etc/nginx/modules.conf
    case $WG_ACCESS_GUACAMOLE in *pub*) echo 'include conf/guacamole-ext.conf;' >>/etc/nginx/ext_modules.conf ;; esac
fi