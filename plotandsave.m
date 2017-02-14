function f = plotandsave(time,freq,c,stage)
    colorVec2= prism(length(c(:,1)));
    for i=1:length(c(:,1))
        figure(2);%the separated signals
        subplot(length(c(:,1)),1,i); plot(time,c(i,:),'Color',colorVec2(i,:));
        axis([0,20,-1,1]);
        file = strcat('/home/kt-fitz/BME463/output/ICA-',num2str(i),'_',stage,'.wav');
        audiowrite(file,c(i,:),freq);
    end
end