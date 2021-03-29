#! /usr/bin/env python3

import os
import pathlib
import re
import sys
from datetime import datetime
from functools import lru_cache

import pytz
from dateutil import parser

date_re = re.compile('Date: (.*)')
email_re = re.compile('<mailto:(.*?)>')
url_re = re.compile(r'(https?://[^\s]*)')


@lru_cache(maxsize=None)
def create_url_verify_page(url):
    tmp_dir = pathlib.Path(os.path.expanduser('~/tmp/mdf/'))
    tmp_dir.mkdir(parents=True, exist_ok=True)
    if len(os.listdir(tmp_dir)) == 0:
        next_num = 1
    else:
        next_num = max(int(x, 16) for x in os.listdir(tmp_dir)) + 1

    filename = os.path.expanduser(f'~/tmp/mdf/{hex(next_num)}')

    with open(filename, 'w+') as f:
        f.write(f'''<!doctype html>
        <html>
        <body>
            <textarea id="url_edit"
                      rows="10"
                      style="width: 100%;">{url}</textarea>
            <br />
            <input id="go" type="button" value="Go" />
            <script>
                const redirect = () => {{
                    const url = document.getElementById('url_edit').value;
                    window.location.replace(url);
                }}
                document.getElementById('go').addEventListener('click', redirect);
                document.onkeypress = e => {{
                    if (e.keyCode === 13) {{
                        redirect();
                        return false;
                    }}
                }};
                document.getElementById('url_edit').focus();
            </script>
        </body>
        </html>''')

    return f'<file://{filename}>'


def parse_datetime(datetime_string):
    # https://docs.python.org/3/library/datetime.html#strftime-and-strptime-behavior
    alternative_formats = []
    try:
        return parser.parse(datetime_string, fuzzy_with_tokens=True)[0]
    except ValueError:
        for f in alternative_formats:
            try:
                return datetime.strptime(datetime_string, f)
            except ValueError:
                pass


for line in sys.stdin.readlines():
    date_match = date_re.match(line)
    if date_match:
        # Fix Date to be in the local time
        date_str = date_match.groups()[0]
        dt = parse_datetime(date_str)
        if not dt:
            print('Date Parse Fail')
        else:
            tz_name = '/'.join(os.readlink('/etc/localtime').split('/')[-2:])
            dt = dt.astimezone(pytz.timezone(tz_name))
            line = 'Date: {}\n'.format(
                dt.strftime('%a, %b %d %H:%M:%S %Y (%Z)'))
    elif email_re.findall(line):
        # Remove redundant <mailto:{email}>.
        for email in email_re.findall(line):
            if f'{email}<mailto:{email}>' in line:
                line = line.replace(f'<mailto:{email}>', '')
    elif url_re.findall(line):
        # Create a HTML page that has a link to the actual URL, and give a
        # local address instead of a long URL.
        for url in url_re.findall(line):
            if len(url) > 30:
                url_verify_page_filename = create_url_verify_page(url)
                if len(url_verify_page_filename) < len(url):
                    line = line.replace(url, url_verify_page_filename)

    print(line, end='')
