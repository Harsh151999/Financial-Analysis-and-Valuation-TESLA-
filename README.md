# Tesla Financial Analysis and Valuation

A financial analytics portfolio project using **Python, SQL, and Excel** to examine Tesla's historical performance and explore assumption-driven valuation scenarios.

The project combines revenue and profitability analysis, cash-flow analysis, regulatory-credit adjustments, peer comparisons, discounted cash flow (DCF), and sensitivity analysis.

> **Scope:** Historical data covers **2012–2020**. Forecasts and technology estimates are illustrative inputs transcribed from a supplied report and have not been independently reconciled to original filings. Valuation outputs are scenario calculations, not current market estimates.

## Business questions

- How did revenue, profitability, and cash generation change between 2012 and 2020?
- How much does regulatory-credit revenue contribute to reported operating income?
- How do growth, operating margins, capital expenditure, and discount rates affect valuation?
- How sensitive is the DCF to WACC and terminal growth?
- What assumptions would support additional value from software and autonomy?

## Key findings

Results below use the repository's supplied data and default assumptions.

| Metric | Calculated result |
| --- | ---: |
| Revenue, 2012 | $413.26 million |
| Revenue, 2020 | $31,536 million |
| Revenue CAGR, 2012–2020 | 71.92% |
| Free cash flow, 2020 | $2,786 million |
| Operating income, 2020 | $1,994 million |
| Operating income less regulatory-credit revenue, 2020 | $414 million |
| Baseline DCF value per share: tapered CapEx | $51.77 |
| Bear-case DCF value per share | $19.35 |
| Baseline DCF value per share: flat 7.5% CapEx | $48.37 |
| Terminal value as a share of baseline enterprise value | 74.63% |

The regulatory-credit adjustment holds all costs constant and subtracts credit revenue from operating income. It is not a restated GAAP measure.

Terminal value accounts for most of the baseline enterprise value, making long-run assumptions particularly influential. The two baseline CapEx interpretations also produce different per-share values.

## Repository contents

| File | Purpose |
| --- | --- |
| [Tesla_Financial_Analysis.ipynb](Tesla_Financial_Analysis.ipynb) | Embedded historical data, calculations, visualizations, DCF scenarios, sensitivity analysis, checks, and optional exports |
| [Tesla_Financial_Analysis.sql](Tesla_Financial_Analysis.sql) | SQLite tables, derived metrics, reconciliation queries, and reproducible DCF calculations |
| [Tesla_Financial_Analysis.xlsx](Tesla_Financial_Analysis.xlsx) | Excel model with Summary, Assumptions, DCF, Historical, Reference, and Source worksheets |
| [Tesla_Tableau_Guide.md](Tesla_Tableau_Guide.md) | Dashboard documentation and intended controls |
| [LICENSE](LICENSE) | Repository license |

**Tableau delivery status:** The guide references a packaged dashboard and PNG preview, but these files are not currently included in this repository. No published dashboard link is provided.

## Tools and techniques

- **Python:** pandas, NumPy, Matplotlib, IPython, and Jinja2.
- **SQL:** SQLite tables and views, window functions, recursive CTEs, aggregations, and validation queries.
- **Excel:** Linked assumptions, formula-driven forecasts, valuation summaries, and source reconciliation.
- **Financial analysis:** CAGR, margins, free cash flow, regulatory-credit adjustments, peer multiples, DCF, and scenario analysis.

## Methodology

### Historical analysis

The notebook embeds nine annual observations for 2012–2020. It preserves original inputs and calculates derived metrics separately.

- Revenue growth and CAGR use chronological observations and elapsed years.
- Gross, operating, and net margins use revenue as the denominator.
- Historical free cash flow equals operating cash flow less capital expenditure.
- Regulatory credits are treated as part of automotive revenue and are not added again to total revenue.
- Reconciliation checks identify inconsistencies without inserting balancing amounts.

### DCF valuation

The model projects five relative forecast years:

1. Forecast revenue using annual growth assumptions.
2. Calculate EBIT using operating-margin assumptions.
3. Apply cash taxes to positive EBIT.
4. Add depreciation and amortization.
5. Deduct capital expenditure and changes in net working capital.
6. Discount unlevered free cash flow and terminal value.
7. Add cash, subtract debt, and divide equity value by diluted shares.

```text
UFCF = EBIT − Cash taxes + D&A − CapEx − Change in NWC
Terminal value = Year 5 UFCF × (1 + g) / (WACC − g)
Equity value = PV of forecast UFCF + PV of terminal value + Cash − Debt
Value per share = Equity value / Diluted shares
```

Explicit cash flows use mid-year discounting. Terminal value is discounted from the end of Year 5.

| Shared input | Default assumption |
| --- | ---: |
| WACC | 11.45% |
| Cash tax rate | 21.00% |
| D&A / revenue | 4.80% |
| NWC / change in revenue | 3.00% |
| Cash and investments | $33,650 million |
| Debt | $5,750 million |
| Diluted shares | 3,180 million |

