% fast intepret
dirPath = pwd;
dirPath = [dirPath 'Data/'];
gsFilePath = [dirPath 'GS/'];
fixedPath = [dirPath 'GS_Fixed/'];
savePath = [dirPath 'mat/acto/'];
matFile = [dirPath 'mat/HActo.mat'];
gsFileName = sort(split(ls(gsFilePath)));
gsFileName = gsFileName(2:end);
fileLen = length(gsFileName);

%%%%
FFLevel = 1;
%%%%

load(matFile)
fprintf('%d files total.\n', HActo.fileLen);


lastsize = 0;
for i = 1:HActo.fileLen
    
    matFileName = HActo.fileList{i};
    
    if FFLevel == 1
        load([savePath matFileName]);
        fprintf(repmat('\b', 1, lastsize));
        lastsize = fprintf('loading %s\n', [savePath matFileName]);
        c = GSObj.c;
        a = GSObj.a;
        
        xData = (1:length(c))' - 1;
        % fit routine
        [ffRe gof1] = HAFourier1(xData, c, 1);
        HActo.p1.ffRe{i} = ffRe;
        
        pwave = ffRe.a0 + ffRe.a1 * cos(xData * ffRe.w) + ffRe.b1 * sin(xData * ffRe.w);
        [sinRe, gof2] = sinFit1(xData, pwave, ffRe.w, [ffRe.a0, 0, 0], 2);
        
        
        HActo.p1.sinRe{i} = sinRe;
        
        HActo.p1.dpc(i, 1) = pi/ffRe.w/60/24;
        % shift & check % refitting
        HActo.p1 = adjustment(sinRe, ffRe, HActo.p1, i);
        HActo.p1 = checkpoint(xData, pwave, HActo.p1, i);
        %[sinRe, gof] = sinFit1(xData, c, ffRe.w, [ffRe.a0, 0, 0], 2);
        
        
        HActo.p1.onset(i, 1) = a(1) + seconds(HActo.p1.sinRe{i}.c*30/ffRe.w);
        HActo.p1.dayth(i, 1) = yyyymmdd(HActo.p1.onset(i));
        
        
    end
    
    if FFLevel == 2
        load([savePath matFileName]);
        fprintf('Loading %s\n', matFileName)
        xData = (1:length(c))' - 1;
        % fit routine
        ffRe= HAFourier2(xData, c, 1);
        HActo.p2.sin1.ffRe{i} = ffRe;
        HActo.p2.sin2.ffRe{i} = ffRe;
        
        p1wave = ffRe.a0 + ffRe.a1 .* cos(xData * ffRe.w) + ffRe.b1 .* sin(xData * ffRe.w);
        p2wave = ffRe.a0 + ffRe.a2 .* cos(2 * xData * ffRe.w) + ffRe.b2 .* sin(2 * xData * ffRe.w);
        
        A = [ffRe.a1 ffRe.b1];
        [~,index] = max(abs(A));
        [sinRe, gof] = sinFit1(xData, p1wave, ffRe.w, [ffRe.a0 0 0], 2);
        
        HActo.p2.sin1.sinRe{i} = sinRe;
        
        HActo.p2.sin1.dpc(i) = pi/ffRe.w/60/24;
        % shift & check % refitting
        HActo.p2.sin1 = adjustment(sinRe, ffRe.w, HActo.p2.sin1, i);
        HActo.p2.sin1 = checkpoint(xData, p1wave, HActo.p2.sin1, i);
        %[sinRe, gof] = sinFit1(xData, c, ffRe.w, [ffRe.a0, 0, 0], 2);
        
        HActo.p2.sin1.onset(i) = a(1) + HActo.p2.sin1.sinRe{i}.c*30/ffRe.w;
        HActo.p2.sin1.dayth(i) = yyyymmdd(HActo.p2.sin1.onset(i));
        
        A = [ffRe.a2 ffRe.b2];
        [~,index] = max(abs(A));
        [sinRe, gof] = sinFit1(xData, p2wave, ffRe.w*2, [ffRe.a0 A(2) 0], 3);
        
        HActo.p2.sin2.sinRe{i} = sinRe;
        
        HActo.p2.sin2.dpc(i) = pi/ffRe.w/60/24;
        % shift & check % refitting
        HActo.p2.sin2 = adjustment(sinRe, ffRe.w*2, HActo.p2.sin2, i);
        HActo.p2.sin2 = checkpoint(xData, p2wave, HActo.p2.sin2, i);
        %[sinRe, gof] = sinFit1(xData, c, ffRe.w, [ffRe.a0, 0, 0], 2);
        
        HActo.p2.sin2.onset(i, 1) = a(1) + HActo.p2.sin2.sinRe{i}.c*30/ffRe.w;
        HActo.p2.sin2.dayth(i, 1) = yyyymmdd(HActo.p2.sin2.onset(i));
        
        
    end
end

save(matFile, 'HActo', '-v7.3')



