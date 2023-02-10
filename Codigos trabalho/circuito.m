clc; clear all;
R1 =10;
R2=8;
L1 = 0.5;
L2 = 0.25;
C1 = 1;
C2 =1;
A = [(-R1-R2)/L1 R2/L1 -1/L1 -1/L1
      R2/L2  -R2/L2 0 1/L2
      1/C1 0 0 0
      1/C2 -1/C2 0 0]
B = [1/L1
     0
     0
     0]
C = [0 -R2 0 0]
D=[0];
ctrb(A,B)
 rank(ctrb(A,B))
obsv(A,C)
rank(obsv(A,C))
 [n,m] = ss2tf(A,B,C,D);
 sys = tf([0 16 512 64 0],[1 68 136 80 8])
 [p,z] = pzmap(sys)