The baseline uses a CapEx-to-revenue taper from 7.50% to 6.75%. A separate case holds CapEx at 7.50%. The bear case uses lower growth and operating-margin assumptions.

### Sensitivity and software analysis

The notebook includes:

- A WACC versus terminal-growth sensitivity grid.
- Software adoption versus monthly revenue per subscriber scenarios.
- Illustrative compute-cost allocations and hardware-cost ranges.

Software value uses an assumed **10.44× EV / Year 5 UFCF multiplier** and **52% cash-flow conversion**. It is an exploratory extension. A complete sum-of-the-parts valuation would need to remove any software cash flows already included in the baseline.

## Getting started

### Python notebook

Clone the repository and enter its folder:

```bash
git clone https://github.com/Harsh151999/Financial-Analysis-and-Valuation-TESLA-.git
cd Financial-Analysis-and-Valuation-TESLA-
```

Create and activate a virtual environment:

```bash
python -m venv .venv
```

On macOS or Linux:

```bash
source .venv/bin/activate
```

On Windows PowerShell:

```powershell
.venv\Scripts\Activate.ps1
```

Install dependencies and launch JupyterLab:

```bash
python -m pip install numpy pandas matplotlib ipython jinja2 jupyterlab
jupyter lab Tesla_Financial_Analysis.ipynb
```

Run the cells in order. Edit the assumptions and rerun subsequent cells to explore scenarios.

Set `EXPORT_RESULTS = True` in the final export cell to generate CSV tables and PNG charts in `tesla_notebook_outputs/`. Exports are disabled by default.

The notebook contains its input data and requires no API keys. Package versions are not currently pinned.

### SQL model

Use **SQLite 3.35 or later with math functions enabled**, including `POWER`.

Run the script against a new database:

```bash
sqlite3 tesla_analysis.db < Tesla_Financial_Analysis.sql
```

The script creates `tesla_*` tables and views and runs analysis queries. Rerunning it against the same populated database intentionally fails instead of overwriting existing inputs. Use a new database filename for another clean run.

### Excel model

Open `Tesla_Financial_Analysis.xlsx` and start with **Summary**.

Change `Assumptions!E5` to select:

| Selection | Scenario |
| --- | --- |
| 1 | Baseline taper |
| 2 | Bear case |
| 3 | Flat CapEx |

Review the assumptions and supporting DCF calculations before interpreting outputs.

## Data quality and limitations

- **Source provenance:** Inputs were transcribed from a supplied report. The notebook references `Tesla_Financial_Analysis_Report.pdf` and `Pasted text(3).txt`; these source materials are not included in the repository. Individual figures still need dated filing citations.
- **Historical discrepancies:** Revenue-component residuals are −$356.60 million in 2017, +$9.27 million in 2018, −$51.00 million in 2019, and −$2.00 million in 2020. Residual means total revenue minus the supplied business segments. The 2019 gross-profit-minus-OpEx reconciliation also differs from operating income by $149.00 million.
- **Valuation date:** The notebook edition is labelled 30 March 2022, but the forward model has no consistent calendar valuation date. Its technology assumptions should not be interpreted as information available on that date.
- **Scenario starting point:** Baseline Year 0 revenue is $96,491.23 million; bear-case Year 0 revenue is $96,153.85 million. Both are inferred from scenario inputs. A revised model should reconcile them to a common historical base or explain the difference.
- **Peer comparability:** Peer figures are a supplied December 2020 snapshot. Fiscal periods and accounting definitions have not been standardized.
- **Balance-sheet coverage:** Complete current-asset, current-liability, and annual debt series are unavailable. Liquidity and leverage ratios requiring those inputs are not calculated.
- **Technology estimates:** Hardware specifications, compute spending, and software monetization assumptions are unverified estimates.
- **Dashboard verification:** The Tableau guide states that native opening, rendering, and interactions have not been verified in Tableau.

## Validation

The notebook contains structural assertions, arithmetic reconciliation, and checks on the direction of valuation changes when WACC or CapEx increases. SQL includes source-reconciliation and forecast-completeness queries.

Selected Python calculation cells and the SQL model reproduce the same default per-share results: **$51.77**, **$19.35**, and **$48.37**. Agreement between implementations does not establish the accuracy of their shared source inputs.

## Planned improvements

- Populate a source register with filing dates, URLs, page references, and metric definitions.
- Resolve historical reconciliation differences.
- Establish a consistent valuation date and scenario starting point.
- Support forecast assumptions with evidence and standardize peer comparisons.
- Add the referenced Tableau package, preview, and shareable source report.
- Add pinned dependencies and automated cross-model checks.
- Document each author's individual contribution.

## Authors

**Kanishk Raj, Abhishek Kashyap, and Harsh Parashar**  
Bachelor of Business Administration, Birla Institute of Technology, Mesra.

Individual responsibilities are not yet documented in the repository.


