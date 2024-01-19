#! /usr/bin/env python3
# Depends on:
#  - python-vobject
#    (https://www.archlinux.org/packages/community/any/python-vobject/) for
#    querying the synced contacts from Xandikos
#  - csmdirsearch (https://github.com/jackrosenthal/csmdirsearch/) by Jack
#    Rosenthal for searching for Colorado School of Mines students and faculty
#    email addresses.
#  - goobook (https://gitlab.com/goobook/goobook/) to search Google contacts.
#  - python-gitlab (https://github.com/python-gitlab/python-gitlab to enable
#    GitLab issue creation auto-complete.
#  - python-fuzzywuzzy (https://github.com/seatgeek/fuzzywuzzy) fuzzy search
#    for GitLab projects
#  - python-levenshtein

import sys
from pathlib import Path
from typing import List

import tabulate
import vobject
from fuzzywuzzy import fuzz, process

query = " ".join(sys.argv[1:])
contacts_dir = Path("~/.local/share/vdirsyncer/contacts/addressbook").expanduser()
contacts = []

for contact_file in contacts_dir.glob("*.vcf"):
    with open(contact_file) as cf:
        contact = vobject.readOne(cf.read())
        fullname = contact.fn.value
        if (score := process.extractOne(query, fullname.lower().split())[1]) > 70:
            contacts.append((fuzz.ratio(query, fullname.lower()), contact))


def parse_type(typestrs: List[str]):
    if len(typestrs) == 0:
        return ""
    typestr = typestrs[0]
    return (
        "("
        + (
            (typestr[2:] if typestr.startswith("x-") else typestr)
            .replace("_", " ")
            .lower()
        )
        + ")"
    )


def pluralize(word: str, items: int):
    return (
        word if items == 1 else (word + "S" if not word.endswith("S") else word + "ES")
    )


for i, (score, contact) in enumerate(
    sorted(contacts, key=lambda x: (x[0], x[1].fn.value), reverse=True)
):
    if i > 0:
        print()
        print("=" * 80)
        print()

    emails = []
    phone_numbers = []
    addresses = []
    for c in contact.getChildren():
        name = c.name.lower()
        if name == "email":
            if c.value and c.value != "":
                emails.append(f"{c.value} {parse_type(c.params.get('TYPE', []))}")
        elif name == "adr":
            addresses.append(f"{c.value} {parse_type(c.params.get('TYPE', []))}")
        elif name == "tel":
            phone_numbers.append(f"{c.value} {parse_type(c.params.get('TYPE', []))}")

    rows = [
        ("NAME", contact.fn.value),
        (pluralize("EMAIL", len(emails)), "\n".join(emails)),
        (pluralize("PHONE NUMBER", len(phone_numbers)), "\n".join(phone_numbers)),
        (pluralize("ADDRESS", len(addresses)), "\n\n".join(addresses)),
    ]

    print(tabulate.tabulate(rows, tablefmt="plain"))
