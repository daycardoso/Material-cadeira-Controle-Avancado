# Programa desenvolvido para a disciplina de Tópicos em Controle Avançado
# Prof.: Dr. Vitor Gervini (vitor.gervini@gmail.com)
# Fundação Universidade Federal do Rio Grande - FURG
# Data: 03/07/2020

import numpy as np
import matplotlib.pyplot as plt
from vpython import *

def dados_simul():
    RK4 = lambda f : lambda x , dt, temp = 0 :(lambda dx1:(lambda dx2:(lambda dx3:(lambda dx4:(dx1+2*dx2+2*dx3+dx4)/6)(dt*f(x+dx3,temp)))(dt*f(x+dx2/2,temp)))(dt*f(x+dx1/2,temp)))(dt*f(x,temp))
    dx = RK4(lambda x, temp: A@x + B@u)

    m1=2.0; m2=1.0; k1=10.0; k2=10.0; b1=0; b2=1.0
    A = np.array([[0,0,1,0],
                  [0,0,0,1],
                  [-(k1+k2)/m1,k2/m1,-(b1+b2)/m1,b2/m1],
                  [k2/m2,-k2/m2,b2/m2,-b2/m2]])
    B = np.array([[0],[0],[1/m1],[0]])

    t0, tf, dt = 0, 20, .01
    x0, u0 = np.array([[3],[-1],[0],[0]]), np.vstack(np.zeros(B.shape[1]))

    T, X, U = t, x, u = t0, x0, u0

    for i in range(int((tf-t0)/dt)):
        t, x = t + dt, x + dx(x,dt)
        T, X, U = np.append(T,t), np.append(X,x,axis=1), np.append(U,u,axis=1)

    f1, f2 = U[0], U[0]
    
    return T, X, f1, f2

def imprime():
    plt.plot(T,X[0],'k')
    plt.xlabel('tempo (s)')
    plt.ylabel('x1 (m)')
    plt.grid(True)
    plt.show()

    plt.plot(T,X[1],'k')
    plt.xlabel('tempo (s)')
    plt.ylabel('x2 (m)')
    plt.grid(True)
    plt.show()

    plt.figure()
    plt.plot(T,f1,'k')
    plt.xlabel('tempo (s)')
    plt.ylabel('f1 (N)')
    plt.grid(True)
    plt.show()

    plt.figure()
    plt.plot(T,f2,'k')
    plt.xlabel('tempo (s)')
    plt.ylabel('f2 (N)')
    plt.grid(True)
    plt.show()

def inicializa():
    tam_eixo, tam_cubo, tam_mola, esp_chao = 2, 2, 5, .05
    cena1 = canvas(title='Simulação massa-mola-amortecedor com controle',width=640,height=300,center=vector(8,0,0),background=color.white) #scroll = True)#,xmin=-20, xmax=50, ymin=-2e3, ymax=5e3)
    dir1 = vector(1,0,0)
    dir2 = -dir1
    forca1 = arrow(pos=vector(0,tam_cubo,0),axis=dir1,color=color.green)
    forca2 = arrow(pos=vector(0,tam_cubo,0),axis=dir1,color=color.red)
    mola1 = helix(vector=dir,thickness=.2,color=color.blue)
    mola2 = helix(vector=dir,thickness=.2,color=color.blue)
    arrow(axis=vector(tam_eixo,0,0),color=color.red), arrow(axis=vector(0,tam_eixo,0),color=color.green), arrow(axis=vector(0,0,tam_eixo),color=color.blue)
    massa1=box(opacity=.5,size=2*tam_cubo*vec(1,1,1),color=color.green)
    massa2=box(opacity=.5,size=2*tam_cubo*vec(1,1,1),color=color.red)
    chao= box(pos=vec(15,-(tam_cubo+esp_chao),0),size=vec(30,2*esp_chao,2*tam_cubo),color=vec(.8, .8, .8))
    graf1 = graph(title='Posição', width=600, height=300,xtitle='<i>t</i> (s)', ytitle='<i>x</i><sub>1</sub> (m)    <i>x</i><sub>2</sub> (m)',
                  fast=True,xmin=T.min(),xmax=T.max())
    graf2 = graph(title='Força', width=600, height=300,xtitle='<i>t</i> (s)', ytitle='<i>F</i><sub>1</sub> (N)  <i>F</i><sub>2</sub> (N)',
                  fast=True,xmin=T.min(),xmax=T.max())
    graf3 = graph(title='Velocidade', width=600, height=300,xtitle='<i>t</i> (s)', ytitle='<i>v</i><sub>1</sub> (m/s)    <i>v</i><sub>2</sub> (m/s)',
                  fast=True,xmin=T.min(),xmax=T.max())
    return (forca1,forca2,mola1,mola2,massa1,massa2,gcurve(graph=graf1,color=color.green), gcurve(graph=graf1,color=color.red),
            gcurve(graph=graf2,color=color.green), gcurve(graph=graf2,color=color.red),
            gcurve(graph=graf3,color=color.green), gcurve(graph=graf3,color=color.red),
            tam_cubo,tam_mola)

def move():
    delta_f = lambda x: 0 if x<0 else 2*tam_cubo
    gx1.delete(), gx2.delete(), gf1.delete(), gf2.delete(), gv1.delete(), gv2.delete()
    x1, x2, v1, v2 = X[0]+tam_mola, X[1]+2*(tam_mola+tam_cubo), X[2], X[3]
    disp_rate = 1/(T[1]-T[0])

    for i in range(len(T)):
        rate(disp_rate)
        mola1.axis.x = x1[i]
        massa1.pos.x = x1[i]+tam_cubo
        mola2.pos.x, mola2.axis.x = x1[i]+2*tam_cubo, x2[i]-x1[i]-2*tam_cubo
        massa2.pos.x = x2[i]+tam_cubo
        forca1.pos.x, forca1.axis.x = x1[i]+delta_f(f1[i]), f1[i]/2
        forca2.pos.x, forca2.axis.x = x2[i]+delta_f(f2[i]), f2[i]/2
        gx1.plot(T[i],X[0][i]), gx2.plot(T[i],X[1][i])
        #gx1.plot(T[i],x1[i]), gx2.plot(T[i],x2[i])
        gv1.plot(T[i],X[2][i]), gv2.plot(T[i],X[3][i])
        gf1.plot(T[i],f1[i]), gf2.plot(T[i],f2[i])

T,X,f1,f2 = dados_simul()
imprime()
forca1,forca2,mola1,mola2,massa1,massa2,gx1,gx2,gf1,gf2,gv1,gv2,tam_cubo,tam_mola = inicializa()
move()
