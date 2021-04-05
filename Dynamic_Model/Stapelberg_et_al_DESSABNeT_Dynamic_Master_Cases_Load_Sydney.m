

%% DESSABNeT Dynamic Model. Copyright (C) Nicolas J. C. Stapelberg 2020, 2021, All Rights Reserved 

        % A Discrete-Event, Simulated Social Agent-Based Network Transmission (DESSABNeT) Model for Communicable Diseases
        % Programmed by Nicolas J. C. Stapelberg, commenced 2 April 2020
        % Modular Version completed 20 August 2020
        
       
    % This program is free software: you can redistribute it and/or modify
    % it under the terms of the GNU General Public License as published by
    % the Free Software Foundation, either version 3 of the License, or
    % (at your option) any later version.

    % This program is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    % GNU General Public License for more details: Please access <https://www.gnu.org/licenses/>.
    
    % If you use this software, please cite the following peer-reviewed paper: 
    
    % N.J.C. Stapelberg, N.R. Smoll, M. Randall, D. Palipana, B. Bui, K. Macartney, G. Khandaker, A. Wattiaux (In Review). 
    % A Discrete-Event, Simulated Social Agent-Based Network Transmission (DESSABNeT) Model for Communicable Diseases: 
    % Method and Validation Using SARS-CoV-2 Data in Three Large Australian Cities. PlosOne  


        %% Load Global Variables and All TimeTables:
         
         clearvars
         rng default
         %rng shuffle
         fprintf('%s\t','Loading Simulated Population...');
         fprintf('\n');
         
         
         %% Load Global Variables and Context Data
        
         % Use this code to load the smaller test population:
         load('2021_DESSABNeT_Population_Setup_Global_10000_v7_3.mat') 
         Index_Variables_A = load('2021_DESSABNeT_Population_Indexed_Variables_Phase1_10000_v7_3.mat');
         Index_Variables_B = load('2021_DESSABNeT_Population_Indexed_Variables_Phase3_10000_v7_3.mat');
         Index_Variables_C = load('2021_DESSABNeT_Population_Indexed_Variables_Phase4_10000_v7_3.mat');
         
         %{
         % Use this code to load the full Sydney population:
         load('2021_DESSABNeT_Population_Setup_Global_5312000_v7_3.mat') %5312000
         Index_Variables_A = load('2021_DESSABNeT_Population_Indexed_Variables_Phase1_5312000_v7_3.mat');
         Index_Variables_B = load('2021_DESSABNeT_Population_Indexed_Variables_Phase3_5312000_v7_3.mat');
         Index_Variables_C = load('2021_DESSABNeT_Population_Indexed_Variables_Phase4_5312000_v7_3.mat');
        %}

         %% Load Case Injection Spreadsheet if Required
         Stapelberg_et_al_DESSABNeT_Dynamic_Module_Inj_XCL_Load_Sydney   
         
         %% Modify Disease Dynamic Parameters
         fprintf('%s\t','Modifying Disease Dynamic Parameters...');
         fprintf('\n');
         Stapelberg_et_al_DESSABNeT_Dynamic_Disease_Dynamic_Vars
         
         %% Multiple Runs Code Block - Context A
         
         Date_Time = string(datetime('today'));
         Context_Title = strcat('_Sydney_',Date_Time,'_');
         
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
        WeekCalendar = 7;  %Day 1 of the simulation is Sunday the 1st of March
        How_Many_Runs = 3; %100 %Between 50-300
        How_Many_Days = 80; %8  Run simulation for how many days?
        Day_One_of_B = 24; % Day 1 of Context B, Phase 3
        Day_One_of_C = 31; % Day 1 of Context C, Phase 4
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
         
         
         
         %% Load and Run the Standard DESSABNeT Dynamic Model Module:
         
         fprintf('%s\t','Running Simulation...');
         fprintf('\n');
         Stapelberg_et_al_DESSABNeT_Dynamic_Standard_Module_Sydney
         
        
         
         