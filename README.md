##Tesla Financial Analysis and Valuation
A data analytics portfolio project that examines Tesla's revenue, profitability, cash flow, and valuation using Python, SQL, Excel, and Tableau. It combines historical financial analysis with editable discounted cash flow (DCF) scenarios and visual reporting.
Historical period: 2012–2020
Notebook edition label: 30 March 2022
Report authors: Kanishk Raj, Abhishek Kashyap, and Harsh Parashar
Institution: Birla Institute of Technology, Mesra — Bachelor of Business Administration
The edition label is retained from the project; it does not establish when every technology assumption or companion file was created. Historical figures come from the supplied report and have not been independently reconciled to original filings. Forecasts and valuations are illustrative model outputs, not current market estimates.
Project objectives
- Measure changes in revenue, profit margins, cash generation, and capital expenditure.
- Compare reported operating income with a simple adjustment for regulatory credits.
- Evaluate baseline, bear, and flat-CapEx valuation scenarios.
- Explore the effect of discount rates and terminal growth on valuation.
- Communicate findings through a notebook, SQL queries, an Excel model, Tableau dashboards, and a PDF report.
- Make data definitions, calculation choices, and source inconsistencies visible.
Project files
These are companion deliverables. This README describes them; it does not embed the files. Keep the listed filenames when organizing a project folder or repository.
File	Purpose
Tesla_Financial_Analysis.ipynb	Python analysis with embedded data, saved tables and charts, editable assumptions, and optional exports.
Tesla_Financial_Analysis.sql	SQLite tables, embedded inputs, analytical views, and example queries.
Tesla_Financial_Analysis.xlsx	Excel dashboard and valuation model with six worksheets and three charts.
Tesla_Financial_Dashboard.twbx	Packaged Tableau workbook containing two dashboards, 16 worksheets, eight CSV datasets, and the institution logo.
Tesla_Dashboard_Preview.png	Data-based design preview of the dashboards; not a Tableau screenshot.
Tesla_Tableau_Guide.md	Tableau controls, calculation notes, and opening instructions.
Tesla_Financial_Analysis_Report.pdf	Formatted edition of the supplied financial report.


Tools and methods
Tool	Work demonstrated
Python / Jupyter	Reproducible analysis, scenario calculations, and sensitivity analysis.
pandas / NumPy	Data preparation, derived metrics, and numerical calculations.
Matplotlib	Financial trends, comparisons, sensitivity charts, and pie charts.
SQLite	Relational tables, joins, common table expressions, window functions, and analytical views.
Microsoft Excel	Formula-driven forecasts, editable assumptions, KPI reporting, and charts.
Tableau	Calculated fields, parameter controls, financial dashboards, and data visualization.


Selected results
The figures below describe the supplied dataset and the default model assumptions.
Historical measure	Result
Revenue, 2012	USD 413.26 million
Revenue, 2020	USD 31,536 million
Revenue CAGR, 2012–2020	71.92%
Net income, 2020	USD 690 million
Net margin, 2020	2.19%
Free cash flow, 2020	USD 2,786 million
Cash and equivalents, 2020	USD 19,384 million


Revenue CAGR uses eight elapsed years between 2012 and 2020. Free cash flow is operating cash flow minus capital expenditure.
DCF scenario	Model value per share
Baseline with implied CapEx taper	USD 51.77
Bear case	USD 19.35
Baseline with flat 7.5% CapEx	USD 48.37


The baseline attributes approximately 74.63% of enterprise value to discounted terminal value, showing how strongly the result depends on longer-term assumptions. These per-share outputs use the model's assumed share count and balance-sheet inputs; they are not quoted share prices.
Run the notebook
Install the notebook environment and analysis packages:
python -m pip install jupyterlab numpy pandas matplotlib ipython jinja2
python -m jupyterlab Tesla_Financial_Analysis.ipynb
Open the notebook and run all cells from top to bottom. The data and logo are embedded, so the analysis requires no API keys or separate data download. Package installation requires internet access if the packages are not already installed.
Edit the assumptions cells and rerun the downstream cells to explore another scenario. Set EXPORT_RESULTS = True in the final export section to save CSV tables and PNG charts to tesla_notebook_outputs in the notebook's working directory.
Run the SQL analysis
Use SQLite 3.35 or later with math functions enabled, including POWER. Run the script from the directory containing the SQL file, using a new database filename:
sqlite3 tesla_analysis.db < Tesla_Financial_Analysis.sql
The script creates tesla_* objects and loads the supplied inputs. Rerunning it against a populated project database intentionally fails rather than replacing edited data. Use another new database filename for a fresh run.
Example queries after loading the database:
-- Historical revenue, growth, and free cash flow
SELECT year, revenue, revenue_yoy_pct, calculated_free_cash_flow
FROM tesla_historical_metrics
ORDER BY year;

