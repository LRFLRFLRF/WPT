

% 调用python程序以执行ansys仿真
clear classes;
% pathToSpeech = fileparts(which('maxwell_script'))
% if count(py.sys.path, pathToSpeech) == 0
%     insert(py.sys.path, int32(0), pathToSpeech);
% end

send_tw = 0.27;
dupli_dis = 25;
send_N = 3;
aux_N = 2;
paralist = [send_tw,dupli_dis,send_N,aux_N];

obj = py.importlib.import_module('maxwell_script');
py.importlib.reload(obj);
py.maxwell_script.run(paralist);



