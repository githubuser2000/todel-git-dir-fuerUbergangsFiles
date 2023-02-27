#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-


def bruchSpalt(text) -> list:
    bruchSpalten: list[str] = text.split("/")
    bruchSpaltenNeu = []
    if len(bruchSpalten) < 2:
        return []
    for k, bS in enumerate(bruchSpalten):
        zahl, keineZahl, bsNeu = {}, {}, []
        for i, char in enumerate(bS):
            if char.isdecimal():
                zahl[i] = char
            else:
                keineZahl[i] = char
        flag: bool = False
        allVergleich: list[bool] = [
            zahl > c for c, zahl in zip(keineZahl.keys(), zahl.keys())
        ]
        zahlSet: set = set(zahl.keys())
        keineZahlSet: set = set(keineZahl.keys())
        if len(zahlSet) == 0:
            return []
        anfang, ende = k == 0, k == len(bruchSpalten) - 1
        if anfang and all(allVergleich):
            flag = True
        elif ende and not any(allVergleich):
            flag = True
        elif (
            not anfang
            and not ende
            and keineZahlSet.issubset(range(min(zahlSet) + 1, max(zahlSet)))
        ):
            flag = True
        else:
            flag = False
        if flag is False:
            return []
        bsNeu = [zahl, keineZahl]
        bruchSpaltenNeu += [bsNeu]
    return bruchSpaltenNeu
