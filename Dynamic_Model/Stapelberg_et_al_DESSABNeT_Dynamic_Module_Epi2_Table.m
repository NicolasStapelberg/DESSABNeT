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
    
    
      %% For All Data, Create Table and Save it to File:           
        
                    Big_T = table;
                    
                    Big_T.DN_Loop2 = Result_Array1(1:Universal_Counter,1);
                    Big_T.DN_Loop1 = Result_Array1(1:Universal_Counter,2);
                    Big_T.DN_Run = Result_Array1(1:Universal_Counter,3);
                    Big_T.DN_Day = Result_Array1(1:Universal_Counter,4);
                    Big_T.Ext_Date = Result_Array1(1:Universal_Counter,5);
                    Big_T.Ext_Phase = Result_Array1(1:Universal_Counter,6);
                    
                    %Big_T.Ext_Restrictions = Result_Array1(1:Universal_Counter,7);
                    Big_T.Ext_Restrictions = Result_Array4(1:Universal_Counter,1);
                    
                    Big_T.Ext_Returned_Travellers = Result_Array1(1:Universal_Counter,8);
                    Big_T.Ext_Community_Acquired_I = Result_Array1(1:Universal_Counter,9);
                    Big_T.DN_Prevalence_Comptmt_Susceptible = Result_Array1(1:Universal_Counter,10);
                    Big_T.DN_Prevalence_Comptmt_Exposed_1  = Result_Array1(1:Universal_Counter,11);
                    Big_T.DN_Prevalence_Comptmt_Exposed_2  = Result_Array1(1:Universal_Counter,12);
                    Big_T.DN_Prevalence_Comptmt_Infected  = Result_Array1(1:Universal_Counter,13);
                    Big_T.DN_Prevalence_Comptmt_Managed = Result_Array1(1:Universal_Counter,14);
                    Big_T.DN_Prevalence_Comptmt_Recovered = Result_Array1(1:Universal_Counter,15);
                    Big_T.DN_Prevalence_Comptmt_Dead = Result_Array1(1:Universal_Counter,16);
                    Big_T.DN_Prevalence_Symptomatic_Infected  = Result_Array1(1:Universal_Counter,17);
                    Big_T.DN_Prevalence_Community_Prevalence = Result_Array1(1:Universal_Counter,18);
                    Big_T.DN_Incident_Comptmt_Exposed_1  = Result_Array1(1:Universal_Counter,19);
                    Big_T.DN_Incident_Comptmt_Exposed_2  = Result_Array1(1:Universal_Counter,20);
                    Big_T.DN_Incident_Comptmt_Infected  = Result_Array1(1:Universal_Counter,21);
                    Big_T.DN_Incident_Comptmt_Managed = Result_Array1(1:Universal_Counter,22);
                    Big_T.DN_Incident_Comptmt_Recovered = Result_Array1(1:Universal_Counter,23);
                    Big_T.DN_Incident_Comptmt_Dead = Result_Array1(1:Universal_Counter,24);
                    Big_T.DN_Incident_Symptomatic_Infected  = Result_Array1(1:Universal_Counter,25);
                    Big_T.DN_Incident_Community_Incidence = Result_Array1(1:Universal_Counter,26);
                    Big_T.DN_Prevalence_Recovered_at_Home_0_4_Years  = Result_Array1(1:Universal_Counter,27);
                    Big_T.DN_Prevalence_Recovered_at_Home_5_19_Years  = Result_Array1(1:Universal_Counter,28);
                    Big_T.DN_Prevalence_Recovered_at_Home_20_64_Years  = Result_Array1(1:Universal_Counter,29);
                    Big_T.DN_Prevalence_Recovered_at_Home_65_Years_and_Over  = Result_Array1(1:Universal_Counter,30);
                    Big_T.DN_Prevalence_Hospitalisations_0_4_Years  = Result_Array1(1:Universal_Counter,31);
                    Big_T.DN_Prevalence_Hospitalisations_5_19_Years  = Result_Array1(1:Universal_Counter,32);
                    Big_T.DN_Prevalence_Hospitalisations_20_64_Years  = Result_Array1(1:Universal_Counter,33);
                    Big_T.DN_Prevalence_Hospitalisations_65_Years_and_Over  = Result_Array1(1:Universal_Counter,34);
                    Big_T.DN_Prevalence_ICU_Admissions_0_4_Years  = Result_Array1(1:Universal_Counter,35);
                    Big_T.DN_Prevalence_ICU_Admissions_5_19_Years  = Result_Array1(1:Universal_Counter,36);
                    Big_T.DN_Prevalence_ICU_Admissions_20_64_Years  = Result_Array1(1:Universal_Counter,37);
                    Big_T.DN_Prevalence_ICU_Admissions_65_Years_and_Over  =  Result_Array1(1:Universal_Counter,38);
                    Big_T.DN_Prevalence_Deaths_0_4_Years  =  Result_Array1(1:Universal_Counter,39);
                    Big_T.DN_Prevalence_Deaths_5_19_Years  =  Result_Array1(1:Universal_Counter,40);
                    Big_T.DN_Prevalence_Deaths_20_64_Years  =  Result_Array1(1:Universal_Counter,41);
                    Big_T.DN_Prevalence_Deaths_65_Years_and_Over  =  Result_Array1(1:Universal_Counter,42);
                    Big_T.DN_Incident_Recovered_at_Home_0_4_Years  =  Result_Array1(1:Universal_Counter,43);
                    Big_T.DN_Incident_Recovered_at_Home_5_19_Years  =  Result_Array1(1:Universal_Counter,44);
                    Big_T.DN_Incident_Recovered_at_Home_20_64_Years  =  Result_Array1(1:Universal_Counter,45);
                    Big_T.DN_Incident_Recovered_at_Home_65_Years_and_Over  =  Result_Array1(1:Universal_Counter,46);
                    Big_T.DN_Incident_Hospitalisations_0_4_Years  =  Result_Array1(1:Universal_Counter,47);
                    Big_T.DN_Incident_Hospitalisations_5_19_Years  =  Result_Array1(1:Universal_Counter,48);
                    Big_T.DN_Incident_Hospitalisations_20_64_Years  =  Result_Array1(1:Universal_Counter,49);
                    Big_T.DN_Incident_Hospitalisations_65_Years_and_Over  =  Result_Array1(1:Universal_Counter,50);
                    Big_T.DN_Incident_ICU_Admissions_0_4_Years  =  Result_Array1(1:Universal_Counter,51);
                    Big_T.DN_Incident_ICU_Admissions_5_19_Years  =  Result_Array1(1:Universal_Counter,52);
                    Big_T.DN_Incident_ICU_Admissions_20_64_Years  =  Result_Array1(1:Universal_Counter,53);
                    Big_T.DN_Incident_ICU_Admissions_65_Years_and_Over  = Result_Array1(1:Universal_Counter,54);
                    Big_T.DN_Incident_Deaths_0_4_Years  = Result_Array1(1:Universal_Counter,55);
                    Big_T.DN_Incident_Deaths_5_19_Years  = Result_Array1(1:Universal_Counter,56);
                    Big_T.DN_Incident_Deaths_20_64_Years  = Result_Array1(1:Universal_Counter,57);
                    Big_T.DN_Incident_Deaths_65_Years_and_Over  = Result_Array1(1:Universal_Counter,58);
                    Big_T.DN_Prevalence_N_Quarantined_or_Isolated  = Result_Array1(1:Universal_Counter,59);
                    Big_T.DN_Incident_N_Quarantined_or_Isolated  = Result_Array1(1:Universal_Counter,60);
                    Big_T.DN_Daily_New_Transmissons = Result_Array1(1:Universal_Counter,61);
                    Big_T.DN_Cumulative_Transmissions = Result_Array1(1:Universal_Counter,62);
                    Big_T.DN_Daily_R_Effective = Result_Array1(1:Universal_Counter,63);
                    
                     Epi_File_Name = strcat('DESSABNeT_',Context_Designator,string(Population),'_All_Epi_Daily_Outputs_Table.xlsx');
                     writetable(Big_T,Epi_File_Name); %,'Delimiter','\t','WriteRowNames',true);
           