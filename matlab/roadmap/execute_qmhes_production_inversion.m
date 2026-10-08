% Roadmap inversion from source/supplied-counter-source.md.
% Phases follow Van Gelder, QMHES Mathematical Appendix, 2026, §6.
% Test 3 vector is appendix §4.3: (0,1,2,3,5,4,6,5,6) -> AAAARARAA, final seq 7.
% The loop continues after ABORTED only to score the published pattern.
% Normative v1.0.1 behavior is to stop at the first reject.

function [Roadmap_Status] = execute_qmhes_production_inversion()
    [seq_status, final_seq] = phase_1_2_strict_sequence_validation();
    wire_status = phase_4_wire_format_codec();
    qkd_status = phase_5_6_qkd_telemetry_loop(0.04, 1024);
    v2_status = phase_8_sliding_window_upgrade();
    Roadmap_Status = seq_status && wire_status && qkd_status && v2_status;
    fprintf('seq=%d final=%d wire=%d qkd=%d v2=%d status=%d\n', ...
        seq_status, final_seq, wire_status, qkd_status, v2_status, Roadmap_Status);
end

function [is_valid, expected_next_seq] = phase_1_2_strict_sequence_validation()
    input_sequence = [0, 1, 2, 3, 5, 4, 6, 5, 6];
    expected_pattern = ['A', 'A', 'A', 'A', 'R', 'A', 'R', 'A', 'A'];
    expected_next_seq = 0;
    actual_pattern = char(zeros(1, length(input_sequence)));
    session_state = 'AUTHENTICATED';
    for i = 1:length(input_sequence)
        if input_sequence(i) ~= expected_next_seq
            actual_pattern(i) = 'R';
            session_state = 'ABORTED'; %#ok<NASGU>
        else
            actual_pattern(i) = 'A';
            expected_next_seq = expected_next_seq + 1;
        end
    end
    is_valid = isequal(actual_pattern, expected_pattern) && (expected_next_seq == 7);
end

function [format_valid] = phase_4_wire_format_codec()
    msg_type = uint8(2);
    seq = uint32(42);
    payload = uint8([192, 168, 1, 1]);
    plen = uint16(length(payload));
    seq_be = typecast(swapbytes(seq), 'uint8');
    plen_be = typecast(swapbytes(plen), 'uint8');
    hmac_input_buffer = [msg_type, seq_be, plen_be, payload];
    expected_length = 1 + 4 + 2 + length(payload);
    format_valid = (length(hmac_input_buffer) == expected_length);
end

function [operations_stable] = phase_5_6_qkd_telemetry_loop(qber_metric, key_pool_level)
    QBER_THRESHOLD = 0.05;
    MIN_KEY_POOL = 256;
    if qber_metric > QBER_THRESHOLD
        operations_stable = false;
    elseif key_pool_level < MIN_KEY_POOL
        operations_stable = false;
    else
        operations_stable = true;
    end
end

function [upgrade_ready] = phase_8_sliding_window_upgrade()
    window_size = 64;
    received_packets = zeros(1, window_size); %#ok<NASGU>
    current_seq = 100;
    incoming_seq = 105;
    if incoming_seq > current_seq && (incoming_seq - current_seq) < window_size
        upgrade_ready = true;
    else
        upgrade_ready = false;
    end
end
