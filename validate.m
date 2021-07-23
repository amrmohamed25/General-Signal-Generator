function y=validate(string)
k=1;
while(k==1)
        choice=str2double(input(string,'s')); %used to check if the input is correct or not
        %str2double convert string to double if it isn't a number it will give nan
        if(isnan(choice))
            fprintf('Error!Try Again!!!\n')
        else
            k=0;
            y=choice;%no error
        end
    end
end