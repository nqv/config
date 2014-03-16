#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# This script transforms dictionary tabfile to OPF file. It is used
# to convert StarDict's dictionaries to Kindle format.
#
# Author: Viet Nguyen Quoc
# License: New BSD License
# References:
# 1. StarDict tabfile format
#    http://stardict.sourceforge.net/HowToCreateDictionary
# 2. OPF specifications
#    http://www.mobipocket.com/dev/article.asp?BaseFolder=prcgen
# 3. StarDict tools
#    http://stardict.sourceforge.net/other.php
# 4. KindleGen
#    http://www.amazon.com/kindlepublishing
# Usage:
# $ python tab-opf.py [-i <INFLECTIONS_FILE>] <TAB_FILE>
# $ kindlegen output.odf
#

import sys
import getopt
from xml.sax.saxutils import escape
from xml.sax.saxutils import quoteattr

OPF_TPL = """<?xml version="1.0" encoding="utf-8"?>
<package unique-identifier="uid">
<metadata>
  <dc-metadata xmlns:dc="http://purl.org/metadata/dublin_core" xmlns:oebpackage="http://openebook.org/namespaces/oeb-package/1.0/">
    <dc:Identifier id="uid">656E2D7669</dc:Identifier>
    <dc:Title>English-Vietnamese Dictionary</dc:Title>
    <dc:Creator>Viet NQ</dc:Creator>
    <dc:Date>2011-04-20</dc:Date>
    <dc:Copyrights>Open Vietnamese Dictionaries Project</dc:Copyrights>	
    <dc:Subject></dc:Subject>
    <dc:Language>en</dc:Language>
  </dc-metadata>
  <x-metadata>
    <DictionaryInLanguage>en</DictionaryInLanguage>
    <DictionaryOutLanguage>vi</DictionaryOutLanguage>
  </x-metadata>
</metadata>
<manifest>%s</manifest>
<spine>%s</spine>
<guide>%s</guide>
</package>
"""
OPF_STARTPAGE_TPL = """<?xml version="1.0" encoding="utf-8"?>
<!doctype html>
<html>
<head>
  <title>English-Vietnamese Dictionary</title>
  <meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8"/>
</head>
<body>
  <h3>English-Vietnamese Dictionary</h3>
  <div>Copyright &copy; by Open Vietnamese Dictionaries Project. URL: <a href="http://www.tudientiengviet.net" title="OVDP">www.tudientiengviet.net</a></div>
  <div>Data conversion: Viet Nguyen Quoc</div>
  <div>Scripts: <a href="http://github.com/vietnq/conf/tree/master/scripts" title="scripts">github.com/vietnq</a></div>
</body>
</html>
"""
OPF_MAINIFEST_TPL = """  <item id="%s" href="%s.html" media-type="text/x-oeb1-document"/>
"""
OPF_SPINE_TPL = """  <itemref idref="%s"/>
"""
OPF_MAINIFEST_STARTPAGE_TPL = """  <item id="%s-start" href="%s-start.html" media-type="application/xhtml+xml"/>
"""
OPF_SPINE_STARTPAGE_TPL = """  <itemref idref="%s-start"/>
"""
OPF_GUIDE_STARTPAGE_TPL = """  <reference type="start" title="Start here" href="%s-start.html"/>
"""
DICT_HEAD_TPL = """<?xml version="1.0" encoding="utf-8"?>
<html xmlns:idx="mobipocket.com" xmlns:mbp="mobipocket.com">
  <body>
"""
DICT_TAIL_TPL = """  </body>
</html>
"""
DICT_ENTRY_TPL = """<idx:entry>%s%s</idx:entry><hr/>
"""
DICT_KEY_TPL = """<idx:key key=%s/>"""
DICT_ORTH_TPL = """<b><idx:orth>%s%s</idx:orth></b>"""
DICT_INFL_TPL = """<idx:infl>%s</idx:infl>"""
DICT_IFORM_TPL = """<idx:iform value=%s/>"""

