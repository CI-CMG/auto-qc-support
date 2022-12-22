import sys, getopt
import util.dbutils as dbutils
import util.main as main
import json
from pathlib import Path


options, remainder = getopt.getopt(sys.argv[1:], 't:d:o:h')
targetdb = 'iquod.db'
dbtable = 'iquod'
outdir = '.'
for opt, arg in options:
    if opt == '-d':
        dbtable = arg
    if opt == '-t':
        targetdb = arg
    if opt == '-o':
        outdir = arg
    if opt == '-h':
        print('usage:')
        print('-d <db table name to read from>')
        print('-o <directory to write results file if test failures are present>')
        print('-t <name of db file>')
        print('-h print this help message and quit')

df = dbutils.db_to_df(table=dbtable, targetdb=targetdb)
testNames = df.columns[1:].values.tolist()

results = {}
for index, row in df.iterrows():
    cast = row['uid']
    failures = []
    for test in testNames:
        if row[test]:
            failures.append(test)
    if failures:
        results[cast] = failures

if results:
    Path(outdir).mkdir( parents=True, exist_ok=True )
    with open(outdir + "/" + dbtable + '-qc-failures.json', 'w') as outfile:
        json.dump(results, outfile, indent = 4)
    sys.exit(42)

sys.exit(0)
