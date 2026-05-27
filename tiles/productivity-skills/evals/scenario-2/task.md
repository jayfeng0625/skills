# Environment Variable Validation Skill

## Problem/Feature Description

A platform engineering team maintains dozens of services, each with its own `.env` configuration file. Developers frequently deploy broken services because they forgot to set a required variable, used the wrong format for a URL, or left a placeholder value like `YOUR_API_KEY_HERE` in production. These mistakes waste hours of debugging.

The team wants an agent skill that can help validate environment configuration files before deployment. The validation rules are the same every time: required keys must be present, certain values must match specific formats (URLs, email addresses, integers in a valid range), and no placeholder values should remain. Because these checks are mechanical and identical on every run, they should not rely on the agent generating new code each time — the checks should be reliable and consistent.

Build a skill that helps developers catch configuration problems early. The skill should be useful for new services being set up for the first time as well as for routine validation before releases.

## Output Specification

Create the skill under `env-validator/`. Include everything needed for a working skill, including any automation components the design warrants.

Write a brief `approach.md` documenting what you built and the reasoning behind each component you included or excluded.
