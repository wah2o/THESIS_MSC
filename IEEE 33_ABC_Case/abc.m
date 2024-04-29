%
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: YPEA114
% Project Title: Implementation of Artificial Bee Colony in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Cite as:
% Mostapha Kalami Heris, Artificial Bee Colony in MATLAB (URL: https://yarpiz.com/297/ypea114-artificial-bee-colony), Yarpiz, 2015.
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

%

%% Problem Definition
function [g_best,BestCost]=abc
format long;
%CostFunction = @(x) Sphere(x);        % Cost Function

nVar = 2;             % Number of Decision Variables

VarSize = [1 nVar];   % Decision Variables Matrix Size

VarMin = [1000 2];         % Decision Variables Lower Bound
VarMax = [2300 33];         % Decision Variables Upper Bound

%% ABC Settings

MaxIt = 100;              % Maximum Number of Iterations

nPop = 50;               % Population Size (Colony Size)

nOnlooker = nPop;         % Number of Onlooker Bees

L = round(0.6*nVar*nPop); % Abandonment Limit Parameter (Trial Limit)

a = 1;                    % Acceleration Coefficient Upper Bound

%% Initialization

% Empty Bee Structure
empty_bee.Position = [];
empty_bee.Cost = [];

% Initialize Population Array
pop = repmat(empty_bee, nPop, 1);

% Initialize Best Solution Ever Found
GlobalBest.Cost = inf;

% Create Initial Population
for i = 1:nPop
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    pop(i).Cost = Load_Flow(pop(i).Position);
    if pop(i).Cost <= GlobalBest.Cost
        GlobalBest = pop(i);
    end
end

% Abandonment Counter
C = zeros(nPop, 1);

% Array to Hold Best Cost Values
BestCost = zeros(MaxIt, 1);

%% ABC Main Loop

for it = 1:MaxIt
    
    % Recruited Bees
    for i = 1:nPop
        
        % Choose k randomly, not equal to i
        K = [1:i-1 i+1:nPop];
        k = K(randi([1 numel(K)]));
        
        % Define Acceleration Coeff.
        phi = a*unifrnd(-1, +1, VarSize);
        
        % New Bee Position
        newbee.Position = pop(i).Position+phi.*(pop(i).Position-pop(k).Position);
        
        % Apply Bounds
        newbee.Position = max(newbee.Position, VarMin);
        newbee.Position = min(newbee.Position, VarMax);

        % Evaluation
        newbee.Cost = Load_Flow(newbee.Position);
        
        % Comparision
        if newbee.Cost <= pop(i).Cost
            pop(i) = newbee;
        else
            C(i) = C(i)+1;
        end
        
    end
    
    % Calculate Fitness Values and Selection Probabilities
    F = zeros(nPop, 1);
    MeanCost = mean([pop.Cost]);
    for i = 1:nPop
        F(i) = exp(-pop(i).Cost/MeanCost); % Convert Cost to Fitness
    end
    P = F/sum(F);
    
    % Onlooker Bees
    for m = 1:nOnlooker
        
        % Select Source Site
        i = RouletteWheelSelection(P);
        
        % Choose k randomly, not equal to i
        K = [1:i-1 i+1:nPop];
        k = K(randi([1 numel(K)]));
        
        % Define Acceleration Coeff.
        phi = a*unifrnd(-1, +1, VarSize);
        
        % New Bee Position
        newbee.Position = pop(i).Position+phi.*(pop(i).Position-pop(k).Position);
        
        % Apply Bounds
        newbee.Position = max(newbee.Position, VarMin);
        newbee.Position = min(newbee.Position, VarMax);
        
        % Evaluation
        newbee.Cost = Load_Flow(newbee.Position);
        
        % Comparision
        if newbee.Cost <= pop(i).Cost
            pop(i) = newbee;
        else
            C(i) = C(i) + 1;
        end
        
    end
    
    % Scout Bees
    for i = 1:nPop
        if C(i) >= L
            pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
            pop(i).Cost = Load_Flow(pop(i).Position);
            C(i) = 0;
        end
    end
    
    % Update Best Solution Ever Found
    for i = 1:nPop
        if pop(i).Cost <= GlobalBest.Cost
            GlobalBest = pop(i);
        end
    end
    
    % Store Best Cost Ever Found
    BestCost(it) = GlobalBest.Cost;
    
    % Display Iteration Information
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
