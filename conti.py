import sys
keys1 = ['q', 'w', 'ac', 'ad', 'ae', 'ak', 'au', 'z', 'x', 'r', 'aa', 'at', 'p']
keys2 = ['17', '23', '29', '30', '31', '37', '47', '26', '24', '18', '27', '46', '16']
values = [[["020", "2"]],[["001", "7"], ["019", "0"]], [["001", "8"]], [["001", "9"], ["003", "2"]],[ ["001", "10"]], [["001", "11"]], [["001", "12"]], [["002", "2"]], [["009", "0"], ["018", "0"], ["018", "1"]], [["011", "0"], ["018", "0"]], [["013", "0"], ["013", "1"], ["013", "2"]], [["019", "1"]], [["020", "1"]]]
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
