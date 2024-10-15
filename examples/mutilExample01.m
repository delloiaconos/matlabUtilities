%% 
 % matlabUtilities: MATLAB Common Utilities 
 % Copyright (C) 2024 Salvatore Dello Iacono
 %
 %
 % This is free software; you can redistribute it and/or modify
 % it under the terms of the GNU General Public License as published by
 % the Free Software Foundation; either version 3 of the License, or
 % (at your option) any later version.
 %
 % This is distributed in the hope that it will be useful,
 % but WITHOUT ANY WARRANTY; without even the implied warranty of
 % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 % GNU General Public License for more details.
 %
 %  You should have received a copy of the GNU General Public License
 %  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 %

%%
 %   @file    mutilExample01.m
 %   @brief   matlabUtility Example 1 file.
 %   @details matlabUtility file, this script is a simple example of how to 
 %            use the function tab2tabular.
 %
 
clear all;
close all;
clc;

%% Include matlabUtilities
addpath( '../utilities' );

%%  *********************************************************************   
 %                               Example 01
 %  *********************************************************************  

a2t = @( T ) array2table( T );

% Preparing Data
tblT = table();

tblT(:, "Var1" ) = a2t( rand( [100, 1 ] ) );
tblT(:, "Var2" ) = a2t( rand( [100, 1 ] ) );
tblT(:, "Var3" ) = a2t( rand( [100, 1 ] ) );


%% Export Table to LaTeX Tabular!
tab2tabular( tblT, fullfile( "../Outputs/", "table.txt" ), ...
            "NoOutput", true, ...
            "Variables", ["Var1", "Var2", "Var3"], ...
            "Headers", ["Variable #1", "Variable #2", "Variable #3"], ...
            "Formats", ["%0.1f", "%0.1f", "%0.2f"], ...
            "Conditioner", { { @(x) x < 0.9, "\\textbf{%0.1f}", @(x) x < 0.6, "\\textit{%0.1f}", @(x) x < 0.3, "\\cellcolor{blue!25}%0.1fd"}, ...
                             {}, ...
                             {} } ...
           );

