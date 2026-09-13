%% AURORA-1 CubeSat Orbital Analysis
% Version 0.1
% Purpose: Preliminary orbital analysis for a 500 km circular LEO

clear;
clc;

%% Constants

Re = 6378;          % Mean Earth radius [km]
mu = 398600.4418;   % Earth's gravitational parameter [km^3/s^2]

%% Mission Orbit

h = 500;            % AURORA-1 altitude [km]

% Orbital radius / semi-major axis for circular orbit
a = Re + h;

%% Orbital Period

T = 2*pi*sqrt(a^3/mu);   % Orbital period [s]
T_min = T/60;            % Convert seconds to minutes

fprintf('AURORA-1 Orbital Analysis\n');
fprintf('-------------------------\n');
fprintf('Altitude: %.0f km\n', h);
fprintf('Orbital Radius: %.0f km\n', a);
fprintf('Orbital Period: %.2f minutes\n', T_min);

%% Orbital Velocity

v = sqrt(mu/a);     % Circular orbital velocity [km/s]

fprintf('Orbital Velocity: %.3f km/s\n', v);

%% Orbits Per Day

orbits_per_day = (24*60)/T_min;

fprintf('Orbits Per Day: %.2f\n', orbits_per_day);

%% Eclipse Duration

eclipse_time = (T/pi) * asin(Re/a);    % Eclipse duration [s]
eclipse_min = eclipse_time/60;         % Convert to minutes

fprintf('Eclipse Duration: %.2f minutes\n', eclipse_min);

%% Sunlight Duration

sunlight_min = T_min - eclipse_min;

fprintf('Sunlight Duration: %.2f minutes\n', sunlight_min);
