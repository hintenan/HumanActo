function [timeLine] = timeFix(timeLine)
    % change wired time format
    timeLine = replace(timeLine, '上午 01', '01');
    timeLine = replace(timeLine, '上午 02', '02');
    timeLine = replace(timeLine, '上午 03', '03');
    timeLine = replace(timeLine, '上午 04', '04');
    timeLine = replace(timeLine, '上午 05', '05');
    timeLine = replace(timeLine, '上午 06', '06');
    timeLine = replace(timeLine, '上午 07', '07');
    timeLine = replace(timeLine, '上午 08', '08');
    timeLine = replace(timeLine, '上午 09', '09');
    timeLine = replace(timeLine, '上午 10', '10');
    timeLine = replace(timeLine, '上午 11', '11');
    timeLine = replace(timeLine, '下午 12', '12');
    
    timeLine = replace(timeLine, '上午 12', '00');
    timeLine = replace(timeLine, '下午 01', '13');
    timeLine = replace(timeLine, '下午 02', '14');
    timeLine = replace(timeLine, '下午 03', '15');
    timeLine = replace(timeLine, '下午 04', '16');
    timeLine = replace(timeLine, '下午 05', '17');
    timeLine = replace(timeLine, '下午 06', '18');
    timeLine = replace(timeLine, '下午 07', '19');
    timeLine = replace(timeLine, '下午 08', '20');
    timeLine = replace(timeLine, '下午 09', '21');
    timeLine = replace(timeLine, '下午 10', '22');
    timeLine = replace(timeLine, '下午 11', '23');

end
