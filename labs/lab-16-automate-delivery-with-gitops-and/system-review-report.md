# Lab 16 — System Review Report (LO5)

A system review closes the cloud native loop: read the observability data against the
SLOs, decide what must change, and adapt the architecture. This report is the evidence
for LO5 — *implement system reviews to monitor solution status and adapt according to
Cloud Native frameworks*.

**Review period:** last 30 days
**Reviewed by:** ______________________  **Date:** ______________
**Data sources:** `slo-targets.csv`, Prometheus (Labs 12–13), `kubectl` cluster state

---

## 1. Solution status against the SLOs

Fill this in from `slo-targets.csv`. Sort worst-first: the breaches are the agenda.

| Service | Metric | Target | Actual | Budget consumed | Status |
|---|---|---|---|---|---|
| | | | | | |
| | | | | | |
| | | | | | |

**Services meeting every SLO:** ______ of ______

## 2. Breaches — root cause and evidence

For each breached SLO, state what the telemetry actually shows.

### Breach 1: ____________________
- **Symptom users experienced:**
- **Evidence (metric / query / dashboard):**
- **Probable cause:**
- **Which golden signal detected it:**

### Breach 2: ____________________
- **Symptom users experienced:**
- **Evidence:**
- **Probable cause:**
- **Which golden signal detected it:**

### Breach 3: ____________________
- **Symptom users experienced:**
- **Evidence:**
- **Probable cause:**
- **Which golden signal detected it:**

## 3. Adaptations — what changes, and why

At least three, each traceable to evidence above and to a mechanism from this course.

| # | Adaptation | Which breach it addresses | Mechanism (topic/lab) | Expected effect | How you will verify |
|---|---|---|---|---|---|
| 1 | | | | | |
| 2 | | | | | |
| 3 | | | | | |

## 4. Architecture-management decisions

1. `notification-worker` has consumed 100% of its error budget on queue lag.
   Which autoscaling mechanism from Topic 3 fits an event-driven worker, and why is
   a CPU-based HPA the wrong tool here?
2. `checkout-api` meets availability but breaches p95 latency. Explain why availability
   alone is a misleading health signal.
3. `search-api` had 4 incidents and breached availability. What would you change about
   its **release process** (Topic 5), not just its runtime configuration?
4. Which adaptation would you implement FIRST, and what is your justification?

## 5. Review cadence and next steps

| Question | Answer |
|---|---|
| How often should this review run? | |
| Who owns each adaptation? | |
| What triggers an out-of-cycle review? | |
| Date of next review | |

## 6. Sign-off

- [ ] All breached SLOs have an owner and an adaptation
- [ ] Each adaptation names the evidence that justifies it
- [ ] Verification method defined for every adaptation
- [ ] Next review scheduled
