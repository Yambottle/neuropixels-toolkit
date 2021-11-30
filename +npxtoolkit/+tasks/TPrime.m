classdef TPrime < npxtoolkit.tasks.TaskBase
    properties
        Info
        Probe
        Configs
        Output
        L
    end

    methods
        function obj = TPrime(taskInfo, probe, configs, logger)
            obj.Info = taskInfo;
            obj.Probe = probe;
            if class(configs.TPrime.runTPrime)=="char"
                configs.TPrime.runTPrime = str2num(configs.TPrime.runTPrime);
            end
            if class(configs.TPrime.runTPrime)=="char"
                configs.TPrime.tPrime3A = str2num(configs.TPrime.tPrime3A);
            end
            obj.Configs = configs;
            obj.L = logger;
        end
        
        function execute(obj)
            obj.L.info("TPrime.m", strcat("Running task: ", obj.Info));
            names = [fieldnames(obj.Configs.Tools); fieldnames(obj.Configs.Data); fieldnames(obj.Configs.TPrime)];
            configs = cell2struct([struct2cell(obj.Configs.Tools); struct2cell(obj.Configs.Data); struct2cell(obj.Configs.TPrime)], names, 1);

            prb = obj.Probe;

            runFolderName = strcat(configs.runName, '_g', configs.gateIdx);
            catGTResultFolderName = strcat('catgt_', runFolderName);
            probFolderName = strcat(runFolderName, '_imec', prb);
            probFolder = fullfile(configs.npxDir, runFolderName, probFolderName);
            inputDataDirectory = probFolder;
            fileName = strcat(runFolderName, '_tcat.imec', prb, '.ap.bin');
            metaName = strcat(runFolderName, '_tcat.imec', prb, '.ap.meta');

            inputMetaFullpath = fullfile(configs.npxDir, catGTResultFolderName, probFolderName, metaName);
            continuousFile = fullfile(configs.npxDir, catGTResultFolderName, probFolderName, fileName);

            taskName = strcat(configs.runName, '_TPrime');
            inputJson = fullfile(configs.jsonDir, strcat(taskName, '-input.json'));
            outputJson = fullfile(configs.jsonDir, strcat(taskName, '-output.json'));

            % build list of sync extractions to send to TPrime
            syncExtract = strcat('-SY=', prb, ',-1,6,500');
            imExList = strcat(configs.imExList, ' ', syncExtract);
            obj.L.debug(strcat("KiloSort.m - ", obj.Info), strcat('imExList: ', imExList));
            
            info = py.py_modules.caller.createInputJson(...
                pyargs(...
                    'output_file', inputJson,...
                    'ecephys_directory', configs.ecephysDir,...
                    'kilosort_repository', configs.kilosortRepo,...
                    'KS2ver', configs.KSver,...
                    'npy_matlab_repository', configs.npyMatlabRepo,...
                    'catGTPath', configs.catGTPath,...
                    'tPrime_path', configs.tPrimePath,...
                    'cWaves_path', configs.cWavesPath,...
                    'kilosort_output_tmp', configs.kilosortOutputTmp,...
                    'npx_directory', configs.npxDir,...
                    'continuous_file', continuousFile,...
                    'spikeGLX_data', configs.spikeGLXData,...
                    'input_meta_path', inputMetaFullpath,...
                    'kilosort_output_directory', configs.catGTDest,...
                    'extracted_data_directory', configs.catGTDest,...
                    'tPrime_im_ex_list', imExList,...
                    'tPrime_ni_ex_list', configs.niExtractStr,...
                    'event_ex_param_str', configs.eventExParamStr,...
                    'sync_period', configs.syncPeriod,...
                    'toStream_sync_params', configs.toStreamSyncParams,...
                    'niStream_sync_params', configs.niStreamSyncParams,...
                    'tPrime_3A', configs.tPrime3A,...
                    'toStream_path_3A', configs.toStreamPath3A,...
                    'fromStream_list_3A', configs.fromStreamList3A...
                )...
            );

            if configs.runTPrime
                % TODO - reduce python
                params = strcat("-W ignore -m ecephys_spike_sorting.modules.tPrime_helper",...
                                " --input_json ", inputJson,...
                                " --output_json ", outputJson);
                obj.L.debug(strcat("TPrime.m - ", obj.Info), strcat("python ", params));
                py.py_modules.caller.call_python(params);
                obj.L.info(strcat("TPrime.m - ", obj.Info), "Done!");
            else
                obj.L.info(strcat("TPrime.m - ", obj.Info), "Skipped!");
            end
        end
    end
end