#! /usr/bin/env python3
# Depends on:
#  - python-vobject
#    (https://www.archlinux.org/packages/community/any/python-vobject/) for
#    querying the synced contacts from Xandikos
#  - csmdirsearch (https://github.com/jackrosenthal/csmdirsearch/) by Jack
#    Rosenthal for searching for Colorado School of Mines students and faculty
#    email addresses.
#  - python-gitlab (https://github.com/python-gitlab/python-gitlab to enable
#    GitLab issue creation auto-complete.
#  - python-fuzzywuzzy (https://github.com/seatgeek/fuzzywuzzy) fuzzy search
#    for GitLab projects
#  - python-levenshtein

import concurrent
import os
import sys
from pathlib import Path
from subprocess import PIPE, run

import csmdirsearch
import gitlab
import vobject
from fuzzywuzzy import fuzz

# Read from the config file
with open(os.path.expanduser("~/.config/contact-query/config")) as f:
    emailkey = f.readline().strip()
    groups = []
    for line in f:
        groups.append(line.strip())


def test_internet():
    """
    Tests whether or not the computer is currently connected to the internet.
    """
    command = ["ping", "-c", "1", "8.8.8.8"]
    return run(command, stdout=PIPE, stderr=PIPE).returncode == 0


if len(sys.argv) < 2:
    print("Enter something, you moron.")
    sys.exit(1)


def query_vdirsyncer(query):
    query = query.lower()

    contacts_dir = Path("~/.local/share/vdirsyncer/contacts/addressbook").expanduser()
    for contact_file in contacts_dir.glob("*.vcf"):
        with open(contact_file) as cf:
            contact = vobject.readOne(cf.read())
            fullname = contact.fn.value

            emails = (
                c.value
                for c in contact.getChildren()
                if c.name.lower() == "email" and c.value and c.value != ""
            )
            for email in emails:
                fullname_email = f"{contact.fn.value} <{email}>"
                if fuzz.partial_ratio(query, fullname_email.lower()) > 70:
                    yield f"{email}\t{fullname}"


def query_gitlab(query):
    if not test_internet():
        return
    query = query.lower()

    # GitLab Projects
    gl = gitlab.Gitlab.from_config()
    gl.auth()
    gl_username = gl.user.username
    me = gl.users.list(username=gl_username)[0]
    projects = [(gl_username, p.attributes["name"]) for p in me.projects.list(all=True)]

    for g in groups:
        projects.extend(
            [
                (g, p.attributes["name"])
                for p in gl.groups.get(g).projects.list(all=True)
            ]
        )

    for g, p in projects:
        if fuzz.partial_ratio(query, p.lower()) > 70:
            yield f"incoming+{g}/{p}+{emailkey}@incoming.gitlab.com\t{g}/{p}"


def query_csmdirsearch(query):
    if not test_internet():
        return

    for result in csmdirsearch.search(query):
        if not hasattr(result, "business_email"):
            continue
        yield "{}\t{}\t{}".format(
            result.business_email,
            result.name.strfname("{pfirst} {last}"),
            result.desc,
        )


with concurrent.futures.ThreadPoolExecutor(max_workers=30) as executor:
    query = " ".join(sys.argv[1:])
    futures = [
        executor.submit(fn, query)
        for fn in (
            query_vdirsyncer,
            query_gitlab,
            query_csmdirsearch,
        )
    ]
    print()  # Mutt ignores the first line
    for future in concurrent.futures.as_completed(futures):
        try:
            for r in future.result() or []:
                print(r)
        except Exception:
            # Who cares
            pass
