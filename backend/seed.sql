-- ============================================================================
-- BrewAlgo Database Seeding Script
-- ============================================================================
-- This script populates the database with realistic LeetCode-style data
-- All passwords are BCrypt hashed (plain text: password123 for users, admin123 for admin)
-- ============================================================================

-- Clear existing data (in correct order due to foreign keys)
DELETE FROM submissions;
DELETE FROM contests;
DELETE FROM problems;
DELETE FROM users;

-- Reset sequences
ALTER SEQUENCE users_id_seq RESTART WITH 1;
ALTER SEQUENCE problems_id_seq RESTART WITH 1;
ALTER SEQUENCE submissions_id_seq RESTART WITH 1;
ALTER SEQUENCE contests_id_seq RESTART WITH 1;

-- ============================================================================
-- USERS (passwords are BCrypt hashed)
-- ============================================================================
-- Password for all users: "password123"
-- Password for admin: "admin123"
-- BCrypt rounds: 10 (Spring Security default)

INSERT INTO users (username, email, password_hash, rating, problems_solved, created_at, last_login_at, role) VALUES
('admin', 'admin@brewalgo.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8z4cXjNfT7xmIrL3KFyXNGfJPx8m6', 2500, 150, NOW() - INTERVAL '6 months', NOW(), 'ADMIN'),
('alice', 'alice@example.com', '$2a$10$8K1p/a0dL2F7FqLXwi2C9O6HPGmUOEVXANJlUF3YNjPbVMXb4gQJy', 1800, 85, NOW() - INTERVAL '4 months', NOW() - INTERVAL '2 hours', 'USER'),
('bob', 'bob@example.com', '$2a$10$8K1p/a0dL2F7FqLXwi2C9O6HPGmUOEVXANJlUF3YNjPbVMXb4gQJy', 1500, 62, NOW() - INTERVAL '3 months', NOW() - INTERVAL '1 day', 'USER'),
('charlie', 'charlie@example.com', '$2a$10$8K1p/a0dL2F7FqLXwi2C9O6HPGmUOEVXANJlUF3YNjPbVMXb4gQJy', 1200, 38, NOW() - INTERVAL '2 months', NOW() - INTERVAL '3 days', 'USER'),
('dave', 'dave@example.com', '$2a$10$8K1p/a0dL2F7FqLXwi2C9O6HPGmUOEVXANJlUF3YNjPbVMXb4gQJy', 1000, 15, NOW() - INTERVAL '1 month', NOW() - INTERVAL '1 week', 'USER');

-- ============================================================================
-- PROBLEMS - EASY (10 problems)
-- ============================================================================

INSERT INTO problems (slug, title, description, difficulty, base_score, acceptance_rate, total_submissions, successful_submissions, created_at, hints, tags) VALUES
('two-sum', 'Two Sum', 
'Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

**Example 1:**
```
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
```

**Example 2:**
```
Input: nums = [3,2,4], target = 6
Output: [1,2]
```

**Constraints:**
- 2 <= nums.length <= 10^4
- -10^9 <= nums[i] <= 10^9
- -10^9 <= target <= 10^9
- Only one valid answer exists.',
'EASY', 100, 85, 15420, 13107, NOW() - INTERVAL '180 days',
'Use a hash map to store numbers you''ve seen|Look for target - current number',
'Array,Hash Table'),

('reverse-string', 'Reverse String',
'Write a function that reverses a string in-place. The input string is given as an array of characters `s`.

You must do this by modifying the input array in-place with O(1) extra memory.

**Example 1:**
```
Input: s = ["h","e","l","l","o"]
Output: ["o","l","l","e","h"]
```

**Example 2:**
```
Input: s = ["H","a","n","n","a","h"]
Output: ["h","a","n","n","a","H"]
```

**Constraints:**
- 1 <= s.length <= 10^5
- s[i] is a printable ascii character.',
'EASY', 100, 92, 8340, 7673, NOW() - INTERVAL '175 days',
'Use two pointers|Swap characters from both ends moving towards center',
'Two Pointers,String'),

