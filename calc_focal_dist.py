#!/bin/python

import numpy as np
import matplotlib.pyplot as plt

DEBUG=False

class Ray(object):
    def __init__(self, startx, starty):
        self.x = [startx]
        self.y = [starty]
        self.nx= 1.0
        self.ny= 0.0
        self.use = True
        
    def pos_x(self,idx):
        return self.x[idx]
    
    def pos_y(self,idx):
        return self.y[idx]
    
    def add_pos(self,x,y):
        self.x.append(x)
        self.y.append(y)

class Lens(object):
    def __init__(self, offset_x=0., n=1.75, h=1e-2):
        self.offset_x=offset_x
        self.n = n
        self.h = h
        
    def left_x(self):
        return
    
    def right_x(self):
        return
        
    def _f(self, ray_inst, sidefunc, y):
        m_inv = ray_inst.nx/ray_inst.ny
        x0 = ray_inst.pos_x(-1)
        y0 = ray_inst.pos_y(-1)
        res = sidefunc(y) - (m_inv*(y-y0)+x0)
        return res
    
    def Newtonstep(self,ray_inst,sidefunc,yn):
        ynn= yn - self._f(ray_inst, sidefunc,yn)/((self._f(ray_inst, sidefunc,yn+1e-7)-self._f(ray_inst, sidefunc,yn-1e-7))/2e-7)
        if DEBUG: print "ynn = {}".format(ynn)
        return ynn
    
    def Newton_find_yzero(self, ray_inst, sidefunc):
        if np.abs(ray_inst.ny) < 1e-10:
            return ray_inst.pos_y(-1)
        epsilon = 1e-4
        yn = 0.
        ynn= self.Newtonstep(ray_inst,sidefunc,yn)
        while np.abs((ynn-yn)/(yn+1e-10)) > epsilon:
            yn = ynn
            ynn= self.Newtonstep(ray_inst,sidefunc,yn)
        return ynn
            
    def _rot_counterclock(self, phi, vec):
        b_vec = np.array([[np.cos(phi), np.sin(phi)],[-np.sin(phi),np.cos(phi)]]).dot(vec)
        return b_vec
            

    def refract_ray_curved(self,ray_inst, water_x):
        for sidefunc in [self.left_x,self.right_x]:
            if ray_inst.use:
                yhit = self.Newton_find_yzero(ray_inst, sidefunc)
                #if np.abs(yhit) > self.h/2. : ray_inst.add_pos(self.offset_x,yhit)
                #else:
                xhit = sidefunc(yhit)
                lens_deriv_x = sidefunc(yhit+1e-6) - sidefunc(yhit-1e-6)
                lens_tangential = np.array([lens_deriv_x,2e-6])
                lens_tangential /= np.linalg.norm(lens_tangential)
                lens_orthonormal = np.array([lens_tangential[1],-lens_tangential[0]])
                if lens_orthonormal[0] > 1e-8: 
                    lens_orthonormal *=-1
                
                if DEBUG: plt.arrow(xhit,yhit,lens_orthonormal[0]*1e-3,lens_orthonormal[1]*1e-3,head_width=0.,width=1e-4)
                
                nray = np.array([ray_inst.nx,ray_inst.ny])
                angle_left = np.arccos(nray.dot(lens_orthonormal))
                if angle_left > np.pi/2.: 
                    angle_left = np.pi - angle_left
                env_n = 1.0
                if xhit > water_x: env_n = 1.333
                ratio = env_n/self.n
                if sidefunc == self.right_x: ratio = 1./ratio
                if np.abs(ratio * np.sin(angle_left)) < 1.0:
                    angle_2 = np.arcsin(ratio * np.sin(angle_left))
                    angle_tilt = angle_left-angle_2
                    nrot = np.array([0.,0.])
                    if (nray+lens_orthonormal)[1] < 0.:
                        nrot = self._rot_counterclock(-angle_tilt,nray)
                    if (nray+lens_orthonormal)[1] >= 0.:
                        nrot = self._rot_counterclock( angle_tilt,nray)
                    ray_inst.nx = nrot[0]
                    ray_inst.ny = nrot[1]
                    ray_inst.add_pos(xhit,yhit)
                else:
                    angle_tilt = 2.*(np.pi/2. - angle_left)
                    nrot = np.array([0.,0.])
                    if (nray+lens_orthonormal)[1] < 0.:
                        nrot = self._rot_counterclock( angle_tilt,nray)
                    if (nray+lens_orthonormal)[1] >= 0.:
                        nrot = self._rot_counterclock(-angle_tilt,nray)
                    ray_inst.nx = nrot[0]
                    ray_inst.ny = nrot[1]
                    ray_inst.add_pos(xhit,yhit)
                    ray_inst.add_pos(xhit+nrot[0]*1e-3,yhit+nrot[1]*1e-3)
                    ray_inst.use = False
            
    def plot_lens(self):
        div = 20
        lyl = range(div+1)
        ly = [-self.h/2. + k*self.h/div for k in lyl]
        lx = [self.left_x(y) for y in ly]
        rx = [self.right_x(y) for y in ly]
        plt.plot(lx,ly)
        plt.plot(rx,ly)
        
