# Talk Outline: "Why Your Microservices Are Making You Slower"

**Conference:** DevOps Days Regional
**Slot:** 30 minutes
**Audience:** Mid-level engineers and team leads at companies that have adopted or are considering microservices

---

## Narrative Arc

Start with a provocative claim: most teams that switch to microservices end up slower, not faster. Walk through why that happens. End with a framework for knowing when microservices actually help.

## Sections

### 1. Hook (3 min)
Story: a team I know spent 8 months migrating to microservices and their deploy frequency went down by 60%.

### 2. The Promise vs Reality (5 min)
- What we were promised: independent deployments, team autonomy, scale
- What many teams got: distributed monolith, coordination overhead, debugging nightmares

### 3. Root Causes (10 min)
- Tight coupling persists through API contracts
- Shared databases (haven't really decomposed)
- Too many services too fast

### 4. The Framework (8 min)
A decision rubric: when microservices help vs when a modular monolith wins

### 5. Takeaways (4 min)
Three questions to ask before splitting a service

---

## Concerns

I'm not sure if the hook is too negative for a conference audience. The framework section feels vague — I don't have a crisp way to present the rubric yet. I also don't know if 30 minutes is enough for all of this.
