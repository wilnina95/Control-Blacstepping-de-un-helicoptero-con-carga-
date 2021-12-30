%------Programa referenciado de https://www.researchgate.net -------

function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 1,
    sys=mdlDerivatives(t,x,u);
case 3,
    sys=mdlOutputs(t,x,u);
case {2,4,9}
    sys = [];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 6; %numero de constantes
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 6; %numero de salidas
sizes.NumInputs      = 2; %numero de entradsa
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 0;
sys=simsizes(sizes);
x0=[-27 5 -6 1.3 0 0]; %condiciones iniciales de  x 
str=[];
ts=[];
function sys=mdlDerivatives(t,x,u)
%-------------parametros de las variables de las ecuaciones diferenciales --------------
La=130;
Lw=50;
Lh=20;
k=0.5;
Mw=1880;
Mf=450;
Mb=450;
g=9.81;

u1=u(1);
u2=u(2);
%-------ecuaciones que intervienen  -----------
ka=(La*k)/(Mw*Lw^2+(Mf+Mb)*La^2);
kb=(Mw*Lw*g-Mf*La*g-Mb*La*g)/(Mw*Lw^2+(Mf+Mb)*La^2);
kc=(k)/(Mf*Lh+Mb*Lh);
kd=(Mb*g-Mf*g)/(Mf*Lh+Mb*Lh);
ke=(La*Mf+La*Mb-Lw*Mw)*g/(Mw*Lw^2+(Mf+Mb)*(La^2+Lh^2));
%-------EStacio de estados del modelamiento del helicóptero  -----------
sys(1)=x(2);
sys(2)=ka*u1+kb; 
sys(3)=x(4);
sys(4)=kc*u2+kd;
sys(5)=x(6);
sys(6)=ke*x(3); 
%salidas de la planta 
function sys=mdlOutputs(t,x,u)
sys(1)=x(2);
sys(2)=x(4);
sys(3)=x(6);
sys(4)=x(1);
sys(5)=x(3);
sys(6)=x(5);