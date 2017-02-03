addpath ('/home/kt-fitz/Documents/MATLAB/MATLAB/FastICA_25;')
%{
A = sin(linspace(0,50, 1000));   % A
B = sin(linspace(0,37, 1000)+5); % B
figure; 
subplot(2,1,1); plot(A);         % plot A
subplot(2,1,2); plot(B, 'r');    % plot B

M1 = A - 2*B;                  % mixing 1
M2 = 1.73*A+3.41*B;            % mixing 2
figure;
subplot(2,1,1); plot(M1);      % plot mixing 1
subplot(2,1,2); plot(M2, 'r'); % plot mixing 2

figure;

c = fastica([M1;M2]);              % compute and plot unminxing using fastICA	
subplot(2,1,1); plot(c(1,:));
subplot(2,1,2); plot(c(2,:),'r');
%}

info = audioinfo('record_kf-sync.mp3');
[kf,kf_Fs] = audioread('record_kf-sync.mp3');
%kf = resample(kf,16000,kf_Fs);
%kf_Fs = 16000;
[ash,ash_Fs] = audioread('record_ASH-sync.mp3');
ash = ash(:,1);
[tony,tony_Fs] = audioread('record_tony-sync.mp3');
%tony = resample(tony(:,1),16000,tony_Fs);
%tony_Fs = 16000;
%[sh,sh_Fs] = audioread('record_SH.mp3');
%t1 = 0:seconds(1/Fs):seconds(info.Duration);
start= 290000;
stop = 307950;
sound(kf(start:stop),kf_Fs);
t = linspace(0,seconds(info.Duration),length(kf));% t1(1:end-1);
figure;
subplot(2,1,1); plot(t(start:stop),kf(start:stop,2));
subplot(2,1,2); plot(t(start:stop),kf(start:stop,1),'r');
xlabel('Time')
ylabel('Audio Signal')
%{
c = fastica([ash.',tony.']);
figure;
subplot(2,1,1); plot(t,c(1,:));
subplot(2,1,2); plot(t,c(2,:),'r');
%}