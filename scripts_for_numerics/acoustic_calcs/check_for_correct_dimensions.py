import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--Rmax", help="max rad of bubble", type=float, required=True)
    parser.add_argument("--D", help="distance of bubble", type=float, required=True)
    parser.add_argument("--factRmax", help="domain-factor times Rmax", type=float, required=True)
    args = parser.parse_args()
    
    if (args.D + args.Rmax + 15e-6 > args.Rmax * args.factRmax) or args.D - args.Rmax - 15e-6 < 0.0:
        print "no"
    else:
        print "yes"