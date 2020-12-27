clear all;
clc;

%% Radar Specifications
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frequency of operation = 77GHz
% Max Range = 200m
% Range Resolution = 1 m
% Max Velocity = 100 m/s
%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc = 7.7;             %carrier freq Hz
radar_max_range = 200;
radar_range_resolution = 1;
radar_max_velocity = 100;
c = 3e8; %Constant Speed of light
%% Define Target Range and Velocity

target_range = 250;
target_velocity = 40;

%% FMCW Waveform Generation

% Calculate the Bandwidth (B), Chirp Time (Tchirp) and slope (slope) of the FMCW
B = c /(2 * radar_range_resolution);

% The sweep time can be computed based on the time needed for the signal to travel the unambiguous
% maximum range. In general, for an FMCW radar system, the sweep time should be at least
% 5 to 6 times the round trip time. This example uses a factor of 5.5.
t_sweep = 5.5;
t_chirp = t_sweep * 2 * (radar_max_range/c);
slope = B / t_chirp;

%The number of chirps in one sequence.
%Better a 2^ value for the ease of running the FFT for Doppler Estimation.
Nd = 4;                   % Nb of doppler cells OR #of sent periods % number of chirps

%The number of samples on each chirp.
Nr = 2048;                % Nb of range cells (Chirp time)

% Timestamp for Nd chirps and Nr samples
t = linspace(0,Nd*t_chirp,Nr*Nd); %total time for samples

%Create Transmitted , received and Mixed signals
Tx = zeros(1, length(t)); %transmitted signal
Rx = zeros(1, length(t)); %received signal
Mix = zeros(1, length(t)); %beat signal


%Similar vectors for range_covered and time delay.
r_t = zeros(1, length(t));
td = zeros(1, length(t));

%% Chirp generation and Moving Target simulation

for i = 1 : length(t)
    
  %For each time stamp update the Range of the Target for constant velocity.
  r_t(i) = target_range + (target_velocity*t(i));
  td(i) = (2 * r_t(i)) / c;

  %Update transmitted and received signal
  Tx(i) = cos(2 * pi * (fc * t(i) + 0.5 * slope * t(i)^2));
  Rx(i)  = cos(2 * pi * (fc * (t(i) - td(i)) + 0.5 * slope * (t(i) - td(i))^2));

  %Get the beat signal by Mixing transmitted and received signals
  Mix(i) = Tx(i) .* Rx(i);
end

figure();
subplot(211);
plot(t,Tx);
ylabel('Transmitted chirp');
subplot(212);
plot(t,Rx);
xlabel('t');
ylabel('Received Chirp');