 % fast intepret
FFLevel = 1;

%load('HActo.mat')
matFilePath = './data/mat/HR/';%HActo.filePath;

load('HHR.mat');
fprintf('%d files total.\n', HHR.fileLen);


lastsize = 0;
for i = 10%1:HHR.fileLen
    
    matFileName = HHR.fileList{i};
    
    if FFLevel == 1
        load([matFilePath matFileName]);
        fprintf(repmat('\b', 1, lastsize));
        lastsize = fprintf('loading %s\n', [matFilePath matFileName]);
        
        c = b;
        xData = (1:length(c))' - 1;
        % fit routine
        [ffRe gof1] = HRFourier1(xData, c, 1);
        HHR.p1.ffRe{i} = ffRe;
        
        pwave = ffRe.a0 + ffRe.a1 * cos(xData * ffRe.w) + ffRe.b1 * sin(xData * ffRe.w);
        [sinRe, gof2] = sinFit1(xData, pwave, ffRe.w, [ffRe.a0, 0, 0], 2);
        
        
        HHR.p1.sinRe{i} = sinRe;
        
        HHR.p1.dpc(i, 1) = pi/ffRe.w/60/24;
        HHR.p1.w(i, 1) = ffRe.w;
        % shift & check % refitting
        HHR.p1 = adjustment(sinRe, ffRe, HHR.p1, i);
        HHR.p1 = checkpoint(xData, pwave, HHR.p1, i);
        %[sinRe, gof] = sinFit1(xData, c, ffRe.w, [ffRe.a0, 0, 0], 2);
        
        
        HHR.p1.onset(i, 1) = a(1) + seconds(HHR.p1.sinRe{i}.c*30/ffRe.w);
        HHR.p1.dayth(i, 1) = yyyymmdd(HHR.p1.onset(i));
        
        
    end
    
    if FFLevel == 2
        load([matFilePath matFileName]);
        fprintf('Loading %s\n', matFileName)
        xData = (1:length(c))' - 1;
        % fit routine
        ffRe= HAFourier2(xData, c, 1);
        HHR.p2.sin1.ffRe{i} = ffRe;
        HHR.p2.sin2.ffRe{i} = ffRe;
        
        p1wave = ffRe.a0 + ffRe.a1 .* cos(xData * ffRe.w) + ffRe.b1 .* sin(xData * ffRe.w);
        p2wave = ffRe.a0 + ffRe.a2 .* cos(2 * xData * ffRe.w) + ffRe.b2 .* sin(2 * xData * ffRe.w);
        
        A = [ffRe.a1 ffRe.b1];
        [~,index] = max(abs(A));
        [sinRe, gof] = sinFit1(xData, p1wave, ffRe.w, [ffRe.a0 0 0], 2);
        
        HHR.p2.sin1.sinRe{i} = sinRe;
        
        HHR.p2.sin1.dpc(i) = pi/ffRe.w/60/24;
        % shift & check % refitting
        HHR.p2.sin1 = adjustment(sinRe, ffRe.w, HHR.p2.sin1, i);
        HHR.p2.sin1 = checkpoint(xData, p1wave, HHR.p2.sin1, i);
        %[sinRe, gof] = sinFit1(xData, c, ffRe.w, [ffRe.a0, 0, 0], 2);
        
        HHR.p2.sin1.onset(i) = a(1) + HHR.p2.sin1.sinRe{i}.c*30/ffRe.w;
        HHR.p2.sin1.dayth(i) = yyyymmdd(HHR.p2.sin1.onset(i));
        
        A = [ffRe.a2 ffRe.b2];
        [~,index] = max(abs(A));
        [sinRe, gof] = sinFit1(xData, p2wave, ffRe.w*2, [ffRe.a0 A(2) 0], 3);
        
        HHR.p2.sin2.sinRe{i} = sinRe;
        
        HHR.p2.sin2.dpc(i) = pi/ffRe.w/60/24;
        % shift & check % refitting
        HHR.p2.sin2 = adjustment(sinRe, ffRe.w*2, HHR.p2.sin2, i);
        HHR.p2.sin2 = checkpoint(xData, p2wave, HHR.p2.sin2, i);
        %[sinRe, gof] = sinFit1(xData, c, ffRe.w, [ffRe.a0, 0, 0], 2);
        
        HHR.p2.sin2.onset(i, 1) = a(1) + HHR.p2.sin2.sinRe{i}.c*30/ffRe.w;
        HHR.p2.sin2.dayth(i, 1) = yyyymmdd(HHR.p2.sin2.onset(i));
        
        
    end
end

%save('HActo.mat', 'HActo', '-v7.3')



