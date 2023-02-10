import numpy as np

def RK4(f): return lambda x, u, dt:(lambda dx1:(lambda dx2:(lambda dx3:(lambda
dx4:(dx1+2*dx2+2*dx3+dx4)/6)(dt*f(x+dx3,u)))(dt*f(x+dx2/2,u)))(dt*f(x+dx1/2,u)))(dt*f(x,u))

dx = RK4(lambda x, u: A@x + B@u)
m1=2.0; m2=1.0; k1=10.0; k2=10.0; c1=0; c2=1.0;

A = np.array([[0,0,1,0],[0,0,0,1],[-(k1+k2)/m1,k2/m1,-(c1+c2)/m1,c2/m1],[k2/m2,-k2/m2,c2/m2,-c2/m2]])
B = np.array([[0],[0],[1/m1],[0]])
C = np.array([[0,1,0,0]])
D = np.array([[0]])
K = np.array([[105.92,-64.72,29,17.08]])
N = np.array([[51.2]])

t, tf, dt, u, x, r = 0, 10, .01, np.array([[0]]), np.array([[0.5],[1],[0],[0]]), np.array([[-10]])
X, U, T = x, u, t

for i in range(int((tf-t)/dt)):
   t, x = t + dt, x + dx(x,u,dt)
   u = N@r-K@x
   X, U, T = np.append(X,x,axis=1), np.append(U,u,axis=1), np.append(T,t)

Y = C@X+D@U

import matplotlib.pyplot as plt
plt.plot(T,Y[0],'k')
plt.xlabel('tempo (s)')
plt.ylabel('x2 (m)')
plt.grid(True)
plt.show()