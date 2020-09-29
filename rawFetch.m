% Reading raw data into mat
% NO TREATMENT AT ALL
% Part 1
% You might treat it as a convention
dirPath = pwd;
dirPath = [dirPath 'Data/'];
gsFilePath = [dirPath 'GS/'];
fixedPath = [dirPath 'GS_Fixed/'];
savePath = [dirPath 'mat/acto/'];
matFile = [dirPath 'mat/HActo.mat'];
gsFileName = sort(split(ls(gsFilePath)));
gsFileName = gsFileName(2:end);
fileLen = length(gsFileName);


SKIPPER = 250;
formater = '%q%{yyyy/MM/dd}D%q%q%q%q%q%q%q%q%q%q%q%q%q';
skipRead = 0;
countFixed = 1;
fixQueue = [];


if exist(matFile, 'file') == 2
    load(matFile)
    fileMod = HActo.fileMod;
    skipNum = HActo.skipNum;
    colStartTag = HActo.colStartTag;
    colEndTag = HActo.colEndTag;
    fileStartTag = HActo.fileStartTag;
    fileEndTag = HActo.fileEndTag;
else
    fileMod = zeros(length(gsFileName), 1);
    skipNum = zeros(length(gsFileName), 1);
    colStartTag = NaT(length(gsFileName), 1);
    colEndTag = NaT(length(gsFileName), 1);
    fileStartTag = NaT(length(gsFileName), 1);
    fileEndTag = NaT(length(gsFileName), 1);
end

lastsize = 0;
for i = 1:fileLen
    fprintf(repmat('\b', 1, lastsize));
    lastsize = fprintf('Fetching %s ', gsFileName{i});
    
    fid = fopen([gsFilePath gsFileName{i}],'r', 'n', 'UTF-8');    
    if fid > 0
        M = textscan(fid, formater, 'delimiter', ',', 'headerlines', SKIPPER);
    else
        fprintf('Can not find file: %s\n', [gsFilePath gsFileName{i}]);
    end
    if fid > 0
        fclose(fid);
    end
    
    for j = 1:5
        if isempty(M{1}{j})
            skipRead = 1; % 1 is empty
            fprintf('.');
            lastsize = lastsize + 1;
        end
    end
    
    if skipRead % == 1 then find fixed file
        fidf = fopen([fixedPath gsFileName{i}],'r', 'n', 'UTF-8');
        psize = fprintf('Checking fixed %s', gsFileName{i});
        lastsize = lastsize + psize;
        if fidf > 0
            M = textscan(fidf, formater, 'delimiter', ',', 'headerlines', SKIPPER);
        else
            fprintf('Can not find FIXED file: %s\n', [fixedPath gsFileName{i}]);
            skipRead = 2; % file needed to be fixed.
            
        end
        
        if skipRead ~= 2
            for j = 1:5
                if isempty(M{1}{j})
                    skipRead = 2;
                    fprintf('.');
                    lastsize = lastsize + 1;
                    continue
                else
                    skipRead = 1;
                end
            end
        end
        if fidf
            fclose(fidf);
        end
    end
                
    if skipRead == 2
        fprintf('Skippig: %s\n', [gsFilePath gsFileName{i}]);
        fixQueue{countFixed} = gsFileName{i};
        countFixed = countFixed + 1;
        skipRead = 0;
        continue
    end
    
    % file format checking is done, now reading
    fprintf('.');
    lastsize = lastsize + 1;
    if skipRead == 0
        fidc = fopen([gsFilePath gsFileName{i}],'r', 'n', 'UTF-8');
    elseif skipRead == 1
        fidc = fopen([fixedPath gsFileName{i}],'r', 'n', 'UTF-8');
        skipRead = 0;
    end
    
    yourLine = cell(1, 4);
    if fidc ~= -1
      for j = 1:22
        fgetl(fid);
      end
      for j = 1:4
        yourLine{j} = fgetl(fid);
      end
    end
    td1 = split(yourLine{1}, [",", '"']);
    td2 = split(yourLine{2}, [",", '"']);
    td2 = timeFix(td2{5});
    ts = datetime(datetime(td1{5}, 'InputFormat', 'yyyy/MM/dd') + duration(td2), 'Format', 'yyyy/MM/dd HH:mm:ss');
    td1 = split(yourLine{3}, [",", '"']);
    td2 = split(yourLine{4}, [",", '"']);
    td2 = timeFix(td2{5});
    te = datetime(datetime(td1{5}, 'InputFormat', 'yyyy/MM/dd') + duration(td2), 'Format', 'yyyy/MM/dd HH:mm:ss');
    
    if fidc ~= -1
        newM = textscan(fidc, formater, 'delimiter', ',', 'headerlines', SKIPPER - str2double(M{1}{1}) + 1 - 26);
    end
    fprintf('.');
    lastsize = lastsize + 1;
    newM{3} = timeFix(newM{3});
    
    % save conflict para
    a = datetime(newM{2} + duration(newM{3}), 'Format','yyyy/MM/dd HH:mm:ss');
    b = str2double(newM{5});
    colStartTag(i) = ts;
    colEndTag(i) = te;
    fileStartTag(i) = a(1);
    fileEndTag(i) = a(end);
    
    c = movmean(b, 120*4+1, 'omitnan', 'Endpoints', 'fill');
    dayNum = unique(newM{2});
    dayName = datestr(dayNum, 'ddd');
    killnan = 0;
    if isempty(a)
        fprintf('a is empty.\n');
    end
    if isempty(b)
        fprintf('b1? is empty.\n');
    end

    GSObj.a = a;
    GSObj.b = b;
    GSObj.c = c;
    GSObj.dayNum = dayNum;
    GSObj.dayName = dayName;
    GSObj.killnan = killnan;

    save([savePath gsFileName{i}(1:end-4) '.mat'], 'GSObj', '-v7.3');
    if fidc > 0
        fclose(fidc);
    end
    
    skipNum(i) = SKIPPER - str2double(M{1}{1}) + 1;
end
fprintf('\n');


gsFileName = sort(split(ls(savePath)));
gsFileName = gsFileName(2:end);

HActo.rawMatPath = savePath;
HActo.fileLen = length(gsFileName);
HActo.fileList = gsFileName;

HActo.fileMod = fileMod;
HActo.skipNum = skipNum;
HActo.colStartTag = datetime(colStartTag, 'Format', 'yyyy/MM/dd HH:mm:ss');
HActo.colEndTag = datetime(colEndTag, 'Format', 'yyyy/MM/dd HH:mm:ss');
HActo.fileStartTag = datetime(fileStartTag, 'Format', 'yyyy/MM/dd HH:mm:ss');
HActo.fileEndTag = datetime(fileEndTag, 'Format', 'yyyy/MM/dd HH:mm:ss');

save(matFile, 'HActo', '-v7.3');