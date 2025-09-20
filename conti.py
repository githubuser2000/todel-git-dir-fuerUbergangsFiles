import sys
keys1 = ['q', 'w', 'ac', 'ad', 'ae', 'ak', 'au', 'z']
keys2 = ['17', '23', '29', '30', '31', '37', '47', '26']
values = [[["020", "2"]],[["001", "7"]], [["001", "8"]], [["001", "9"], ["003", "2"]],[ ["001", "10"]], [["001", "11"]], [["001", "12"]], [["002", "2"]]]
map1 = dict(zip(keys1, values))
map2 = dict(zip(keys2, values))
arg = sys.argv[1]
if arg.isdecimal():
    bla=map2[arg]
else:
    bla=map1[arg]
import outCsvCol 
for b in bla:
    sys.argv = ["outCsvCol.py", "concat-reli-"+str(b[0])+".csv", b[1]]
    outCsvCol.start()
