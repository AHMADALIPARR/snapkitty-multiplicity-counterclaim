% ADR 003 from source/supplied-counter-source.md.
% Negative example: stripping an MLWE error term and iterating to entropy 0.
% Do not use as a key schedule. See docs/adr/ADR-003.md.

function [Drain_Status] = execute_entropy_drain_framework()
    p = 7;
    n = 4; %#ok<NASGU>
    initial_boundary = [6; 2; 5; 4; 1; 3; 6; 0];
    [crystal_lut, lemma_lut_holds] = lemma_dense_sas_lut(p);
    [final_state, iterations, lemma_collapse_holds] = lemma_zero_entropy_collapse(initial_boundary, crystal_lut);
    Drain_Status = lemma_lut_holds && lemma_collapse_holds;
    fprintf('iters=%d final0=%d status=%d\n', iterations, final_state(1), Drain_Status);
end

function [lut, structure_dense] = lemma_dense_sas_lut(p)
    lut = zeros(p, 1);
    for i = 0:(p-1)
        lut(i+1) = floor(sqrt(i));
    end
    unique_outputs = length(unique(lut));
    structure_dense = unique_outputs < p;
end

function [state, epoch, zero_entropy_achieved] = lemma_zero_entropy_collapse(tensor, crystal_lut)
    state = tensor;
    epoch = 0;
    max_epochs = 100;
    while epoch < max_epochs
        current_entropy = calculate_shannon_entropy(state);
        if current_entropy == 0.0
            break;
        end
        next_state = zeros(size(state));
        for i = 1:length(state)
            idx = state(i) + 1;
            next_state(i) = crystal_lut(idx);
        end
        min_val = min(next_state);
        state = next_state - min_val;
        epoch = epoch + 1;
    end
    final_entropy = calculate_shannon_entropy(state);
    zero_entropy_achieved = (final_entropy == 0.0);
end

function H = calculate_shannon_entropy(data_vector)
    [~, ~, idx] = unique(data_vector);
    counts = accumarray(idx, 1);
    probabilities = counts / length(data_vector);
    H = -sum(probabilities .* log2(probabilities));
    if abs(H) < 1e-10
        H = 0.0;
    end
end
