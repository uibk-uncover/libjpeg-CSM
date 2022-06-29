
use_win_path = false;
if use_win_path, ENDL = '\'; else, ENDL = '/'; end

%%%%%%%%%%%%%%%%%%
% EVALUATE MODEL %
%%%%%%%%%%%%%%%%%%

v_alice = '7'; % set Alice' version
v_eve = '7';   % set Eve's version
bpnzac = .4;

% ===== Model =====
% load model
model = load(sprintf('model/model_%s_%s_%.1f.mat',v_alice,v_eve,bpnzac)).model;

% ===== Prepare Data =====
% load data
C_jsrm_6b_6b = load('data/C_jsrm_6b_6b.mat').C_jsrm;
S_jsrm_6b_6b = load(sprintf('data/S_jsrm_6b_6b_%.1f.mat',bpnzac)).S_jsrm;
C_jsrm_7_7   = load('data/C_jsrm_7_7.mat').C_jsrm;
S_jsrm_7_7   = load(sprintf('data/S_jsrm_7_7_%.1f.mat',bpnzac)).S_jsrm;
C_jsrm_6b_7  = load('data/C_jsrm_6b_7.mat').C_jsrm;
S_jsrm_6b_7  = load(sprintf('data/S_jsrm_6b_7_%.1f.mat',bpnzac)).S_jsrm;
C_jsrm_7_6b  = load('data/C_jsrm_7_6b.mat').C_jsrm;
S_jsrm_7_6b  = load(sprintf('data/S_jsrm_7_6b_%.1f.mat',bpnzac)).S_jsrm;
% split train:test
rng(12345) % seed
N = size(C_jsrm_6b_6b,1);
random_permutation = randperm(N, N);
tr = random_permutation(1:N*.75);
te = random_permutation(N*.75+1:end);

% ===== Predict =====
% predict for test
pred_C_6b_6b_te = ensemble_testing(C_jsrm_6b_6b(te,:),model);
pred_S_6b_6b_te = ensemble_testing(S_jsrm_6b_6b(te,:),model);
pred_C_7_7_te   = ensemble_testing(C_jsrm_7_7(te,:),model);
pred_S_7_7_te   = ensemble_testing(S_jsrm_7_7(te,:),model);
pred_C_6b_7_te  = ensemble_testing(C_jsrm_6b_7(te,:),model);
pred_S_6b_7_te  = ensemble_testing(S_jsrm_6b_7(te,:),model);
pred_C_7_6b_te  = ensemble_testing(C_jsrm_7_6b(te,:),model);
pred_S_7_6b_te  = ensemble_testing(S_jsrm_7_6b(te,:),model);
% predict for training data
pred_C_6b_6b_tr = ensemble_testing(C_jsrm_6b_6b(tr,:),model);
pred_S_6b_6b_tr = ensemble_testing(S_jsrm_6b_6b(tr,:),model);
pred_C_7_7_tr   = ensemble_testing(C_jsrm_7_7(tr,:),model);
pred_S_7_7_tr   = ensemble_testing(S_jsrm_7_7(tr,:),model);
pred_C_6b_7_tr  = ensemble_testing(C_jsrm_6b_7(tr,:),model);
pred_S_6b_7_tr  = ensemble_testing(S_jsrm_6b_7(tr,:),model);
pred_C_7_6b_tr  = ensemble_testing(C_jsrm_7_6b(tr,:),model);
pred_S_7_6b_tr  = ensemble_testing(S_jsrm_7_6b(tr,:),model);

% ===== Evaluate =====
% evaluate for test data
[E_6b_6b_te,fp_6b_6b_te,md_6b_6b_te] = evaluate(pred_C_6b_6b_te, pred_S_6b_6b_te);
[E_7_7_te,fp_7_7_te,md_7_7_te]       = evaluate(pred_C_7_7_te, pred_S_7_7_te);
[E_6b_7_te,fp_6b_7_te,md_6b_7_te]    = evaluate(pred_C_6b_7_te, pred_S_6b_7_te);
[E_7_6b_te,fp_7_6b_te,md_7_6b_te]    = evaluate(pred_C_7_6b_te, pred_S_7_6b_te);
% evaluate for training data
[E_6b_6b_tr,fp_6b_6b_tr,md_6b_6b_tr] = evaluate(pred_C_6b_6b_tr, pred_S_6b_6b_tr);
[E_7_7_tr,fp_7_7_tr,md_7_7_tr]       = evaluate(pred_C_7_7_tr, pred_S_7_7_tr);
[E_6b_7_tr,fp_6b_7_tr,md_6b_7_tr]    = evaluate(pred_C_6b_7_tr, pred_S_6b_7_tr);
[E_7_6b_tr,fp_7_6b_tr,md_7_6b_tr]    = evaluate(pred_C_7_6b_tr, pred_S_7_6b_tr);

% ===== Cleanup =====
% remove data
clear C_jsrm_6b_6b C_jsrm_6b_7 C_jsrm_7_7 C_jsrm_7_6b;
clear S_jsrm_6b_6b_04 S_jsrm_6b_7_04 S_jsrm_7_7_04 S_jsrm_7_6b_04;
