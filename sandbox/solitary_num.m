clear all
close all

test_number = 24;
test_val = sum(divisor(test_number))/test_number;
for id = 1:100000000
    out = sum(divisor(id))/id;


    if mod(id,10000) == 0
        fprintf(['Checking number ' num2str(id) '. \n']);
    end
    if out == test_val
        if test_number ~= id & id ~= 1
            fprintf(['The number ' num2str(test_number) ' is friendly with number ' num2str(id) '. \n'])
            break

        end
    end
end

% 
% find(out == test_val)
% figure; plot(1:id,out);
% figure; hist(out,1000);