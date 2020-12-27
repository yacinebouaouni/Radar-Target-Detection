function[Mix,t]=FMCW_Sim(radar_range_resolution,radar_max_range,Nd,Nr,target_range,target_velocity,fc)

%% Description :
%This function generates FMCW waveform , sends it and receives it after td
%delay

%% Params:
%radar_range_resolution
%radar_max_range
%Nd : Number of chirps
%Nr : Number of samples/chirp
%target range
%target velocity
%fc : carrier frequency of FMCW.

%% FMCW Waveform Generation
c = 3e8;

% Calculate the Bandwidth (B), Chirp Time (Tchirp) and slope (slope) of the FMCW
B = c /(2 * radar_range_resolution);

% The sweep time can be computed based on the time needed for the signal to travel the unambiguous
% maximum range. In general, for an FMCW radar system, the sweep time should be at least
% 5 to 6 times the round trip time. This example uses a factor of 5.5.
t_sweep = 5.5;
t_chirp = t_sweep * 2 * (radar_max_range/c);
slope = B / t_chirp;



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

%Generate white noise with 0 mean and 1 standard deviation
mu=0;
sigma=0.00;
noise= sigma *randn(1,length(t))+mu;

for i = 1 : length(t)
    
  %For each time stamp update the Range of the Target for constant velocity.
  r_t(i) = target_range + (target_velocity*t(i));
  td(i) = (2 * r_t(i)) / c;


  %Update transmitted and received signal
  Tx(i) = cos(2 * pi * (fc * t(i) + 0.5 * slope * t(i)^2));
  Rx(i)  = 0.5*cos(2 * pi * (fc * (t(i) - td(i)) + 0.5 * slope * (t(i) - td(i))^2));
  %Get the beat signal by Mixing transmitted and received signals
  Mix(i) = Tx(i) .* Rx(i);
end

end