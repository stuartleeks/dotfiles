import os
import re
import subprocess
from thefuck.conf import settings
from thefuck.types import Command
from thefuck.utils import for_app

RE_AUTH_TEXT = "Could not resolve to a Repository"



def parse_org_settings(input: str):
    """Parse env var setting values.
    
    Format is <org1_name>|<user1_name>;<org2_name>|<user2_name>...
    
    This configures user1_name as the user needed for org1_name etc"""
    orgs = {}
    input_orgs = input.split(";")
    for input_org in input_orgs:
        if input_org:
            parts = input_org.split("|")
            if len(parts) != 2:
                raise Exception(f"Each section in org config should be separated by ';' and in the form 'org|user'. Got '{input_org}'")
            orgs[parts[0]] = parts[1]
    return orgs

default_user = os.getenv("THE_FUCK_GH_SWITCH_USER_DEFAULT_USER")
if not default_user:
    raise Exception("Missing env var: THE_FUCK_GH_SWITCH_USER_DEFAULT_USER")
orgs = parse_org_settings(os.getenv("THE_FUCK_GH_SWITCH_USER_ORGS"))

# At the time of writing, the `gh` CLI gives the following error when it doesn't have permissions
# to query a repo via GraphQL:
# GraphQL: Could not resolve to a Repository with the name 'my-org/my-repo'. (repository)
def get_target_from_output(command: Command):
    # Use regex to match "my-org/my-repo" in "GraphQL: Could not resolve to a Repository with the name 'my-org/my-repo'. (repository)"
    target_regex = "Could not resolve to a Repository with the name '(.*)/(.*)'."
    m = re.search(target_regex, command.output)
    if m:
        return (m.group(1), m.group(2))
    return None


def get_current_gh_user():
    return (
        subprocess.run(["gh", "switch-user", "--show"], capture_output=True)
        .stdout.decode("utf-8")
        .rstrip()
    )


@for_app("gh")
def match(command: Command):
    (target_org, _) = get_target_from_output(command)
    if target_org:
        org_user = orgs.get(target_org)
        current_gh_user = get_current_gh_user()
        if org_user:
            # The org is in the settings - it's a rule match if we're not the org user
            return current_gh_user != org_user
        else:
            # No matching org  in the settings - it's a rule match if we're not the default user
            return current_gh_user != default_user

    return False


def get_new_command(command: Command):
    (target_org, _) = get_target_from_output(command)
    org_user = orgs.get(target_org)
    if org_user:
        # We have a user for this org - switch to it
        command = f"gh switch-user {org_user};{command.script}"
    else:
        # We don't have a user for this org - switch to the default user
        command = f"gh switch-user {default_user};{command.script}"
    return command


enabled_by_default = True
priority = 1  # Lowest first
