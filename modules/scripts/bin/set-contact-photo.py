#! /usr/bin/env python3

import io
import sys

import vobject
from PIL import Image

if len(sys.argv) != 3:
    print("Usage:")
    print("    set-contact-photo <vcf file> <photo file>")
    sys.exit(1)

with open(sys.argv[1]) as cf:
    vcard = vobject.readOne(cf.read())

with open(sys.argv[2], "rb") as imagefile:
    image_data = imagefile.read()
    image = Image.open(io.BytesIO(image_data))

photos = [c for c in vcard.getChildren() if c.name.lower() == "photo"]

if len(photos) == 1:
    # Check if the photo is the same
    if image_data == photos[0].value:
        print("Photos are the same")
        sys.exit(0)

    while True:
        print(f"Already have a photo for {vcard.fn.value}. Replace? [Yn]: ", end="")
        response = input().lower()
        if response == "y":
            break
        if response == "n":
            sys.exit(0)

if len(photos) > 1:
    while True:
        print(
            f"Multiple photos found for {vcard.fn.value}. Remove all and replace? [Yn]: ",
            end="",
        )
        response = input().lower()
        if response == "y":
            break
        if response == "n":
            sys.exit(0)


# Remove all old photos:
for child in photos:
    vcard.remove(child)

photo = vcard.add("photo")
photo.type_param = image.format
photo.encoding_param = "b"
photo.value = image_data

with open(sys.argv[1], "w+") as cf:
    cf.write(vcard.serialize())
