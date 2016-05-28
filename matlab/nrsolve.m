function [x,exitflag,k] = nrsolve(eval_g,x0,opts)
% use the Newton-Raphson method to solve a set of non-linear equations
% usage: [x,exitflag,k] = nrsolve(g,x0,opts)
%
% This function solves the unconstrained optimization problem
%  minimize   0.5 g(x)' * g(x)
%     x
%
% Inputs:
%  eval_g is the g function, with two outputs (g and Jac_g).
%  x0 is a starting point
%  opts comes form numerics_options
% Outputs:
%  x is the ouptut optizer
%  exitflag is one of:
%   1  - found a solution that solves g(x)=0
%   -1 - found a solution that minimizes 0.5 g(x)' * g(x)
%   0  - failed to find any solution.
%  k is the number of iterations required to solve the problem.

% process inputs
if nargin<2, error('at least 2 inputs needed'); end
if nargin<3, opts = numerics_options; end;
if nargout(eval_g)==1
    error('The input function needs to output the jacobian');
end

% if opt.nr.linesearch = 'cubic_spline'
% addpath('../matlab');
% end
max_iters = opts.nr.max_iterations;
tolerance = opts.nr.tolerance;
verbose   = opts.nr.verbose;
use_fsolve = opts.nr.use_fsolve;
alpha = 0;

x = x0;
exitflag = 0;
tic;

%{
% check the condition of the jac
[~,J] = eval_g(x0);
c = condest(J);
if c>1e8
    warning('nrsolve:JCondition','J appears to be ill conditioned: %g',c);
end
%}

% solve with fsolve
if use_fsolve
    fsolve_opts = optimset( 'Jacobian','on',...
        'Algorithm','trust-region-dogleg',...
        'Display','off');
    [x,~,flag] = fsolve(eval_g,x0,fsolve_opts);
    success = (flag==1);
    exitflag = success; % = (flag==1);
    
else
    % print something
    if verbose
        disp('Iter   Max(|g|)   |g|_2      |J.''*g|      alpha     det(J)');
    end
    
    for k = 0:max_iters
        % evaluate the function and the derivative
        [g,J] = feval(eval_g,x);
        
        % do some calculations to check for convergence:
        max_mismatch = max(abs(g)); % inf norm
        % check first order optimality condition
        Jg = J.'*g;
        mean_Jg = mean(Jg);
        mean_g2 = mean(g.^2);
        % print something
        if verbose
            dJ =  det(J);
            if k==0
                fprintf('%4d %10.7f %10.7f %10.7f     ----   %10.7e\n', ...
                    k, full(max_mismatch), full(mean_g2), full(mean_Jg), dJ);
            else
                fprintf('%4d %10.7f %10.7f %10.7f %10.7f %10.7e\n', ...
                    k, full(max_mismatch), full(mean_g2), full(mean_Jg), alpha, dJ);
            end
        end
        
        % check for convergence
        if max_mismatch<tolerance %checks if max is is greater than tolerance
            exitflag = 1;
            if verbose
                et = toc;
                fprintf('Solution found in %g seconds\n',et);
            end
            break;
        end
%         if mean_Jg<tolerance
%             exitflag = -1;
%             if verbose
%                 et = toc;
%                 fprintf('Solution found that minimized g''*g, but g(x)~=0 (in %g seconds)\n',et);
%             end
%             break;
%         end
        % choose the search direction
        p = -(J\g);
        %keyboard
        
        % save x for the plot below with different alpha's
        x_old = x;
        
        % do some sort of line search to select the step size and the new x
        [x,alpha,~,flag] = linesearch(p,x,eval_g,opts);
        if ~flag
            if verbose
                fprintf(' Could not find a step size that decreased the mismatch\n');
            end
            break;
        end
        % produce a plot to help think about alpha
        if 0
            alpha_range = -1:0.01:2;
            g_norm = zeros(size(alpha_range));
            for ai = 1:length(alpha_range)
                x_new = x_old + alpha_range(ai)*p;
                g_new = feval(eval_g,x_new);
                g_norm(ai) = mean(g_new.^2);
            end
            figure(1); clf
            plot(alpha_range,g_norm);
            xlabel('Alpha');
            ylabel('g-norm');
            pause;
        end
        if alpha < 1e-12
            break
        end
    end
end

if  verbose && exitflag~=1
    disp(' Did not find a solution to g(x)=0');
end

return;

function [x,alpha,g,exitflag] = linesearch(p,x_prev,eval_g,opts)
% perform a line search to choose a step size
% usage: [x,alpha,g,exitflag] = linesearch(p,x_prev,eval_g,opts)
%  exitflag of 1 means that we got a valid output

exitflag = 1;

% get the starting point
f_prev = qnorm(feval(eval_g,x_prev));
% choose the method
switch opts.nr.linesearch
    case 'none'
        alpha = 1;
        x = x_prev + alpha*p;
        g = feval(eval_g,x);
    case 'backtrack'
        alpha = 1;
        alpha_min = opts.nr.alpha_min;
        mu        = opts.nr.mu;
        while alpha > alpha_min
            x = x_prev + alpha*p;
            g = feval(eval_g,x);
            f = qnorm(g);
            % test the sufficient decrease (Armijo) condition
            if f <= f_prev + mu * alpha * sum( p.*x );
                break
            end
            alpha = alpha / 2;
%             if 0
%                 a = -1:.01:1;
%                 for i = 1:length(a)
%                     fi(i) = qnorm(feval(eval_g,x_prev + a(i)*p));
%                 end
%                 figure(1);
%                 plot(a,fi);
%                 pause
%             end
        end
    case 'exact'
        f_mis = @(a) qnorm(feval(eval_g,x_prev + a*p));
        %[alpha,~,flag] = fminunc(f_mis,1,optimset('Display','off','LargeScale','off'));
        [alpha,~,flag] = fminbnd(f_mis,0,2);
        if flag==0
            alpha = 0;
        end
        x = x_prev + alpha*p;
        g = feval(eval_g,x);
        if f_prev < qnorm(g)
            [alpha,~,flag] = fminbnd(f_mis,0,0.1);
            if flag~=1
                error('Could not find a minimizing alpha');
            end
        end
        
    case 'cubic_spline'
        alpha = 1;
        alphaEnd  = 1.5;
        alpha_min = opts.nr.alpha_min;
        mu        = opts.nr.mu;
        while alpha > alpha_min
            try
                [alpha] = minstep(eval_g, x_prev, 0, alphaEnd, p);
            catch
                alpha = alphaEnd;
            end
            %check if alpha is reasonable. if alpha > alphaEnd, set alpha
            %to alpha end.
            if alpha > alphaEnd
                alpha = alphaEnd;
            end
            
            x = x_prev + alpha*p;
            g = feval(eval_g,x);
            f = qnorm(g);
            %keyboard
            % test the sufficient decrease (Armijo) condition
            if f <= f_prev + mu * alpha * sum( p.*x );
                break
            end
            alphaEnd = alphaEnd/2;
        end
    otherwise
        error('unsupported line search method');
end

x = x_prev + alpha*p;
g = feval(eval_g,x);
if f_prev < qnorm(g)
    exitflag = 0;
end


function f = qnorm(x)
% simple quadratic norm:
% note that the derivative of this is 2*x/2 = x

f = sum( x.^2 ) / 2;
