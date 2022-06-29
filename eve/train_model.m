
use_win_path = false;
if use_win_path, ENDL = '\'; else, ENDL = '/'; end
mkdir('model');

%%%%%%%%%%%%%%%
% TRAIN MODEL %
%%%%%%%%%%%%%%%

bpnzac = .4;

% trains model and exports it to a mat file
for v_alice = {'6b' '7'}

    % Eve's libjpeg version independent on Alice
    for v_eve = {'6b' '7'}

        % load data
        C_jsrm = load(sprintf('data/C_jsrm_%s_%s.mat',v_alice,v_eve)).C_jsrm;
        S_jsrm = load(sprintf('data/S_jsrm_%s_%s_%.1f.mat',v_alice,v_eve,bpnzac)).S_jsrm;
        
        % split train:test
        rng(12345) % seed
        N = size(C_jsrm,1);
        random_permutation = randperm(N, N);
        tr = random_permutation(1:N*.75);
        te = random_permutation(N*.75+1:end);
        
        % train ensamble model
        [model,results] = ensemble_training(C_jsrm(tr,:),S_jsrm(tr,:));%, struct(k_step=100, Eoob_tolerance=.01));

        % save model
        save(sprintf('model/model_%s_%s_%.1f.mat',v_alice,v_eve,bpnzac), 'model', '-v7.3');
    end

end
