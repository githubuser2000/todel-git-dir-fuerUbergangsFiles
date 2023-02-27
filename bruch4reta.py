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
    charsVorBruchStrich = []
    charsNachBruchStrich = []
    lastZahlVorBruchStrich = None
    lastZahlNachBruchStrich = None
    lastZahlVorBruchStrich2 = None
    lastZahlNachBruchStrich2 = None
    flag = False
    for i, bSLL in enumerate(bruchSpaltenListList):
        zahl0List = dictToList(bSLL[0])
        if flag:
            print("jaa2")
            flag = False
            zahlDavorVorBruchstrich = int("".join(lastZahlVorBruchStrich2))
            zahlDavorNachBruchstrich = int("".join(lastZahlNachBruchStrich))
            zahlDanachVorBruchStrich = int("".join(lastZahlVorBruchStrich))
            zahlDanachNachBruchStrich = int("".join(zahl0List))
            zahlenDavor = range(zahlDavorVorBruchstrich, zahlDanachVorBruchStrich + 1)
            zahlenDanach = range(
                zahlDavorNachBruchstrich, zahlDanachNachBruchStrich + 1
            )
            print(["zahlenDavor", zahlenDavor, "zahlenDanach", zahlenDanach])
        if len(bSLL) == 3:
            if tuple(bSLL[1].values()) == ("-",):
                print("jaa1")
                flag = True

            chars1List = dictToList(bSLL[1])
            zahl2List = dictToList(bSLL[2])

            neuZahlVorBruchstrich += chars1List + zahl2List
            neuZahlNachBruchstrich += zahl0List + chars1List
            lastZahlVorBruchStrich2 = lastZahlVorBruchStrich
            lastZahlNachBruchStrich2 = lastZahlNachBruchStrich
            lastZahlVorBruchStrich = zahl2List
            lastZahlNachBruchStrich = zahl0List
        elif len(bSLL) == 1:
            if i == 0:
                neuZahlVorBruchstrich += zahl0List
                lastZahlVorBruchStrich2 = lastZahlVorBruchStrich
                lastZahlNachBruchStrich2 = lastZahlNachBruchStrich
                lastZahlVorBruchStrich = zahl0List
            elif i == len(bruchSpaltenListList) - 1:
                neuZahlNachBruchstrich += zahl0List
                lastZahlVorBruchStrich2 = lastZahlVorBruchStrich
                lastZahlNachBruchStrich2 = lastZahlNachBruchStrich
                lastZahlNachBruchStrich = zahl0List
            else:
                raise
    return "".join(neuZahlVorBruchstrich), "".join(neuZahlNachBruchstrich)


def createRangesForBruchLists():
    pass


def bla(text):
    return get2StrsFromBSlistList(bruchSpalt(text))
