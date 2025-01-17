classdef (Abstract) Config < handle
    %Config Summary of this class goes here
    %   Detailed explanation goes here

    methods (Static)
        function configs = parseJson(fpath)
            try
                fid = fopen(fpath); 
                raw = fread(fid,inf); 
                json = char(raw'); 
                fclose(fid);
                configs = jsondecode(json);
            catch ME
                import npxtoolkit.internal.thirdparty.logging.log4m
                switch ME.identifier
                    case 'MATLAB:FileIO:InvalidFid'
                        logger = log4m.getLogger("npx.log");
                        logger.error("Error - Config.m", "Config file is not found");
                    otherwise
                        rethrow(ME);
                end
            end
        end
    end
end