('valid-parentheses', 'Valid Parentheses',
'Given a string `s` containing just the characters ''('', '')'', ''{'', ''}'', ''['' and '']'', determine if the input string is valid.

An input string is valid if:
1. Open brackets must be closed by the same type of brackets.
2. Open brackets must be closed in the correct order.
3. Every close bracket has a corresponding open bracket of the same type.

**Example 1:**
```
Input: s = "()"
Output: true
```

**Example 2:**
```
Input: s = "()[]{}"
Output: true
```

**Example 3:**
```
Input: s = "(]"
Output: false
```

**Constraints:**
- 1 <= s.length <= 10^4
- s consists of parentheses only ''()[]{}''.',
'EASY', 100, 78, 12890, 10054, NOW() - INTERVAL '170 days',
'Use a stack data structure|Push opening brackets, pop when you see closing|Check if popped bracket matches',
'String,Stack'),

('merge-two-sorted-lists', 'Merge Two Sorted Lists',
'You are given the heads of two sorted linked lists `list1` and `list2`.

Merge the two lists into one sorted list. The list should be made by splicing together the nodes of the first two lists.

Return the head of the merged linked list.

**Example 1:**
```
Input: list1 = [1,2,4], list2 = [1,3,4]
Output: [1,1,2,3,4,4]
```

**Example 2:**
```
Input: list1 = [], list2 = []
Output: []
```

**Constraints:**
- The number of nodes in both lists is in the range [0, 50].
- -100 <= Node.val <= 100
- Both list1 and list2 are sorted in non-decreasing order.',
'EASY', 100, 81, 9560, 7744, NOW() - INTERVAL '165 days',
'Use a dummy node to simplify edge cases|Compare values and advance pointers',
'Linked List,Recursion'),

('best-time-to-buy-sell-stock', 'Best Time to Buy and Sell Stock',
'You are given an array `prices` where `prices[i]` is the price of a given stock on the ith day.

You want to maximize your profit by choosing a single day to buy one stock and choosing a different day in the future to sell that stock.

Return the maximum profit you can achieve from this transaction. If you cannot achieve any profit, return 0.

**Example 1:**
```
Input: prices = [7,1,5,3,6,4]
Output: 5
Explanation: Buy on day 2 (price = 1) and sell on day 5 (price = 6), profit = 6-1 = 5.
```

**Example 2:**
```
Input: prices = [7,6,4,3,1]
Output: 0
Explanation: No profit can be made.
```

**Constraints:**
- 1 <= prices.length <= 10^5
- 0 <= prices[i] <= 10^4',
'EASY', 100, 73, 11230, 8198, NOW() - INTERVAL '160 days',
'Keep track of minimum price seen so far|Calculate profit at each step',
'Array,Dynamic Programming'),

('palindrome-number', 'Palindrome Number',
'Given an integer `x`, return `true` if `x` is a palindrome, and `false` otherwise.

**Example 1:**
```
Input: x = 121
Output: true
Explanation: 121 reads as 121 from left to right and from right to left.
```

**Example 2:**
```
Input: x = -121
Output: false
Explanation: From left to right, it reads -121. From right to left, it becomes 121-.
```

**Constraints:**
- -2^31 <= x <= 2^31 - 1',
'EASY', 100, 88, 7890, 6943, NOW() - INTERVAL '155 days',
'Negative numbers are not palindromes|Reverse the number and compare',
'Math'),

('maximum-subarray', 'Maximum Subarray',
'Given an integer array `nums`, find the subarray with the largest sum, and return its sum.

**Example 1:**
```
Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
Output: 6
Explanation: The subarray [4,-1,2,1] has the largest sum 6.
```

**Example 2:**
```
Input: nums = [1]
Output: 1
Explanation: The subarray [1] has the largest sum 1.
```

**Constraints:**
- 1 <= nums.length <= 10^5
- -10^4 <= nums[i] <= 10^4',
'EASY', 100, 69, 13450, 9281, NOW() - INTERVAL '150 days',
'Use Kadane''s algorithm|Keep track of current sum and maximum sum',
'Array,Dynamic Programming,Divide and Conquer'),

('climbing-stairs', 'Climbing Stairs',
'You are climbing a staircase. It takes `n` steps to reach the top.

Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?

**Example 1:**
```
Input: n = 2
Output: 2
Explanation: There are two ways to climb to the top.
1. 1 step + 1 step
2. 2 steps
```

**Example 2:**
```
Input: n = 3
Output: 3
Explanation: There are three ways to climb to the top.
1. 1 step + 1 step + 1 step
2. 1 step + 2 steps
3. 2 steps + 1 step
```

**Constraints:**
- 1 <= n <= 45',
'EASY', 100, 76, 8920, 6779, NOW() - INTERVAL '145 days',
'This is a Fibonacci sequence problem|Use dynamic programming or recursion with memoization',
'Math,Dynamic Programming,Memoization'),

