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


%% DESSABNeT, Dynanic Standard Module
        
       % This module acts as an engine for the DESSABNeT Dynamic Model Simulation. Key variables are loaded and then all the big nested loops for the Dynamic Model Simulation are run from here.  

        Start_Bigger_Cycle = 1; 
        End_Bigger_Cycle = 1;
        Gapper= 1;
        Global_N_Contexts = 4; %Set the number of contexts for this city
         
        % This will be required to calculate positive "case injections":
        Adult_Carriers = round((100-(Perc_Under_5+Perc_School_5_19))/100*Population,0);
        Injected_Number=zeros(50,1); %For CQ and Constant Injection Simulations       
         
        Result_Array1 = zeros(How_Many_Days*How_Many_Runs*(1+ceil((End_Bigger_Cycle+1-Start_Bigger_Cycle)/Gapper)),63); 
        Result_Array2 = zeros(How_Many_Days,63,1+ceil((End_Bigger_Cycle+1-Start_Bigger_Cycle)/Gapper)); 
        Result_Array5 = zeros(How_Many_Runs,How_Many_Days,63);
        Contact_Tracing_Factor_On = 0.73;
        Contact_Tracing_Factor_Off = 1;
        
        Bigger_Cycle_Count=0;
        Universal_Counter = 0; %This allows a continous count of each day across runs and bigger_counter 
        
        R0_Matrix = zeros(4,4,7,7); % This is an array for calculation of R0 in a separate module...
        Sub_G_Counter = zeros(4,7,7); % This is an array for calculation of R0 in a separate module...
        R0_Matrix_S = zeros(4,4); % This is an array for calculation of R0 in a separate module...
        Sub_G_Counter_S = zeros(4,1); % This is an array for calculation of R0 in a separate module...
        R0_Matrix_C = zeros(4,4,7); % This is an array for calculation of R0 in a separate module...
        Person_Matrix = zeros(Population,36);
        Person_Profile = Person_Profile(1:Population,:);
        Person_Matrix(:,1:8)= Person_Profile(:,1:8);

        People_Age_No(1) = sum(Person_Profile(:,2)==1);
        People_Age_No(2) = sum(Person_Profile(:,2)==2);
        People_Age_No(3) = sum(Person_Profile(:,2)==3);
        People_Age_No(4) = sum(Person_Profile(:,2)==4);
        
        Pop_Range_0_4_Start = 1;
        Pop_Range_0_4_End = People_Age_No(1);
        Pop_Range_5_19_Start = People_Age_No(1)+1;
        Pop_Range_5_19_End = People_Age_No(1)+People_Age_No(2);
        Pop_Range_20_64_Start = People_Age_No(1)+People_Age_No(2)+1;
        Pop_Range_20_64_End = People_Age_No(1)+People_Age_No(2)+People_Age_No(3);
        Pop_Range_65_Over_Start = People_Age_No(1)+People_Age_No(2)+People_Age_No(3)+1;
        Pop_Range_65_Over_End = People_Age_No(1)+People_Age_No(2)+People_Age_No(3)+People_Age_No(4);
        
        Infectors = zeros(4,1);
        Daily_Infections = zeros(Population,How_Many_Days);
        Daily_Infectors = zeros(Population,How_Many_Days);
        Cumulative_Infectors = 0;
        Cumulative_Infections = 0;
        School_Open = 1;    
        
        %% Big Loops
    for Even_BiggerCounter = 1:1
                
        
        for BiggerCounter = Start_Bigger_Cycle:Gapper:End_Bigger_Cycle
                        Bigger_Cycle_Count=Bigger_Cycle_Count+1;
                        Result_Array3 = zeros(How_Many_Days,63); 

                Context_Designator = strcat(Context_Title,string(BiggerCounter),'_');  

                 R_Zero = zeros(How_Many_Days,1);
                 R_Zero_Daily = zeros(How_Many_Days,1);
                 Container = zeros(How_Many_Runs,20,Global_N_Contexts); 

             for Run_Counter = 1:How_Many_Runs
                 
                %% Load Run Counter Variables:   
                 Stapelberg_et_al_DESSABNeT_Dynamic_Module_Run_Counter_V
                
                %% Day_Count Loop:   
                
                        for Day_Count = 1:How_Many_Days % Big Time Loop
                            
                              %% Restrictions Code Block for This City:
                            
                                Stapelberg_et_al_DESSABNeT_Dynamic_Restr_Code_Block_Sydney

                              %% Case Injection Module:

                                Stapelberg_et_al_DESSABNeT_Dynamic_Module_Case_Injection_Sydney


                              %% Transmission Code Block:
                              
                                
                                Stapelberg_et_al_DESSABNeT_Dynamic_Module_Transmission
                             

                              %% Medical Sequelae Code Block and Quarantine Code Block:
                              
                                Stapelberg_et_al_DESSABNeT_Dynamic_Module_Med_Seq_Code_Block
                                Stapelberg_et_al_DESSABNeT_Dynamic_Module_Quarantine


                              %% Calculate and Present Data Within Daycount:
                             
                              Stapelberg_et_al_DESSABNeT_Dynamic_Module_Output

                        end % Day_Count


                %% Calculate and Present Container Data Within BigCounter:
               
                Stapelberg_et_al_DESSABNeT_Dynamic_Module_Container_Table


            end %BigCounter

                %% Calculate and Present Data Within BiggerCounter:
               
                Stapelberg_et_al_DESSABNeT_Dynamic_Module_Epi1_Table

        end %BiggerCounter
       
        Stapelberg_et_al_DESSABNeT_Dynamic_Module_Epi2_Table
    end %Even_BiggerCounter

       