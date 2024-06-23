#!/usr/local/bin/python3
# encoding: utf-8
'''
Script to convert binary image file to Memory Initialization File (MIF)

Created by Bruno Duarte Gouveia
Updated by ChatGPT

@contact: bgouveia@gmail.com
'''

from argparse import ArgumentParser

__version__ = 0.1
__date__ = '2012-11-18'
__updated__ = '2024-06-22'

def parsefile(filename):
    with open(filename, 'r') as inputfile:
        read_data = inputfile.read().strip().replace('\n', '')

    # Each bit is a separate address
    return [bit for bit in read_data]

def writefile(filename, data):
    with open(filename, "w") as f:
        f.write(f"WIDTH=1;\nDEPTH={len(data)};\n\n")
        f.write("ADDRESS_RADIX=HEX;\nDATA_RADIX=BIN;\n\nCONTENT BEGIN\n")
        for i, bit in enumerate(data):
            f.write(f"\t{i:X}   :   {bit};\n")
        f.write("END;\n")

def main():
    parser = ArgumentParser(description='Convert binary image file to MIF')
    parser.add_argument("inputfile", help="path to input file")
    parser.add_argument("outputfile", help="path to output file")
    
    args = parser.parse_args()
    inputfile = args.inputfile
    outputfile = args.outputfile
    
    print(f"Input: {inputfile}")
    print(f"Output: {outputfile}")
        
    data = parsefile(inputfile)
    writefile(outputfile, data)

if __name__ == "__main__":
    main()
