% rawTreatment
% Part 1
% You might treat it as a convention
dirPath = pwd;
dirPath = [dirPath 'Data/'];
%gsFilePath = [dirPath 'GS/'];
%fixedPath = [dirPath 'GS_Fixed/'];
%savePath = [dirPath 'mat/acto/'];
matFile = [dirPath 'mat/HActo.mat'];
%gsFileName = sort(split(ls(gsFilePath)));
%gsFileName = gsFileName(2:end);
%fileLen = length(gsFileName);

load(matFile);
% Check raw data

filePath = HActo.rawMatPath;
savePath = HActo.rawMatPath;

if exist('HActo.td', 'var')
    td = HActo.td;
    bnanCount = HActo.bnanCount;
    cnanCount = HActo.cnanCount;
    bnanCountPost = HActo.bnanCountPost;
    cnanCountPost = HActo.cnanCountPost;
else
    % pre-allocation
    td = zeros(HActo.fileLen, 1);
    bnanCount = zeros(HActo.fileLen, 1);
    bnanCountPost = zeros(HActo.fileLen, 1);
    cnanCount = zeros(HActo.fileLen, 1);
    cnanCountPost = zeros(HActo.fileLen, 1);
end


lastsize = 0;
for i = 1:HActo.fileLen
    fprintf(repmat('\b', 1, lastsize));
    lastsize = fprintf('Checking treatment on %s. ', HActo.fileList{i});
    load([filePath HActo.fileList{i}]);

    % copy a tmp data
    if ~GSObj.killnan
        GSObj.killnan = 1;
        a = GSObj.a;
        b = GSObj.b;
        a_backup = GSObj.a;
        b_backup = GSObj.b;
        c = GSObj.c;
    else
        a = GSObj.a_backup;
        b = GSObj.b_backup;
        c = movmean(b, 120*4+1, 'omitnan', 'Endpoints', 'fill');
        a_backup = GSObj.a_backup;
        b_backup = GSObj.b_backup;
    end

    % Treatment 1
    % Fix "Marked Time Tag" and "File Time Tag" conflict 
    if  GSObj.a(1) < HActo.colStartTag(i)
        fprintf('caution!\n');
        % Never happend
        % leave it empty
    end

    if  GSObj.a(end) > HActo.colEndTag(i)
        fprintf('caution!\n');
        % Never happend
        % leave it empty
    end

    % Treatment 2
    % recording nan before treatment
    tds = (diff(a) == seconds(30));
    td(i) = sum(~tds);
    if td(i)
        fprintf('Time diff error.\n');
        lastsize = 0;
    end

    bnanCount(i) = sum(isnan(b));
    % skip bnan warning
    cnanCount(i) = sum(isnan(c));
    if cnanCount(i)
        fprintf('cnan error.\n');
        lastsize = 0;
    end
  
    % Treatment 3
    % Fix head/tail long consecutive Nan issue
    bnans = isnan(b);
    dd = [true; diff(bnans) ~= 0; true];  % TRUE if values change
    nn = diff(find(dd));  % Number of repetitions

    if sum(bnans(1:2880)) > 1000
        cc = 1;
        nancc = 0;
        while nancc < 1000
            nancc = nancc + nn(cc);
            cc = cc + 1;
        end
        b = b(nancc + 1:end);
        a = a(nancc + 1:end);
   
    end

    if sum(bnans(end-2880:end)) > 1000
        cc = 0;
        nancc = 0;
        while nancc < 1000
            nancc = nancc + nn(end-cc);
            cc = cc + 1;
        end
        b = b(1:end-nancc);
        a = a(1:end-nancc);
   
    end

    % Treatment 4
    % Fix head short Nan issue
    bnans = isnan(b);
    dd = [true; diff(bnans) ~= 0; true];  % TRUE if values change
    nn = diff(find(dd));  % Number of repetitions
    if bnans(1)
        b = b(nn(1) + 1:end);
        a = a(nn(1) + 1:end);
    end
    

    bnanCountPost(i) = sum(isnan(b));
    c = movmean(b, 120*4+1, 'omitnan', 'Endpoints', 'fill');
    cnanCountPost(i) = sum(isnan(c));
    
    GSObj.a = a;
    GSObj.b = b;
    GSObj.c = c;
    GSObj.a_backup = a_backup;
    GSObj.b_backup = b_backup;
    save([savePath HActo.fileList{i}], 'GSObj', '-v7.3');

end
fprintf('\n');

varNames = {'index', 'fileName', 'timeDiffCheck', 'bnan', 'bnanPost', 'cnan', 'cnanPost'};
HActo.property = table((1:HActo.fileLen)', HActo.fileList, td, bnanCount, bnanCountPost, cnanCount, cnanCountPost, 'VariableNames',varNames);

save(matFile, 'HActo', '-v7.3');