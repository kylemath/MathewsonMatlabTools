%oneway_ANOVA_kyle.m
%HW7 - 

Y = [5;7;3;8;7;5;4;3;7;6;2;3;1;1;3;9;10;8;8;10;];
groups= [1;1;1;1;1;2;2;2;2;2;3;3;3;3;3;4;4;4;4;4];

% 1) Here is the data from 20 subjects, 5 in each of 4 groups, this code performs
% a one-way ANOVA on the data, indicate for each line of this code what the
% line does.

% 2) On line 51, I use the command ANOVA1(Y,groups) to run the same test.
% to check that this code works.
% Now consider the same Y data as a two-way ANOVA design, with 2 levels of each factor
% Use ANOVA2() and consider the data a 2 X 2 2-way ANOVA, you will have to
% change the groups vector. Save the resulting F table when you get it to work.
% HINT: Try typing help ANOVA2() for more information

% 3) Create a new matlab script: 'twoway_ANOVA_yourname.m' starting from this
% one, that does the two-way ANOVA from 2). You will have to change the design matrix, 
% as well as the reduced model. Make sure it gives the same results as 2).
% HINT: Try typing edit ANOVA2() and see how the matlab script does it.





%oneway_ANOVA_kyle.m
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%First, layout your values in a column, one group at a time, stacked on top
%of each other, in order
Y = [5;7;3;8;7;5;4;3;7;6;2;3;1;1;3;9;10;8;8;10;];
groups= [1;1;1;1;1;2;2;2;2;2;3;3;3;3;3;4;4;4;4;4];

%Next we make the ______________
X(1:20,1) = ones;
X(1:5,2) = ones;
X(6:10,3) = ones;
X(11:15,4) = ones;
X(16:20,2:4) = -1;

%Here the regression weights are ...
B = inv(X'*X)*(X'*Y);
Y_pred = X*B;
E = Y - Y_pred;
SSE_full = E'*E;

%Now we make a reduced model with just the ________
X_reduced = ones(20,1);
B_reduced = inv(X_reduced'*X_reduced)*(X_reduced'*Y);
Y_pred_reduced = X_reduced*B_reduced;
E_reduced = Y - Y_pred_reduced;

%The SSE in the reduced model is the ________
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
p_value = 1 - fcdf(F,df_TR,df_E);
F_crit = finv(1 -.05,df_TR,df_E);


%---------------------------------------------------
%As a sanity check, we can just get matlab to do all this work for us:
groups= [1;1;1;1;1;2;2;2;2;2;3;3;3;3;3;4;4;4;4;4];
[P,ANOVATAB,STATS] = anova1(Y,groups)
 