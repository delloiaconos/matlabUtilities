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


%% matlab Aliases
% Contains common aliases (shortcuts) in the form of inline function 
% handlers used to manage tables and other data structure.

% Array to Table
a2t = @( T ) array2table( T );
