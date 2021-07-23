clc;
clear all;
Fs=validate('Please Enter Sampling Frequency of the Signal:');
while(Fs<=0)
    if(Fs<=0)
        fprintf('Error!Try Again!!!\n');
    end
    Fs= validate('Please Enter Sampling Frequency of the Signal:');
end
t_start= validate('Please Enter Start of Time Scale:');

t_end= validate('Please Enter End of Time Scale:');
while(t_start>=t_end)
    fprintf('Start time should be smaller than end time!Try Again')
    t_start= validate('Please Enter Start of Time Scale:');
    t_end= validate('Please Enter End of Time Scale:');
end
 n= validate('Please Enter Number of Break points:');
    while(n<0)
        fprintf('Error!!Incorrect Number of Breakpoints');
        n= validate('Please Enter Number of Break points:');
    end
bp=[];
for i=1:n
    str=sprintf('Please Enter position of Breakpoint %d at t=',i);
    bp(i)=validate(str);
    if(bp(i)<=t_start | bp(i)>=t_end)
        fprintf('Error!!Breakpoints should be between Start and end of time scale\n');
        bp(i)=validate('Please Enter position of Breakpoint at t=');
    end
end
bp(end+1)=t_start(1);
bp(end+1)=t_end(1);
points=sort(bp);
Signal=[];
T=[];
i=1;
%Adding zeros to view the signal
t=points(1)-2:1/Fs:points(1);
a=zeros(size(t));
Signal=[Signal a];
T=[T t];
while(i<=length(points)-1)
    temp=[];
    str=sprintf('From %d to %d\n1.Dc\n2.Ramp\n3.Polynomial\n4.Exponential\n5.Sinuisoidal.\nPlease Choose from 1 to 5:',points(i),points(i+1));
    choice=validate(str);
    t=linspace(points(i),points(i+1),(points(i+1)-points(i))*Fs);
    if(choice==1)
        amplitude=validate('Please Enter Amplitude:');
        a=t>=points(i);
        b=t>points(i+1);
        temp= amplitude*(a-b); 
        Signal=[Signal temp]; %Concatenating Signal
        T=[T t]; 
        
    elseif(choice==2)
        slope=validate('Please Enter Slope:');
        intercept=validate('Please Enter Intercept:');
        temp = (slope.*t+intercept).*(t>=0);%Ramp is Causal
        Signal=[Signal temp];
        T=[T t];
    elseif(choice==3)
        fprintf('Polynomial Ex:amplitude*(at^order+bt^(order-1)+...)\n');
        power=validate('Please Enter order of equation :');
        while(power<0 | mod(power,1))%Order must be positive integer 
            power=validate('Please Enter (Positive integer) order of equation :');
        end
        amplitude=validate('Please Enter Amplitude:');
        temp=zeros(1,(points(i+1)-points(i))*Fs);
        for j=power:-1:0
            str=sprintf('Please Enter Coefficient of t^%d:',j);
            coefficient=validate(str);
            temp=temp+coefficient*(t.^j);
        end
        Signal=[Signal amplitude.*temp];
        T=[T t];
    elseif(choice==4)
        amplitude=validate('Please Enter amplitude:');
        exponent=validate('Please Enter exponent:');
        temp=amplitude.*exp(exponent.*t);
        Signal=[Signal temp];
        T=[T t];
    elseif(choice==5)
        amplitude=validate('Please Enter amplitude:');
        frequency=validate('Please Enter Frequency:');
        while(frequency<0)
            frequency=validate('Please Enter positive Frequency:');
        end
        phase=validate('Please Enter phase:');
        temp=amplitude.*sin(2*pi*frequency.*t+phase);
        Signal=[Signal temp];
        T=[T t];
    else
        fprintf('Please Choose a valid signal!\n');
        i=i-1;
    end
    i=i+1;
end
t=points(end):1/Fs:points(end)+2;
a=zeros(size(t));
Signal=[Signal a];
T=[T t];
figure;plot(T,Signal);grid on;
flag=1;
while(flag==1)
    operation=validate('Operations:\n1.Amplitude Scaling\n2.Time Reversal\n3.Time Shift\n4.Expanding the Signal\n5.Compressing the Signal\n6.None\nPlease Choose an operation from 1 to 6:');
    if(operation==1)
        scale=validate('Please Enter Scale value:');
        Signal=scale.*Signal;
        
    elseif(operation==2)
        T=-T;
    elseif(operation==3)
        shift=validate('Please Enter Shift Value:');
        T=T+shift;
        
    elseif(operation==4)
        expand=validate('Please Enter Expanding value:');
        while(expand<=0)
            expand=validate('Error!Try Again!!!Please Enter Expanding value:');
        end
        T=T.*expand;
        
    elseif(operation==5)
        compress=validate('Please Enter Compressing value:');
        while(compress<=0)
            compress=validate('Error!Try Again!!!Please Enter Compressing value:');
        end
        T=T./compress;
    elseif(operation==6)
        flag=0;
    else
        fprintf('Error!Please Choose from 1 to 6\n');
        continue;
    end
    figure;plot(T,Signal); grid on;
end