('linked-list-cycle', 'Linked List Cycle',
'Given `head`, the head of a linked list, determine if the linked list has a cycle in it.

There is a cycle in a linked list if there is some node in the list that can be reached again by continuously following the `next` pointer.

Return `true` if there is a cycle in the linked list. Otherwise, return `false`.

**Example 1:**
```
Input: head = [3,2,0,-4], pos = 1
Output: true
Explanation: There is a cycle, where the tail connects to the 1st node (0-indexed).
```

**Constraints:**
- The number of nodes in the list is in the range [0, 10^4].
- -10^5 <= Node.val <= 10^5',
'EASY', 100, 82, 9670, 7929, NOW() - INTERVAL '140 days',
'Use Floyd''s cycle detection (tortoise and hare)|Use two pointers with different speeds',
'Hash Table,Linked List,Two Pointers'),

('remove-duplicates-sorted-array', 'Remove Duplicates from Sorted Array',
'Given an integer array `nums` sorted in non-decreasing order, remove the duplicates in-place such that each unique element appears only once. The relative order of the elements should be kept the same.

Return the number of unique elements in `nums`.

**Example 1:**
```
Input: nums = [1,1,2]
Output: 2, nums = [1,2,_]
Explanation: Your function should return k = 2, with the first two elements of nums being 1 and 2 respectively.
```

**Constraints:**
- 1 <= nums.length <= 3 * 10^4
- -100 <= nums[i] <= 100
- nums is sorted in non-decreasing order.',
'EASY', 100, 79, 10340, 8169, NOW() - INTERVAL '135 days',
'Use two pointers technique|One pointer tracks unique elements position',
'Array,Two Pointers');

-- ============================================================================
-- PROBLEMS - MEDIUM (10 problems)
-- ============================================================================

INSERT INTO problems (slug, title, description, difficulty, base_score, acceptance_rate, total_submissions, successful_submissions, created_at, hints, tags) VALUES
('3sum', '3Sum',
'Given an integer array nums, return all the triplets `[nums[i], nums[j], nums[k]]` such that `i != j`, `i != k`, and `j != k`, and `nums[i] + nums[j] + nums[k] == 0`.

Notice that the solution set must not contain duplicate triplets.

**Example 1:**
```
Input: nums = [-1,0,1,2,-1,-4]
Output: [[-1,-1,2],[-1,0,1]]
```

**Example 2:**
```
Input: nums = [0,1,1]
Output: []
Explanation: The only possible triplet does not sum up to 0.
```

**Constraints:**
- 3 <= nums.length <= 3000
- -10^5 <= nums[i] <= 10^5',
'MEDIUM', 200, 45, 8920, 4014, NOW() - INTERVAL '130 days',
'Sort the array first|Use two pointers after fixing one element|Skip duplicates to avoid duplicate triplets',
'Array,Two Pointers,Sorting'),

('longest-substring-without-repeating', 'Longest Substring Without Repeating Characters',
'Given a string `s`, find the length of the longest substring without repeating characters.

**Example 1:**
```
Input: s = "abcabcbb"
Output: 3
Explanation: The answer is "abc", with the length of 3.
```

**Example 2:**
```
Input: s = "bbbbb"
Output: 1
Explanation: The answer is "b", with the length of 1.
```

**Constraints:**
- 0 <= s.length <= 5 * 10^4
- s consists of English letters, digits, symbols and spaces.',
'MEDIUM', 200, 52, 10230, 5320, NOW() - INTERVAL '125 days',
'Use sliding window technique|Use hash set to track characters in current window|Shrink window when duplicate found',
'Hash Table,String,Sliding Window'),

('add-two-numbers', 'Add Two Numbers',
'You are given two non-empty linked lists representing two non-negative integers. The digits are stored in reverse order, and each of their nodes contains a single digit. Add the two numbers and return the sum as a linked list.

You may assume the two numbers do not contain any leading zero, except the number 0 itself.

**Example 1:**
```
Input: l1 = [2,4,3], l2 = [5,6,4]
Output: [7,0,8]
Explanation: 342 + 465 = 807.
```

**Constraints:**
- The number of nodes in each linked list is in the range [1, 100].
- 0 <= Node.val <= 9',
'MEDIUM', 200, 58, 9340, 5417, NOW() - INTERVAL '120 days',
'Handle carry between digits|Create new nodes for result|Don''t forget final carry',
'Linked List,Math,Recursion'),

