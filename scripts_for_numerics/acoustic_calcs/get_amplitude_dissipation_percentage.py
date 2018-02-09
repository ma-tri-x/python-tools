import os
import sys
import numpy as np
import argparse
from find_local_maxima import *

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--path", help="path to the txt file of row-data like x-y-...", type=str, required=True)
    args = parser.parse_args()
    fpath = os.path.dirname(os.path.realpath(__file__))
    dpath = os.path.join(fpath, args.path)
    
    a = np.loadtxt(dpath)
    transpose = a.T[1]
    mean = np.mean(transpose)
    boxsize = int(len(a)/200)
    if boxsize < 10: boxsize = 10
    
    b = get_max_with_box(a, boxsize=boxsize)
    
    #plt.plot(a.T[0],a.T[1],'b.')
    #plt.plot(b.T[0],b.T[1],'ro')
    #plt.show()
    ratios = []
    for i in range(len(b)-1):
        ratios.append(((b[i+1][1]-mean)/(b[i][1]-mean) - 1)*100)
    print np.mean(ratios)
    #np.savetxt(outpath, np.array(local_max), fmt='%.6e', delimiter='  ', header='# local_maxima from {}'.format(dpath))

if __name__ == "__main__":
    main()