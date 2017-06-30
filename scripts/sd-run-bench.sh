#!/bin/sh

NPEXECS=30  # Number of process executions (30 in the warmup paper).
CSV_FILES=sd-v8-results  # File stem only.
PDF=sd-v8-plots.pdf
TABLE=sd-v8-table.tex
TEX2PDF=pdflatex

# Generate one CSV file for each process execution.
i=0
while [ "$i" -lt "$NPEXECS" ]
do
    echo Process execution: "$i"
    tools/sd_run_perf.py --arch x64 --binary-override-path out.gn/x64.release/d8 benchmarks/sd-v8.json --csv-test-results "$CSV_FILES"-"$i".csv
    i=`expr $i + 1 `
done

tools/sd_merge_csv.py --files "$CSV_FILES"

../warmup_stats/bin/csv_to_krun_json -l javascript -v V8 -u "`uname -a`" "$CSV_FILES".csv

../warmup_stats/bin/warmup_stats --output-plots "$PDF" -l javascript -v V8 -u "`uname -a`" "$CSV_FILES".csv
../warmup_stats/bin/warmup_stats --output-latex "$TABLE" -l javascript -v V8 -u "`uname -a`" "$CSV_FILES".csv
"$TEX2PDF" "$TABLE"
