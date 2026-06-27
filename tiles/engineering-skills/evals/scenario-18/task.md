There is a merge conflict in `inputs/payment-service.ts`. Two branches modified the same function in different, valid ways: one added structured error handling so callers can distinguish retryable failures from hard declines, and the other extended the return type to include the settled amount and currency for multi-currency support.

Resolve the conflict correctly. Before writing the resolution, explain what each branch was trying to accomplish and why both changes matter. Then produce the merged version of the file that satisfies both intents without introducing new bugs.
