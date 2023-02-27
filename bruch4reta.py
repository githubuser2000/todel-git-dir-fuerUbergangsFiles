#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-


def bruchSpalt(text):
    bruchSpalten = text.split("/")
    bruchSpaltenNeu = []
    for k, bS in enumerate(bruchSpalten):
        zahl, keineZahl, bsNeu = {}, {}, []
        for i, char in enumerate(bS):
            if char.isdecimal():
                zahl[i] = char
            else:
                keineZahl[i] = char
        flag = False
        allVergleich = [zahl > c for c, zahl in zip(keineZahl.keys(), zahl.keys())]
        zahlSet = set(zahl.keys())
        keineZahlSet = set(keineZahl.keys())
        if k == 0 and all(allVergleich):
            flag = True
        elif k == len(bS) - 1 and not any(allVergleich):
            flag = True
        elif keineZahlSet.issubset(range(min(zahlSet) + 1, max(zahlSet))):
            flag = True
        else:
            flag = False
        if flag is False:
            return []
        bsNeu = [zahl, keineZahl]
        bruchSpaltenNeu += [bsNeu]
    return bruchSpaltenNeu
