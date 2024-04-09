

% -------------------------------------------------
% Citation details:
% Alireza Askarzadeh, Anovel metaheuristic method for solving constrained
% engineering optimization problems: Crow search algorithm, Computers &
% Structures, Vol. 169, 1-12, 2016.

% Programmed by Alireza Askarzadeh at Kerman Graduate %
% University of Advanced Technology (KGUT) %
% Date of programming: September 2015 %
% -------------------------------------------------
% This demo only implements a standard version of CSA for minimization of
% a standard test function (Sphere) on MATLAB 7.6.0 (R2008a).
% -------------------------------------------------
% Note:
% Due to the stochastic nature of meta-heuristc algorithms, different runs
% may lead to slightly different results.
% -------------------------------------------------
function [g_best,ffit]=CrowSearchAlgorithm
format long;

pd=2; % Problem dimension (number of decision variables)
N=50; % Flock (population) size
AP=0.1; % Awareness probability
fl=2; % Flight length (fl)

[x,l,u]=init(N,pd); % Function for initialization
for k=1:N
ft(k)=Load_Flow(x(k,:)); % Function for fitness evaluation
end
mem=x; % Memory initialization
fit_mem=ft; % Fitness of memory positions

tmax=100; % Maximum number of iterations (itermax)
for t=1:tmax

    num=ceil(N*rand(1,N)); % Generation of random candidate crows for following (chasing)
    for i=1:N
        if rand>AP
            xnew(i,:)= round(x(i,:)+fl*rand*(mem(num(i),:)-x(i,:)),0); % Generation of a new position for crow i (state 1)
        else
            for j=1:pd
                xnew(i,j)=round(l(pd)-(l(pd)-u(pd))*rand,0); % Generation of a new position for crow i (state 2)
            end
        end
    xn(i,:)=xnew(i,:);
    ft(i)=Load_Flow(xn(i,:)); % Function for fitness evaluation of new solutions    
    end



    for i=1:N % Update position and memory
        if xnew(i,:)>=l & xnew(i,:)<=u
            x(i,:)=xnew(i,:); % Update position
            if ft(i)<fit_mem(i)
                mem(i,:)=xnew(i,:); % Update memory
                fit_mem(i)=ft(i);
            end
        end
    end

    ffit(t)=min(fit_mem); % Best found value until iteration t
    min(fit_mem);
    disp(['Iteration ' num2str(t) ': Best Cost = ' num2str(ffit(t))]);
end

ngbest=find(fit_mem== min(fit_mem));
g_best=mem(ngbest(1),:); % Solutin of the problem
end

