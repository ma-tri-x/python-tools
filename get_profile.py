#import os
#import sys
#import json
#import shutil
#import re
import numpy as np
import cv2
import pylab as plt
import argparse

def get_profile(img, pos, width, along_picture_axis):
    if along_picture_axis==1:
        cut = img[pos-width/2:pos+width/2, 0:-1]
        px_idx = 0
        avg = []
        while px_idx < cut.shape[1]:
            val_sum = 0
            for line in cut[0:-1,px_idx:px_idx+width-1]:
                val_sum += np.average(np.array(line))/float(width)
            avg.append(val_sum)
            px_idx += width-1
        return avg
    if along_picture_axis==0:
        cut = img[0:-1,pos-width/2:pos+width/2]
        px_idx = 0
        avg = []
        while px_idx < cut.shape[0]:
            val_sum = 0
            for line in cut[px_idx:px_idx+width-1]:
                val_sum += np.average(np.array(line))/float(width)
            avg.append(val_sum)
            px_idx += width-1
        #cv2.imshow('bla',cut)
        #cv2.waitKey(0)
        #cv2.destroyAllWindows()
        return avg        
        

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-f", "--file", help="tif file to convert", type=str, required=True)
    parser.add_argument("-w", "--width", help="width of averaging pixels", type=int, default=10)
    parser.add_argument("-x", "--xpos", help="position on x-axis of line along yaxis in pixels", type=int, default=None)
    parser.add_argument("-y", "--ypos", help="position on y-axis of line along xaxis in pixels", type=int, default=None)
    args = parser.parse_args()
    
    
    
    img = cv2.imread(args.file)
    if img is None:
        print "img is empty"
        exit(1)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    # Draw a diagonal blue line with thickness of 5 px
    im_color = cv2.applyColorMap(gray, cv2.COLORMAP_JET)
    # YOU DONT BELIEVE BUT FOR PICTURES FIRST AXIS IS Y FROM TOP TO BOTTOM
    # SECOND AXIS IS X FROM LEFT TO RIGHT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    posx = gray.shape[1]/2
    posy = gray.shape[0]/2
    if args.xpos != None and args.xpos < gray.shape[1] and args.xpos > 0: posx = args.xpos
    if args.ypos != None and args.ypos < gray.shape[0] and args.ypos > 0: posy = args.ypos
    x_avg = get_profile(img=gray, pos=posy, width=args.width, along_picture_axis=1)
    y_avg = get_profile(img=gray, pos=posx, width=args.width, along_picture_axis=0)
    
    # YOU DONT BELIEVE BUT FOR LINE, NORMAL X-Y_SYTEM IS EXPECTED AGAIN!!!!!
    cv2.line(gray,(0,posy),(gray.shape[1],posy),(0,0,0),args.width)
    cv2.line(gray,(posx,0),(posx,gray.shape[0]),(0,0,0),args.width)
    
    
    plt.close('all')
    
    fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2,2) #, sharex='col', sharey='row')
    im = ax4.imshow(gray, vmin=0, vmax=255, cmap='jet') #, aspect='true')
    ax4.set_xlim(0,gray.shape[1])
    #ax4.set_ylim(0,gray.shape[0])
    
    fig.subplots_adjust(right=0.8)
    cbar_ax = fig.add_axes([0.85, 0.15, 0.05, 0.7])
    fig.colorbar(im, cax=cbar_ax)
    
    x_array = []
    for i,_ in enumerate(x_avg):
        x_array.append(float(args.width/2 + i*args.width))
    y_array = []
    for i,_ in enumerate(y_avg):
        y_array.append(float(args.width/2 + i*args.width))
    
    ax1.axis('off')
    
    ax2.plot(x_array,x_avg)
    ax3.invert_yaxis()
    ax3.plot(y_avg, y_array)
    
    np.savetxt("{}_x.dat".format((args.file).split(".tif")[0]), np.column_stack([x_array,x_avg]))
    np.savetxt("{}_y.dat".format((args.file).split(".tif")[0]), np.column_stack([y_array,y_avg]))
    
    
    plt.show()
    
    


if __name__ == '__main__':
    main()