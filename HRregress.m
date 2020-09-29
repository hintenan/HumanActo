% regression HR and acti
load('./HActo.mat');
% Check raw data

actiPath = HActo.rawMatPath;
HRPath = './data/mat/HR/';
figPath = './imgs/HR/regression/';

for i = 2%1:HActo.fileLen
    
    cHR = [];
    cmatch = [];
    amatch = NaT(1);

    load([actiPath HActo.fileList{i}]);
    load([HRPath HActo.fileList{i} '.mat']);
    figure(1)
    plot(GSObj.a, GSObj.c)
    hold on
    plot(a, c)
    hold off
    saveas(gcf, ['./imgs/HR/compareRaw/' HActo.fileList{i}(1:end-4) '.jpg']);
    
    lenc = length(GSObj.c);
    cc = 1;
    for j = 1:length(a)
        
        aInd = a(j) < GSObj.a;
        if sum(aInd) == lenc
            continue;
        end
        afind = find(aInd);
        
        if isempty(afind)
            break;
        end
        
        if afind(1) <= lenc
            cHR(cc) = c(cc);
            cmatch(cc) = GSObj.c(afind(1));
            amatch(cc) = a(cc);
            cc = cc + 1;
        else
            break;
        end
        
    end
    figure(2)
    plot(amatch, cmatch)
    hold on
    plot(amatch, cHR)
    hold off

    len = length(cmatch);
    [R, M, B] = regression(cmatch, cHR);
    figure(2)
    plot(amatch, cmatch * M + B)
    hold on
    plot(amatch, cHR)
    hold off
    legend('acti', 'HR')
    saveas(gcf, [figPath HActo.fileList{i}(1:end-4) '_r.jpg']);
end


yresid = cHR - (cmatch * M + B);
SSresid = sum(yresid.^2);
SStotal = (length(cHR)-1) * var(cHR);

rsq = 1 - SSresid/SStotal
rsq_adj = 1 - SSresid/SStotal * (length(cHR)-1)/(length(cHR)-2)