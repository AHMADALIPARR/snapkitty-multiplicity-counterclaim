% ADR 002 from source/supplied-counter-source.md.
% Elementary-abelian bifurcation. Not a post-quantum KEM.

function [Holo_Status] = execute_holographic_pq_framework()
    p = 7;
    n = 4;
    [bifurcated_state, lemma_bifurcation_holds] = lemma_strict_bifurcation(10);
    bulk_message = [3; 1; 6; 5];
    [boundary_ciphertext, lemma_holographic_holds] = lemma_abelian_holographic_tensor(bulk_message, p, n);
    Holo_Status = lemma_bifurcation_holds && lemma_holographic_holds;
    fprintf('node=%d boundary0=%d status=%d\n', bifurcated_state, boundary_ciphertext(1), Holo_Status);
end

function [state_node, strictly_bifurcated] = lemma_strict_bifurcation(epochs)
    current_node = 1;
    for t = 1:epochs
        hash_parity = mod(t * 137, 2);
        if hash_parity == 0
            current_node = 2 * current_node;
        else
            current_node = 2 * current_node + 1;
        end
    end
    state_node = current_node;
    expected_min = 2^epochs;
    expected_max = 2^(epochs + 1) - 1;
    strictly_bifurcated = (state_node >= expected_min) && (state_node <= expected_max);
end

function [boundary_tensor, holographic_bound_holds] = lemma_abelian_holographic_tensor(bulk_msg, p, n)
    G = mod(vander(1:2*n), p);
    G_trunc = G(:, 1:n);
    boundary_tensor = mod(G_trunc * bulk_msg, p);
    G_subset = G_trunc(1:n, :);
    det_val = round(det(G_subset));
    isInvertible = mod(det_val, p) ~= 0;
    holographic_bound_holds = isInvertible;
end
