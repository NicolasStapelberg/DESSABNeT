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
    
    
       %% Load Spreadsheet Which Contains Factual Data on Restricions, Returning Travellers and Community Transmission Cases:
         
         fprintf('%s\t','Loading Cases...');
         fprintf('\n');
         
         %Load Spreadsheet
         
            D = dir(pwd);
            % Let variable D = the number of files in the the current folder. pwd = current folder
            D([D.isdir]) = [];
            % This looks in all the subdirectories in the file as well.
            for jj = 1:length(D)
                %Loop - let jj = 1 to the number of files
                [fp,fn,ext] = fileparts(D(jj).name);
                %Variables fp, fn and ext are given the fileparts of current file
                % So fp = file path, fn = file name and ext = file extension for current file
                if strcmpi(fn,'covid_19_interstate_overseas_case_numbers_Sydney') % Get exact file name
                    if strcmpi(ext,'.xlsx')
                        % string compare. If correct filename found then proceed...
                        [Spreadsheet_Numbers,Spreadsheet_Text,~] = xlsread([fp,fn,ext]);
                        Spreadsheet_Text(1,:)=[]; % Delete the first row of Spreadsheet_Text which has the headings

                    end
                end
            end
         