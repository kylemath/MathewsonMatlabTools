%First, layout your values in a column, one group at a time, stacked on top
%of each other, in order
Y = [5;7;3;8;7;5;4;3;7;6;2;3;1;1;3;9;10;8;8;10;];
groups= {'classroom_lab';'classroom_lab';'classroom_lab';'classroom_lab';'classroom_lab';...
'conversation_lab';'conversation_lab';'conversation_lab';'conversation_lab';'conversation_lab';...
'classroom_no_lab';'classroom_no_lab';'classroom_no_lab';'classroom_no_lab';'classroom_no_lab';...
'conversation_no_lab';'conversation_no_lab';'conversation_no_lab';'conversation_no_lab';'conversation_no_lab'};

%Next we make the design matrix. Each row corresonds to the Y value in thesame row.
%When multiplied by the B vector, each row will give you the expected value for that Y value.
%The +/- ones and zeros are multipliers for the B, in order to pick up the corresponding mean for that Group.
%The first column is the overall mean.
X(1:20,1) = ones;
X(1:5,2) = ones;
X(6:10,3) = ones;
X(11:15,4) = ones;
X(16:20,2:4) = -1;

%Here the regression weights are the overall mean
B = inv(X'*X)*(X'*Y);
Y_pred = X*B;
E = Y - Y_pred;
SSE_full = E'*E;

%Now we make a reduced model with just the overall mean
X_reduced = ones(20,1);
B_reduced = inv(X_reduced'*X_reduced)*(X_reduced'*Y);
Y_pred_reduced = X_reduced*B_reduced;
E_reduced = Y - Y_pred_reduced;
%The SSE in the reduced model is the SSTO in the full model since it is just the sum of the squared deviations from the overall mean
SSE_reduced = E_reduced'*E_reduced;
SSE = SSE_full;
SSTO = SSE_reduced; 
SSTR = SSTO - SSE;

%Degrees of Freedom & Mean Squares
df_E = length(Y) - length(B);
df_TR = length(B) - 1;
MSE = SSE/df_E;
MSTR = SSTR/df_TR;

%F Test and Significance Test
F = MSTR/MSE;
p_value = fcdf(F,df_TR,df_E);
F_crit = finv(.05,df_TR,df_E);



%------------------------------------------------------
%Note we can also use the regression approach with the cell means model,
%where the weights now pick up the corresponding group mean for that Y
%value in the B vector. Note SSE_full and SSE_full_cell_means are the same
X(1:5,1) = ones;
X(6:10,2) = ones;
X(11:15,3) = ones;
X(16:20,4) = ones;
B = inv(X'*X)*(X'*Y);
Y_pred = X*B;
E = Y - Y_pred;
%SSE_full_cell_means = E'*E;

%---------------------------------------------------
%As a sanity check, we can just get matlab to do all this work for us:
groups= {'classroom_lab';'classroom_lab';'classroom_lab';'classroom_lab';'classroom_lab';...
'conversation_lab';'conversation_lab';'conversation_lab';'conversation_lab';'conversation_lab';...
'classroom_no_lab';'classroom_no_lab';'classroom_no_lab';'classroom_no_lab';'classroom_no_lab';...
'conversation_no_lab';'conversation_no_lab';'conversation_no_lab';'conversation_no_lab';'conversation_no_lab'};
[P,ANOVATAB,STATS] = anova1(Y,groups)
 