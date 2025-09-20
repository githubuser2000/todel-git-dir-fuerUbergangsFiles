import sys
keys1 = ['q', 'w', 'ac']
keys2 = ['17', '23', '29']
values = [["020", "2"],["001", "7"], ["001", "8"]]

map1 = dict(zip(keys1, values))
map2 = dict(zip(keys2, values))

arg=sys.argv[1]
if arg.isdecimal():
    bla=map2[arg]
else:
    bla=map1[arg]
sys.argv = ["outCsvCol.py", "concat-reli-"+bla[0]+".csv", bla[1]]
import outCsvCol 
