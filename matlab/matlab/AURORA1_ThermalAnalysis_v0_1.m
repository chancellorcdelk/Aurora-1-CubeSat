%% AURORA-1 Preliminary Thermal Analysis
% Version 0.1
% Simple equilibrium hot-case estimate

clear;
clc;

%% Constants
S = 1361;                 % Solar flux [W/m^2]
sigma = 5.670374419e-8;   % Stefan-Boltzmann constant [W/m^2/K^4]

%% Preliminary Surface Properties
alpha = 0.6;              % Solar absorptivity
epsilon = 0.8;            % Infrared emissivity

%% Geometry
A_sun = 0.01;             % Approx. sun-facing area [m^2]
A_rad = 0.06;             % Approx. total radiating area [m^2]

%% Internal Heat
P_internal = 3.0;         % Preliminary internal dissipation [W]

%% Earth Environmental Heating

earth_IR = 237;          % Average Earth infrared flux [W/m^2]
albedo = 0.30;           % Average Earth albedo coefficient
A_earth = 0.01;          % Approx. Earth-facing projected area [m^2]

Q_earth_IR = epsilon * earth_IR * A_earth;
Q_albedo = alpha * albedo * S * A_earth;

%% Hot-Case Equilibrium Temperature
Q_solar = alpha*S*A_sun;
Q_total = Q_solar + P_internal;

T_hot = (Q_total/(epsilon*sigma*A_rad))^(1/4);
T_hot_C = T_hot - 273.15;
fprintf('Earth IR Heating: %.2f W\n', Q_earth_IR);
fprintf('Albedo Heating: %.2f W\n', Q_albedo);
fprintf('AURORA-1 Preliminary Thermal Analysis\n');
fprintf('-------------------------------------\n');
fprintf('Absorbed Solar Power: %.2f W\n', Q_solar);
fprintf('Total Heat Input: %.2f W\n', Q_total);
fprintf('Estimated Hot-Case Temperature: %.2f C\n', T_hot_C);

%% Preliminary Transient Thermal Model

% Approximate spacecraft thermal properties
m_sc = 2.0;            % Spacecraft mass [kg]
Cp = 900;              % Effective specific heat [J/kg/K]

% Initial temperature
T0 = 293.15;           % 20 C [K]

% Time step
dt = 1;               % seconds

% Orbit durations from previous analysis
sunlight_time = 58.86 * 60;    % [s]
eclipse_time = 35.75 * 60;     % [s]

% Total simulation time
t_total = sunlight_time + eclipse_time;
time = 0:dt:t_total;

T = zeros(size(time));
T(1) = T0;

%% Heater Parameters
heater_power = 13.0;
heater_on_temp = 10.0;
heater_off_temp = 12.0;
heater_on = false;

for i = 1:length(time)-1

    % Determine whether spacecraft is in sunlight or eclipse
    if time(i) <= sunlight_time
        Q_in = Q_solar + Q_albedo + Q_earth_IR + P_internal;
    else
        Q_in = Q_earth_IR + P_internal;
    end

    % Current spacecraft temperature [C]
    current_temp_C = T(i) - 273.15;

    % Thermostat logic
    if current_temp_C <= heater_on_temp
        heater_on = true;
    elseif current_temp_C >= heater_off_temp
        heater_on = false;
    end

    % Add heater power when active
    if heater_on
        Q_in = Q_in + heater_power;
    end
    % Radiated heat
    Q_out = epsilon * sigma * A_rad * T(i)^4;

    % Net heat
    Q_net = Q_in - Q_out;

    % Temperature change
    dT = (Q_net / (m_sc * Cp)) * dt;

    % Update temperature
    T(i+1) = T(i) + dT;

end
    T_C = T - 273.15;

    fprintf('Maximum Orbital Temperature: %.2f C\n', max(T_C));
    fprintf('Minimum Orbital Temperature: %.2f C\n', min(T_C));
    fprintf('Heater Power: %.2f W\n', heater_power);
    fprintf('Minimum Temperature with Heater: %.2f C\n', min(T_C));

    figure;
    plot(time/60, T_C, 'LineWidth', 1.5);
    xlabel('Time [minutes]');
    ylabel('Spacecraft Temperature [C]');
    title('AURORA-1 Preliminary Orbital Temperature with Heater');
    grid on;

    % Radiated heat
    Q_out = epsilon * sigma * A_rad * T(i)^4;

    % Net heat
    Q_net = Q_in - Q_out;

    % Temperature change
    dT = (Q_net / (m_sc * Cp)) * dt;

    % Update temperature
    T(i+1) = T(i) + dT;



T_C = T - 273.15;

fprintf('Maximum Orbital Temperature: %.2f C\n', max(T_C));
fprintf('Minimum Orbital Temperature: %.2f C\n', min(T_C));

figure;
plot(time/60, T_C, 'LineWidth', 1.5);
xlabel('Time [minutes]');
ylabel('Spacecraft Temperature [C]');
title('AURORA-1 Preliminary Orbital Temperature');
grid on;

