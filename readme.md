# My 2-Month "Why-Driven" DevOps Plan

The goal is not to "learn DevOps tools." The goal is to **achieve full automation** for a real project.

The "why" is to solve the pain of manual, repetitive, and error-prone work. I will stop "studying" Docker, CI/CD, and Monitoring and start *using* them to build a hands-free pipeline for my Next.js application.

---

> ## Phase 1: The "Why am I doing this by hand?" Weeks (Weeks 1-2)
>
> **Focus:** Continuous Integration (CI) and Git.
>
> **The "Why":** Why am I *manually* running `npm test` and `npm run build` on my machine every time I want to push? What if I forget? What if my tests pass but my build is broken?
>
> **Your Project:** **"The Automatic Sentry" (GitHub Actions for CI).**
>
> ### Week 1 Focus: Feeling the Pain & The First "Why"
>
> 1.  **The Manual Pain:** On your Next.js project, get in the habit of *manually* running your linter (`npm run lint`) and tests (`npm test`) *every single time* before you `git push`.
> 2.  **Forget on Purpose:** Make a small text change, *don't* run the tests, and `git push`. Realize there's no "gate" protecting your `main` branch. This is the "why."
>
> ### Week 2 Focus: Building the Sentry (CI)
>
> 1.  **Problem 1: Automate the Linter & Tests.**
>     * In your Next.js repo, create a `.github/workflows/ci.yml` file.
>     * Write a basic GitHub Action that triggers `on: push`.
>     * This action must check out your code, install Node.js, run `npm install`, and finally run `npm run lint` and `npm test`.
> 2.  **Problem 2: The "Broken Build" Gate.**
>     * Add a step to your `ci.yml`: `npm run build`.
>     * Now, make a change that *breaks the build* (e.g., import a file that doesn't exist). Push it.
>     * Watch the GitHub Action **fail**. It will show a red "X."
>     * **You've just discovered Continuous Integration.** You created an automated gate that protects your code, and it didn't cost you a "study" session—it solved a real problem.

---

## Phase 2: The "Why does it work on my machine?" Weeks (Weeks 3-4)

**Focus:** Containerization (Docker).

**The "Why":** Why did my `npm run build` work on my Ubuntu machine, but fail on the GitHub Actions server (or vice-versa)? Why will my app crash on a server that has the wrong Node.js version?

**Your Project:** **"The Magic Box" (Dockerizing the Next.js App).**

1.  **Problem 1: The "Wrong Version" Hell.**
    * Build and run your Next.js app locally. Now, imagine your server has a different Node.js version (e.g., v16 vs. v18). The app would crash. This is the "why" for Docker.
2.  **Problem 2: Build the Box (`Dockerfile`).**
    * Create a `Dockerfile` in the root of your Next.js project.
    * Use a multi-stage build:
        * Stage 1 (`builder`): Use a `node:18-alpine` image, copy `package.json`, run `npm install`, copy your source code, and run `npm run build`.
        * Stage 2 (`runner`): Use a minimal `node:18-alpine` image, copy the `.next` folder and `package.json` from the `builder` stage, and run a *production-only* `npm install`.
    * The `CMD` will be `["npm", "start"]`.
3.  **Problem 3: The "It Works Everywhere" Moment.**
    * Build your image: `docker build -t my-portfolio .`
    * Run your image: `docker run -p 3000:3000 my-portfolio`
    * **You've just discovered Containerization.** You now have a *single, self-contained file* that includes your app, your `node_modules`, and the correct Node.js version. It will run *identically* on your machine, your friend's Mac, or a Google Cloud server.

---

## Phase 3: The "Why am I dragging files to a server?" Weeks (Weeks 5-6)

**Focus:** Continuous Deployment (CD) & Artifact Registry.

**The "Why":** Why am I building a Docker image just to... what? SSH into a server and manually `docker pull` it? That's still manual.

**Your Project:** **"The Push-Button Deployment" (GitHub Actions for CD).**

1.  **Problem 1: Where do Docker images live?**
    * You can't `push` a Docker image to GitHub. You need an "image registry."
    * Go to your Google Cloud project and enable **Artifact Registry**. Create a new Docker repository.
2.  **Problem 2: Automate the "Build & Push."**
    * Update your `ci.yml` (or create a new `cd.yml`).
    * After the "test" and "build" steps, add steps to:
        * Authenticate to Google Cloud (using a Service Account).
        * Build the Docker image (using the `Dockerfile` you just wrote).
        * **Tag** the image with the registry's URL (e.g., `us-central1-docker.pkg.dev/YOUR-PROJECT/...).`
        * **Push** the image to your Artifact Registry.
3.  **Problem 3: The "One-Click" Deploy (Semi-Auto).**
    * Go to **Google Cloud Run**.
    * Click "Create Service."
    * Select "Deploy new revision from an existing container image" and find the image you just pushed to Artifact Registry.
    * Click "Deploy." Your app is now live on the internet.
4.  **Problem 4: The "Zero-Click" Deploy (Full-Auto).**
    * Now, automate that last click.
    * Add a final step to your GitHub Action. Use the `gcloud run deploy` command.
    * This command tells Cloud Run: "Hey, there's a new image in the registry. Go fetch it and deploy it."
    * **You've just discovered Continuous Deployment.** Now, when you `git push`, GitHub will test your code, build your Docker image, push it to the registry, and deploy it to Cloud Run... all while you're getting coffee.

---

## Phase 4: The "Is it on fire?" Weeks (Weeks 7-8)

**Focus:** Logging, Monitoring, and Resilience (Your Stated Goal).

**The "Why":** My app is deployed, but... is it working? Is it slow? What are my users seeing? What happens if it crashes?

**Your Project:** **"The Dashboard and The Bouncer."**

1.  **Problem 1: "My app is down!" (Resilience).**
    * **This is the "why" for Cloud Run.** It's "serverless." If your container crashes (e.g., an unhandled exception), Cloud Run *automatically restarts it*. You don't have to do anything.
    * It also **auto-scales**. If 1,000 users visit, it scales up to multiple containers. When they leave, it scales back down to zero (or one). This is resilience and efficiency *by default*.
2.  **Problem 2: "I can't see my `console.log`s!" (Logging).**
    * In your Next.js app, add a log line to an API route: `console.log("INFO: User requested /api/hello");`
    * Deploy this change (just `git push`!).
    * Go to the **Google Cloud Run** dashboard for your service. Click the **"Logs"** tab.
    * You will see your log message, live, without ever SSH-ing into a server.
    * **This is the "why" for Centralized Logging.**
3.  **Problem 3: "Is it slow? Is it erroring?" (Monitoring).**
    * Go to the **"Metrics"** tab in Cloud Run.
    * You will *immediately* see graphs for:
        * Request Count
        * Request Latency (how fast your app is)
        * Container CPU and Memory
        * **Error Rate (5xx errors)**
    * **This is the "why" for Monitoring.** You have a dashboard *for free* telling you the health of your service.
4.  **Problem 4: The "Wake me up" Alert (Quality Check).**
    * Go to the **Google Cloud Monitoring** section.
    * Create an **Alerting Policy**.
    * Set the policy: "IF the **5xx Error Rate** for my Cloud Run service (`my-portfolio`) is **above 1%** for **5 minutes**, THEN send me an email."
    * **You've just achieved your goal.** You now have an automated system that deploys your app, verifies it's healthy, and *notifies you* if it breaks in production.

---

## How to Not Break the Cycle

1.  **One Tool at a Time.** Don't try to learn Docker, Kubernetes, and Terraform all at once. Your plan is: 1) GitHub Actions -> 2) Docker -> 3) Cloud Run. That's it.
2.  **Stick to One Project.** Use your portfolio for this. Don't get distracted by a new "perfect" project. The goal is the *pipeline*, not the app.
3.  **Read Docs, Not Tutorials.** When you get stuck, go to the official GitHub Actions, Docker, or Google Cloud docs first. Tutorials get outdated. The "Why" is in the official documentation.
