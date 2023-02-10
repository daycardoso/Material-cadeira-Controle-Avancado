
clear all; close all; clc;

%%%%%%%%%%%% Defini??o das constantes do sistema %%%%%%%%%  Unidade: %%%%
m1=2;          % massa do bloco 1                            [kg]
m2=1;          % massa do bloco 2                            [kg]
k1=10;         % constante da mola 1                         [N/m]
k2=10;         % constante da mola 2                         [N/m]
c2=1;          % coeficiente de atrito entre os blocos 1 e 2 [N.s/m]
x01=0.5;       % posi??o inicial do bloco 1                  [m]
x02=1;         % posi??o inicial do bloco 2                  [m]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% Defini??o da matriz A e B do sistema %%%%%%%%%%%%%%%%%%%%%%%%
A=[     0         0      1      0  ;...
        0         0      0      1  ;...
   -(k1+k2)/m1  k2/m1 -c2/m1  c2/m1;...
       k2/m2   -k2/m2  c2/m2 -c2/m2];
B=[0 0 1/m1 0]';
xo=[x01 x02 0 0]'; % estado inicial do sistema

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% Declara??o das vari?veis simb?licas %%%%%%%%%%%%%%%%%%%%%%%%%
syms('s');
syms('k1','real');
syms('k2','real');
syms('k3','real');
syms('k4','real');
K=[k1 k2 k3 k4];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% C?lculo da din?mica dos p?los %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
din_controlador=det(s*eye(4)-(A-B*K));
din_desejada=(s+4)^4;
din_controlador_simp=collect(din_controlador)
din_desejada_simp=collect(din_desejada)
coef_cont=coeffs(din_controlador_simp,s)'
coef_dese=coeffs(din_desejada_simp,s)'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% C?lculo dos coeficientes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
equacoes=coef_cont-coef_dese;
[k1 k2 k3 k4]=solve(equacoes(1),equacoes(2),equacoes(3),equacoes(4),[k1,k2,k3,k4])
K=eval([k1 k2 k3 k4]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rss= 0.5; % yr

C=[0 1 0 0]; % matriz de obseva??o apenas x1
D=[0]';

N=inv([A B; C D])*[[0 0 0 0]'; 1];

Nx=N(1:4), Nu=N(5),

%%%%%%%%%%% Declara??o das vari?veis simb?licas %%%%%%%%%%%%%%%%%%%%%%%%%
syms('s');
syms('l1','real');
syms('l2','real');
syms('l3','real');
syms('l4','real');
L=[l1 l2 l3 l4]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% C?lculo da din?mica Observador %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
din_observador=det(s*eye(4)-(A-L*C))
din_desejada=(s+8)^4
din_observador_simp=collect(din_observador)
din_desejada_simp=collect(din_desejada)
coef_obs=coeffs(din_observador_simp,s)'
coef_dese=coeffs(din_desejada_simp,s)'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% C?lculo dos coeficientes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
equacoes=coef_obs-coef_dese;
[l1 l2 l3 l4]=solve(equacoes(1),equacoes(2),equacoes(3),equacoes(4),'l1','l2','l3','l4')
L=eval([l1 l2 l3 l4]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N=Nu+K*Nx;
