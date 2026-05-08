---
layout:     post
title:      "LeetCodeReview"
subtitle:   " \"学死我\""
date:       2026-5-5 00:47:24
author:     "HZY"
header-img: ""
catalog: true
tags:
    - Algorithm
---

#### LIS 和 Kadane
* LIS
  * 这道题目主要是  https://leetcode.cn/problems/longest-increasing-subsequence?envType=study-plan-v2&envId=top-100-liked
  * 300 最长递增子序列
  * 法一就是通过dp动态规划去做
  * 法二：通过贪心+二分实现 nlogn

  ``` java
    class Solution {
        public int lengthOfLIS(int[] nums) {
            if(nums == null || nums.length == 0) return 0;
            int[] g = new int[nums.length];
            int size = 0 ;

            for(int c: nums){
                int i = Arrays.binarySearch(g,0,size,c);
                if(i<0){
                    i = -(i+1);
                }
                g[i] = c;
                if(i == size){
                    size++;
                }
            }

            return size;
        }
    }
  ```


* Kadane
    * https://leetcode.cn/problems/maximum-product-subarray?envType=study-plan-v2&envId=top-100-liked
    * 这个和上面的题目不一样的点在于，需要需要子序列或者子串连续
    * 需要连续的话我们就使用 Kadane 算法
    * 使用O(1)的空间解决问题

    ``` java
    class Solution {
        public int maxProduct(int[] nums) {
            int max = Integer.MIN_VALUE, imax = 1, imin = 1;
            for(int i = 0;i<nums.length;i++){
                
                if(nums[i]<0){
                    int temp = imax;
                    imax = imin;
                    imin = temp;
                }

                imax = Math.max(nums[i],imax*nums[i]);
                imin = Math.min(nums[i],imin*nums[i]);

                max = Math.max(max,imax);
            }
            return max;
        }
    }
 
    ``` 