-- Compare the three valuation cases
SELECT scenario_name, ROUND(value_per_share, 2) AS value_per_share_usd
FROM tesla_dcf_valuation
ORDER BY scenario_id;

-- Inspect differences between source totals and their components
SELECT *
FROM tesla_source_reconciliation
ORDER BY year;
The main calculated views are tesla_historical_metrics, tesla_source_reconciliation, tesla_dcf_forecast, and tesla_dcf_valuation.
Use the Excel model
Open Tesla_Financial_Analysis.xlsx and start on Summary. The worksheets are Summary, Assumptions, DCF, Historical, Reference, and Source.
Change Assumptions!E5 to select a case:
Value	Scenario
1	Baseline taper
2	Bear case
3	Flat CapEx


Blue input values on the Assumptions sheet can be edited. Keep formula cells intact and enable automatic calculation so the forecast and summary update when inputs change.
Explore the Tableau dashboards
The packaged workbook targets Tableau 2026.1 or later. Open Tesla_Financial_Dashboard.twbx and start on Financial Overview.
View or control	Purpose
Financial Overview	Revenue, net income, free cash flow, profit margins, and DCF scenario comparison.
Historical year	Sets the historical KPI year and the ending year of historical trends.
Valuation scenario	Selects the case used for valuation KPIs and forecast charts.
Valuation and Technology	Enterprise value, net cash, terminal-value contribution, forecasts, compute-budget pie chart, and peer multiples.
Source Differences	Displays source reconciliation differences in a separate worksheet.


The scenario-comparison chart always shows all three cases. The case selector filters precomputed forecast data; it does not rerun SQL or provide a live connection to the Excel model. Changes made in the notebook, SQL, or Excel are not automatically synchronized to Tableau. Regenerate the relevant data and replace the packaged CSVs when updating the Tableau assumptions.
Validation boundary: Workbook structure, field references, packaged files, and model values were checked. Opening, native rendering, tooltips, and control interactions have not been tested inside Tableau. Consult Tesla_Tableau_Guide.md for connection and version troubleshooting. The workbook has not been published online.
Calculation conventions
- Financial amounts and share counts are in millions unless a field states otherwise; equity value divided by shares gives USD per share.
- Raw historical percentage fields use percentage points. Model rates and Tableau margin/share fields use decimals.
- The source records CapEx cash outflows as negative values, so historical free cash flow equals operating cash flow plus the signed CapEx outflow.
- Regulatory credits are already included in automotive revenue and must not be added again to total revenue.
- Forecasts use relative Years 1–5, because the source does not define a consistent forward valuation date.
- The default weighted average cost of capital (WACC) is 11.45%. Explicit cash flows use mid-year discounting; terminal value is discounted from the end of Year 5.
- The baseline CapEx rates are 7.50%, 7.50%, 7.25%, 7.00%, and 6.75%. The flat-CapEx case uses 7.50% in every year.
Core valuation relationships:
Unlevered free cash flow = EBIT - cash taxes + depreciation - CapEx - change in working capital
Enterprise value = present value of forecast cash flows + present value of terminal value
Equity value = enterprise value + assumed cash - assumed debt
Value per share = equity value / assumed shares outstanding
Data quality and scope
The project preserves four revenue-component differences in 2017–2020 and a 2019 operating-income difference. It does not insert balancing amounts to hide them. Original reported values and recalculated measures are kept distinct.
The compute pie chart uses the report's supplied allocation of 58.5%, 13.8%, 12.3%, 8.5%, and 6.9%. These sum to 100% and are not calculated from cost-range midpoints. Peer multiples use the supplied December 2020 snapshot; NIO is excluded from the EV/EBITDA chart because its value is missing.
Software monetization, compute costs, hardware specifications, and forward valuation inputs remain illustrative source assumptions. Peer accounting periods and definitions have not been standardized. The PDF preserves the report presentation, while the analytical companions recalculate selected results and document differences.
The notebook contains saved execution results for all 19 code cells with no recorded execution errors. SQL was previously executed with SQLite 3.53.1. These checks establish calculation reproducibility, not independent verification of the source financial statements.
Further work
- Reconcile each historical field to a dated original annual report and record its page or table.
- Set a consistent valuation date, balance-sheet snapshot, and share-count definition.
- Reconcile incremental software cash flows before combining them with the core DCF.
- Open and test both dashboards in Tableau, then replace the design preview with verified screenshots if publishing the project.
Attribution
The analysis is based on the supplied Tesla report and its companion notebook. Report authorship is attributed to Kanishk Raj, Abhishek Kashyap, and Harsh Parashar, BBA, Birla Institute of Technology, Mesra. The institution logo is retained from the supplied project materials.
