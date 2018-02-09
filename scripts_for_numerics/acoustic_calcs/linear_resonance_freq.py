import os
import sys
import numpy as np
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-f", "--frequency", help="frequency in Hz", type=float, default=20000.0)
    parser.add_argument("-Rn", "--rad_at_rest", help="radius at rest R_n in meter(!)", type=float, default=50e-6)
    parser.add_argument("-r", "--rho", help="density of liquid", type=float, default=998.20608789369)
    parser.add_argument("-p", "--pstat", help="atmospheric pressure in Pa", type=float, default=101315.0)
    parser.add_argument("-m", "--mu", help="viscosity of liquid in kg/(ms)", type=float, default=1.002e-3)
    parser.add_argument("--pv", help="vapour pressure in Pa, default 0", type=float, default=0.0)
    parser.add_argument("--sigma", help="surface tension", type=float, default=0.0725)
    parser.add_argument("-g", "--gamma", help="ratio of specific heats", type=float, default=1.4)
    parser.add_argument("-s", "--solve_for", help="solve for either frequency or Rn", type=str, required = True, choices=['Rn','freq'])
    args = parser.parse_args()
    
    if args.solve_for == 'freq':
        freq = np.sqrt( 3.*args.gamma*(args.pstat + 2.*args.sigma/args.rad_at_rest - args.pv) - 2.*args.sigma/args.rad_at_rest - 4.*args.mu*args.mu/(args.rho*args.rad_at_rest*args.rad_at_rest) ) \
               / (2.*np.pi *args.rad_at_rest*np.sqrt(args.rho))
        print freq
    else:
        print "not yet implemented"

if __name__ == "__main__":
    main()