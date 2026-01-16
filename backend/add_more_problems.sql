-- Problem 2: Reverse String
INSERT INTO problems (title, slug, description, difficulty, base_score, acceptance_rate, total_submissions, successful_submissions, tags, hints, created_at)
VALUES (
  'Reverse String',
  'reverse-string',
  'Write a program that reverses a string.

Example 1:
Input: "hello"
Output: "olleh"

Example 2:
Input: "world"
Output: "dlrow"

Constraints:
- 1 <= s.length <= 1000
- s consists of printable ASCII characters',
  'EASY',
  80,
  92.5,
  8420,
  7789,
  'String,Two Pointers',
  'Use two pointers from start and end | Swap characters until pointers meet',
  CURRENT_TIMESTAMP
);

-- Test cases for Reverse String (problem_id will be 2)
INSERT INTO test_cases (problem_id, input, expected_output, is_hidden, order_index)
VALUES 
  ((SELECT id FROM problems WHERE slug = 'reverse-string'), 'hello', 'olleh', false, 1),
  ((SELECT id FROM problems WHERE slug = 'reverse-string'), 'world', 'dlrow', false, 2),
  ((SELECT id FROM problems WHERE slug = 'reverse-string'), 'a', 'a', false, 3);

-- Problem 3: Palindrome Number
INSERT INTO problems (title, slug, description, difficulty, base_score, acceptance_rate, total_submissions, successful_submissions, tags, hints, created_at)
VALUES (
  'Palindrome Number',
  'palindrome-number',
  'Given an integer x, return true if x is a palindrome, and false otherwise.

Example 1:
Input: 121
Output: true
Explanation: 121 reads as 121 from left to right and from right to left.

Example 2:
Input: -121
Output: false
Explanation: From left to right, it reads -121. From right to left, it becomes 121-. Therefore it is not a palindrome.

Example 3:
Input: 10
Output: false

Constraints:
- -2^31 <= x <= 2^31 - 1',
  'EASY',
  90,
  88.3,
  12340,
  10896,
  'Math,String',
  'Convert to string and compare with reversed | Negative numbers are never palindromes',
  CURRENT_TIMESTAMP
);

-- Test cases for Palindrome Number (problem_id will be 3)
INSERT INTO test_cases (problem_id, input, expected_output, is_hidden, order_index)
VALUES 
  ((SELECT id FROM problems WHERE slug = 'palindrome-number'), '121', 'true', false, 1),
  ((SELECT id FROM problems WHERE slug = 'palindrome-number'), '-121', 'false', false, 2),
  ((SELECT id FROM problems WHERE slug = 'palindrome-number'), '10', 'false', false, 3);