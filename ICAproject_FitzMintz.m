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
kf= 0.5*kf(:,1)+0.5*kf(:,2);
%kf = resample(kf,16000,kf_Fs);
%kf_Fs = 16000;
[ash,ash_Fs] = audioread('record_ASH-sync.mp3');
%ash = resample(ash,16000,ash_Fs);
[tony,tony_Fs] = audioread('record_tony-sync.mp3');
%tony = resample(tony,16000,tony_Fs);
[my,my_Fs] = audioread('record_MY-sync.mp3');
[cc,cc_Fs] = audioread('record_CC-sync.mp3');
%my = resample(my,16000,my_Fs);
%tony = resample(tony(:,1),16000,tony_Fs);
%tony_Fs = 16000;
%[sh,sh_Fs] = audioread('record_SH.mp3');
t = 0:seconds(1/kf_Fs):seconds(info.Duration);
t= t(1:end-1);
start= 0;
stop = 307950;
%t = linspace(0,seconds(info.Duration),length(kf));% 
figure;
subplot(5,1,1); plot(t,kf);
subplot(5,1,2); plot(t,ash,'r');
subplot(5,1,3); plot(t,tony,'k');
ylabel('Audio Signal')
subplot(5,1,4); plot(t,my,'g');
subplot(5,1,5); plot(t,cc,'y');
xlabel('Time')


c = fastica([ash,tony,kf,my,cc].');
figure;
subplot(5,1,1); plot(t,c(1,:));
subplot(5,1,2); plot(t,c(2,:),'r');
subplot(5,1,3); plot(t,c(3,:),'k');
subplot(5,1,4); plot(t,c(4,:),'g');
subplot(5,1,5); plot(t,c(5,:),'y');