('container-with-most-water', 'Container With Most Water',
'You are given an integer array `height` of length `n`. There are `n` vertical lines drawn such that the two endpoints of the ith line are `(i, 0)` and `(i, height[i])`.

Find two lines that together with the x-axis form a container, such that the container contains the most water.

Return the maximum amount of water a container can store.

**Example 1:**
```
Input: height = [1,8,6,2,5,4,8,3,7]
Output: 49
Explanation: The vertical lines are at 1,8,6,2,5,4,8,3,7. The max area is between index 1 and 8 with area = 7 * 7 = 49.
```

**Constraints:**
- n == height.length
- 2 <= n <= 10^5
- 0 <= height[i] <= 10^4',
'MEDIUM', 200, 61, 7890, 4813, NOW() - INTERVAL '115 days',
'Use two pointers from both ends|Move the pointer with smaller height|Area is limited by shorter line',
'Array,Two Pointers,Greedy'),

('generate-parentheses', 'Generate Parentheses',
'Given `n` pairs of parentheses, write a function to generate all combinations of well-formed parentheses.

**Example 1:**
```
Input: n = 3
Output: ["((()))","(()())","(())()","()(())","()()()"]
```

**Example 2:**
```
Input: n = 1
Output: ["()"]
```

**Constraints:**
- 1 <= n <= 8',
'MEDIUM', 200, 67, 6120, 4100, NOW() - INTERVAL '110 days',
'Use backtracking|Only add open parenthesis if count < n|Only add close if close count < open count',
'String,Dynamic Programming,Backtracking'),

('permutations', 'Permutations',
'Given an array `nums` of distinct integers, return all the possible permutations. You can return the answer in any order.

**Example 1:**
```
Input: nums = [1,2,3]
Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
```

**Example 2:**
```
Input: nums = [0,1]
Output: [[0,1],[1,0]]
```

**Constraints:**
- 1 <= nums.length <= 6
- -10 <= nums[i] <= 10
- All the integers of nums are unique.',
'MEDIUM', 200, 72, 8230, 5925, NOW() - INTERVAL '105 days',
'Use backtracking|Swap elements to generate permutations|Track which elements are used',
'Array,Backtracking'),

('rotate-image', 'Rotate Image',
'You are given an n x n 2D matrix representing an image, rotate the image by 90 degrees (clockwise).

You have to rotate the image in-place, which means you have to modify the input 2D matrix directly. DO NOT allocate another 2D matrix and do the rotation.

**Example 1:**
```
Input: matrix = [[1,2,3],[4,5,6],[7,8,9]]
Output: [[7,4,1],[8,5,2],[9,6,3]]
```

**Constraints:**
- n == matrix.length == matrix[i].length
- 1 <= n <= 20
- -1000 <= matrix[i][j] <= 1000',
'MEDIUM', 200, 69, 7450, 5141, NOW() - INTERVAL '100 days',
'Transpose the matrix first|Then reverse each row|Or rotate layer by layer',
'Array,Math,Matrix'),

('group-anagrams', 'Group Anagrams',
'Given an array of strings `strs`, group the anagrams together. You can return the answer in any order.

An Anagram is a word or phrase formed by rearranging the letters of a different word or phrase, typically using all the original letters exactly once.

**Example 1:**
```
Input: strs = ["eat","tea","tan","ate","nat","bat"]
Output: [["bat"],["nat","tan"],["ate","eat","tea"]]
```

**Example 2:**
```
Input: strs = [""]
Output: [[""]]
```

**Constraints:**
- 1 <= strs.length <= 10^4
- 0 <= strs[i].length <= 100
- strs[i] consists of lowercase English letters.',
'MEDIUM', 200, 63, 9120, 5746, NOW() - INTERVAL '95 days',
'Sort each string and use as key|Or use character count as key|Use hash map to group anagrams',
'Array,Hash Table,String,Sorting'),

