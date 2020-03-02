%  Matlab Code-Library for Feature Selection
%  A collection of S-o-A feature selection methods
%  Version 6.2 October 2018
%  Support: Giorgio Roffo
%  E-mail: giorgio.roffo@glasgow.ac.uk
%
%  Before using the Code-Library, please read the Release Agreement carefully.
%
%  Release Agreement:
%
%  - All technical papers, documents and reports which use the Code-Library will acknowledge the use of the library as follows:
%    The research in this paper use the Feature Selection Code Library (FSLib) and a citation to:
%  ------------------------------------------------------------------------
% @InProceedings{RoffoICCV17,
% author={Giorgio Roffo and Simone Melzi and Umberto Castellani and Alessandro Vinciarelli},
% booktitle={2017 IEEE International Conference on Computer Vision (ICCV)},
% title={Infinite Latent Feature Selection: A Probabilistic Latent Graph-Based Ranking Approach},
% year={2017},
% month={Oct}}
%  ------------------------------------------------------------------------
% @InProceedings{RoffoICCV15,
% author={G. Roffo and S. Melzi and M. Cristani},
% booktitle={2015 IEEE International Conference on Computer Vision (ICCV)},
% title={Infinite Feature Selection},
% year={2015},
% pages={4202-4210},
% doi={10.1109/ICCV.2015.478},
% month={Dec}}
%  ------------------------------------------------------------------------

% FEATURE SELECTION TOOLBOX v 6.2 2018 - For Matlab 
% Please, select a feature selection method from the list:
% [1] ILFS 
% [2] InfFS 
% [3] ECFS 
% [4] mrmr 
% [5] relieff 
% [6] mutinffs 
% [7] fsv 
% [8] laplacian 
% [9] mcfs 
% [10] rfe 
% [11] L0 
% [12] fisher 
% [13] UDFS 
% [14] llcfs 
% [15] cfs 
% [16] fsasl 
% [17] dgufs 
% [18] ufsol 
% [19] lasso 

% Before using the toolbox compile the solution:
% make;

%% DEMO FILE
clear all
close all
clc;
fprintf('\nFEATURE SELECTION TOOLBOX v 6.2 2018 - For Matlab \n');

% Select a feature selection method from the list
listFS = {'ILFS','InfFS','ECFS','mrmr','relieff','mutinffs','fsv','laplacian','mcfs','rfe','L0','fisher','UDFS','llcfs','cfs','fsasl','dgufs','ufsol','lasso'};

[ methodID ] = readInput( listFS );
selection_method = listFS{methodID}; % Selected

% Load the data and select features for classification
load Gear1
X = Gear1(:,1:130);

Y = Gear1(:,131);

% remove=any(X<1&X>.9);
% X=X(:,~remove);

% Randomly partitions observations into a training set and a test
% set using stratified holdout
P = cvpartition(Y,'Holdout',0.4);

X_train = X(P.training,:);
Y_train = Y(P.training);

X_test = X(P.test,:);
Y_test = Y(P.test);

% number of features
numF = size(X_train,2);


