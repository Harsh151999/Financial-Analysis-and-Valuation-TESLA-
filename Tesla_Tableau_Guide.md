# Tesla Tableau dashboard

Open `Tesla_Financial_Dashboard.twbx` in **Tableau Desktop or Tableau Public desktop app, version 2026.1 or later**. Start on the **Financial Overview** tab. The package includes all CSV data and the BIT Mesra logo; no database login is required.

## Dashboard controls

| Control or tab | Behavior |
| --- | --- |
| Historical year | Changes revenue, net-income and free-cash-flow KPIs. Historical charts show 2012 through the selected year. |
| Valuation scenario | Selects Baseline taper, Bear case or Flat CapEx for valuation KPIs and forecast charts on both dashboards. |
| Scenario comparison | Always shows all three cases; this comparison is separate from the selected-case KPI. |
| Valuation and Technology | Enterprise value, net cash, DCF price, terminal-value share, five-year forecasts, compute pie chart and peer multiples. |
| Source Differences worksheet | Displays source reconciliation differences. Red marks exceed USD 0.02 million. |

Hover over marks for detail. The worksheets, labels, colors and layout are editable in Tableau. Use the bottom tabs to switch dashboards.

## Data and calculations

The data comes from the supplied Tesla report, its notebook edition labeled **30 March 2022**, and `Tesla_Financial_Analysis.sql`. Historical observations cover **2012–2020**. The notebook edition label is not a claim that all forward technology assumptions were known on that date. Source figures have not been independently reconciled to filings. Forecasts, hardware assumptions and valuations are illustrative rather than current market estimates.

Financial figures are USD millions. Share counts are millions; dividing equity value by shares gives USD per share. Margin and compute-share fields are decimal rates. Original historical fields whose names end in `Pct` retain the notebook's percentage-point convention.

The dashboard calculates enterprise value, net cash, equity value, per-share value and terminal-value share using Tableau calculated fields. Forecast schedules are reproducible snapshots from the SQL model. The case selector selects these snapshots; it does not rerun SQL or change the underlying growth/WACC inputs. To change those assumptions, edit the companion SQL model, regenerate its outputs and replace the relevant CSV data.

The selected WACC is 11.45%. Explicit cash flows use mid-year discounting; terminal value uses end-of-Year-5 discounting. The baseline follows the CapEx taper implied by the report's numeric rows. Flat CapEx uses 7.5% in all five years.

| Case | Expected value per share |
| --- | ---: |
| Baseline taper | $51.77 |
| Bear case | $19.35 |
| Flat CapEx | $48.37 |

Compute percentages are the supplied allocation (58.5%, 13.8%, 12.3%, 8.5%, 6.9%), not proportions recalculated from cost midpoints. The peer chart uses the supplied December 2020 snapshot; NIO is omitted because its EV / EBITDA is unavailable. Peer accounting and fiscal-period definitions have not been standardized.

Historical revenue component differences are retained for 2017, 2018, 2019 and 2020. The 2019 operating-income difference is also retained. There are no inserted balancing amounts. Regulatory credits are already included in automotive sales.

## Opening and validation

The workbook XML was checked against Tableau's 2026.1 schema, with restrictive declarations resolving two unused optional metadata namespaces. Embedded data files, field references, dashboard bounds and model values were checked. **Tableau itself is not installed in the authoring environment, so opening, native rendering, tooltips and control interactions have not been verified in Tableau.** The separate PNG is a data-based design preview, not a Tableau screenshot.

If Tableau requests a missing file, make a copy of the `.twbx`, rename the copy to `.zip`, and extract it. Open the extracted `.twb`; use **Data → [data source] → Edit Connection** to select the matching CSV in its `Data` folder. Keep the `Images` folder alongside it. Save a new packaged workbook after reconnecting. If the version is unsupported, use Tableau 2026.1 or later.

The file has not been published online. To publish after reviewing it locally, use your Tableau application's publishing command and check the destination and data visibility before saving.

## Technical references

- [Tableau packaged workbooks](https://help.tableau.com/current/pro/desktop/en-us/save_savework_packagedworkbooks.htm)
- [Official Tableau workbook schemas and validation limits](https://github.com/tableau/tableau-document-schemas)
- [Tableau text-file connections](https://help.tableau.com/current/pro/desktop/en-us/examples_text.htm)

Report authors: Kanishk Raj, Abhishek Kashyap and Harsh Parashar. BBA, Birla Institute of Technology, Mesra.
