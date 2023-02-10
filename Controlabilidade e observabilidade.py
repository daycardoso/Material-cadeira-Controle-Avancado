import numpy as np
import matplotlib.pyplot as plt
import control as co
import sympy as sp
from scipy import linalg

s = sp.symbols('s')


#NAO FACO IDEIA - DESNECESSARIO TALVEZ
#plt.rcParams["figure.figsize"] = [23,10]
#plt.rcParams["font.size"] = 24

#Definicao matrizes
A = np.array([[-7,-12],[1,0]])
B = np.array([[1,0],[2,-1]])
C = np.array([[1,0],[1,-1]])
D = np.array([[1,0],[0,0]])

#Controlabilidade
M = co.ctrb(A,B)
print(M)
print(np.linalg.matrix_rank(M))

#Observabilidade
N = co.obsv(A,C)
print(N)
print(np.linalg.matrix_rank(N))

#Modelo em espaço de estados
sys7 = co.ss(A,B,C,D)
print(sys7)

#Tranformar de EE em FT, deu errado :(
#sys7_tf = co.ss2tf(sys7)
#print(sys7_tf)

#Verifica cancelamento de polos e zeros
#co.minreal(sys7)

#Calculando a matriz da ft
F = s*np.identity(2)-A
print(F)


G = np.linalg.inv(F)
print(G)