class AsphLens(Lens):
    def __init__(self):
        self.info="thorlabs ACL7560U"
        self.R=31.384e-3
        self.k=-1.911
        self.A=5.0e-6
        self.d=30e-3
        self.n=1.43
        self.offset_x = Lens().offset_x
        self.h = Lens().h
        
    def left_x(self,y):
        x = (y*y/(self.R*(1.+np.sqrt(1.-(1.+self.k)*y*y/self.R/self.R))) + self.A*y*y*y*y) + self.offset_x   #/17.8e-3*27.7e-3
        return x
    
    def right_x(self,y):
        return self.left_x(0.0) + self.d
    
class SphLLens(Lens):
    def __init__(self, Rl, Rr, d):
        self.info="some spherical lens"
        self.R=Rl
        self.Rr=Rr
        self.d = d
        self.h = Lens().h
        self.n=1.43
        self.offset_x=Lens().offset_x
        
    def left_x(self,y):
        posx = np.sqrt(self.R*self.R - y*y) - self.offset_x - np.sqrt(self.R*self.R - self.h*self.h/4.)
        return -posx
    
    def right_x(self,y):
        if self.Rr=="inf":
            return self.d + self.offset_x
        else:
            return np.sqrt(self.Rr*self.Rr - y*y) + self.d + self.offset_x - np.sqrt(self.Rr*self.Rr - self.h*self.h/4.)
    
class ParabLens(Lens):
    def __init__(self, a, b, d):
        self.info="some spherical lens"
        self.a=a
        self.b=b
        self.d = d
        self.h = Lens().h
        self.n=1.43
        self.offset_x=Lens().offset_x
        
    def left_x(self,y):
        return self.a*y*y  + self.offset_x
    
    def right_x(self,y):
        return self.d + self.a*(self.h/2.)**2 + self.offset_x + self.b*(self.h/2.)**2 - self.b*y*y

class Beam(object):
    def __init__(self, width=5e-3, raycount=10, startx=-10e-3, water_x=0., endx=60e-3, debug=False):
        self.width = width
        self.startx = startx
        self.endx = endx
        self.water_x = water_x
        self.water_n = 1.333
        self.raycount = raycount
        self.rays = []
        self.lenses = []
        self.debug = debug
        for i in range(self.raycount):
            new_y = -self.width/2. + i*self.width/(self.raycount-1.)
            #print -self.width/2. + i*self.width/(self.raycount-1.)
            self.rays.append(Ray(startx,new_y))
        
    def end(self):
        for i in self.rays:
            if i.use:
                if DEBUG: print i.nx, i.ny
                endx = self.endx
                last_y = 0.
                if i.ny > i.nx: endx = i.pos_x(-1) + 1e-4 
                last_y = i.ny/i.nx * endx + (i.pos_y(-1) - i.ny/i.nx*i.pos_x(-1))
                i.add_pos(self.endx,last_y)
            
    #def write_output(self):
        #with open("out.dat", 'w') as out:
            #for ray in self.rays:
                #for j,x in enumerate(ray.x):
                    #out.write("{}  {}\n".format(x,ray.y[j]))
                #out.write("\n")
    
    def add_lens(self,lens_inst):
        self.lenses.append(lens_inst)
        
    def refract_rays(self):
        for lens in self.lenses:
            for num,ray in enumerate(self.rays):
                print "---{}---".format(num)
                lens.refract_ray_curved(ray,self.water_x)
                
    def plot_rays(self):
        for ray in self.rays:
            if DEBUG: plt.plot(ray.x,ray.y,'o-')
            else: plt.plot(ray.x,ray.y)
        
    
class WaterLens(Beam,Lens):
    def __init__(self):
        self.h = Lens().h
        self.d = 1e-3
        self.n = 1.333
        self.offset_x = Beam().water_x
            
    def left_x(self,y):
        return self.offset_x
    
    def right_x(self,y):
        return self.offset_x + self.d
    
    
class Bubble(Lens):
    def __init__(self, R=1e-3, offset_x=0.):
        self.R = R
        self.h = 2*R
        self.n = 1.0
        self.offset_x = offset_x
            
    def left_x(self,y):
        if np.abs(y) > self.R: return self.offset_x
        return self.offset_x - np.sqrt(self.R**2 - y*y)
    
    def right_x(self,y):
        if np.abs(y) > self.R: return self.offset_x
        return self.offset_x + np.sqrt(self.R**2 - y*y)
            
        
        
def main():
    beam = Beam(width=1.9e-3,raycount = 10, water_x=-6e-3, startx=-6e-3, endx=10e-3)
    h=0.0254

    #best_form_lens_f50_1inch = SphLLens(d=3.3e-3, Rl=0.172, Rr=30.1e-3)
    #best_form_lens_f50_1inch.h = h
    #best_form_lens_f50_1inch.offset_x = 0.
    #best_form_lens_f50_1inch.plot_lens()
    #beam.add_lens(best_form_lens_f50_1inch)

    #par = ParabLens(d=1e-3,a=20, b=0)
    #par.h = h
    #par.plot_lens()
    #beam.add_lens(par)
    
    #asph = AsphLens()
    #asph.offset_x=-30e-3
    #asph.h=h
    #asph.plot_lens()
    #beam.add_lens(asph)

    bubble = Bubble(R=1e-3)
    bubble.plot_lens()
    beam.add_lens(bubble)
    
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
    plt.show()
  
if __name__ == '__main__':
    main()