('coin-change', 'Coin Change',
'You are given an integer array `coins` representing coins of different denominations and an integer `amount` representing a total amount of money.

Return the fewest number of coins that you need to make up that amount. If that amount of money cannot be made up by any combination of the coins, return -1.

You may assume that you have an infinite number of each kind of coin.

**Example 1:**
```
Input: coins = [1,2,5], amount = 11
Output: 3
Explanation: 11 = 5 + 5 + 1
```

**Example 2:**
```
Input: coins = [2], amount = 3
Output: -1
```

**Constraints:**
- 1 <= coins.length <= 12
- 1 <= coins[i] <= 2^31 - 1
- 0 <= amount <= 10^4',
'MEDIUM', 200, 48, 8670, 4162, NOW() - INTERVAL '90 days',
'Use dynamic programming|Build up solution from amount 0 to target|dp[i] = min coins needed for amount i',
'Array,Dynamic Programming,Breadth-First Search'),

('course-schedule', 'Course Schedule',
'There are a total of `numCourses` courses you have to take, labeled from `0` to `numCourses - 1`. You are given an array `prerequisites` where `prerequisites[i] = [ai, bi]` indicates that you must take course `bi` first if you want to take course `ai`.

Return `true` if you can finish all courses. Otherwise, return `false`.

**Example 1:**
```
Input: numCourses = 2, prerequisites = [[1,0]]
Output: true
Explanation: There are 2 courses. To take course 1 you should have finished course 0. So it is possible.
```

**Example 2:**
```
Input: numCourses = 2, prerequisites = [[1,0],[0,1]]
Output: false
Explanation: To take course 1 you need course 0, and to take course 0 you need course 1. So it is impossible.
```

**Constraints:**
- 1 <= numCourses <= 2000
- 0 <= prerequisites.length <= 5000',
'MEDIUM', 200, 51, 7230, 3687, NOW() - INTERVAL '85 days',
'This is cycle detection in directed graph|Use DFS with visited states|Or use topological sort',
'Depth-First Search,Breadth-First Search,Graph,Topological Sort');

-- ============================================================================
-- PROBLEMS - HARD (5 problems)
-- ============================================================================

INSERT INTO problems (slug, title, description, difficulty, base_score, acceptance_rate, total_submissions, successful_submissions, created_at, hints, tags) VALUES
('median-two-sorted-arrays', 'Median of Two Sorted Arrays',
'Given two sorted arrays `nums1` and `nums2` of size m and n respectively, return the median of the two sorted arrays.

The overall run time complexity should be O(log (m+n)).

**Example 1:**
```
Input: nums1 = [1,3], nums2 = [2]
Output: 2.00000
Explanation: merged array = [1,2,3] and median is 2.
```

**Example 2:**
```
Input: nums1 = [1,2], nums2 = [3,4]
Output: 2.50000
Explanation: merged array = [1,2,3,4] and median is (2 + 3) / 2 = 2.5.
```

**Constraints:**
- nums1.length == m
- nums2.length == n
- 0 <= m <= 1000
- 0 <= n <= 1000
- 1 <= m + n <= 2000
- -10^6 <= nums1[i], nums2[i] <= 10^6',
'HARD', 300, 38, 5230, 1987, NOW() - INTERVAL '80 days',
'Use binary search on smaller array|Partition both arrays correctly|Ensure left partition <= right partition',
'Array,Binary Search,Divide and Conquer'),

('trapping-rain-water', 'Trapping Rain Water',
'Given `n` non-negative integers representing an elevation map where the width of each bar is 1, compute how much water it can trap after raining.

**Example 1:**
```
Input: height = [0,1,0,2,1,0,1,3,2,1,2,1]
Output: 6
Explanation: The elevation map is represented by array [0,1,0,2,1,0,1,3,2,1,2,1]. In this case, 6 units of rain water are being trapped.
```

**Example 2:**
```
Input: height = [4,2,0,3,2,5]
Output: 9
```

**Constraints:**
- n == height.length
- 1 <= n <= 2 * 10^4
- 0 <= height[i] <= 10^5',
'HARD', 300, 42, 6120, 2570, NOW() - INTERVAL '75 days',
'Water level at position i is min(max_left, max_right)|Use two pointers or dynamic programming|Or use stack to track boundaries',
'Array,Two Pointers,Dynamic Programming,Stack,Monotonic Stack'),

