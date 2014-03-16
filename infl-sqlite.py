#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Convert inflected word list to sqlite3 database.
# Inflections: http://wordlist.sourceforge.net/
#

import sys
import sqlite3

IN_FILE = 'infl.txt'
OUT_FILE = 'infl.sqlite3'

try:
    f = open(IN_FILE, 'r')
except IOError:
    print('could not open file');
    sys.exit(1)

conn = sqlite3.connect(OUT_FILE);
conn.text_factory = str
c = conn.cursor();

# Create table
c.execute('''CREATE TABLE infl(k text UNIQUE, n text NULL, v text NULL, a text NULL)''');

def insert_infl(key, type, val):
    # check existed
    c.execute('SELECT COUNT(*) FROM infl WHERE k=?', (key,))
    if c.fetchone()[0] == 0:
        c.execute('INSERT INTO infl(k, %s) VALUES (?, ?)' % type, (key, val))
    else:
        c.execute('UPDATE infl SET %s=? WHERE k=?' % type, (val, key))


# import
for line in f:
    # key/type
    k, t, v = line.strip().split(' ', 2)
    if (t == 'N:'):
        t = 'n'
    elif (t == 'V:'):
        t = 'v'
    elif (t == 'A:'):
        t = 'a'
    else:
        continue
    print(k)
    insert_infl(k, t, v)

f.close()
conn.commit()
c.close()

