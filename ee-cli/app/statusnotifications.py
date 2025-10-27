# potential warnings
# is the certificate going to expire
# are there any updates for the OS
# are there any updates for webmin module
# are services set to enable but do not run
# are services updatable?
# is myElexis bridge up and running (if active)
import datetime


def checkNotifications(site_status):
    status = []
    now = datetime.datetime.now()

    # config error: is system.fqdn equal to ee.config.hostname
    if(site_status['system']['fqdn'] != site_status['ee']['config']['hostname']):
        hostnameConfigError = {"level": "ERROR", "element": "system.fqdn",
                               "reason": "system_hostname_does_not_match_configuration"}
        status.append(hostnameConfigError)

    # external hostname resolve error, dns problem?
    if(site_status['system']['network']['external-ip'].startswith("error")):
        extResolveIpError = {"level": "ERROR", "element": "network.external-ip",
                       "reason": "external_ip_resolution_error"}
        status.append(extResolveIpError)

    # are there any updates for EE.git
    if(site_status['ee']['git']['branch-head-commit'] != site_status['ee']['git']['origin-branch-head-commit']):
        gitUpdAvail = {"level": "INFO", "element": "ee.git",
                       "reason": "ee_git_update_available"}
        status.append(gitUpdAvail)

    # is hdd space on any partition running low?
    for key, value in site_status['system']['disk'].items():
        if(value['percent'] > 80):
            level = "ERROR" if value['percent'] > 90 else "WARN"
            partWarn = {"level": level, "element": "system.disk." +
                        key, "reason": "hdd_partition_space_running_low"}
            status.append(partWarn)

    # was there a system (re)boot in the last 24 hours
    boot_time = datetime.datetime.strptime(
        site_status['system']['boot-time'], '%Y-%m-%dT%H:%M:%S.%f')
    if now - datetime.timedelta(hours=24) <= boot_time:
        bootInfo = {"level": "INFO", "element": "system.boot-time",
                    "reason": "system_boot_within_last_24_hours"}
        status.append(bootInfo)

    # is the certificate about to expire within 14 days or is it invalid
    try:
        cert_not_after = datetime.datetime.strptime(site_status['ee']['site']['cert-not-after'], '%Y-%m-%dT%H:%M:%S.%f')
        if now + datetime.timedelta(days=1) >= cert_not_after:
            certInfo= {"level": "ERROR", "element": "ee.site.cert_expired",
                    "reason": "cert_expired"}
            status.append(certInfo)
        elif now + datetime.timedelta(days=14) >= cert_not_after:
            certInfo= {"level": "WARN", "element": "ee.site.cert_not_after",
                    "reason": "cert_about_to_expire"}
            status.append(certInfo)
    except Exception as e:
        print(e)
        certInfo= {"level": "WARN", "element": "ee.site.cert_not_after",
                    "reason": "invalid_cert"}
        status.append(certInfo)

    # is the bridge active but the name resolution fails
    if site_status['ee']['bridge']['status'] == "up":
        if site_status['ee']['bridge']['remote-dns'].startswith("error"):
            bridgeInfo = {"level": "WARN", "element": "ee.bridge.remote-dns",
                    "reason": "bridge_remote_dns_resolve_error"}
            status.append(bridgeInfo)

    if(status):
        site_status['status'] = status
