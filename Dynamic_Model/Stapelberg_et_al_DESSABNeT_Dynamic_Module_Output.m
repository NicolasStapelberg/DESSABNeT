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

        %% Calculate and Present All Output Data for Each Day:
          
        % Code for Person_Profile(:,9):
                % 0 = Susceptible (S)
                % 1 = Exposure1 or incubation period and is determined on a lognormal distibution ending in 14 days (minus 2 days = 12 days max)
                % 2 = Exposure2. Agents are shedding virus but not yet symptomatic. This is fixed at 2 days.
                % 3 = Infective (I) period. This is currently set at 10 days. Agents are shedding virus
                % 4 = Recovered (R)
                % 5 = Managed (M)
                % 6 = Death (D) 
                
            if Day_Count == 1, I2_Number = 0; end %This has to be here because Daily_I2_Yesterday requires it

            Daily_I2_Yesterday = I2_Number;
            % Calculate Today's Values:
            S_Number = sum(Person_Profile(:,9)==0);
            Returned_Travellers = Spreadsheet_Numbers(Day_Count,5); %FOR THE City Sim MODULE. 
            %Returned_Travellers = Injected_Number(Day_Count); %FOR THE Injection MODULE

            I1_Number = sum(Person_Profile(:,9)==1); % Number of agents in E1
            I2_Number = sum(Person_Profile(:,9)==2); % Number of agents in E1
            I3_Number = sum(Person_Profile(:,9)==3 & Person_Profile(:,39) ~= 1); % Number of agents in I (without returning travellers)
            I4_Number = sum(Person_Profile(:,9)==3 & Person_Profile(:,43)==1 & Person_Profile(:,39) ~= 1); %This counts only symptomatic cases (who are not returning travellers)
            R_Number = sum(Person_Profile(:,9)==4); % Number of agents Recovered
            M_Number = sum(Person_Profile(:,9)==5); % Number of agents Managed
            D_Number = sum(Person_Profile(:,9)==6); % Number of agents Died
            
            People_in_Quarantine = sum(Person_Profile(:,49)==1);
            M_Total_Number = M_Number + People_in_Quarantine; 
            Community_Prevalence = I4_Number + sum(Person_Profile(:,9)==5 & Person_Profile(:,39) ~= 1); %Community_Prevalence = asymptomatic cases + managed cases (but not travellers)
            
            Ln_I_Total_Number = log(M_Total_Number+1); %Add 1 here in case I_Total_Number = 0
            
            %% Medical Sequelae:
            
            No_100k_0_4 = 100000/ sum(Person_Profile(:,2)==1);
            No_100k_5_19 = 100000/ sum(Person_Profile(:,2)==2);
            No_100k_20_64 = 100000/ sum(Person_Profile(:,2)==3);
            No_100k_Over_65 = 100000/ sum(Person_Profile(:,2)==4);
            
            Rx_Home_Kindy=sum(Person_Profile(:,36)==6 & Person_Profile(:,2)==1) ; 
            Rx_Home_School=sum(Person_Profile(:,36)==6 &Person_Profile(:,2)==2);
            Rx_Home_Adult=sum(Person_Profile(:,36)==6 &Person_Profile(:,2)==3);
            Rx_Home_Older_Adult=sum(Person_Profile(:,36)==6 &Person_Profile(:,2)==4);
            
            Hosp_Kindy=sum(Person_Profile(:,36)==7 &Person_Profile(:,2)==1) ; 
            Hosp_School=sum(Person_Profile(:,36)==7 &Person_Profile(:,2)==2);
            Hosp_Adult=sum(Person_Profile(:,36)==7 &Person_Profile(:,2)==3);
            Hosp_Older_Adult=sum(Person_Profile(:,36)==7 &Person_Profile(:,2)==4);
            
            ICU_Kindy=sum(Person_Profile(:,36)==4 &Person_Profile(:,2)==1) ; 
            ICU_School=sum(Person_Profile(:,36)==4 &Person_Profile(:,2)==2);
            ICU_Adult=sum(Person_Profile(:,36)==4 &Person_Profile(:,2)==3);
            ICU_Older_Adult=sum(Person_Profile(:,36)==4 &Person_Profile(:,2)==4);
            
            Death_Kindy=sum(Person_Profile(:,9)==6 & Person_Profile(:,2)==1) ; 
            Death_School=sum(Person_Profile(:,9)==6 & Person_Profile(:,2)==2);
            Death_Adult=sum(Person_Profile(:,9)==6 & Person_Profile(:,2)==3);
            Death_Older_Adult=sum(Person_Profile(:,9)==6 & Person_Profile(:,2)==4);
            
        
            %% Calculate Reff:
            R_Zero_Sum_E2_I = sum(Person_Profile(:,32)); % Both E2 and I will be counted, Column 39 already excluded
            R_Zero_No_E2 = sum(Person_Profile(:,9)==3);
            R_Zero_No_I = sum(Person_Profile(:,9)==2);
            R_Zero(Day_Count) = R_Zero_Sum_E2_I/(R_Zero_No_E2+R_Zero_No_I)*Mean_Infective_Period;
           
        
            R_Zero_Sum_E2_I_Daily = sum(Person_Profile(:,46)); 
            
            %% Use a Moving Window of 7 Days to Calculate Reff:
            
            if Day_Count > 6
                Window_Add1 = 0;
                Window_Add2 = 0;
                for Window = Day_Count-6:Day_Count
                    Window_Add1 = Window_Add1 + sum(Daily_Infections(:,Window));
                    Window_Add2 = Window_Add2 + sum(Daily_Infectors(:,Window));
                end
                     R_Zero_Daily(Day_Count) = Window_Add1/Window_Add2 * Mean_Infective_Period;  
            else
                R_Zero_Daily(Day_Count) = 0;
            end        
            if isnan(R_Zero_Daily(Day_Count)), R_Zero_Daily(Day_Count) = 0; end
            
            Cumulative_Infectors = Cumulative_Infectors + sum(Daily_Infectors(:,Day_Count));
            Cumulative_Infections = Cumulative_Infections + sum(Daily_Infections(:,Day_Count));
            Cumulative_R0 = Cumulative_Infections/Cumulative_Infectors;
           
            Person_Profile(:,46)=0; % This column keeps a duplicate count of infections per agent and is zeroed daily.
             
            %% Calculate Agents in Quarantine
            
            Daily_M_Total_Number = Daily_M_Number + Daily_People_in_Quarantine;
            
            if Day_Count > 1
                Daily_Growth_Rate = (I2_Number-Daily_I2_Yesterday)/Daily_I2_Yesterday;
               
            else
                Daily_Growth_Rate =0;
            end
            
            %% Now store all calculated values in two arrays: One for daily "raw" data and one where the mean is calculated:
            
            Universal_Counter = Universal_Counter+1;

                Result_Array1(Universal_Counter,1) = Even_BiggerCounter;
                Result_Array1(Universal_Counter,2) = BiggerCounter;
                Result_Array1(Universal_Counter,3) =  Run_Counter;
                Result_Array1(Universal_Counter,4) =  Day_Count;
                Result_Array1(Universal_Counter,5) = Spreadsheet_Numbers(Day_Count,2);
                Result_Array1(Universal_Counter,6) = Spreadsheet_Numbers(Day_Count,3);
                Result_Array1(Universal_Counter,7) = Spreadsheet_Numbers(Day_Count,4);
                
                Result_Array4{Universal_Counter,1} = Spreadsheet_Text{Day_Count,4}; % This array will store text: Descriptions of the various social restrictions
                
                Result_Array1(Universal_Counter,8) =  Returned_Travellers;
                Result_Array1(Universal_Counter,9) = Spreadsheet_Numbers(Day_Count,6);
                Result_Array1(Universal_Counter,10) =  S_Number;
                Result_Array1(Universal_Counter,11) =  I1_Number;
                Result_Array1(Universal_Counter,12) =  I2_Number;
                Result_Array1(Universal_Counter,13) =  I3_Number;
                Result_Array1(Universal_Counter,14) =  M_Total_Number;
                Result_Array1(Universal_Counter,15) =  R_Number;
                Result_Array1(Universal_Counter,16) =  D_Number;
                Result_Array1(Universal_Counter,17) =  I4_Number;
                Result_Array1(Universal_Counter,18) =  Community_Prevalence;
                Result_Array1(Universal_Counter,19) = Daily_I1_Number;
                Result_Array1(Universal_Counter,20) = Daily_I2_Number;
                Result_Array1(Universal_Counter,21) = Daily_I3_Number;
                Result_Array1(Universal_Counter,22) = Daily_M_Total_Number;
                Result_Array1(Universal_Counter,23) = Daily_R_Number;
                Result_Array1(Universal_Counter,24) = Daily_D_Number;
                Result_Array1(Universal_Counter,25) = Daily_I4_Number;
                Result_Array1(Universal_Counter,26) = Daily_Community_Incidence;
                Result_Array1(Universal_Counter,27) =  Rx_Home_Kindy ;
                Result_Array1(Universal_Counter,28) =  Rx_Home_School ;
                Result_Array1(Universal_Counter,29) =  Rx_Home_Adult ;
                Result_Array1(Universal_Counter,30) =  Rx_Home_Older_Adult;
                Result_Array1(Universal_Counter,31) =  Hosp_Kindy ;
                Result_Array1(Universal_Counter,32) =  Hosp_School ;
                Result_Array1(Universal_Counter,33) =  Hosp_Adult ;
                Result_Array1(Universal_Counter,34) =  Hosp_Older_Adult;
                Result_Array1(Universal_Counter,35) =  ICU_Kindy ;
                Result_Array1(Universal_Counter,36) =  ICU_School ;
                Result_Array1(Universal_Counter,37) =  ICU_Adult ;
                Result_Array1(Universal_Counter,38) =  ICU_Older_Adult;
                Result_Array1(Universal_Counter,39) =  Death_Kindy ;
                Result_Array1(Universal_Counter,40) =  Death_School ;
                Result_Array1(Universal_Counter,41) =  Death_Adult ;
                Result_Array1(Universal_Counter,42) =  Death_Older_Adult;
                Result_Array1(Universal_Counter,43) = Daily_Rx_Home_Kindy;
                Result_Array1(Universal_Counter,44) = Daily_Rx_Home_School;
                Result_Array1(Universal_Counter,45) = Daily_Rx_Home_Adult;
                Result_Array1(Universal_Counter,46) = Daily_Rx_Home_Older_Adult;
                Result_Array1(Universal_Counter,47) = Daily_Hosp_Kindy;
                Result_Array1(Universal_Counter,48) = Daily_Hosp_School;
                Result_Array1(Universal_Counter,49) = Daily_Hosp_Adult;
                Result_Array1(Universal_Counter,50) = Daily_Hosp_Older_Adult;
                Result_Array1(Universal_Counter,51) = Daily_ICU_Kindy;
                Result_Array1(Universal_Counter,52) = Daily_ICU_School;
                Result_Array1(Universal_Counter,53) = Daily_ICU_Adult;
                Result_Array1(Universal_Counter,54) = Daily_ICU_Older_Adult;
                Result_Array1(Universal_Counter,55) = Daily_Death_Kindy;
                Result_Array1(Universal_Counter,56) = Daily_Death_School;
                Result_Array1(Universal_Counter,57) = Daily_Death_Adult;
                Result_Array1(Universal_Counter,58) = Daily_Death_Older_Adult;
                Result_Array1(Universal_Counter,59) =  People_in_Quarantine;
                Result_Array1(Universal_Counter,60) =  Daily_People_in_Quarantine;
                Result_Array1(Universal_Counter,61) =  R_Zero_Sum_E2_I_Daily;
                Result_Array1(Universal_Counter,62) =  R_Zero_Sum_E2_I;
                Result_Array1(Universal_Counter,63) =  R_Zero_Daily(Day_Count);


                %% The mean for values in this array will be calculated over the total days of simulation:

                Result_Array3(Day_Count,1) = Even_BiggerCounter;
                Result_Array3(Day_Count,2) = BiggerCounter;
                Result_Array3(Day_Count,3) =  Run_Counter;
                Result_Array3(Day_Count,4) =  Day_Count;
                Result_Array3(Day_Count,5) = Spreadsheet_Numbers(Day_Count,2);
                Result_Array3(Day_Count,6) = Spreadsheet_Numbers(Day_Count,3);
                Result_Array3(Day_Count,7) = Spreadsheet_Numbers(Day_Count,4);
                Result_Array3(Day_Count,8) =  Returned_Travellers;
                Result_Array3(Day_Count,9) = Spreadsheet_Numbers(Day_Count,6);
                Result_Array3(Day_Count,10) =  Result_Array3(Day_Count,10) +  S_Number;
                Result_Array3(Day_Count,11) =  Result_Array3(Day_Count,11) +  I1_Number;
                Result_Array3(Day_Count,12) =  Result_Array3(Day_Count,12) +  I2_Number;
                Result_Array3(Day_Count,13) =  Result_Array3(Day_Count,13) +  I3_Number;
                Result_Array3(Day_Count,14) =  Result_Array3(Day_Count,14) +  M_Total_Number;
                Result_Array3(Day_Count,15) =  Result_Array3(Day_Count,15) +  R_Number;
                Result_Array3(Day_Count,16) =  Result_Array3(Day_Count,16) +  D_Number;
                Result_Array3(Day_Count,17) =  Result_Array3(Day_Count,17) +  I4_Number;
                Result_Array3(Day_Count,18) =  Result_Array3(Day_Count,18) +  Community_Prevalence;
                Result_Array3(Day_Count,19) =  Result_Array3(Day_Count,19) + Daily_I1_Number;
                Result_Array3(Day_Count,20) =  Result_Array3(Day_Count,20) + Daily_I2_Number;
                Result_Array3(Day_Count,21) =  Result_Array3(Day_Count,21) + Daily_I3_Number;
                Result_Array3(Day_Count,22) =  Result_Array3(Day_Count,22) + Daily_M_Total_Number;
                Result_Array3(Day_Count,23) =  Result_Array3(Day_Count,23) + Daily_R_Number;
                Result_Array3(Day_Count,24) =  Result_Array3(Day_Count,24) + Daily_D_Number;
                Result_Array3(Day_Count,25) =  Result_Array3(Day_Count,25) + Daily_I4_Number;
                Result_Array3(Day_Count,26) =  Result_Array3(Day_Count,26) + Daily_Community_Incidence;
                Result_Array3(Day_Count,27) =  Result_Array3(Day_Count,27) +  Rx_Home_Kindy ;
                Result_Array3(Day_Count,28) =  Result_Array3(Day_Count,28) +  Rx_Home_School ;
                Result_Array3(Day_Count,29) =  Result_Array3(Day_Count,29) +  Rx_Home_Adult ;
                Result_Array3(Day_Count,30) =  Result_Array3(Day_Count,30) +  Rx_Home_Older_Adult;
                Result_Array3(Day_Count,31) =  Result_Array3(Day_Count,31) +  Hosp_Kindy ;
                Result_Array3(Day_Count,32) =  Result_Array3(Day_Count,32) +  Hosp_School ;
                Result_Array3(Day_Count,33) =  Result_Array3(Day_Count,33) +  Hosp_Adult ;
                Result_Array3(Day_Count,34) =  Result_Array3(Day_Count,34) +  Hosp_Older_Adult;
                Result_Array3(Day_Count,35) =  Result_Array3(Day_Count,35) +  ICU_Kindy ;
                Result_Array3(Day_Count,36) =  Result_Array3(Day_Count,36) +  ICU_School ;
                Result_Array3(Day_Count,37) =  Result_Array3(Day_Count,37) +  ICU_Adult ;
                Result_Array3(Day_Count,38) =  Result_Array3(Day_Count,38) +  ICU_Older_Adult;
                Result_Array3(Day_Count,39) =  Result_Array3(Day_Count,39) +  Death_Kindy ;
                Result_Array3(Day_Count,40) =  Result_Array3(Day_Count,40) +  Death_School ;
                Result_Array3(Day_Count,41) =  Result_Array3(Day_Count,41) +  Death_Adult ;
                Result_Array3(Day_Count,42) =  Result_Array3(Day_Count,42) +  Death_Older_Adult;
                Result_Array3(Day_Count,43) =  Result_Array3(Day_Count,43) + Daily_Rx_Home_Kindy;
                Result_Array3(Day_Count,44) =  Result_Array3(Day_Count,44) + Daily_Rx_Home_School;
                Result_Array3(Day_Count,45) =  Result_Array3(Day_Count,45) + Daily_Rx_Home_Adult;
                Result_Array3(Day_Count,46) =  Result_Array3(Day_Count,46) + Daily_Rx_Home_Older_Adult;
                Result_Array3(Day_Count,47) =  Result_Array3(Day_Count,47) + Daily_Hosp_Kindy;
                Result_Array3(Day_Count,48) =  Result_Array3(Day_Count,48) + Daily_Hosp_School;
                Result_Array3(Day_Count,49) =  Result_Array3(Day_Count,49) + Daily_Hosp_Adult;
                Result_Array3(Day_Count,50) =  Result_Array3(Day_Count,50) + Daily_Hosp_Older_Adult;
                Result_Array3(Day_Count,51) =  Result_Array3(Day_Count,51) + Daily_ICU_Kindy;
                Result_Array3(Day_Count,52) =  Result_Array3(Day_Count,52) + Daily_ICU_School;
                Result_Array3(Day_Count,53) =  Result_Array3(Day_Count,53) + Daily_ICU_Adult;
                Result_Array3(Day_Count,54) =  Result_Array3(Day_Count,54) + Daily_ICU_Older_Adult;
                Result_Array3(Day_Count,55) =  Result_Array3(Day_Count,55) + Daily_Death_Kindy;
                Result_Array3(Day_Count,56) =  Result_Array3(Day_Count,56) + Daily_Death_School;
                Result_Array3(Day_Count,57) =  Result_Array3(Day_Count,57) + Daily_Death_Adult;
                Result_Array3(Day_Count,58) =  Result_Array3(Day_Count,58) + Daily_Death_Older_Adult;
                Result_Array3(Day_Count,59) =  Result_Array3(Day_Count,59) +  People_in_Quarantine;
                Result_Array3(Day_Count,60) =  Result_Array3(Day_Count,60) +  Daily_People_in_Quarantine;
                Result_Array3(Day_Count,61) =  Result_Array3(Day_Count,61) +  R_Zero_Sum_E2_I_Daily;
                Result_Array3(Day_Count,62) =  Result_Array3(Day_Count,62) +  R_Zero_Sum_E2_I;
                Result_Array3(Day_Count,63) =  Result_Array3(Day_Count,63) +  R_Zero_Daily(Day_Count);
            
                %% Means, Medians, Percentiles
                
                Result_Array5(Run_Counter,Day_Count,1) = Even_BiggerCounter;
                Result_Array5(Run_Counter,Day_Count,2) = BiggerCounter;
                Result_Array5(Run_Counter,Day_Count,3) =  Run_Counter;
                Result_Array5(Run_Counter,Day_Count,4) =  Day_Count;
                Result_Array5(Run_Counter,Day_Count,5) = Spreadsheet_Numbers(Day_Count,2);
                Result_Array5(Run_Counter,Day_Count,6) = Spreadsheet_Numbers(Day_Count,3);
                Result_Array5(Run_Counter,Day_Count,7) = Spreadsheet_Numbers(Day_Count,4);
                Result_Array5(Run_Counter,Day_Count,8) =  Returned_Travellers;
                Result_Array5(Run_Counter,Day_Count,9) = Spreadsheet_Numbers(Day_Count,6);
                Result_Array5(Run_Counter,Day_Count,10) =  S_Number;
                Result_Array5(Run_Counter,Day_Count,11) =  I1_Number;
                Result_Array5(Run_Counter,Day_Count,12) =  I2_Number;
                Result_Array5(Run_Counter,Day_Count,13) =  I3_Number;
                Result_Array5(Run_Counter,Day_Count,14) =  M_Total_Number;
                Result_Array5(Run_Counter,Day_Count,15) =  R_Number;
                Result_Array5(Run_Counter,Day_Count,16) =  D_Number;
                Result_Array5(Run_Counter,Day_Count,17) =  I4_Number;
                Result_Array5(Run_Counter,Day_Count,18) =  Community_Prevalence;
                Result_Array5(Run_Counter,Day_Count,19) = Daily_I1_Number;
                Result_Array5(Run_Counter,Day_Count,20) = Daily_I2_Number;
                Result_Array5(Run_Counter,Day_Count,21) = Daily_I3_Number;
                Result_Array5(Run_Counter,Day_Count,22) = Daily_M_Total_Number;
                Result_Array5(Run_Counter,Day_Count,23) = Daily_R_Number;
                Result_Array5(Run_Counter,Day_Count,24) = Daily_D_Number;
                Result_Array5(Run_Counter,Day_Count,25) = Daily_I4_Number;
                Result_Array5(Run_Counter,Day_Count,26) = Daily_Community_Incidence;
                Result_Array5(Run_Counter,Day_Count,27) =  Rx_Home_Kindy ;
                Result_Array5(Run_Counter,Day_Count,28) =  Rx_Home_School ;
                Result_Array5(Run_Counter,Day_Count,29) =  Rx_Home_Adult ;
                Result_Array5(Run_Counter,Day_Count,30) =  Rx_Home_Older_Adult;
                Result_Array5(Run_Counter,Day_Count,31) =  Hosp_Kindy ;
                Result_Array5(Run_Counter,Day_Count,32) =  Hosp_School ;
                Result_Array5(Run_Counter,Day_Count,33) =  Hosp_Adult ;
                Result_Array5(Run_Counter,Day_Count,34) =  Hosp_Older_Adult;
                Result_Array5(Run_Counter,Day_Count,35) =  ICU_Kindy ;
                Result_Array5(Run_Counter,Day_Count,36) =  ICU_School ;
                Result_Array5(Run_Counter,Day_Count,37) =  ICU_Adult ;
                Result_Array5(Run_Counter,Day_Count,38) =  ICU_Older_Adult;
                Result_Array5(Run_Counter,Day_Count,39) =  Death_Kindy ;
                Result_Array5(Run_Counter,Day_Count,40) =  Death_School ;
                Result_Array5(Run_Counter,Day_Count,41) =  Death_Adult ;
                Result_Array5(Run_Counter,Day_Count,42) =  Death_Older_Adult;
                Result_Array5(Run_Counter,Day_Count,43) = Daily_Rx_Home_Kindy;
                Result_Array5(Run_Counter,Day_Count,44) = Daily_Rx_Home_School;
                Result_Array5(Run_Counter,Day_Count,45) = Daily_Rx_Home_Adult;
                Result_Array5(Run_Counter,Day_Count,46) = Daily_Rx_Home_Older_Adult;
                Result_Array5(Run_Counter,Day_Count,47) = Daily_Hosp_Kindy;
                Result_Array5(Run_Counter,Day_Count,48) = Daily_Hosp_School;
                Result_Array5(Run_Counter,Day_Count,49) = Daily_Hosp_Adult;
                Result_Array5(Run_Counter,Day_Count,50) = Daily_Hosp_Older_Adult;
                Result_Array5(Run_Counter,Day_Count,51) = Daily_ICU_Kindy;
                Result_Array5(Run_Counter,Day_Count,52) = Daily_ICU_School;
                Result_Array5(Run_Counter,Day_Count,53) = Daily_ICU_Adult;
                Result_Array5(Run_Counter,Day_Count,54) = Daily_ICU_Older_Adult;
                Result_Array5(Run_Counter,Day_Count,55) = Daily_Death_Kindy;
                Result_Array5(Run_Counter,Day_Count,56) = Daily_Death_School;
                Result_Array5(Run_Counter,Day_Count,57) = Daily_Death_Adult;
                Result_Array5(Run_Counter,Day_Count,58) = Daily_Death_Older_Adult;
                Result_Array5(Run_Counter,Day_Count,59) =  People_in_Quarantine;
                Result_Array5(Run_Counter,Day_Count,60) =  Daily_People_in_Quarantine;
                Result_Array5(Run_Counter,Day_Count,61) =  R_Zero_Sum_E2_I_Daily;
                Result_Array5(Run_Counter,Day_Count,62) =  R_Zero_Sum_E2_I;
                Result_Array5(Run_Counter,Day_Count,63) =  R_Zero_Daily(Day_Count);
                
            %% Reset Daily Variables:
            
            Daily_I1_Number= 0;
            Daily_I2_Number= 0;
            Daily_I3_Number= 0;
            Daily_I4_Number= 0;
            Daily_M_Total_Number= 0;
            Daily_Community_Incidence= 0;
            Daily_R_Number= 0;
            Daily_M_Number= 0;
            Daily_D_Number= 0;
            
            Daily_People_in_Quarantine= 0;
            
            
            Daily_Rx_Home_Kindy= 0;
            Daily_Rx_Home_School= 0;
            Daily_Rx_Home_Adult= 0;
            Daily_Rx_Home_Older_Adult= 0;
            Daily_Hosp_Kindy= 0;
            Daily_Hosp_School= 0;
            Daily_Hosp_Adult= 0;
            Daily_Hosp_Older_Adult= 0;
            Daily_ICU_Kindy= 0;
            Daily_ICU_School= 0;
            Daily_ICU_Adult= 0;
            Daily_ICU_Older_Adult= 0;
            Daily_Death_Kindy= 0;
            Daily_Death_School= 0;
            Daily_Death_Adult= 0;
            Daily_Death_Older_Adult= 0;
            
           
            