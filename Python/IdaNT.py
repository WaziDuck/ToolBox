# plz in script not plugin
from idc import *
from idaapi import *
from idautils import *

with open("nt", "r", encoding = "utf-8") as PJGCCMCIOOM:
    KHMFJLKBGBP = PJGCCMCIOOM.read()

COPFDHKIFHO = KHMFJLKBGBP.split("\n")
JJOBNCFKOJI = {}

for PIHBECEFJIG in COPFDHKIFHO:
    PKNIPFMCIIH = PIHBECEFJIG.split("⇨")
    JJOBNCFKOJI[PKNIPFMCIIH[0]] = PKNIPFMCIIH[1]

def KFBOPOJJPMA(PKNIPFMCIIH):
    NAKBHGKKNJO = PKNIPFMCIIH
    for PIHBECEFJIG in PKNIPFMCIIH.split("$"):
        if PIHBECEFJIG in JJOBNCFKOJI:
            NAKBHGKKNJO = NAKBHGKKNJO.replace(PIHBECEFJIG, JJOBNCFKOJI[PIHBECEFJIG])
    return NAKBHGKKNJO


for GHPCHGGAKPF in Functions():
    KLDNOJFBLNH = get_func_name(GHPCHGGAKPF)
    set_name(GHPCHGGAKPF, KFBOPOJJPMA(KLDNOJFBLNH), SN_FORCE)
