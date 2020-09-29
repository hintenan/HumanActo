function [obj, lastsize] = checkpoint(xData, pwave, obj, cc)

        [sinRe_check, gof_check] = sinFit1(xData, pwave, obj.ffRe{cc}.w, [obj.sinRe{cc}.a0 obj.sinRe{cc}.a1 obj.sinRe{cc}.c], 10);
        %psize = fprintf('checking...\n');
        
        if sinRe_check.a1 < 0
            fprintf("1\n")
        end
        if sinRe_check.c > pi*2
            fprintf("2\n")
        end
        if sinRe_check.c < -pi*2
            fprintf("2\n")
        end
        if sinRe_check.c > pi
            fprintf("3\n")
        end
        if sinRe_check.c < -pi
            fprintf("3\n")
        end
        
        obj.sinRe{cc} = sinRe_check;
        
end