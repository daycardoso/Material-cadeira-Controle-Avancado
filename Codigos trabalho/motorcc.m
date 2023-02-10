clc;clear all;
R = 8;
L = 0.8;
J = 1;
b = 1;
ki = 0.5;
kb = 0.5;
s = tf('s');
G = (ki)/(s*(s*L+R)*(s*J+b)+s*kb*ki)
n = [ 0 0 0 0.5];
m = [0.8 8.8 8.25 0];
[A,B,C,D] = tf2ss(n,m)
ctrb(A,B);
rank(ctrb(A,B))
obsv(A,C)
rank(obsv(A,C))