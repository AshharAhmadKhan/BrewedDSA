BrewAlgo
BrewAlgo is a competitive programming platform built to explore backend system design, Docker-based isolation, and the challenges of safely executing untrusted code.

The project focuses on correctness, isolation, and architectural clarity rather than scale, and serves as a hands-on study of how real-world online judges are designed.

The system follows Clean Architecture, supports multiple languages, and evaluates submissions against test cases in real time.

Core Capabilities
Code Execution
Docker-isolated execution with enforced CPU and memory limits

Multi-language support (Java, Python) via an extensible executor design

Real-time compilation and runtime feedback

Multiple test cases per submission, including hidden tests

Verdict classification:

ACCEPTED

WRONG_ANSWER

COMPILATION_ERROR

RUNTIME_ERROR

TIME_LIMIT_EXCEEDED

Platform Features
JWT-based authentication and session handling

Global leaderboard and user rating system

Personal submission history and statistics

Contest system framework (extensible, not fully implemented)

Architecture & Design
BrewAlgo follows Clean Architecture principles to keep business logic independent of frameworks and external systems.

Layered Structure
Presentation — REST controllers, request/response DTOs

Application — use cases, orchestration, business rules

Domain — entities, value objects, core logic (no framework dependencies)

Infrastructure — persistence, security, Docker execution, external integrations

The domain layer contains zero Spring dependencies, ensuring framework independence and testability.

Security & Isolation Model
All user code executes inside short-lived Docker containers

Containers are configured with:

CPU and memory limits

No external network access

Dropped Linux capabilities

Containers are destroyed after execution to prevent state leakage

This setup mitigates common abuse vectors but is not intended to be a production-grade sandbox. The project prioritizes learning and correctness over hardened isolation.

System Overview
Plaintext
┌─────────────────────────────────────────────────────────────────┐
│                         FRONTEND (React)                        │
│  - Problem Browser      - Code Editor      - Leaderboard        │
└────────────────────────────┬────────────────────────────────────┘
                             │ REST API (JWT)
┌────────────────────────────▼────────────────────────────────────┐
│                    BACKEND (Spring Boot 3.2)                    │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Presentation Layer  - Controllers, DTOs                 │   │
│  ├──────────────────────────────────────────────────────────┤   │
│  │  Application Layer   - Use Cases, Services               │   │
│  ├──────────────────────────────────────────────────────────┤   │
│  │  Domain Layer        - Entities, Value Objects           │   │
│  ├──────────────────────────────────────────────────────────┤   │
│  │  Infrastructure      - JPA, Security, Docker SDK         │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────────┬─────────────────────────────┬──────────────────────┘
             │                             │
             │ JDBC                        │ Docker Java SDK
             ▼                             ▼
┌─────────────────────┐      ┌──────────────────────────────────┐
│     PostgreSQL DB   │      │       Docker Engine              │
│  - Users            │      │  ┌────────────────────────────┐  │
│  - Problems         │      │  │ Isolated Container         │  │
│  - Submissions      │      │  │ - JDK 17 / Python 3.11     │  │
│  - Test Cases       │      │  │ - Resource Limits          │  │
└─────────────────────┘      │  │ - Execution Timeout        │  │
                             │  └────────────────────────────┘  │
                             └──────────────────────────────────┘
Execution Flow
Submission is persisted to the database.

Language-specific executor is selected based on the submission metadata.

Docker container is created with enforced resource limits (CPU/Memory).

Code is compiled inside the isolated container (for compiled languages).

Test cases are executed sequentially against the binary or script.

Stdout and stderr are captured asynchronously via a custom result callback.

Verdict is computed by comparing captured output with expected results.

Container is destroyed immediately to prevent side effects or state leakage.

Each submission currently uses a fresh container to prioritize isolation correctness over throughput.

Tech Stack
Backend
Java 17

Spring Boot 3.2.1

Spring Security, Spring Data JPA

PostgreSQL

Docker Java SDK 3.4.0

JWT (jjwt)

Frontend
React 18

Vite

Tailwind CSS

Tooling
Docker

Maven

Git

Getting Started
Prerequisites
Java 17+

Node.js 18+

PostgreSQL

Docker

Maven

Run Locally
Bash
git clone https://github.com/AshharAhmadKhan/BrewAlgo.git
cd BrewAlgo/backend
mvn spring-boot:run
Key Engineering Challenges
Docker Dependency Resolution
Problem: Encountered NoClassDefFoundError: HttpVersionPolicy during container initialization.

Cause: Version mismatch between Spring Boot–managed httpcore5 and docker-java.

Resolution: Upgraded Docker Java SDK to 3.4.0 and explicitly enforced httpcore5:5.3.1 via Maven dependency management.

Output Capture
Implemented a custom ResultCallback.Adapter<Frame> to reliably capture and aggregate container stdout and stderr, preventing data loss during asynchronous execution between the daemon and the application.

Limitations & Future Work
Docker cold-start latency impacts submission response time.

No horizontal scaling or worker pool yet (sequential processing).

Output comparison is strict (no custom checkers/special judges).

Planned Improvements:

Executor pooling for higher throughput.

Custom judge support for problems with multiple valid solutions.

Async submission processing with WebSockets for real-time updates.

Further sandbox hardening (seccomp profiles).

What I Learned
Designing and documenting REST APIs before implementation.

Managing Docker container lifecycles safely from a Java environment.

Balancing execution correctness with performance trade-offs.

Applying Clean Architecture in a real-world backend system.

Debugging complex dependency conflicts in production-like setups.

Author
Ashhar Ahmad Khan BTech Computer Science Student (3rd Year) | Backend-Focused Developer

Email: itzashhar@gmail.com

GitHub: https://github.com/AshharAhmadKhan

LinkedIn: https://www.linkedin.com/in/ashhar-ahmad-khan
