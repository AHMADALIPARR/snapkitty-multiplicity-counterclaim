% QMHES Macrosemantic Algebraic Reduction Framework
% From source/supplied-counter-source.md (ADR 001 section).
% Execution of these functions evaluates the invariants defined in ADR 001.
% Not a proof of Van Gelder's Proposition 3.13.

function [Framework_Status] = execute_qmhes_framework()
    % Root execution node orchestrating the validation of all four lemmas.

    psi = [complex(1/sqrt(2), 0); complex(0, 1/sqrt(2))];
    [freq, lemma_B2_holds] = lemma_B2_projective_normalization(psi);

    phi = [complex(sqrt(0.8), 0); complex(0, sqrt(0.2))];
    [dist, lemma_F2_holds] = lemma_F2_lipschitz_boundary(psi, phi);

    M1 = [0.5, 0.1; 0.2, 0.8];
    M2 = [0.9, 0.4; 0.1, 0.7];
    [enc_M1, lemma_B4_holds] = lemma_B4_voronoi_quantization(M1, M2, 0.1);

    % Test curve: y^2 = x^3 + 2x + 3 mod 97, generator (3, 6)
    p = 97; a = 2; b = 3; G_x = 3; G_y = 6;
    P_prev = [3, 6]; QBER = 0.02; lambda = 0.85;
    [P_t, lemma_C2_holds] = lemma_C2_elliptic_feedback(QBER, lambda, P_prev, [G_x, G_y], a, p);

    Framework_Status = lemma_B2_holds && lemma_F2_holds && lemma_B4_holds && lemma_C2_holds;
    fprintf('B2=%d F2=%d B4=%d C2=%d status=%d\n', ...
        lemma_B2_holds, lemma_F2_holds, lemma_B4_holds, lemma_C2_holds, Framework_Status);
    fprintf('freq_norm=%g dist=%g enc11=%g P=(%d,%d)\n', ...
        norm(freq), dist, enc_M1(1,1), P_t(1), P_t(2));
end

function [freq_vector, invariant_conserved] = lemma_B2_projective_normalization(psi)
    psi = psi / norm(psi);
    n = length(psi);
    freq_vector = zeros(2*n, 1);
    for j = 1:n
        freq_vector(2*j - 1) = real(psi(j));
        freq_vector(2*j)     = imag(psi(j));
    end
    metric_norm = norm(freq_vector, 2);
    invariant_conserved = abs(metric_norm - 1.0) < 1e-12;
end

function [euclidean_dist, boundary_respected] = lemma_F2_lipschitz_boundary(psi, phi)
    psi = psi / norm(psi);
    phi = phi / norm(phi);
    F_psi = lemma_B2_projective_normalization(psi);
    F_phi = lemma_B2_projective_normalization(phi);
    euclidean_dist = norm(F_psi - F_phi, 2);
    inner_product = abs(psi' * phi);
    supreme_bound = 2 * sqrt(2) * sqrt(1 - inner_product);
    boundary_respected = euclidean_dist <= supreme_bound + 1e-12;
end

function [encoded_matrix, structural_isolation] = lemma_B4_voronoi_quantization(M1, M2, R)
    quantize = @(M) round(M ./ (2*R)) .* (2*R);
    encoded_M1 = quantize(M1);
    encoded_M2 = quantize(M2);
    encoded_matrix = encoded_M1;
    frob_dist = norm(M1 - M2, 'fro');
    if frob_dist > 2*R
        structural_isolation = ~isequal(encoded_M1, encoded_M2);
    else
        structural_isolation = true;
    end
end

function [P_t, discrete_log_held] = lemma_C2_elliptic_feedback(QBER, lambda_val, P_prev, G, a, p)
    k_t = mod(floor(QBER * 1e5) + floor(lambda_val * 1e3) + P_prev(1), p - 1) + 1;
    curr_x = P_prev(1);
    curr_y = P_prev(2);
    bin_k = dec2bin(k_t);
    for i = 2:length(bin_k)
        [curr_x, curr_y] = group_add(curr_x, curr_y, curr_x, curr_y, a, p);
        if bin_k(i) == '1'
            [curr_x, curr_y] = group_add(curr_x, curr_y, P_prev(1), P_prev(2), a, p);
        end
    end
    [P_t_x, P_t_y] = group_add(curr_x, curr_y, G(1), G(2), a, p);
    P_t = [P_t_x, P_t_y];
    b = mod(G(2)^2 - G(1)^3 - a*G(1), p);
    curve_verification = mod(P_t(1)^3 + a*P_t(1) + b - P_t(2)^2, p);
    discrete_log_held = (curve_verification == 0);
end

function [x3, y3] = group_add(x1, y1, x2, y2, a, p)
    if x1 == x2 && y1 == y2
        num = mod(3 * x1^2 + a, p);
        den = mod(2 * y1, p);
        inv_den = ext_euclidean_inverse(den, p);
        slope = mod(num * inv_den, p);
    else
        num = mod(y2 - y1, p);
        den = mod(x2 - x1, p);
        if den < 0, den = den + p; end
        inv_den = ext_euclidean_inverse(den, p);
        slope = mod(num * inv_den, p);
    end
    x3 = mod(slope^2 - x1 - x2, p);
    y3 = mod(slope * (x1 - x3) - y1, p);
    if x3 < 0, x3 = x3 + p; end
    if y3 < 0, y3 = y3 + p; end
end

function inv = ext_euclidean_inverse(n, p)
    t = 0; newt = 1;
    r = p; newr = n;
    while newr ~= 0
        quotient = floor(r / newr);
        temp_t = t - quotient * newt;
        t = newt; newt = temp_t;
        temp_r = r - quotient * newr;
        r = newr; newr = temp_r;
    end
    if r > 1
        error('division by zero in F_p inversion');
    end
    if t < 0
        t = t + p;
    end
    inv = t;
end
