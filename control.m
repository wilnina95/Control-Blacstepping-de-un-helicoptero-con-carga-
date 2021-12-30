%------Programa referenciado de https://www.researchgate.net -------

function [sys,x0,str,ts] = spacemodel(t,x,u,flag)
switch flag,
case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;
case 3,
    sys=mdlOutputs(t,x,u);
case {1,2,4,9}
    sys=[];
otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end
function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;%numero de salidas
sizes.NumInputs      = 7;%numero de entradas
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 0;
sys = simsizes(sizes);
x0  = [];
str = [];
ts  = [];
function sys=mdlOutputs(t,x,u)
%-------------parametros de las variables de las ecuaciones diferenciales --------------
La=130;
Lw=50;
Lh=20;
k=0.5;
Mw=1880;
Mf=450;
Mb=450;
g=9.81;
%-------ecuaciones que intervienen  -----------
ka=(La*k)/(Mw*Lw^2+(Mf+Mb)*La^2);
kb=(Mw*Lw*g-Mf*La*g-Mb*La*g)/(Mw*Lw^2+(Mf+Mb)*La^2);
kc=(k)/(Mf*Lh+Mb*Lh);
kd=(Mb*g-Mf*g)/(Mf*Lh+Mb*Lh);
ke=(La*Mf+La*Mb-Lw*Mw)*g/(Mw*Lw^2+(Mf+Mb)*(La^2+Lh^2));
%--------Señales de entrada del controlador ------------------------------%

x0=u(1); %señal senoidal
x1=u(2); %señal x(1)
x2=u(3); %señal x(2)
x3=u(4); %señal x(3)
dx1=u(5);
dx0=cos(t);
ddx0=-sin(t);
%dx2=u(6);
dx0=cos(t);

e=x1-x0;%error
de=dx1-dx0;% derivada error

e11=x2-x0;%error2
de1=dx1-dx0;% derivada error
%-------------parametros de las variables en la estimacion del error--------
ce1=0.5;
ce2=1.5;
ee1=0.3;
ee2=2.5;
ae=1.5;
xe=0.1;
ed=0.2;
%--------
cp1=0.2;
cp2=0.5;
ep1=1.5;
ep2=5.5;
ap=2.5;
xp=0.5;
pd=1.5;
%e1=((1-ce1^2+a3)*e+(ce1+ce2)*e11-ce1*ae*xe+de);
%e2=((1-cp1^2+ap)*ep1+(cp1+cp2)*ep2-cp1*ap*xp+de1);
e1=-0.008;
e2=-0.006;
%-----------Leyes de control propuestas en el paper ---------
ut=(1/La*k)*((Mw*Lw^2+(Mf+Mb)*La^2)*e1-Mw*Lw*g+(Mf+Mb)*La*g);
u2=(1/k)*((Mf*Lh+Mb*Lh)*e2-Mb*g+Mb*g);
%--------Salidas del controlador---------
sys(1)=ut;
sys(2)=u2;
sys(3)=e;
