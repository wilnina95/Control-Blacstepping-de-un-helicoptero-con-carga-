%
%Extraido de la siguiente página
%http://www.motiongenesis.com/MGWebSite/MGGetStarted/MGExampleHelicopterRetrievalPendulum/
%%
%% Péndulo Esférico
% Simulación y animación de un péndulo esférico
%
%% 
clear ; close all ; clc
%% Escenario
% Parametros
l = 3;                              % Longitud [m]
% Condiciones iniciales
theta0  = pi/6;                     % Ángulo polar [rad]
phi0    = 0;                        % Azimuth [rad]
dtheta0 = 0;                        % d/dt(theta) [rad/s]
dphi0   = 3;                        % d/dt(phi) [rad/s]
x0 = [theta0 phi0 dtheta0 dphi0]';
% Parametros
tf      = 30;                       % Tiempo final [s]
fR      = 30;                       % Velocidad de fotogramas [fps]
dt      = 1/fR;                     % Tiempo de resolución [s]
time    = linspace(0,tf,tf*fR);     % Tiempo [s]
%% Simulación
[TOUT,XOUT] = ode45(@(t,x) pendulum(t,x,l),time,x0);
% Recuperación de estados
alpha   = XOUT(:,1);
beta    = XOUT(:,2);
dalpha  = XOUT(:,3);
dbeta   = XOUT(:,4);
% Coordenadas
rx = l*sin(alpha).*cos(beta);
ry = l*sin(alpha).*sin(beta);
rz = -l*cos(alpha);
%% Animation
% Ejes mínimo-máximo
min_x = min(rx)-l/2;
max_x = max(rx)+l/2;
min_y = min(ry)-l/2;
max_y = max(ry)+l/2;
min_z = min(rz)-l/2;
max_z = 0;
figure(1)
set(gcf,'Position',[50 50 640 640]) % Social
% Crea y abre un archivo de grabación de video
v = VideoWriter('spherical_pendulum.mp4','MPEG-4');
v.Quality = 100;
open(v);
    
hold on ; grid on ; axis equal
set(gca,'CameraPosition',[42.0101   30.8293   16.2256])
set(gca,'XLim',[min_x max_x])
set(gca,'YLim',[min_y max_y])
set(gca,'ZLim',[min_z max_z])
set(gca,'XTickLabel',[],'YTickLabel',[],'ZTickLabel',[])
for i = 1:length(rx)
    
    cla
    % Línea vertical
    plot3([0 0],[0 0],[0 -l],'k--')
    % Punto fijo (helicoptero)
    p = plot3(0,0,0,'Marker','*','Color','k','MarkerSize',10);
    % Trayectoria del péndulo
    plot3(rx(1:i),ry(1:i),rz(1:i),'b')
    % Cuerda del péndulo
    plot3([0 rx(i)],[0 ry(i)],[0 rz(i)],'r')
    % Esfera pendular
    plot3(rx(i),ry(i),rz(i),'Marker','o','Color','k','MarkerFaceColor','r','MarkerSize',10);
    % Proyecciones
    plot3(min_x*ones(1,i),ry(1:i),rz(1:i),'g')
    plot3(rx(1:i),min_y*ones(1,i),rz(1:i),'g')
    plot3(rx(1:i),ry(1:i),min_z*ones(1,i),'g')
    frame = getframe(gcf);
    writeVideo(v,frame);
    
end
close(v);
 
function dx = pendulum(~,x,l)
    
    % Parametros
    g = 9.81;                       % Gravedad [m/s2]
    % Variables de estado
    x1 = x(1);
    % x2 = x(2);
    x3 = x(3);
    x4 = x(4);
    % Ecuaciones de estado
    dx1 = x3;
    dx2 = x4;
    dx3 = (l*x4^2*sin(x1)*cos(x1) - g*sin(x1))/l;
    dx4 = -2*x3*x4/tan(x1);
    dx = [dx1 dx2 dx3 dx4]';
end