('merge-k-sorted-lists', 'Merge k Sorted Lists',
'You are given an array of `k` linked-lists `lists`, each linked-list is sorted in ascending order.

Merge all the linked-lists into one sorted linked-list and return it.

**Example 1:**
```
Input: lists = [[1,4,5],[1,3,4],[2,6]]
Output: [1,1,2,3,4,4,5,6]
Explanation: The linked-lists are:
[
  1->4->5,
  1->3->4,
  2->6
]
merging them into one sorted list:
1->1->2->3->4->4->5->6
```

**Constraints:**
- k == lists.length
- 0 <= k <= 10^4
- 0 <= lists[i].length <= 500
- -10^4 <= lists[i][j] <= 10^4',
'HARD', 300, 49, 4890, 2396, NOW() - INTERVAL '70 days',
'Use min heap to track smallest elements|Or merge lists one by one|Or use divide and conquer approach',
'Linked List,Divide and Conquer,Heap (Priority Queue),Merge Sort'),

('word-ladder', 'Word Ladder',
'A transformation sequence from word `beginWord` to word `endWord` using a dictionary `wordList` is a sequence of words `beginWord -> s1 -> s2 -> ... -> sk` such that:

- Every adjacent pair of words differs by a single letter.
- Every si for 1 <= i <= k is in wordList. Note that beginWord does not need to be in wordList.
- sk == endWord

Given two words, beginWord and endWord, and a dictionary wordList, return the number of words in the shortest transformation sequence from beginWord to endWord, or 0 if no such sequence exists.

**Example 1:**
```
Input: beginWord = "hit", endWord = "cog", wordList = ["hot","dot","dog","lot","log","cog"]
Output: 5
Explanation: One shortest transformation sequence is "hit" -> "hot" -> "dot" -> "dog" -> "cog", which is 5 words long.
```

**Constraints:**
- 1 <= beginWord.length <= 10
- endWord.length == beginWord.length
- 1 <= wordList.length <= 5000
- wordList[i].length == beginWord.length',
'HARD', 300, 40, 3670, 1468, NOW() - INTERVAL '65 days',
'Use BFS to find shortest path|Preprocess word list for faster lookup|Try changing each character and check if valid',
'Hash Table,String,Breadth-First Search'),

('lru-cache', 'LRU Cache',
'Design a data structure that follows the constraints of a Least Recently Used (LRU) cache.

Implement the LRUCache class:
- `LRUCache(int capacity)` Initialize the LRU cache with positive size capacity.
- `int get(int key)` Return the value of the key if the key exists, otherwise return -1.
- `void put(int key, int value)` Update the value of the key if the key exists. Otherwise, add the key-value pair to the cache. If the number of keys exceeds the capacity from this operation, evict the least recently used key.

The functions `get` and `put` must each run in O(1) average time complexity.

**Example 1:**
```
Input
["LRUCache", "put", "put", "get", "put", "get", "put", "get", "get", "get"]
[[2], [1, 1], [2, 2], [1], [3, 3], [2], [4, 4], [1], [3], [4]]
Output
[null, null, null, 1, null, -1, null, -1, 3, 4]
```

**Constraints:**
- 1 <= capacity <= 3000
- 0 <= key <= 10^4
- 0 <= value <= 10^5
- At most 2 * 10^5 calls will be made to get and put.',
'HARD', 300, 44, 5670, 2495, NOW() - INTERVAL '60 days',
'Use hash map + doubly linked list|Hash map provides O(1) lookup|Doubly linked list maintains LRU order',
'Hash Table,Linked List,Design,Doubly-Linked List');

-- ============================================================================
-- CONTESTS (2 contests)
-- ============================================================================

INSERT INTO contests (slug, title, description, start_time, end_time, duration_minutes, status, max_participants, current_participants, created_at) VALUES
('weekly-contest-320', 'Weekly Contest 320',
'Join our weekly coding contest! Test your skills against other programmers. Top performers earn rating points and climb the leaderboard.',
NOW() + INTERVAL '2 days', NOW() + INTERVAL '2 days 90 minutes', 90, 'UPCOMING', 1000, 0, NOW() - INTERVAL '7 days'),

('biweekly-contest-95', 'Biweekly Contest 95',
'Biweekly algorithmic challenge featuring medium to hard problems. Great practice for technical interviews!',
NOW() - INTERVAL '30 minutes', NOW() + INTERVAL '60 minutes', 90, 'LIVE', 1000, 247, NOW() - INTERVAL '14 days');

-- ============================================================================
-- SUBMISSIONS (10 sample submissions)
-- ============================================================================

