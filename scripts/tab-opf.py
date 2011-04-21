#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# This script transforms dictionary tabfile to OPF file. It is used
# to convert StarDict's dictionaries to Kindle format.
#
# Author: Viet Nguyen Quoc
# License: BSD License
# References:
# 1. StarDict tabfile format
#    http://stardict.sourceforge.net/HowToCreateDictionary
# 2. OPF specifications
#    http://www.mobipocket.com/dev/article.asp?BaseFolder=prcgen
# 3. StarDict tools
#    http://stardict.sourceforge.net/other.php
# 4. KindleGen
#    http://www.amazon.com/kindlepublishing
#

import sys
from xml.sax.saxutils import escape
from xml.sax.saxutils import quoteattr

OPF_NAME = "en-vi"
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
DICT_ENTRY_TPL = """<idx:entry>
  <h6><idx:orth>%s</idx:orth></h6>
  <idx:key key=%s />
  %s
</idx:entry>
<hr/>
"""
DICT_MAX_ENTRY = 50000

###

if len(sys.argv) > 1:
    file_path = sys.argv[1]
else:
    print("Usage: python %s <FILE>" % sys.argv[0])
    sys.exit(1)

try:
    fin = open(file_path, "r")
except IOError:
    print("Could not open file: %s" % file_path)
    sys.exit(2)

i = 0
fout = None
dict_list = []

for line in fin:
    dt, dd = line.split("\t", 1)
    
    if i % DICT_MAX_ENTRY == 0:
        if fout:
            fout.write(DICT_TAIL_TPL)
            fout.close()
        d_id = "%s-%d" % (OPF_NAME, i / DICT_MAX_ENTRY)
        fout = open("%s.html" % d_id, "w")
        fout.write(DICT_HEAD_TPL)
        dict_list.append(d_id)
        print("%d\t\t%s\t\t%s" % (i, d_id, dt))
    
    dk = quoteattr(dt)
    dt = escape(dt)
    dd = escape(dd).replace("\\\\", "\\").replace("\r", "").replace("\n", "").replace("\\n", "<br/>")
    fout.write(DICT_ENTRY_TPL % (dt, dk, dd))
    i += 1 

if fout:
    fout.write(DICT_TAIL_TPL)
    fout.close()

fin.close()

fout = open("%s-start.html" % OPF_NAME, "w")
fout.write(OPF_STARTPAGE_TPL)
fout.close()

mainifest = OPF_MAINIFEST_STARTPAGE_TPL % (OPF_NAME, OPF_NAME)
spine = OPF_SPINE_STARTPAGE_TPL % OPF_NAME
guide = OPF_GUIDE_STARTPAGE_TPL % OPF_NAME

fout = open("%s.opf" % OPF_NAME, "w")
for d_id in dict_list:
    mainifest += OPF_MAINIFEST_TPL % (d_id, d_id)
    spine += OPF_SPINE_TPL % d_id

fout.write(OPF_TPL % (mainifest, spine, guide))
fout.close()

