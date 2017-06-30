#!/usr/bin/env python
# Copyright 2014 the V8 project authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

import csv
import glob
import logging
import optparse
import sys

def MergeFiles(file_stem):
  in_files = sorted(glob.glob(file_stem + "-*.csv"))
  out_file = file_stem + ".csv"
  with open(in_files[0], "r") as f:
    header = f.readline().strip().split(",")
  with open(out_file, "w") as f:
    writer = csv.writer(f)
    writer.writerow(header)
    for pexec, in_file in enumerate(in_files):
      with open(in_file, "r") as f_in:
        f_in.readline().strip()  # Throw away header.
        for line in f_in.readlines():
          row_raw = line.split(",")[1:]  # Remove pexec from each row.
          row = [pexec]
          for s in row_raw:
              row.append(s.strip())
          writer.writerow(row)

def Main(args):
  logging.getLogger().setLevel(logging.INFO)
  parser = optparse.OptionParser()
  parser.add_option("--files",
                    help="Stem of filenames that need merging."
                    " For example:"
                    " --files sd-v8 will merge files like sd-v8-0.csv, sd-v8-1.csv"
                    " into sd-v8.csv.",
                    default="sd-v8-results")
  (options, args) = parser.parse_args(args)
  MergeFiles(options.files)

if __name__ == "__main__":  # pragma: no cover
  sys.exit(Main(sys.argv[1:]))
