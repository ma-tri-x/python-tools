#!/bin/python

import numpy as np
import matplotlib.pyplot as plt
from optical_raytracer import *

        
def main():
    #beam = Beam(width=1.99e-3,raycount = 20, water_x=-6e-3, startx=-6e-3, endx=10e-3)
    #beam = Beam(width=15e-3,raycount = 9, water_x=100e-3, startx=-100e-3, endx=100e-3)
    beam = Beam(width=25.4e-3,raycount = 9, water_x=0.0, startx=-10e-3, endx=120e-3)
    h=0.0254

    focal_dist = 50.8e-3

    for inst_num,_ in enumerate(beam.rays):
        alpha = np.arctan(beam.rays[inst_num].pos_y(-1)/focal_dist)
        beam.rays[inst_num].nx = np.cos(alpha)
        beam.rays[inst_num].ny = -np.sin(alpha)

    cuvette = WaterLens(d=119e-3)
    cuvette.h = h
    cuvette.offset_x = -0.001
    cuvette.plot_lens()
    beam.add_lens(cuvette)

    #best_form_lens_f50_1inch = SphLLens(d=3.3e-3, Rl=0.172, Rr=30.1e-3)
    #best_form_lens_f50_1inch.h = h
    #best_form_lens_f50_1inch.offset_x = 0.
    #best_form_lens_f50_1inch.plot_lens()
    #beam.add_lens(best_form_lens_f50_1inch)
    
    #mirror = MirrorF50(offset_x=10e-3)
    ##mirror = ParabMirror(offset_x=10e-3,d=2e-3,h=h)
    ##mirror.plot_mirror()
    ##beam.add_lens(mirror)
    
    ##water = NegativeCuvette(d=40e-3,offset_x=-10e-3)
    ##water.h = h
    ##water.plot_lens()
    ##beam.add_lens(water)
    
    #par = ParabLens(d=1e-3,a=20, b=0)
    #par.h = h
    #par.plot_lens()
    #beam.add_lens(par)
    
    #asph = AsphLens()
    #asph.offset_x=-30e-3
    #asph.h=h
    #asph.plot_lens()
    #beam.add_lens(asph)

    #bubble = Bubble(R=1e-3)
    #bubble.plot_lens()
    #beam.add_lens(bubble)
    
    #wat = WaterLens()
    #wat.h=h
    #wat.offset_x=10e-3
    #wat.d = 10e-3
    #wat.plot_lens()
    #beam.add_lens(wat)

    beam.refract_rays()
    beam.end()
    beam.plot_rays()
    
    plt.axis('equal')
    plt.grid(False)
    plt.show()
  
if __name__ == '__main__':
    main()