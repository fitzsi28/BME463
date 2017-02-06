clear all;
addpath ('/home/kt-fitz/Documents/MATLAB/MATLAB/FastICA_25;')

%{
There was no need to resample although if that is necessary, you can use:
record = resample(recording,desired_rate, actual_rate);
All files were synced in audacity and export to mp3 at 16kHz. Some samples
were originally, 44.1kHz and others were 15kHz. So there was only
subsampling, no oversampling. By using audacity it guarunteed that all
samples were the same length when imported, so no manipulation was done in
the regard either.
A conversion from stereo to mono was done on stereo samples by average the
two.
 %}
NumSamps = 7;
NumSig = 4;
info = audioinfo('record_kf-sync2.mp3')
[kf,kf_Fs] = audioread('record_kf-sync2.mp3');
%kf= 0.5*kf(:,1)+0.5*kf(:,2); %conversion from stereo to mono
[ash,ash_Fs] = audioread('record_ASH-sync2.mp3');
[tony,tony_Fs] = audioread('record_tony-sync2.mp3');
[my,my_Fs] = audioread('record_MY-sync2.mp3');
[cc,cc_Fs] = audioread('record_CC-sync2.mp3');
[mb,mb_Fs] = audioread('record_MB-sync2.mp3');
[mw,mw_Fs] = audioread('record_MW-sync2.mp3');
mix = [ash,tony,kf,my,cc,mb,mw].';
NumSamps = length(mix(:,1));
t = 0:seconds(1/kf_Fs):seconds(info.Duration);
t= t(1:end-1);

start= 0; %for debugging purposes only
stop = 307950;%for debugging purposes
colorVec=cool(NumSamps);

figure(1);
ylabel('Audio Signal')
xlabel('Time')
for i=1:NumSamps;
    figure(1)
    subplot(NumSamps,1,i); plot(t,mix(i,:),'Color',colorVec(i,:))
end


%perform the fast ICA by passing the stack of mixed signals
%[ctemp,A1,W1] = fastica(mix,'numofIC',NumSig-1,'initGuess',[0.05;0.0;0.0;0.0]);
%[ctemp2, A2,W2] = fastica(mix,'initGuess',A1,'numofIC',NumSig);
[stage1,A3,W3]=fastica(mix,'numofIC',NumSig);
c=stage1/10;
colorVec2= prism(NumSig);
for i=1:NumSig
    figure(2);%the separated signals
    subplot(NumSig,1,i); plot(t,c(i,:),'Color',colorVec2(i,:));
    file = strcat('/home/kt-fitz/BME463/output/ICA-',num2str(i),'_v2.wav');
    audiowrite(file,c(i,:),kf_Fs);
end
%{
subplot(NumSig,1,2); plot(t,c(2,:),'r');
subplot(NumSig,1,3); plot(t,c(3,:),'m');
subplot(NumSig,1,4); plot(t,c(4,:),'y');

subplot(NumSig,1,5); plot(t,c(5,:),'g');
subplot(NumSig,1,6); plot(t,c(6,:),'b');
subplot(NumSig,1,7); plot(t,c(7,:),'k');

audiowrite('/home/kt-fitz/BME463/output/ICA-idk1.wav',c(1,:),kf_Fs);
audiowrite('/home/kt-fitz/BME463/output/ICA-idk2.wav',c(2,:),kf_Fs);
audiowrite('/home/kt-fitz/BME463/output/ICA-idk3.wav',c(3,:),kf_Fs);
audiowrite('/home/kt-fitz/BME463/output/ICA-idk4.wav',c(4,:),kf_Fs);

audiowrite('/home/kt-fitz/BME463/output/ICA-idk5.wav',c(5,:),kf_Fs);
audiowrite('/home/kt-fitz/BME463/output/ICA-idk6.wav',c(6,:),kf_Fs);
audiowrite('/home/kt-fitz/BME463/output/ICA-idk7.wav',c(7,:),kf_Fs);
%}