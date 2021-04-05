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
    
    
      %% For Mean, Median and Percentile Data for All Runs, Create Table and Save it to File:

      
          for Output_Cycles = 1:4     
                Result_Array6 = zeros(How_Many_Days,63);
                for CNTR_Y = 1:63
                    for CNTR_X = 1:How_Many_Days
                        if Output_Cycles == 1, Result_Array6(CNTR_X,CNTR_Y)=mean(Result_Array5(:,CNTR_X,CNTR_Y)); end
                        if Output_Cycles == 2, Result_Array6(CNTR_X,CNTR_Y)=median(Result_Array5(:,CNTR_X,CNTR_Y)); end
                        if Output_Cycles == 3, Result_Array6(CNTR_X,CNTR_Y)=prctile(Result_Array5(:,CNTR_X,CNTR_Y),2.5); end
                        if Output_Cycles == 4, Result_Array6(CNTR_X,CNTR_Y)=prctile(Result_Array5(:,CNTR_X,CNTR_Y),97.5); end
                    end
                end
                
                Big_T = table;
                
                Big_T.DN_Loop2 = Result_Array6(:,1);
                Big_T.DN_Loop1 = Result_Array6(:,2);
                Big_T.DN_Run = Result_Array6(:,3);
                Big_T.DN_Day = Result_Array6(:,4);
                Big_T.Ext_Date = Result_Array6(:,5);
                Big_T.Ext_Phase = Result_Array6(:,6);
                %Big_T.Ext_Restrictions = Result_Array6(:,7);
                Big_T.Ext_Restrictions = Spreadsheet_Text(:,4);
                
                Big_T.Ext_Returned_Travellers = Result_Array6(:,8);
                Big_T.Ext_Community_Acquired_I = Result_Array6(:,9);
                Big_T.DN_Prevalence_Comptmt_Susceptible = Result_Array6(:,10);
                Big_T.DN_Prevalence_Comptmt_Exposed_1  = Result_Array6(:,11);
                Big_T.DN_Prevalence_Comptmt_Exposed_2  = Result_Array6(:,12);
                Big_T.DN_Prevalence_Comptmt_Infected  = Result_Array6(:,13);
                Big_T.DN_Prevalence_Comptmt_Managed = Result_Array6(:,14);
                Big_T.DN_Prevalence_Comptmt_Recovered = Result_Array6(:,15);
                Big_T.DN_Prevalence_Comptmt_Dead = Result_Array6(:,16);
                Big_T.DN_Prevalence_Symptomatic_Infected  = Result_Array6(:,17);
                Big_T.DN_Prevalence_Community_Prevalence = Result_Array6(:,18);
                Big_T.DN_Incident_Comptmt_Exposed_1  = Result_Array6(:,19);
                Big_T.DN_Incident_Comptmt_Exposed_2  = Result_Array6(:,20);
                Big_T.DN_Incident_Comptmt_Infected  = Result_Array6(:,21);
                Big_T.DN_Incident_Comptmt_Managed = Result_Array6(:,22);
                Big_T.DN_Incident_Comptmt_Recovered = Result_Array6(:,23);
                Big_T.DN_Incident_Comptmt_Dead = Result_Array6(:,24);
                Big_T.DN_Incident_Symptomatic_Infected  = Result_Array6(:,25);
                Big_T.DN_Incident_Community_Incidence = Result_Array6(:,26);
                Big_T.DN_Prevalence_Recovered_at_Home_0_4_Years  = Result_Array6(:,27);
                Big_T.DN_Prevalence_Recovered_at_Home_5_19_Years  = Result_Array6(:,28);
                Big_T.DN_Prevalence_Recovered_at_Home_20_64_Years  = Result_Array6(:,29);
                Big_T.DN_Prevalence_Recovered_at_Home_65_Years_and_Over  = Result_Array6(:,30);
                Big_T.DN_Prevalence_Hospitalisations_0_4_Years  = Result_Array6(:,31);
                Big_T.DN_Prevalence_Hospitalisations_5_19_Years  = Result_Array6(:,32);
                Big_T.DN_Prevalence_Hospitalisations_20_64_Years  = Result_Array6(:,33);
                Big_T.DN_Prevalence_Hospitalisations_65_Years_and_Over  = Result_Array6(:,34);
                Big_T.DN_Prevalence_ICU_Admissions_0_4_Years  = Result_Array6(:,35);
                Big_T.DN_Prevalence_ICU_Admissions_5_19_Years  = Result_Array6(:,36);
                Big_T.DN_Prevalence_ICU_Admissions_20_64_Years  = Result_Array6(:,37);
                Big_T.DN_Prevalence_ICU_Admissions_65_Years_and_Over  = Result_Array6(:,38);
                Big_T.DN_Prevalence_Deaths_0_4_Years  = Result_Array6(:,39);
                Big_T.DN_Prevalence_Deaths_5_19_Years  = Result_Array6(:,40);
                Big_T.DN_Prevalence_Deaths_20_64_Years  = Result_Array6(:,41);
                Big_T.DN_Prevalence_Deaths_65_Years_and_Over  = Result_Array6(:,42);
                Big_T.DN_Incident_Recovered_at_Home_0_4_Years  = Result_Array6(:,43);
                Big_T.DN_Incident_Recovered_at_Home_5_19_Years  = Result_Array6(:,44);
                Big_T.DN_Incident_Recovered_at_Home_20_64_Years  = Result_Array6(:,45);
                Big_T.DN_Incident_Recovered_at_Home_65_Years_and_Over  = Result_Array6(:,46);
                Big_T.DN_Incident_Hospitalisations_0_4_Years  = Result_Array6(:,47);
                Big_T.DN_Incident_Hospitalisations_5_19_Years  = Result_Array6(:,48);
                Big_T.DN_Incident_Hospitalisations_20_64_Years  = Result_Array6(:,49);
                Big_T.DN_Incident_Hospitalisations_65_Years_and_Over  = Result_Array6(:,50);
                Big_T.DN_Incident_ICU_Admissions_0_4_Years  = Result_Array6(:,51);
                Big_T.DN_Incident_ICU_Admissions_5_19_Years  = Result_Array6(:,52);
                Big_T.DN_Incident_ICU_Admissions_20_64_Years  = Result_Array6(:,53);
                Big_T.DN_Incident_ICU_Admissions_65_Years_and_Over  = Result_Array6(:,54);
                Big_T.DN_Incident_Deaths_0_4_Years  = Result_Array6(:,55);
                Big_T.DN_Incident_Deaths_5_19_Years  = Result_Array6(:,56);
                Big_T.DN_Incident_Deaths_20_64_Years  = Result_Array6(:,57);
                Big_T.DN_Incident_Deaths_65_Years_and_Over  = Result_Array6(:,58);
                Big_T.DN_Prevalence_N_Quarantined_or_Isolated  = Result_Array6(:,59);
                Big_T.DN_Incident_N_Quarantined_or_Isolated  = Result_Array6(:,60);
                Big_T.DN_Daily_New_Transmissons = Result_Array6(:,61);
                Big_T.DN_Cumulative_Transmissions = Result_Array6(:,62);
                Big_T.DN_Daily_R_Effective = Result_Array6(:,63);
                
                
                if Output_Cycles == 1, Epi_File_Name = strcat('DESSABNeT_',Context_Designator,string(Population),'_Mean_Daily_Outputs_Table.xlsx'); end
                if Output_Cycles == 2, Epi_File_Name = strcat('DESSABNeT_',Context_Designator,string(Population),'_Median_Daily_Outputs_Table.xlsx'); end
                if Output_Cycles == 3, Epi_File_Name = strcat('DESSABNeT_',Context_Designator,string(Population),'_2p5_Percentile_Daily_Outputs_Table.xlsx'); end
                if Output_Cycles == 4, Epi_File_Name = strcat('DESSABNeT_',Context_Designator,string(Population),'_97p5_Percentile_Daily_Outputs_Table.xlsx'); end
                     writetable(Big_T,Epi_File_Name); %,'Delimiter','\t','WriteRowNames',true);
           
          end
          
          