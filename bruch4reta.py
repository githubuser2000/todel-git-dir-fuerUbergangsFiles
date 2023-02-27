#!/usr/bin/env pypy3
# -*- coding: utf-8 -*-


def bruchSpalt(text):
    bruchSpalten = text.split("/")
    bruchSpaltenNeu = []
    for bS in bruchSpalten:
        zahl, keineZahl, bsNeu = {}, {}, []
        for i, char in enumerate(bS):
            if char.isdecimal():
                zahl[i] = char
            else:
                keineZahl[i] += char
        bsNeu = [zahl, keineZahl]
    bruchSpaltenNeu += [bsNeu]
