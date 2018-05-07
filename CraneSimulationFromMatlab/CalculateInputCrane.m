function [input]=CalculateInputCrane(n,k,start,final,Ad,Bd,theta_epsilon_final,nominaleps)
% This function will calculate the input for a crane system using ensemble
% control.
% Nathan Vervaeke
% Universiteit Gent
% 2014

% n = number of states
% k = order of ensemble control
% start = initial conditions in vector format
% final = final conditions in vector format
% Ad = discrete-time state matrix, with epsilon as unknown parameter
% Bd = discrete-time input matrix, with epsilon as unknown parameter
% nominaleps = nominal value of epsilon

% Initialisation
syms epsilon;
R = zeros(2*k+2,2*k+2);
r = zeros(2*k+2,1);

% Calculate matrix needed for initial conditions
INI = simplify(Ad^(2*k+2));

% Create waitbar
steps = (2*k+2)^2;
step = 0;
h = waitbar(0,'Calculating input');

% Calculate Taylor series expansion of the ensemble of cranes
for j = 1:2*k+2
    f = simplify(Ad^(j-1)*Bd);
    s=0; % Initialize state switch
    for i = 1:k
        for m = 1:n-s
            R(s+2*(i-1)+m,j) = real(1/factorial(i-1)*subs(f(m+s),epsilon,nominaleps));
            step = step+1; 
            waitbar(step/steps) % Update waitbar
        end
        f=simplify(diff(f, sym('epsilon'), 1));
        s=2; % State switch: only calculate the last 2 states (the states that need ensemble control  
    end
end

% Calculate Taylor series expansion of the initial conditions
s = 0;
for i=1:k  
    ini = -(1/factorial(i-1))*subs(diff(INI*start', sym('epsilon'), (i-1)),epsilon,nominaleps);
    for m = 1:n-s
        r(s+2*(i-1)+m) = ini(m+s);
    end
    s = 2;
end

% Close waitbar
close(h) 

% Implement the final conditions
for m = 1:n
    r(m) = r(m)+final(m);
end

% Implement the epsilon-dependent final condition
if k>1
    r(5) = r(5)+theta_epsilon_final;
end

% Solve the system of linear equations to obtain the input and flip up
% down, because the first element has to be applied last.
input = flipud(R\r);
end