INSERT INTO submissions (user_id, problem_id, code, language, status, execution_time_ms, memory_used_kb, score_awarded, submitted_at) VALUES
-- Alice's submissions (high performer)
(2, 1, 'class Solution { public int[] twoSum(int[] nums, int target) { Map<Integer, Integer> map = new HashMap<>(); for(int i = 0; i < nums.length; i++) { int complement = target - nums[i]; if(map.containsKey(complement)) return new int[]{map.get(complement), i}; map.put(nums[i], i); } return new int[]{}; } }', 'JAVA', 'ACCEPTED', 45, 2048, 100, NOW() - INTERVAL '5 days'),
(2, 3, 'class Solution { public boolean isValid(String s) { Stack<Character> stack = new Stack<>(); for(char c : s.toCharArray()) { if(c == ''('') stack.push('')''); else if(c == ''{'') stack.push(''}''); else if(c == ''['') stack.push('']''); else if(stack.isEmpty() || stack.pop() != c) return false; } return stack.isEmpty(); } }', 'JAVA', 'ACCEPTED', 32, 1536, 100, NOW() - INTERVAL '4 days'),
(2, 11, 'def threeSum(nums): nums.sort(); result = []; for i in range(len(nums)-2): if i > 0 and nums[i] == nums[i-1]: continue; l, r = i+1, len(nums)-1; while l < r: s = nums[i] + nums[l] + nums[r]; if s < 0: l += 1; elif s > 0: r -= 1; else: result.append([nums[i], nums[l], nums[r]]); while l < r and nums[l] == nums[l+1]: l += 1; while l < r and nums[r] == nums[r-1]: r -= 1; l += 1; r -= 1; return result', 'PYTHON', 'ACCEPTED', 156, 4096, 200, NOW() - INTERVAL '3 days'),

-- Bob's submissions (moderate performer)
(3, 1, 'class Solution { public int[] twoSum(int[] nums, int target) { for(int i = 0; i < nums.length; i++) { for(int j = i+1; j < nums.length; j++) { if(nums[i] + nums[j] == target) return new int[]{i, j}; } } return new int[]{}; } }', 'JAVA', 'TIME_LIMIT_EXCEEDED', 0, 0, 0, NOW() - INTERVAL '6 days'),
(3, 1, 'class Solution { public int[] twoSum(int[] nums, int target) { Map<Integer, Integer> map = new HashMap<>(); for(int i = 0; i < nums.length; i++) { int complement = target - nums[i]; if(map.containsKey(complement)) return new int[]{map.get(complement), i}; map.put(nums[i], i); } return new int[]{}; } }', 'JAVA', 'ACCEPTED', 52, 2304, 100, NOW() - INTERVAL '6 days'),
(3, 2, 'def reverseString(s): left, right = 0, len(s) - 1; while left < right: s[left], s[right] = s[right], s[left]; left += 1; right -= 1', 'PYTHON', 'ACCEPTED', 28, 1024, 100, NOW() - INTERVAL '5 days'),

-- Charlie's submissions (beginner)
(4, 1, 'class Solution { public int[] twoSum(int[] nums, int target) { return new int[]{0, 1}; } }', 'JAVA', 'WRONG_ANSWER', 12, 512, 0, NOW() - INTERVAL '7 days'),
(4, 2, 'def reverseString(s): s.reverse()', 'PYTHON', 'COMPILATION_ERROR', 0, 0, 0, NOW() - INTERVAL '7 days'),
(4, 2, 'def reverseString(s): s[:] = s[::-1]', 'PYTHON', 'ACCEPTED', 35, 1280, 100, NOW() - INTERVAL '6 days'),

-- Dave's recent submission
(5, 1, 'function twoSum(nums, target) { const map = {}; for(let i = 0; i < nums.length; i++) { const complement = target - nums[i]; if(complement in map) return [map[complement], i]; map[nums[i]] = i; } return []; }', 'JAVASCRIPT', 'ACCEPTED', 67, 3072, 100, NOW() - INTERVAL '2 days');

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================
-- Uncomment these to verify data after seeding

-- SELECT 'Users:' as table_name, COUNT(*) as count FROM users
-- UNION ALL
-- SELECT 'Problems:', COUNT(*) FROM problems
-- UNION ALL
-- SELECT 'Contests:', COUNT(*) FROM contests
-- UNION ALL
-- SELECT 'Submissions:', COUNT(*) FROM submissions;

-- SELECT username, email, rating, problems_solved, role FROM users ORDER BY rating DESC;
-- SELECT title, difficulty, acceptance_rate, total_submissions FROM problems ORDER BY difficulty, created_at;

COMMIT;