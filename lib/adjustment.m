function [obj] = adjustment(sinRe, ffRe, obj, cc)
    if sinRe.a1 < 0
        %fprintf('Sin1 power correction...\n')
        obj.sinRe{cc}.a1 = -sinRe.a1;
        obj.sinRe{cc}.c = sinRe.c - pi;
    
    end

    while obj.sinRe{cc}.c > pi
        fprintf('p\n')
        %fprintf('Sin1 pahse shifting ...\n')
        obj.sinRe{cc}.c = obj.sinRe{cc}.c - pi * 2;
    end
    while obj.sinRe{cc}.c < -pi
        fprintf('p\n')
        %fprintf('Sin1 pahse shifting ...\n')
        obj.sinRe{cc}.c = obj.sinRe{cc}.c + pi * 2;
    end

end