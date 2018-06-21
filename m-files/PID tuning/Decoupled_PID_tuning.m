%% Decoupling Controller for the gantry crane
% This example shows how to use |looptune| to decouple
% the two main feedback loops in a distillation column.

%   Copyright 1986-2012 The MathWorks, Inc.

%% Distillation Column Model
% This example uses a simple model of the distillation column shown below.
%
% <<../distilldemo1.png>>
% 
% *Figure 1: Distillation Column*

%%
% In the so-called LV configuration, the controlled variables are the concentrations 
% |yD| and |yB| of the chemicals |D| (tops) and |B| (bottoms), and the manipulated variables 
% are the reflux |L| and boilup |V|. This process exhibits strong coupling 
% and large variations in steady-state gain for some combinations of L and V. 
% For more details, see Skogestad and Postlethwaite, _Multivariable Feedback Control_.
%% Flags
clear all
plot_open_loop =0;
%% Define model 

load BlackBoxID_meas16_order6_angle_corrected.mat
Plant = tf(Blackbox_model);
anglePlant_normal = Plant(2,1);
s = tf('s');
posPlant = s*Plant;
anglePlant = posPlant(2,1);

[A,B,C,D] = ssdata(Blackbox_model);

if(plot_open_loop)
figure
subplot(121)
step(Plant(1,1),10)
subplot(122)
step(Plant(2,1),10)

figure
subplot(121)
step(posPlant(1,1),10)
subplot(122)
step(posPlant(2,1),10)
end

%% Define inputs and outputs
%G = [87.8 -86.4 ; 108.2 -109.6]/(75*s+1); model from template
Plant.InputName  = {'controlInput'};
Plant.OutputName = {'yPosition','yAngle'};

%% Control Architecture
% The control objectives are as follows:
%
% * Independent control of the tops and bottoms concentrations by ensuring that a change 
% in the tops setpoint |Dsp| has little impact on the bottoms concentration |B| and vice versa
% * Response time of about 4 minutes with less than 15% overshoot
% * Fast rejection of input disturbances affecting the effective reflux |L| and boilup |V|
%
% To achieve these objectives we use the control architecture shown below. This architecture
% consists of a static decoupling matrix |DM| in series with two PI controllers for the 
% reflux |L| and boilup |V|.

open_system('PID_Tuning')

%% Controller Tuning in Simulink with LOOPTUNE
% The |looptune| command provides a quick way to tune MIMO feedback loops. 
% When the control system is modeled in Simulink, you just specify the
% tuned blocks, the control and measurement signals, and the desired bandwidth, 
% and |looptune| automatically sets up the problem and tunes the controller 
% parameters. |looptune| shapes the open-loop response to provide integral
% action, roll-off, and adequate MIMO stability margins. 

%%
% Use the |slTuner| interface to specify the tuned blocks, the controller I/Os, 
% and signals of interest for closed-loop validation.

ST0 = slTuner('PID_Tuning',{'PID_position','PID_angle'});

% Signals of interest
%addPoint(ST0,{'r','dL','dV','L','V','y'})
addPoint(ST0,{'rPosition','uAngle','uPosition','yPosition','yAngle','controlInput'})

%%
% Set the control bandwidth by specifying the gain crossover frequency
% for the open-loop response. For a response time of 4 minutes, the 
% crossover frequency should be approximately 2/4 = 0.5 rad/min.

wc = 0.5;

%%
% Use |TuningGoal| objects to specify the remaining control objectives.
% The response to a step command should have less than 15% overshoot.
% The response to a step disturbance at the plant input should be well damped, 
% settle in less than 20 minutes, and not exceed 4 in amplitude.

OS = TuningGoal.Overshoot('rPosition','yAngle',15);

%DR = TuningGoal.StepRejection('rPosition','yAngle',4,20);

%%
% Next use |looptune| to tune the controller blocks |PI_L|, |PI_V|, and
% |DM| subject to the disturbance rejection requirement.

Controls = {'controlInput'};
Measurements = {'yPosition','yAngle'};
[ST,gam,Info] = looptune(ST0,Controls,Measurements,wc,OS);%,DR);

%%
% The final value is near 1 which indicates that all requirements were met.
% Use |loopview| to check the resulting design. The responses should stay 
% outside the shaded areas.

figure('Position',[0,0,1000,1200])
loopview(ST,Info)

%% 
% Use |getIOTransfer| to access and plot the closed-loop responses from
% reference and disturbance to the tops and bottoms concentrations. The tuned responses
% show a good compromise between tracking and disturbance rejection.

figure
Ttrack = getIOTransfer(ST,'rPosition','yPos');
step(Ttrack,40), grid, title('Setpoint tracking')

%%

Ttrack = getIOTransfer(ST,'rPosition','yAngle');
step(Treject,40), grid, title('Disturbance rejection Angle')

%%
% Comparing the open- and closed-loop disturbance rejection
% characteristics in the frequency domain shows a clear improvement
% % inside the control bandwidth.
% 
% clf, sigma(Plant,Treject), grid
% title('Principal gains from input disturbances to outputs')
% legend('Open-loop','Closed-loop')



%% Adding Constraints on the Tuned Variables
% Inspection of the controller obtained above shows that the second
% PI controller has negative gains.

PID_pos = getBlockValue(ST,'PID_position')
PID_angle = getBlockValue(ST,'PID_angle')

sim('PID_Tuning_test')
%%
% This is due to the negative signs in the second input channels of the
% plant $G$. In addition, the tunable elements are over-parameterized 
% because multiplying |DM| by two and dividing the PI gains by two 
% does not change the overall controller. To address these issues, fix
% the (1,1) entry of |DM| to 1 and the (2,2) entry to -1.

% DM = getBlockParam(ST0,'DM');
% DM.Gain.Value = diag([1 -1]);
% DM.Gain.Free = [false true;true false];
% setBlockParam(ST0,'DM',DM)
% 
% %%
% % Re-tune the controller for the reduced set of tunable parameters.
% 
% [ST,gam,Info] = looptune(ST0,Controls,Measurements,wc,OS,DR);
% 
% %%
% % The step responses look similar but the values of |DM| and the PI gains
% % are more suitable for implementation.
% 
% figure('Position',[0,0,700,350])
% 
% subplot(121)
% Ttrack = getIOTransfer(ST,'r','y');
% step(Ttrack,40), grid, title('Setpoint tracking')
% 
% subplot(122)
% Treject = getIOTransfer(ST,{'dV','dL'},'y');
% step(Treject,40), grid, title('Disturbance rejection')
% 
% %%
% 
% showTunable(ST)
% 
