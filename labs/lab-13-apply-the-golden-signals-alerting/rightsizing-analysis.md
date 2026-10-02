# Lab 13 — Costed Right-Sizing Recommendation

Cost management is an observability problem: over-provisioning is visible in exactly
the same metrics you already collect. Use `cost-report.csv` and `kubectl top`.

## Step 1 — Compute utilisation for every namespace

Utilisation = used / requested. Anything below ~40% is over-provisioned.

| Namespace | CPU requested | CPU used | CPU utilisation | Mem utilisation | Monthly cost |
|---|---|---|---|---|---|
| production | 32.0 | 24.6 | | | $8,640 |
| staging | 16.0 | 3.2 | | | $4,320 |
| data-pipeline | 24.0 | 19.8 | | | $6,480 |
| ml-training | 48.0 | 7.1 | | | $12,960 |
| internal-tools | 8.0 | 2.4 | | | $2,160 |
| kcna-lab | 4.0 | 1.1 | | | $1,080 |

## Step 2 — Identify the two worst offenders

| Rank | Namespace | CPU utilisation | Why it is wasteful |
|---|---|---|---|
| 1 | | | |
| 2 | | | |

## Step 3 — Recommend, with the saving attached

| Namespace | Change recommended | New request | Est. monthly saving | Risk | Mitigation |
|---|---|---|---|---|---|
| | | | | | |
| | | | | | |

**Total estimated monthly saving: $__________**

## Step 4 — Justify it to the business

1. Which namespace is the *most* efficient? What is it doing right that others are not?
2. `ml-training` runs bursty jobs. Why is a permanently-sized cluster the wrong shape,
   and which two mechanisms from Topic 3 would fix it?
3. What is the RISK of right-sizing purely on average utilisation? Which metric would
   you check as well before cutting a request?
4. Which of these changes would you make first, and why that one?
