
           
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


         %% COVID-19 Transmission Probabilities:

        
                    Scaling_Factor = 1.70; 

                    MG_Factor = 4; 
                    
                    Beta_Family_I_is_Child = 0.044* Scaling_Factor; 
                    Beta_Family_I_is_Adult = 0.044* Scaling_Factor;
                  
                    Beta_E_0_4_Friends_Group = 0.04 * Scaling_Factor * Mask_Scaling_Factor; 
                    Beta_E_5_19_Friends_Group = 0.04 * Scaling_Factor * Mask_Scaling_Factor;
                    Beta_E_Adult_Friends_Group = 0.04 * Scaling_Factor * Mask_Scaling_Factor;
                    Beta_E_Older_Adult_Friends_Group = 0.04 * Scaling_Factor * Mask_Scaling_Factor;
                    
                    Beta_Kindy = 0.0023 * Scaling_Factor * Mask_Scaling_Factor; 
                    Beta_School = 0.0023 * Scaling_Factor * Mask_Scaling_Factor;
                    Beta_Adult = 0.02 * Scaling_Factor * Mask_Scaling_Factor;
                    
                    Beta_E_0_4_Small_Group = 0.007175* Scaling_Factor * Mask_Scaling_Factor;
                    Beta_E_5_19_Small_Group = 0.007175* Scaling_Factor * Mask_Scaling_Factor;
                    Beta_E_Adult_Small_Group = 0.007175* Scaling_Factor * Mask_Scaling_Factor;
                    Beta_E_Older_Adult_Small_Group = 0.007175* Scaling_Factor * Mask_Scaling_Factor;
                 
                    Beta_E_0_4_Medium_Group = MG_Factor * 0.001435* Scaling_Factor * Mask_Scaling_Factor; 
                    Beta_E_5_19_Medium_Group = MG_Factor * 0.001435* Scaling_Factor * Mask_Scaling_Factor;
                    Beta_E_Adult_Medium_Group = MG_Factor * 0.001435* Scaling_Factor * Mask_Scaling_Factor;
                    Beta_E_Older_Adult_Medium_Group = MG_Factor * 0.001435* Scaling_Factor * Mask_Scaling_Factor;
               
                    Beta_E_0_4_Large_Group = 0.000287* Scaling_Factor * Mask_Scaling_Factor;
                    Beta_E_5_19_Large_Group = 0.000287* Scaling_Factor * Mask_Scaling_Factor;
                    Beta_E_Adult_Large_Group = 0.000287* Scaling_Factor * Mask_Scaling_Factor;
                    Beta_E_Older_Adult_Large_Group = 0.000287* Scaling_Factor * Mask_Scaling_Factor;
                   
      