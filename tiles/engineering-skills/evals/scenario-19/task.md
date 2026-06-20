I have a design question about rate limiting my API: should I use a sliding window or a token bucket? I need to handle burst traffic up to 10x the sustained rate, and I want to understand how the two strategies actually behave differently at the burst boundary before I commit to one.

Can you prototype both approaches so I can see the difference in behaviour? This is throwaway exploration — I just need to answer the question, not production code.
