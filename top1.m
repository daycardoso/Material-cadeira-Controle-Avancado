
clear all; close all; clc;

%%%%%%%%%%%% Definição das constantes do sistema %%%%%%%%%  Unidade: %%%%
R1 =10;
R2=8;
L1 = 0.5;
L2 = 0.25;
C1 = 1;
C2 =1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% Definição da matriz A e B do sistema %%%%%%%%%%%%%%%%%%%%%%%%
A = [(-R1-R2)/L1 R2/L2 -1/L1 -1/L1
      R2/L2  -R2/L2 0 1/L2
      1/C1 0 0 0
      1/C2 -1/C2 0 0];
B = [1/L1
     0
     0
     0];

x0=[5 3 0 0]'; % estado inicial do sistema

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% Declaração das variáveis simbólicas %%%%%%%%%%%%%%%%%%%%%%%%%
syms('s');
syms('k1','real');
syms('k2','real');
syms('k3','real');
syms('k4','real');
K=[k1 k2 k3 k4];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% Cálculo da dinâmica dos pólos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
din_controlador=det(s*eye(4)-(A-B*K));
din_desejada=(s+200)^4;
din_controlador_simp=collect(din_controlador)
din_desejada_simp=collect(din_desejada)
coef_cont=coeffs(din_controlador_simp,s)'
coef_dese=coeffs(din_desejada_simp,s)'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% Cálculo dos coeficientes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
equacoes=coef_cont-coef_dese;
[k1 k2 k3 k4]=solve(equacoes(1),equacoes(2),equacoes(3),equacoes(4),[k1,k2,k3,k4])
K=eval([k1 k2 k3 k4]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rss= 3; % yr

C=[1 0 0 0]; % matriz de obsevação apenas x1
D=[0]';

N=pinv([A B; C D])*[[0 0 0 0]'; 1];

Nx=N(1:4), Nu=N(5),
% Definindo a matriz de controlabilidade
M=[B A*B (A^2)*B (A^3)*B];
    
%Teste do posto da matriz M, para determinar a controlabilidade do
%sistema
det(M);
CONTROLABILIDADE=rank(M)
disp('Se o posto é igual a 4, o sistema é totalmente CONTROLÁVEL');
%%%% Polos do sistema %%%%%%
eqcar = poly(A);
polos=roots([eqcar]);


%%%%%%%%%%% Declaração das variáveis simbólicas %%%%%%%%%%%%%%%%%%%%%%%%%
syms('s');
syms('l1','real');
syms('l2','real');
syms('l3','real');
syms('l4','real');
L=[l1 l2 l3 l4]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% Cálculo da dinâmica Observador %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
din_observador=det(s*eye(4)-(A-L*C))
din_desejada=(s+400)^4
din_observador_simp=collect(din_observador)
din_desejada_simp=collect(din_desejada)
coef_obs=coeffs(din_observador_simp,s)'
coef_dese=coeffs(din_desejada_simp,s)'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% Cálculo dos coeficientes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
equacoes=coef_obs-coef_dese;
[l1 l2 l3 l4]=solve(equacoes(1),equacoes(2),equacoes(3),equacoes(4),[l1 l2 l3 l4])
L=eval([l1 l2 l3 l4]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N=Nu+K*Nx;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R = 1
Q = eye(4)
P = care(A,B,Q,R)
Kopt = inv(R)*B'*P


