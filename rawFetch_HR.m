% Reading raw data into mat

gsFilePath = './data/HR5/';
savePath = './data/mat/HR/';
gsFileName = sort(split(ls(gsFilePath)));
gsFileName = gsFileName(2:end);
fileLen = length(gsFileName);

lastsize = 0;
for i = 1%:fileLen
    fprintf(repmat('\b', 1, lastsize));
    lastsize = fprintf('Fetching %s', gsFileName{i});
    
    s = csvread([gsFilePath gsFileName{i}], 1, 0);
    a = datetime(s(:, 1:6));
    b = s(:, 7);
    %d = resample(b, tx, 1/300);
    
    %c = movmean(d, 60/5*4+1, 'omitnan', 'Endpoints', 'fill');
    dayNum = unique(yyyymmdd(a));
    dayName = datestr(datetime(floor(dayNum/10000), floor(rem(dayNum, 10000)/100), rem(dayNum, 100)), 'ddd');
    if length(dayNum) > 8
        fprintf('day length > 8.\n')
        
    end
    save([savePath gsFileName{i}(1:end-4)], 'a', 'b', 'dayNum', 'dayName');
    
    
    figure(1)
    plot(tx, b, 'b-')
    %hold on
    %plot(a, c, 'r.-')
    %hold off
    
end    
fprintf('\n');

FilePath = './data/mat/HR/';
FileName = sort(split(ls(FilePath)));
FileName = FileName(2:end);
fileLen = length(FileName);

HHR.fileList = FileName;
HHR.fileLen = fileLen;
save('HHR.mat', 'HHR', '-v7.3')
