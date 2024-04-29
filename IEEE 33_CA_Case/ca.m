%
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: YPEA125
% Project Title: Implementation of Cultural Algorithm in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Cite as:
% Mostapha Kalami Heris, Cultural Algorithm (CA) in MATLAB (URL: https://yarpiz.com/425/ypea125-cultural-algorithm), Yarpiz, 2015.
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

% clc;
% clear;
% close all;
function [g_best,BestCost]=ca
format long;
%% Problem Definition

%CostFunction = @(x) Sphere(x);        % Cost Function

nVar = 2;          % Number of Decision Variables

VarSize = [1 nVar];   % Decision Variables Matrix Size

VarMin = [1000 2];         % Decision Variables Lower Bound
VarMax = [2300 33];         % Decision Variables Upper Bound

%% Cultural Algorithm Settings

MaxIt = 100;         % Maximum Number of Iterations

nPop = 50;            % Population Size

pAccept = 0.35;                   % Acceptance Ratio
nAccept = round(pAccept*nPop);    % Number of Accepted Individuals

alpha = 0.3;

beta = 0.5;

%% Initialization

% Initialize Culture
Culture.Situational.Cost = inf;
Culture.Normative.Min = inf(VarSize);
Culture.Normative.Max = -inf(VarSize);
Culture.Normative.L = inf(VarSize);
Culture.Normative.U = inf(VarSize);

% Empty Individual Structure
empty_individual.Position = [];
empty_individual.Cost = [];

% Initialize Population Array
pop = repmat(empty_individual, nPop, 1);

% Generate Initial Solutions
for i = 1:nPop
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    pop(i).Cost = Load_Flow(pop(i).Position);
end

% Sort Population
[~, SortOrder] = sort([pop.Cost]);
pop = pop(SortOrder);

% Adjust Culture using Selected Population
spop = pop(1:nAccept);
Culture = AdjustCulture(Culture, spop);

% Update Best Solution Ever Found
GlobalBest = Culture.Situational;

% Array to Hold Best Costs
BestCost = zeros(MaxIt, 1);

%% Cultural Algorithm Main Loop

for it = 1:MaxIt
    
    % Influnce of Culture
    for i = 1:nPop
        
        % % 1st Method (using only Normative component)
%         sigma = alpha*Culture.Normative.Size;
%         pop(i).Position = pop(i).Position+sigma.*randn(VarSize);
        
        % % 2nd Method (using only Situational component)
%         for j = 1:nVar
%            sigma = 0.1*(VarMax-VarMin);
%            dx = sigma*randn;
%            if pop(i).Position(j)<Culture.Situational.Position(j)
%                dx = abs(dx);
%            elseif pop(i).Position(j)>Culture.Situational.Position(j)
%                dx = -abs(dx);
%            end
%            pop(i).Position(j) = pop(i).Position(j)+dx;
%         end
        
        % % 3rd Method (using Normative and Situational components)
        for j = 1:nVar
          sigma = alpha*Culture.Normative.Size(j);
          dx = sigma*randn;
          if pop(i).Position(j)<Culture.Situational.Position(j)
              dx = abs(dx);
          elseif pop(i).Position(j)>Culture.Situational.Position(j)
              dx = -abs(dx);
          end
          pop(i).Position(j) = pop(i).Position(j)+dx;
        end        
        
        % % 4th Method (using Size and Range of Normative component)
%         for j = 1:nVar
%           sigma = alpha*Culture.Normative.Size(j);
%           dx = sigma*randn;
%           if pop(i).Position(j)<Culture.Normative.Min(j)
%               dx = abs(dx);
%           elseif pop(i).Position(j)>Culture.Normative.Max(j)
%               dx = -abs(dx);
%           else
%               dx = beta*dx;
%           end
%           pop(i).Position(j) = pop(i).Position(j)+dx;
%         end        
        
        pop(i).Cost = Load_Flow(pop(i).Position);
        
    end
    
    % Sort Population
    [~, SortOrder] = sort([pop.Cost]);
    pop = pop(SortOrder);

    % Adjust Culture using Selected Population
    spop = pop(1:nAccept);
    Culture = AdjustCulture(Culture, spop);

    % Update Best Solution Ever Found
    GlobalBest = Culture.Situational;
    
    % Store Best Cost Ever Found
    BestCost(it) = GlobalBest.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
end
g_best=GlobalBest.Position;
% %% Results
% 
% figure;
% %plot(BestCost, 'LineWidth', 2);
% semilogy(BestCost, 'LineWidth', 2);
% xlabel('Iteration');
% ylabel('Best Cost');
% grid on;

