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
    now = datetime.datetime.now()
    if now - datetime.timedelta(hours=24) <= boot_time:
        bootInfo = {"level": "INFO", "element": "system.boot-time",
                    "reason": "system_boot_within_last_24_hours"}
        status.append(bootInfo)

    if(status):
        site_status['status'] = status
