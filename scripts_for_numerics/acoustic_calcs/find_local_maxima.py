import os
import sys
import numpy as np
import argparse
from matplotlib import pyplot as plt
import scipy.integrate as integrate

def convolve_it(a):
    win_length = 15
    h = np.hamming(win_length)
    b = np.convolve(a.T[1],h)
    b = b*(a[2*win_length][1]/b[2*win_length])
    while len(b) > len(a.T[0]): b = np.delete(b,-1)
    while len(b) < len(a.T[0]): b = np.append(b,b[-1])
    return np.array([a.T[0],b]).T

def first_derivative(a):
    fd = np.array([0.])
    for i,_ in enumerate(a):
        if i > 0 and i < len(a)-1:
            value = ( a[i+1][1]-a[i-1][1] )/(a[i+1][0]-a[i-1][0])
            #print value
            fd = np.append(fd,[value] )
    fd = np.append(fd,0.)
    return fd

def get_local_max(fd,a,boxsize=20):
    step = boxsize-1
    idxmin = []
    b = []
    i = 0.
    while i < len(fd):
        box = fd[i:i+boxsize]
        j = np.argmin([np.abs(k) for k in box])
        if not (j == 0 or j == boxsize): idxmin.append(i+j)
        i+=step
    for idx in idxmin:   
        b.append(a[idx])
    return np.array(b)

def get_max_with_box(a,boxsize=20):
    transpose = a.T[1]
    mean = np.mean(transpose)
    stdv = np.std(transpose)
    step = boxsize-1
    idxmax = []
    b = []
    i = 0.
    while i < len(a):
        box = a[i:i+boxsize]
        j = np.argmax(box.T[1])
        if not (j == 0 or j == len(box)-1) and a[i+j][1] > mean+0.1*stdv: idxmax.append(i+j)
        i+=step
    for idx in idxmax:   
        b.append(a[idx])
    return np.array(b)

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
    outpath = "{}_local_maxima.dat".format(dpath.split('.xy')[0])
    
    np.savetxt(outpath, np.array(b), delimiter='  ', header='local_maxima from {}'.format(outpath))

if __name__ == "__main__":
    main()