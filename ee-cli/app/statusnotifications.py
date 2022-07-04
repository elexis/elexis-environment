# potential warnings
# was there a system reboot in the last n hours?
# is hdd space getting low
# is the certificate going to expire
# are there any updates for the OS
# are there any updates for webmin module
# are services set to enable but do not run
# is myElexis bridge up and running (if active)

def checkNotifications(site_status):
    status = []

    # are there any updates for EE.git 
    if(site_status['ee']['git']['branch-head-commit'] != site_status['ee']['git']['origin-branch-head-commit']):
        gitUpdAvail = {"level": "INFO", "element": "ee.git",
                       "reason": "ee_git_update_available"}
        status.append(gitUpdAvail)

    if(status):
        site_status['status'] = status
