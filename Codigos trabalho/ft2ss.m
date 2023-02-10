clc;
n = [ 0 0 0 1.31e6 17423000];
m = [1 516.1 5.685e4 1.307e6 1.733e7];
sys = tf([ 0 0 0 1.31e6 17423000],[1 516.1 5.685e4 1.307e6 1.733e7])
%[n,m] = ss2tf(A,B,C,D)

[A,B,C,D] = tf2ss(n,m)
ctrb(A,B);
rank(ctrb(A,B))
obsv(A,C)
rank(obsv(A,C))