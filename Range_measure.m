function Range_measure(Mix,Nr,Nd,t)

%This fucntion computes the range of the target 
%Params : 
% - Nr : Number of chirps
% - Nd : Number of samples
% - t  : time vector Nd*t_chirp*Nr

%Reshape the vector into Nr*Nd array. Nr and Nd here would also define the size of Range and Doppler FFT respectively.
Mix = reshape(Mix, [Nr, Nd]);

%Run FFT on range cells 
sig_fft = fft(Mix(:,1),Nr);

% Take the normalized absolute value of FFT output
sig_fft = abs(sig_fft);
sig_fft = sig_fft ./ max(sig_fft); 

% Output of FFT is double sided signal, but we are interested in only one side of the spectrum.
sig_fft = sig_fft(1 : Nr/2-1);


%%Visualization
%plotting the range
%figure ('Name','Range from First FFT')

% plot FFT output
fig1=figure;

plt=plot(sig_fft);
axis ([0 200 0 1]);
title('Range from First FFT');
ylabel('Normalized Amplitude');
xlabel('Range');

cursorMode = datacursormode(fig1);
hDatatip = cursorMode.createDatatip(plt);
[~,index] = max(sig_fft);
pos = [t(index) sig_fft(index) 0];
set(hDatatip, 'Position', pos);
updateDataCursors(cursorMode);

grid on;

end