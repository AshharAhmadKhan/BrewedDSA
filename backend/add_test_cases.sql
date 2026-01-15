-- Test cases for Two Sum (problem_id = 1)
INSERT INTO test_cases (problem_id, input, expected_output, is_hidden, order_index) VALUES
(1, '2,7,11,15
9', '0,1', false, 1),
(1, '3,2,4
6', '1,2', false, 2),
(1, '3,3
6', '0,1', false, 3);

-- Test cases for Reverse String (problem_id = 2)
INSERT INTO test_cases (problem_id, input, expected_output, is_hidden, order_index) VALUES
(2, 'hello', 'olleh', false, 1),
(2, 'BrewAlgo', 'oglAwerB', false, 2),
(2, 'a', 'a', false, 3);

-- Test cases for Valid Parentheses (problem_id = 3)
INSERT INTO test_cases (problem_id, input, expected_output, is_hidden, order_index) VALUES
(3, '()', 'true', false, 1),
(3, '()[]{}', 'true', false, 2),
(3, '(]', 'false', false, 3),
(3, '([)]', 'false', false, 4);
