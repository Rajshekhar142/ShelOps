# Automation Week 1: The Local Gatekeeper 🛡️

## Goal

The goal of this week is to **build an automated local gatekeeper** that stops broken code (linting errors, failing tests) from *ever leaving your machine*. We'll learn why automation is crucial by first feeling the pain of doing things manually.

## The "Why" (The Problem)

Relying on human memory to run checks like `npm run lint` and `npm run test` before every commit is a guaranteed way to fail. We will inevitably forget, and broken code will end up in our `main` branch. We need an automated process to act as a gatekeeper.

## The Plan & Tools

This week, we'll install and configure a few small tools to create a powerful **pre-commit hook**. A pre-commit hook is a script that Git automatically runs *before* it finalizes a commit.

* **Tools:** `husky`, `lint-staged`
* **The Process:**
    1.  **Days 1-2: Feel the Pain:** Intentionally commit broken code to understand *why* we need a gate.
    2.  **Days 3-4: Build the Gate:** Install **`husky`** to easily manage our Git hooks. We'll create a `pre-commit` hook that blocks any commit if `npm run lint` fails.
    3.  **Days 5-6: Optimize the Gate:** The new pain: linting the *entire* project on every commit is slow. We'll install **`lint-staged`** to run our scripts *only* on the files we're trying to commit.
    4.  **Day 7: Reflect:** Appreciate our fast, automated local gate and identify its one weakness (it can be bypassed), which leads us to Week 2.

---

## Final Setup & Code

Here are the commands and configurations you'll have by the end of the week.

### 1. Install Tools

```bash
# Install husky (for Git hooks)
npm install husky --save-dev

# Install lint-staged (for running on staged files)
npm install lint-staged --save-dev