DICT_MAX_ENTRY = 50000

###

def reformat_stardict(line):
    dt, dd = line.split("\t", 1)
    dk = DICT_KEY_TPL % quoteattr(dt)
    df = ''
    if infl_c is not None:
        # search for inflection words
        infl_c.execute('SELECT n, v, a FROM infl WHERE k=?', (dt,))
        row = infl_c.fetchone()
        if row is not None:
            for val in row:
                df += gen_infl(val)
    if len(df) > 0:
        df = DICT_INFL_TPL % df

    if dd.startswith("@" + dt):
        dd = dd[(len(dt) + 1):]
        dd = escape(dd).replace("\\\\", "\\").replace("\r", "").replace("\n", "").replace("\\n", "<br/>")
        dd = (("@" + DICT_ORTH_TPL) % (escape(dt), df)) + dd
        dt = dk
    else:
        dt = ((DICT_ORTH_TPL + "<br />") % (escape(dt), df)) + dk
        dd = escape(dd).replace("\\\\", "\\").replace("\r", "").replace("\n", "").replace("\\n", "<br/>")
    return dt, dd

def gen_infl(val):
    if val is None:
        return ''
    f = ''        
    val = val.split(' | ')
    for v in val:
        if v.find('?') < 0:
            f += DICT_IFORM_TPL % quoteattr(v)
    return f

def usage():
    print("Usage: python %s [OPTIONS] <FILE>" % sys.argv[0])
    print("  -o <NAME>         Output file name")
    print("  -e                Norminalize (encode) key")
    print("  -f <PATH>         Inflection file")

### main ###
fout = None
dict_list = []
encode_key = False
file_name = "output"
infl_name = None
infl_conn = None
infl_c = None

try:
    opts, args = getopt.getopt(sys.argv[1:], "heo:f:")
except getopt.GetoptError, err:
    # print help information and exit:
    print str(err) # will print something like "option -a not recognized"
    usage()
    sys.exit(1)

if len(args) == 0:
    usage()
    sys.exit(1)

file_path = args[0]

for o, a in opts:
    if (o == "-h"):
        usage()
        sys.exit(0)
    elif (o == "-e"):
        encode_key = True
    elif (o == "-o"):
        file_name = a
    elif (o == "-f"):
        infl_name = a

try:
    fin = open(file_path, "r")
except IOError:
    print("Could not open file: %s" % file_path)
    sys.exit(2)

if infl_name is not None:
    import sqlite3
    infl_conn = sqlite3.connect(infl_name)
    infl_conn.text_factory = str
    infl_c = infl_conn.cursor()

i = 0
for line in fin:
    if i % DICT_MAX_ENTRY == 0:
        if fout:
            fout.write(DICT_TAIL_TPL)
            fout.close()
        d_id = "%s-%d" % (file_name, i / DICT_MAX_ENTRY)
        fout = open("%s.html" % d_id, "w")
        fout.write(DICT_HEAD_TPL)
        dict_list.append(d_id)
        print("%d\t\t%s" % (i, d_id))

    dt, dd = reformat_stardict(line)
    fout.write(DICT_ENTRY_TPL % (dt, dd))
    i += 1
#    if (i == 100000):
#        break

if fout:
    fout.write(DICT_TAIL_TPL)
    fout.close()

fin.close()

fout = open("%s-start.html" % file_name, "w")
fout.write(OPF_STARTPAGE_TPL)
fout.close()

mainifest = OPF_MAINIFEST_STARTPAGE_TPL % (file_name, file_name)
spine = OPF_SPINE_STARTPAGE_TPL % file_name
guide = OPF_GUIDE_STARTPAGE_TPL % file_name

fout = open("%s.opf" % file_name, "w")
for d_id in dict_list:
    mainifest += OPF_MAINIFEST_TPL % (d_id, d_id)
    spine += OPF_SPINE_TPL % d_id

fout.write(OPF_TPL % (mainifest, spine, guide))
fout.close()

if infl_c is not None:
    infl_c.close()

