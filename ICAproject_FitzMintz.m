clear all;
addpath ('C:\Users\Kathleen\Documents\MATLAB\MATLAB\FastICA_25;')
addpath ('C:\Users\Kathleen\Documents\MATLAB\suplabel;')
%addpath ('/home/kt-fitz/Documents/MATLAB/MATLAB/FastICA_25;')		
%addpath ('/home/kt-fitz/Documents/MATLAB/suplabel;')
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

NumSig = 5;
NumObs = 8;
%info = audioinfo('record_Al.m4a')
[Al,Fs] = audioread('record_Al.m4a');
[p,q] = rat(16000/Fs,0.0001);
Al = resample(Al,p,q);
[ash,Fs] = audioread('record_ASH.m4a');
[p,q] = rat(16000/Fs,0.0001);
ash = resample(ash,p,q);
[cc,Fs] = audioread('record_CC.m4a');
[p,q] = rat(16000/Fs,0.0001);
cc = resample(cc,p,q);
[kf,Fs] = audioread('record_kf.mp3');
[p,q] = rat(16000/Fs,0.0001);
kf = resample(kf,p,q);
[mw,Fs] = audioread('record_mw.m4a');
[p,q] = rat(16000/Fs,0.0001);
mw = resample(mw,p,q);
[my,Fs] = audioread('record_MY.m4a');
[p,q] = rat(16000/Fs,0.0001);
my = resample(my,p,q);
[mb,Fs] = audioread('record_MB.m4a');
[p,q] = rat(16000/Fs,0.0001);
mb = resample(mb,p,q);
[tony,Fs] = audioread('record_Tony.m4a');
[p,q] = rat(16000/Fs,0.0001);
tony = resample(tony,p,q);
asyncmix{1} = Al;
asyncmix{2} = ash;
asyncmix{3} = cc;
asyncmix{4} = kf;
asyncmix{5} = mw;
asyncmix{6} = my;
asyncmix{7} = mb;
asyncmix{8} = tony;

leadlag = zeros(NumObs,1);%NumObs);
lengths = zeros(NumObs,1);
noiseratio = zeros(Numobs,1);
for i=1:NumObs;
    lengths(i) = length(asyncmix{i});
    noiseratio(i) = snr(asyncmix{i});
end
[short,shortind]=min(lengths);
%shortind = 7;
for i=1:NumObs;
    [corrlist,laglist]=xcorr(asyncmix{shortind},asyncmix{i});
    [maxcorr,maxind] = max(corrlist);
    leadlag(i) = laglist(maxind);
    if leadlag(i)<0;
      newstart = abs(leadlag(i))+1;
      syncmix{i} = asyncmix{i}(newstart:end);
    else
        push = zeros(leadlag(i),1);
        syncmix{i}=[push;asyncmix{i}];
    end
    newlengths(i) = length(syncmix{i});
end
%{
synclag = zeros(NumObs,NumObs);
for i=1:NumObs;
    %lengths(i) = length(asyncmix{i});
    for j=1:NumObs;
    [corrlist,laglist]=xcorr(syncmix{i},syncmix{j});
    [maxcorr,maxind] = max(corrlist);
    synclag(i,j) = laglist(maxind);
    end
end

[M,I] = min(leadlag(:));
[I_row,I_col] = ind2sub(size(leadlag),I);
%}
newend = min(newlengths);

mix = zeros(newend,0);
for j=1:NumObs;
    mix = [mix,syncmix{j}(1:newend)];
end
mix = mix.';
similarity = corrcoef(mix)


NumSamps = NumObs;%length(mix(:,1));
t=linspace(0,newend/16000,newend);

start= 0; %for debugging purposes only
stop = 307950;%for debugging purposes
colorVec=cool(NumSamps);

for i=1:NumSamps;
    figure(1)
    %subplot(NumSamps,1,i); plot(t,mix(i,:),'Color',colorVec(i,:));
    subplot(NumSamps,1,i); plot(asyncmix{i},'Color',colorVec(i,:));
    %axis([0,20,-1,1]);
end
figure(1)
xlabel('Time')
figure(1)
suplabel('Audio Signal','y');

for i=1:NumSamps;
    figure(2)
    subplot(NumSamps,1,i); plot(t,mix(i,:),'Color',colorVec(i,:));
    %subplot(NumSamps,1,i); plot(syncmix{i},'Color',colorVec(i,:));
    %axis([0,20,-1,1]);
end
figure(2)
xlabel('Time')
figure(2)
suplabel('Audio Signal','y');

%perform the fast ICA by passing the stack of mixed signals
%[ctemp,A1,W1] = fastica(mix,'numofIC',NumSig-1,'initGuess',[0.05;0.0;0.0;0.0]);
%[ctemp2, A2,W2] = fastica(mix,'initGuess',A1,'numofIC',NumSig);
[stage1,A1,W1]=fastica(mix,'numofIC',NumSig);
plotandsave(t,16000,stage1/10,'stage1',3);
%{
mix2 = stage1;% cat(1,stage1,kf.',cc.');
[stage2,A2,W2]=fastica(mix2,'numofIC',NumSig);
plotandsave(t,kf_Fs,stage2/10,'stage2',3);
%}