import npxtoolkit.internal.config.Config

import npxtoolkit.internal.thirdparty.logging.log4m
%% main logger
logger = log4m.getLogger("npx.log");
logger.clearLog();
logger.setLogLevel(logger.DEBUG);

%% Processing Session
% define session
session = npxtoolkit.Session('Session Info');

%% Setup Python env 
% TODO - Future ENV Var 
PYENV_PATH = '/home/ubuntu/anaconda3/envs/npx/bin/python';
session.setPyEnv(PYENV_PATH);
% init session by pipelines, stages and jobs


% %% ===========================================
% %% Auto-assembled pipeline
% pipeline = npxtoolkit.Pipeline('Pipeline0 Info', "configs/test_config.json");
% pipeline.autoAssemble();
% session.addPipeline(pipeline);
% session.parExecute();


% %% ===========================================
% %% Manually-assembled pipeline
% import npxtoolkit.tasks.CatGT
% import npxtoolkit.tasks.KiloSort
% import npxtoolkit.tasks.TPrime

% %% Pipeline 1
% pipeline1 = npxtoolkit.Pipeline('Pipeline0 Info', "configs/test_config.json");

% % CatGT stage
% stageCatgt = npxtoolkit.Stage('CatGT');
% pipeline1.addStage(stageCatgt);
% % CatGT task 1
% taskCatgt1 = CatGT('CatGT probe 0', '0', 1, pipeline1.PipelineConfigs);
% stageCatgt.addTask(taskCatgt1);

% % KiloSort stage
% stageKilo = npxtoolkit.Stage('KiloSort');
% pipeline1.addStage(stageKilo);
% % KiloSort task 1
% taskKilo1 = KiloSort('KiloSort probe 0', '0', 'cortex', pipeline1.PipelineConfigs);
% stageKilo.addTask(taskKilo1);

% % TPrime stage
% stageTPrime = npxtoolkit.Stage('TPrime');
% pipeline1.addStage(stageTPrime);
% % TPrime task 1
% taskTPrime1 = TPrime('TPrime probe 0', '0', pipeline1.PipelineConfigs);
% stageTPrime.addTask(taskTPrime1);

% % append pipeline to session
% session.addPipeline(pipeline1);
% %% Execution
% session.parExecute();


%% ===========================================
%% Configuration
import npxtoolkit.internal.config.PipelineConfig
import npxtoolkit.tasks.CatGT
import npxtoolkit.tasks.KiloSort
import npxtoolkit.tasks.TPrime
pipelineConfig = PipelineConfig("configs/test_config.json");
% task = CatGT('CatGT probe 0', '0', 1, pipelineConfig);
% task = KiloSort('KiloSort probe 0', '0', 'cortex', pipelineConfig);
task = TPrime('TPrime probe 0', '0', pipelineConfig);
task.execute();