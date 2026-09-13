%% AURORA-1 Preliminary ADCS Feasibility
% Version 0.1

clear;
clc;

%% Spacecraft properties

m = 2.4;          % Preliminary spacecraft mass [kg]

% Approximate 2U dimensions [m]
x = 0.10;
y = 0.10;
z = 0.227;

%% Approximate moment of inertia
% Rectangular prism approximation

Ixx = (1/12)*m*(y^2 + z^2);
Iyy = (1/12)*m*(x^2 + z^2);
Izz = (1/12)*m*(x^2 + y^2);

fprintf('Ixx = %.5f kg*m^2\n', Ixx);
fprintf('Iyy = %.5f kg*m^2\n', Iyy);
fprintf('Izz = %.5f kg*m^2\n', Izz);

%% Reaction Wheel Torque

wheel_torque = 0.002;   % 2 mN*m = 0.002 N*m

%% Angular Acceleration

alpha_x = wheel_torque / Ixx;
alpha_y = wheel_torque / Iyy;
alpha_z = wheel_torque / Izz;

fprintf('\nAngular Acceleration:\n');
fprintf('X-axis: %.4f rad/s^2\n', alpha_x);
fprintf('Y-axis: %.4f rad/s^2\n', alpha_y);
fprintf('Z-axis: %.4f rad/s^2\n', alpha_z);

%% 90-Degree Slew Estimate

theta = pi/2;   % 90 degrees [rad]

t_slew_x = 2*sqrt(theta/alpha_x);
t_slew_y = 2*sqrt(theta/alpha_y);
t_slew_z = 2*sqrt(theta/alpha_z);

fprintf('\nEstimated 90-Degree Slew Time:\n');
fprintf('X-axis: %.2f s\n', t_slew_x);
fprintf('Y-axis: %.2f s\n', t_slew_y);
fprintf('Z-axis: %.2f s\n', t_slew_z);

%% Preliminary Pointing Control Simulation
% Simulates one rotational axis with a simple PD controller

dt = 0.01;                 % Time step [s]
t_end = 60;                % Simulation duration [s]
time = 0:dt:t_end;

% Use X-axis inertia
I = Ixx;

% Initial conditions
theta = zeros(size(time));
omega = zeros(size(time));

theta(1) = deg2rad(10);    % Initial pointing error: 10 deg
omega(1) = 0;              % Initial angular rate [rad/s]

%% Controller Parameters

Kp = 0.0015;               % Proportional gain
Kd = 0.006;                % Derivative gain

tau_max = 0.002;           % Reaction wheel torque limit [N*m]
disturbance_torque = 1e-5; % Small disturbance torque [N*m]

%% Simulation

for i = 1:length(time)-1

    % Target attitude is 0 degrees
    error = theta(i);

    % PD control torque
    tau_cmd = -Kp*error - Kd*omega(i);

    % Limit torque to reaction wheel capability
    tau_control = max(min(tau_cmd,tau_max),-tau_max);

    % Add small disturbance torque
    tau_total = tau_control + disturbance_torque;

    % Angular acceleration
    angular_accel = tau_total/I;

    % Update angular velocity and position
    omega(i+1) = omega(i) + angular_accel*dt;
    theta(i+1) = theta(i) + omega(i+1)*dt;

end

%% Convert pointing error to degrees

theta_deg = rad2deg(theta);

%% Determine settling time within +/- 2 degrees

settling_time = NaN;

for i = 1:length(theta_deg)

    if all(abs(theta_deg(i:end)) <= 2)
        settling_time = time(i);
        break;
    end

end

fprintf('\nPointing Control Simulation:\n');
fprintf('Initial Pointing Error: 10 deg\n');
fprintf('Final Pointing Error: %.3f deg\n', theta_deg(end));
fprintf('Settling Time within +/-2 deg: %.2f s\n', settling_time);

%% Plot

figure;
plot(time,theta_deg,'LineWidth',1.5);
hold on;

yline(2,'--');
yline(-2,'--');

xlabel('Time [s]');
ylabel('Pointing Error [deg]');
title('AURORA-1 Preliminary ADCS Pointing Response');
grid on;
