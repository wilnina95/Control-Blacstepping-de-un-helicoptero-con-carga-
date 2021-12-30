%%
%Código creado a partir de la siguiente página.
%http://www.motiongenesis.com/MGWebSite/MGGetStarted/MGExampleHelicopterRetrievalPendulum/
%%
function[t,VAR,Output]=HelicopterRetrievalODE
clc; clear;
eventDetectedByIntegratorTerminate1OrContinue0=[];
thetapp=0; 
L=0; 
Lp=0;

%----------------------------+--------------------------+-------------------+-----------------
% Cantidad                   | Valor                    | Unidad            | Descripción
%----------------------------|--------------------------|-------------------|-----------------
g                               =  9.8;                    % m/sec^2          Constante

theta                           =  1;                      % deg              Valor inicial
thetap                          =  0;                      % deg/sec          Valor inicial

tInitial                        =  0.0;                    % second           Tiempo inicial
tFinal                          =  24.92;                  % sec              Tiempo final
integStp                        =  0.02;                   % sec              Etapa de integración
printIntScreen                  =  1;                      % 0 or +integer    Impresión de numeros
printIntFile                    =  1;                      % 0 or +integer    Impresión de numeros
absError                        =  1.0E-05;                %                  Error absoluto
relError                        =  1.0E-08;                %                  Error relativo
%---------------------------------------------------------------------------------------------

% Unidades de conversión
DEGtoRAD = pi / 180.0;
RADtoDEG = 180.0 / pi;
theta = theta * DEGtoRAD;
thetap = thetap * DEGtoRAD;

VAR = SetMatrixFromNamedQuantities;
[t,VAR,Output] = IntegrateForwardOrBackward( tInitial, tFinal, integStp, absError, relError, VAR, printIntScreen, printIntFile );
OutputToScreenOrFile( [], 0, 0 );   % Cierra los archivos de salida
PlotOutputFiles;


%===========================================================================
function sys = mdlDerivatives(t,VAR,uSimulink)
%===========================================================================
SetNamedQuantitiesFromMatrix( VAR );
% Cantidades especificadas
L = 50 - 2*t;
Lp = -2;

thetapp = -(g*sin(theta)+2*Lp*thetap)/L;

sys = transpose( SetMatrixOfDerivativesPriorToIntegrationStep );
end


%===========================================================================
function VAR = SetMatrixFromNamedQuantities
%===========================================================================
VAR = zeros(1,2);
VAR(1) = theta;
VAR(2) = thetap;
end


%===========================================================================
function SetNamedQuantitiesFromMatrix( VAR )
%===========================================================================
theta = VAR(1);
thetap = VAR(2);
end


%===========================================================================
function VARp = SetMatrixOfDerivativesPriorToIntegrationStep
%===========================================================================
VARp = zeros(1,2);
VARp(1) = thetap;
VARp(2) = thetapp;
end



%===========================================================================
function Output = mdlOutputs( t, VAR, uSimulink )
%===========================================================================
Output = zeros(1,2);
Output(1) = t;
Output(2) = theta*RADtoDEG;
end


%===========================================================================
function OutputToScreenOrFile( Output, shouldPrintToScreen, shouldPrintToFile )
%===========================================================================
persistent FileIdentifier hasHeaderInformationBeenWritten;

if( isempty(Output) ),
   if( ~isempty(FileIdentifier) ),
      fclose( FileIdentifier(1) );
      clear FileIdentifier;
      fprintf( 1, '\n Output is in the file HelicopterRetrievalODE.1\n\n' );
   end
   clear hasHeaderInformationBeenWritten;
   return;
end

if( isempty(hasHeaderInformationBeenWritten) ),
   if( shouldPrintToScreen ),
      fprintf( 1,                '%%       t            theta\n' );
      fprintf( 1,                '%%     (sec)        (degrees)\n\n' );
   end
   if( shouldPrintToFile && isempty(FileIdentifier) ),
      FileIdentifier(1) = fopen('HelicopterRetrievalODE.1', 'wt');   if( FileIdentifier(1) == -1 ), error('Error: unable to open file HelicopterRetrievalODE.1'); 
   end
      fprintf(FileIdentifier(1), '%% FILE: HelicopterRetrievalODE.1\n%%\n' );
      fprintf(FileIdentifier(1), '%%       t            theta\n' );
      fprintf(FileIdentifier(1), '%%     (sec)        (degrees)\n\n' );
   end
   hasHeaderInformationBeenWritten = 1;
end

if( shouldPrintToScreen ), WriteNumericalData( 1,                 Output(1:2) );  
end
if( shouldPrintToFile ),   WriteNumericalData( FileIdentifier(1), Output(1:2) );  
end
end


%===========================================================================
function WriteNumericalData( fileIdentifier, Output )
%===========================================================================
numberOfOutputQuantities = length( Output );
if( numberOfOutputQuantities > 0 ),
   for( i = 1 : numberOfOutputQuantities ),
      fprintf( fileIdentifier, ' %- 14.6E', Output(i) );
   end
   fprintf( fileIdentifier, '\n' );
