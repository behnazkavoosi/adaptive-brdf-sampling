function [c_r, c_g, c_b] = solver_L2(Qhat, k, r, g, b, eta)
    %fprintf('solving coefficients with L2 : k = %d...\n', k);
    
    Qhat = Qhat(:, 1:k);
    
    c_core = inv((Qhat'*Qhat) + (eta*eye(k)));

    c_r = c_core*(Qhat' * r);
    c_g = c_core*(Qhat' * g);
    c_b = c_core*(Qhat' * b);

end
