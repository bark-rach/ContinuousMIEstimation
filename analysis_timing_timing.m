classdef analysis_timing_timing < MI_KSG_data_analysis
    %Each of these objects sets the stage to calculate the mutual
    %information between spike timing of neuron 1 and spike timing of neuron 2 and stores the results of
    %the calculation. 
    
    % For this type of calculation, it is likely that we will have to be creative
    % maybe we will use the average ISI in a breath cycle
    % maybe we will use only the first spike
    % We will have to see how much data we have. 
    
    properties
    end
    
    methods
        function obj = make_timing_behavior(objData,var1,var2)
            % var1- positive integer (neuron number)
            % var2- positive integer (neuron number)
            obj =  MI_KSG_data_analysis(objData, var1, var2);
        end
        
        function [xGroups, yGroups] = setXYvars(obj, verbose)
            % So I propose that we use this method to prep the
            % count_behavior data for the MI core and go ahead and run MI
            % core from here. Then we can use the output of MI core to fill
            % in the MI, kvalue, and errors.
            
            % First, segment neural data into breath cycles
            x = objData.dataByCycles(var1,verbose);
           
            % Find different subgroups for neuron 1
            xCounts = sum(~isnan(x),2);
            xConds = unique(xCounts);

            % Segment neuron 2 into breath cycles
            y = objData.dataByCycles(var2,verbose);

            % Find different subgroups for neuron 2
            yCounts = sum(~isnan(y),2);
            yConds = unique(yCounts);

            xGroups = {};
            yGroups = {};
            groupCounter = 1;
            for ixGroup = 1:length(xConds)
                ixCond = xConds(ixGroup);
                xgroupIdx = find(xCounts == ixCond);
                for iyGroup = 1:length(yConds)
                    iyCond = yConds(iyGroup);
                    ygroupIdx = find(yCounts == iyCond);
                    xygroupIdx = intersect(xgroupIdx,ygroupIdx);
                    xGroup = x(xygroupIdx,1:ixCond);
                    xGroups{groupCounter,1} = xGroup;
                    yGroup = y(xygroupIdx,1:iyCond);
                    yGroups{groupCounter,1} = yGroup;
                    Coeffs(groupCounter,1) = length(xygroupIdx))/length(xCounts);
                    groupCounter = groupCounter + 1;
                end
            end
            
            % Figure out how each subgroup is going to feed into the 
            % MI_sim_manager and set up the data for that (maybe via
            % different lists). 
            

            % Calculate probabilities
            obj.coeffs = Coeffs;
            
           
            % Separate the pressure data into the same subgroups
            
            
            % Next run the MI calculation and k optimization
            obj.kvalues = [INSERT RELEVANT CODE];
            obj.MIs = [INSERT RELEVANT CODE];
            obj.errors = [INSERT RELEVANT CODE];
            
        end
    end
end

