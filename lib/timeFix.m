function [timeLine] = timeFix(timeLine)
    % change wired time format
    timeLine = replace(timeLine, '�W�� 01', '01');
    timeLine = replace(timeLine, '�W�� 02', '02');
    timeLine = replace(timeLine, '�W�� 03', '03');
    timeLine = replace(timeLine, '�W�� 04', '04');
    timeLine = replace(timeLine, '�W�� 05', '05');
    timeLine = replace(timeLine, '�W�� 06', '06');
    timeLine = replace(timeLine, '�W�� 07', '07');
    timeLine = replace(timeLine, '�W�� 08', '08');
    timeLine = replace(timeLine, '�W�� 09', '09');
    timeLine = replace(timeLine, '�W�� 10', '10');
    timeLine = replace(timeLine, '�W�� 11', '11');
    timeLine = replace(timeLine, '�U�� 12', '12');
    
    timeLine = replace(timeLine, '�W�� 12', '00');
    timeLine = replace(timeLine, '�U�� 01', '13');
    timeLine = replace(timeLine, '�U�� 02', '14');
    timeLine = replace(timeLine, '�U�� 03', '15');
    timeLine = replace(timeLine, '�U�� 04', '16');
    timeLine = replace(timeLine, '�U�� 05', '17');
    timeLine = replace(timeLine, '�U�� 06', '18');
    timeLine = replace(timeLine, '�U�� 07', '19');
    timeLine = replace(timeLine, '�U�� 08', '20');
    timeLine = replace(timeLine, '�U�� 09', '21');
    timeLine = replace(timeLine, '�U�� 10', '22');
    timeLine = replace(timeLine, '�U�� 11', '23');

end
