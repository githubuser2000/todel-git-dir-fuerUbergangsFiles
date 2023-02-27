#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-


def grKl(A: set, B: set) -> tuple[set, set]:
    C = set()
    D = set()
    if len(B) == 0:
        return A, A
    for a in A:
        if a > max(B):
            C.add(a)
        elif a < min(B):
            D.add(a)
    return C, D


def getDictLimtedByKeyList(d: dict, keys) -> dict:
    return {k: d[k] for k in keys if k in d}


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
        if len(keineZahlSet) > 0:
            zahlenGroesserSet, zahlenKleinerSet = grKl(zahlSet, keineZahlSet)
            zahlenKleinerDict: dict = getDictLimtedByKeyList(zahl, zahlenKleinerSet)
            zahlenGroesserDict: dict = getDictLimtedByKeyList(zahl, zahlenGroesserSet)
            bsNeu = [zahlenKleinerDict, keineZahl, zahlenGroesserDict]
        else:
            bsNeu = [zahl]
        bruchSpaltenNeu += [bsNeu]
    return bruchSpaltenNeu


def dictToList(dict_: dict) -> list:
    liste = []
    for key, value in dict_.items():
        liste += [value]
    return liste


def get2StrsFromBSlistList(bruchSpaltenListList: list) -> tuple[str, str]:
    neuZahlVorBruchstrich = []
    neuZahlNachBruchstrich = []
    for i, bSLL in enumerate(bruchSpaltenListList):
        if len(bSLL) == 3:
            neuZahlVorBruchstrich += dictToList(bSLL[1]) + dictToList(bSLL[2])
            neuZahlNachBruchstrich += dictToList(bSLL[0]) + dictToList(bSLL[1])
        elif len(bSLL) == 1:
            if i == 0:
                neuZahlVorBruchstrich += dictToList(bSLL[0])
            elif i == len(bruchSpaltenListList) - 1:
                neuZahlNachBruchstrich += dictToList(bSLL[0])
            else:
                raise
    return "".join(neuZahlVorBruchstrich), "".join(neuZahlNachBruchstrich)


def bla(text):
    return get2StrsFromBSlistList(bruchSpalt(text))
