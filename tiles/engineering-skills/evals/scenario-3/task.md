# TDD Plan for User Authentication

## Problem/Feature Description

A startup is adding username/password authentication to their web API. The feature needs: user registration (with email and password), login (returning a session token), and a way to check if a session is still valid. The team wants to use test-driven development, but before writing any code they need a detailed TDD plan.

You are the senior engineer asked to produce the planning artifact. The plan should be good enough that a junior developer can pick it up and execute the TDD cycles without further guidance. No code should be written yet — just the plan.

The codebase is a Node.js REST API. There is no existing authentication module. The team's domain language uses "Member" for registered users and "Session" for an authenticated context.

## Output Specification

Produce a file called `tdd-plan.md` containing:

1. A list of behaviors to test (user-facing, not implementation steps)
2. The proposed public interface for the authentication module (method signatures and what they return)
3. Identification of any interface design decisions made to improve testability
4. Identification of opportunities for deep modules (where a small public interface can hide complex implementation)
5. The proposed order of RED→GREEN cycles, from simplest to most complex
6. Any questions that should be confirmed with the team before starting
