import os
import sys
import numpy as np
import argparse
from matplotlib import pyplot as plt

def get_max_from_second_column(a):
    return np.max(a.T[1])

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--path", help="path to the txt file of row-data like t-CoNum-...", type=str, required=True)
    args = parser.parse_args()
    fpath = os.path.dirname(os.path.realpath(__file__))
    dpath = os.path.join(fpath, args.path)
    
    a = np.loadtxt(dpath)
    
    print get_max_from_second_column(a)

if __name__ == "__main__":
    main()