end
end



%===========================================================================
function PlotOutputFiles
%===========================================================================
if( printIntFile == 0 ),  return;  end
figure;
data = load( 'HelicopterRetrievalODE.1' ); 
plot( data(:,1),data(:,2),'-b', 'LineWidth',3 );
legend( 'theta (degrees)' );
xlabel('t (sec)');   ylabel('theta (degrees)');
title('Péndulo en movimiento por un helicóptero');
clear data;
end



%===========================================================================
function [functionsToEvaluateForEvent, eventTerminatesIntegration1Otherwise0ToContinue, eventDirection_AscendingIs1_CrossingIs0_DescendingIsNegative1] = EventDetection( t, VAR, uSimulink )
%===========================================================================
% Detecta cuando las funciones designadas son cero o cruzan el cero con pendiente positiva o negativa.
% Paso 1: Uncomment call to mdlDerivatives.
% Paso 2: Change functionsToEvaluateForEvent,                      e.g., change  []  to  [t - 5.67]  to stop at t = 5.67.
% Paso 3: Change eventTerminatesIntegration1Otherwise0ToContinue,  e.g., change  []  to  [1]  to stop integrating.
% Paso 4: Change eventDirection_AscendingIs1_CrossingIs0_DescendingIsNegative1,  e.g., change  []  to  [1].
%----------------------------------------------------------------------
% mdlDerivatives( t, VAR, uSimulink );   % UNCOMMENT FOR EVENT HANDLING
functionsToEvaluateForEvent = [];
eventTerminatesIntegration1Otherwise0ToContinue = [];
eventDirection_AscendingIs1_CrossingIs0_DescendingIsNegative1 = [];
eventDetectedByIntegratorTerminate1OrContinue0 = eventTerminatesIntegration1Otherwise0ToContinue;
end


%===========================================================================
function [isIntegrationFinished, VAR] = EventDetectedByIntegrator( t, VAR, nIndexOfEvents )
%===========================================================================
isIntegrationFinished = eventDetectedByIntegratorTerminate1OrContinue0( nIndexOfEvents );
if( ~isIntegrationFinished ),
   SetNamedQuantitiesFromMatrix( VAR );
%  
   VAR = SetMatrixFromNamedQuantities;
end
end



%===========================================================================
function [t,VAR,Output] = IntegrateForwardOrBackward( tInitial, tFinal, integStp, absError, relError, VAR, printIntScreen, printIntFile )
%===========================================================================
OdeMatlabOptions = odeset( 'RelTol',relError, 'AbsTol',absError, 'MaxStep',integStp, 'Events',@EventDetection );
t = tInitial;                 epsilonT = 0.001*integStp;                tFinalMinusEpsilonT = tFinal - epsilonT;
printCounterScreen = 0;       integrateForward = tFinal >= tInitial;    tAtEndOfIntegrationStep = t + integStp;
printCounterFile   = 0;       isIntegrationFinished = 0;
mdlDerivatives( t, VAR, 0 );
while 1,
   if( (integrateForward && t >= tFinalMinusEpsilonT) || (~integrateForward && t <= tFinalMinusEpsilonT) ), isIntegrationFinished = 1;  end
   shouldPrintToScreen = printIntScreen && ( isIntegrationFinished || printCounterScreen <= 0.01 );
   shouldPrintToFile   = printIntFile   && ( isIntegrationFinished || printCounterFile   <= 0.01 );
   if( isIntegrationFinished || shouldPrintToScreen || shouldPrintToFile ),
      Output = mdlOutputs( t, VAR, 0 );
      OutputToScreenOrFile( Output, shouldPrintToScreen, shouldPrintToFile );
      if( isIntegrationFinished ), break;  end
      if( shouldPrintToScreen ), printCounterScreen = printIntScreen;  end
      if( shouldPrintToFile ),   printCounterFile   = printIntFile;    end
   end
   [TimeOdeArray, VarOdeArray, timeEventOccurredInIntegrationStep, nStatesArraysAtEvent, nIndexOfEvents] = ode45( @mdlDerivatives, [t tAtEndOfIntegrationStep], VAR, OdeMatlabOptions, 0 );
   if( isempty(timeEventOccurredInIntegrationStep) ),
      t = TimeOdeArray( length(TimeOdeArray) );
      VAR = VarOdeArray( length(TimeOdeArray), : );
      printCounterScreen = printCounterScreen - 1;
      printCounterFile   = printCounterFile   - 1;
      if( abs(tAtEndOfIntegrationStep - t) >= abs(epsilonT) ), warning('numerical integration failed'); break;  end
      tAtEndOfIntegrationStep = t + integStp;
   else
      t = timeEventOccurredInIntegrationStep;
      VAR = nStatesArraysAtEvent;
      printCounterScreen = 0;
      printCounterFile   = 0;
      [isIntegrationFinished, VAR] = EventDetectedByIntegrator( t, VAR, nIndexOfEvents );
   end
end
end


%======================================================
end   % Fin de la función integrada HelicopterRetrievalODE
%======================================================