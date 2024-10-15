function tab2tabular( tbl, fName, varargin )
%TAB2TABULAR Convert a table to a LaTeX Tabular Structure
%   tbl: table to be converted
%   vars: list of variables to be inserted
    
    locFields = [ "Variables", "Headers", "Formats", "Conditioner", "NoOutput" ];
    locOpts = struct();
    
    vkindex = [];
    
    if ~istable( tbl )
        error( "ERROR: first argument must be a table!\n" );
    end

    % Check which locField is present in varargin
    for idx=1:length(locFields)
        field = locFields(idx);

        loc =  find( cellfun(@(v) ( isstring(v) || ischar(v) ) && all( strcmpi( field, v ) ), varargin ) );
        if ~isempty(loc) && ~ismember(loc, vkindex) && (loc <= nargin-1) 
            locOpts.(field) = varargin{loc+1};
            vkindex = [vkindex loc loc+1];
        end
    end
    

    % Check if all variables are in Table!
    if isfield( locOpts, "Variables" )
        vars = locOpts.("Variables");
        if ~all( contains( vars, tbl.Properties.VariableNames ) )
            error( "ERROR: Variable not in table!\n" );
        end
    else
        vars = tbl.Properties.VariableNames;
    end
    
    % Check headers
    if isfield( locOpts, "Headers" )
        if length( locOpts.("Headers") ) ~= length( vars ) 
            error( "ERROR: 'Headers' should have the same length as Variables!\n" );
        end
    end
    
    % Check Formats
    if isfield( locOpts, "Formats" )
        if length( locOpts.("Formats") ) ~= length( vars ) 
            error( "ERROR: 'Formats' should have the same length as Variables!\n" );
        end
    end
    
    % Check Conditioner
    if isfield( locOpts, "Conditioner" )
        if length( locOpts.("Conditioner") ) ~= length( vars ) 
            error( "ERROR: 'Conditioner' should have the same length as Variables!\n" );
        end
    end

    % NoOutput for DEBUG
    if isfield( locOpts, "NoOutput" ) && ( locOpts.("NoOutput") == true )
        fw = 1;
    else
        fw = fopen( fName, 'wt');
    end
    

    % Begin Print
    fprintf( fw, "\\begin{tabular}{%s}\n", repmat('c',1, length(vars) ) );
    
    if isfield( locOpts, "Headers" )
        headers = locOpts.("Headers");

        for ivar = 1:length(vars)
            header = headers(ivar);
            
            if ivar == 1
                fprintf( fw, "\t" );
            end

            fprintf( fw, "\\textbf{%s}", header );

            if ivar == length( vars )
                fprintf( fw, " \\\\\n" );
            else
                fprintf( fw, " & " );
            end
        end
    end

    for irow = 1:height( tbl )
        for ivar = 1:length(vars)
            var = vars(ivar);
            
            if ivar == 1
                fprintf( fw, "\t" );
            end
            
            if isfield( locOpts, "Formats" )
                frmt = string( locOpts.("Formats"){ivar} );
            else
                frmt = "%f";
            end
            
            rowVal = tbl{irow, var};

            if isfield( locOpts, "Conditioner" )
                cond = locOpts.("Conditioner");
                cond = reshape( cond{ivar}, 2, [] )';
                if ~isempty( cond )
                    for icon = 1:size( cond, 1 )
                        % Matches only the first one!
                        if isa( cond{icon,1}, 'function_handle' ) && ( cond{icon,1}(rowVal) == true )
                            frmt = string( cond{icon,2} );
                            break;
                        end
                    end
                end
            end
     
            fprintf( fw, frmt, rowVal );


            if ivar == length( vars )
                fprintf( fw, " \\\\\n" );
            else
                fprintf( fw, " & " );
            end

        end
    end

    fprintf( fw, "\\end{tabular}\n" );
end