% feature Selection on training data
switch lower(selection_method)
    case 'inffs'
        % Infinite Feature Selection 2015 updated 2016
        alpha = 0.5;    % default, it should be cross-validated.
        sup = 1;        % Supervised or Not
        [ranking, w] = infFS( X_train , Y_train, alpha , sup , 0 );
        
    case 'ilfs'
        % Infinite Latent Feature Selection - ICCV 2017
        [ranking, weights] = ILFS(X_train, Y_train , 6, 0 );
        
    case 'fsasl'
        options.lambda1 = 1;
        options.LassoType = 'SLEP';
        options.SLEPrFlag = 1;
        options.SLEPreg = 0.01;
        options.LARSk = 5;
        options.LARSratio = 2;
        nClass=2;
        [W, S, A, objHistory] = FSASL(X_train', nClass, options);
        [v,ranking]=sort(abs(W(:,1))+abs(W(:,2)),'descend');
    case 'lasso'
        lambda = 25;
        B = lasso(X_train,Y_train);
        [v,ranking]=sort(B(:,lambda),'descend');
        
    case 'ufsol'
        para.p0 = 'sample';
        para.p1 = 1e6;
        para.p2 = 1e2;
        nClass = 2;
        [~,~,ranking,~] = UFSwithOL(X_train',nClass,para) ;
        
    case 'dgufs'
        
        S = dist(X_train');
        S = -S./max(max(S)); % it's a similarity
        nClass = 2;
        alpha = 0.5;
        beta = 0.9;
        nSel = 2;
        [Y,L,V,Label] = DGUFS(X_train',nClass,S,alpha,beta,nSel);
        [v,ranking]=sort(Y(:,1)+Y(:,2),'descend');
        
        
    case 'mrmr'
        ranking = mRMR(X_train, Y_train, numF);
        
    case 'relieff'
        [ranking, w] = reliefF( X_train, Y_train, 20);
        
    case 'mutinffs'
        [ ranking , w] = mutInfFS( X_train, Y_train, numF );
        
    case 'fsv'
        [ ranking , w] = fsvFS( X_train, Y_train, numF );
        
    case 'laplacian'
        W = dist(X_train');
        W = -W./max(max(W)); % it's a similarity
        [lscores] = LaplacianScore(X_train, W);
        [junk, ranking] = sort(-lscores);
        
    case 'mcfs'
        % MCFS: Unsupervised Feature Selection for Multi-Cluster Data
        options = [];
        options.k = 5; %For unsupervised feature selection, you should tune
        %this parameter k, the default k is 5.
        options.nUseEigenfunction = 4;  %You should tune this parameter.
        [FeaIndex,~] = MCFS_p(X_train,numF,options);
        ranking = FeaIndex{1};
        
    case 'rfe'
        ranking = spider_wrapper(X_train,Y_train,numF,lower(selection_method));
        
    case 'l0'
        ranking = spider_wrapper(X_train,Y_train,numF,lower(selection_method));
        
    case 'fisher'
        ranking = spider_wrapper(X_train,Y_train,numF,lower(selection_method));
        
        
    case 'ecfs'
        % Features Selection via Eigenvector Centrality 2016
        alpha = 0.5; % default, it should be cross-validated.
        ranking = ECFS( X_train, Y_train, alpha )  ;
        
    case 'udfs'
        % Regularized Discriminative Feature Selection for Unsupervised Learning
        nClass = 2;
        ranking = UDFS(X_train , nClass );
        
    case 'cfs'
        % BASELINE - Sort features according to pairwise correlations
        ranking = cfs(X_train);
        
    case 'llcfs'
        % Feature Selection and Kernel Learning for Local Learning-Based Clustering
        ranking = llcfs( X_train );
        
    otherwise
        disp('Unknown method.')
end

k = 2; % select the first 2 features

ranking

% % Use a linear support vector machine classifier
% % svmStruct = svmtrain(X_train(:,ranking(1:k)),Y_train,'showplot',true);
% % C = svmclassify(svmStruct,X_test(:,ranking(1:k)),'showplot',true);
% svmClassifier = fitcsvm(X_train(:,ranking(1:k)),Y_train);
% [C, scores] = predict(svmClassifier, X_test(:,ranking(1:k)));
% err_rate = sum(Y_test~= C)/P.TestSize; % mis-classification rate
% conMat = confusionmat(Y_test,C); % the confusion matrix
% 
% disp('X_train size')
% size(X_train)
% 
% disp('Y_train size')
% size(Y_train)
% 
% disp('X_test size')
% size(X_test)
% 
% disp('Y_test size')
% size(Y_test)
% 
% 
% fprintf('\nMethod %s (Linear-SVMs): Accuracy: %.2f%%, Error-Rate: %.2f \n',selection_method,100*(1-err_rate),err_rate);



% MathWorks Licence
% Copyright (c) 2016-2017, Giorgio Roffo
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of the University of Verona nor the names
%       of its contributors may be used to endorse or promote products derived
%       from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
