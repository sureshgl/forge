#!/usr/bin/env python3-3.3.1
import sys
import os
import re
import argparse
from collections import defaultdict

##Global message dictionary 
mesg_dict = defaultdict(list)

parser = argparse.ArgumentParser(description='Script to parse moresimple.rpt for readability and waiver generation')
parser.add_argument('-i', '--moresimple-rpt', required=True, help='moresimple.rpt file path')
parser.add_argument('-o', '--outfile', required=True, help='output file path')

args = parser.parse_args()

with open(args.moresimple_rpt) as f:
    for line in f:
        if line.startswith('['):
            ##Line starting with [ is a real message
            rid, rule, ralias, sev, rfile, line_no, wt, *unw = line.split()
            try:
                int(line_no)
                int(wt)
            except ValueError:
                #print("This line doesn't seem to have the alias mentioned")
                rid, rule, sev, rfile, line_no, wt, *unw = line.split()
                ralias = " "
                
            ## Small gimmick to find the start of the message string
            lidx = [line.find(wt+"  ")]
            while lidx[-1] != -1:
                lidx.append(line.find(wt+"  ", lidx[-1]+len(wt+"  ")))
            ridx = lidx[-2]+len(wt+"  ")
            mesg = line[ridx:]

            ## Filter out all the Info messages
            if sev != 'Info':
                mesg_dict[rfile].append((rid, rule, ralias, sev, line_no, wt, mesg.strip()))
            #print(rid, rule, ralias, sev, rfile, line_no, wt)

with open(args.outfile,'w') as f:
    for key in sorted(mesg_dict.keys()):
        rtl_lines = open(key,'rt').readlines() if os.path.exists(key) else None
        if rtl_lines != None:
            for k in rtl_lines:
                if re.match(r'^\s*module\s+(\w+)',k):
                    du = re.match(r'^\s*module\s+(\w+)',k).group(1)
                    break
                else:
                    du = "Unknown"
        f.write("#"*80+"\n")
        f.write("File: "+key+"\n")
        f.write("#"*80+"\n")
        for msg in mesg_dict[key]:
            rid, rule, ralias, sev, line_no, wt, mess = msg
            f.write("Rule: "+rule+"\n")
            f.write("Severity: "+sev+"\n")
            f.write("Message: "+mess+"\n")
            f.write("RTL Snippet: \n")
            if rtl_lines is not None:
                f.write("\t "+rtl_lines[int(line_no)-1])
            f.write("Waiver: \n")
            f.write("waive -du "+du+" -rule "+rule+" -msg \""+mess+"\" -comment \" \"\n")
            f.write("\n")
