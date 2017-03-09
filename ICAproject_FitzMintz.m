clear all;
%addpath ('C:\Users\Kathleen\Documents\MATLAB\MATLAB\FastICA_25;')
%addpath ('C:\Users\Kathleen\Documents\MATLAB\suplabel;')
addpath ('/home/kt-fitz/Documents/MATLAB/MATLAB/FastICA_25;')		
addpath ('/home/kt-fitz/Documents/MATLAB/suplabel;')
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

When you run c
 %}

NumSig = 3;
%info = audioinfo('record_Al.m4a')
[Al,Al_FS] = audioread('record_Al.m4a');
[ash,ash_Fs] = audioread('record_ASH.m4a');

[kf,kf_Fs] = audioread('nosync-data\record_Al.m4a');
[tony,tony_Fs] = audioread('nosync-data\record_Al.m4a');
[my,my_Fs] = audioread('nosync-data\record_Al.m4a');
[cc,cc_Fs] = audioread('nosync-data\record_Al.m4a');
[mb,mb_Fs] = audioread('nosync-data\record_Al.m4a');
[mw,mw_Fs] = audioread('nosync-data\record_Al.m4a');

%mix = [tony,mw,my,ash,mb].';%[tony,my,mb,mw].';%[ash,tony,kf,my,cc,mb,mw].';


%{
NumSamps = length(mix(:,1));
t = 0:seconds(1/kf_Fs):seconds(info.Duration);
t= t(1:end-529);

start= 0; %for debugging purposes only
stop = 307950;%for debugging purposes
colorVec=cool(NumSamps);

for i=1:NumSamps;
    figure(1)
    subplot(NumSamps,1,i); plot(t,mix(i,:),'Color',colorVec(i,:));
    axis([0,20,-1,1]);
end
figure(1)
xlabel('Time')
figure(1)
suplabel('Audio Signal','y')

%perform the fast ICA by passing the stack of mixed signals
%[ctemp,A1,W1] = fastica(mix,'numofIC',NumSig-1,'initGuess',[0.05;0.0;0.0;0.0]);
%[ctemp2, A2,W2] = fastica(mix,'initGuess',A1,'numofIC',NumSig);
[stage1,A1,W1]=fastica(mix,'numofIC',NumSig);
plotandsave(t,kf_Fs,stage1/10,'stage1',2);
mix2 = stage1;% cat(1,stage1,kf.',cc.');
[stage2,A2,W2]=fastica(mix2,'numofIC',NumSig);
plotandsave(t,kf_Fs,stage2/10,'stage2',3);
%}