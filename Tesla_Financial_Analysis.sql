-- TESLA FINANCIAL ANALYSIS AND VALUATION
-- Report authors: Kanishk Raj, Abhishek Kashyap and Harsh Parashar.
-- Companion to Tesla_Financial_Analysis.ipynb, notebook edition 30 March 2022.
-- Dialect: SQLite 3.35+ with math functions enabled (POWER); tested with 3.53.1.
-- Run against a NEW empty database: sqlite3 tesla_analysis.db < Tesla_Financial_Analysis.sql
-- Creates only tesla_* objects. Rerunning against the same database intentionally fails
-- instead of overwriting edited inputs. No network access or credentials are required.
-- SOURCE: supplied Tesla report and its embedded notebook tables, not independently
-- reconciled to filings. Historical period: 2012-2020. Forecast years are relative 1-5.
-- Figures are illustrative historical/scenario data, not current market estimates.
-- Financial amounts and shares: millions; values per share: USD.
-- Historical columns ending _pct contain percentage POINTS; model rates are decimals.
-- capex_outflow is negative. Regulatory credits are already included in automotive sales.

PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

CREATE TABLE tesla_financials (
    year INTEGER PRIMARY KEY,
    revenue REAL NOT NULL,
    automotive_sales REAL NOT NULL,
    regulatory_credits REAL NOT NULL,
    energy_revenue REAL NOT NULL,
    services_revenue REAL NOT NULL,
    cost_of_revenue REAL NOT NULL,
    automotive_cost_of_sales REAL NOT NULL,
    gross_profit REAL NOT NULL,
    reported_gross_margin_pct REAL NOT NULL,
    research_and_development REAL NOT NULL,
    selling_general_admin REAL NOT NULL,
    operating_expenses REAL NOT NULL,
    operating_income REAL NOT NULL,
    reported_operating_margin_pct REAL NOT NULL,
    interest_expense REAL NOT NULL,
    other_income_expense REAL NOT NULL,
    pretax_income REAL NOT NULL,
    income_tax REAL NOT NULL,
    net_income REAL NOT NULL,
    operating_cash_flow REAL NOT NULL,
    investing_cash_flow REAL NOT NULL,
    capex_outflow REAL NOT NULL,
    financing_cash_flow REAL NOT NULL,
    reported_free_cash_flow REAL NOT NULL,
    cash_and_equivalents REAL NOT NULL
);
INSERT INTO tesla_financials (year, revenue, automotive_sales, regulatory_credits, energy_revenue, services_revenue, cost_of_revenue, automotive_cost_of_sales, gross_profit, reported_gross_margin_pct, research_and_development, selling_general_admin, operating_expenses, operating_income, reported_operating_margin_pct, interest_expense, other_income_expense, pretax_income, income_tax, net_income, operating_cash_flow, investing_cash_flow, capex_outflow, financing_cash_flow, reported_free_cash_flow, cash_and_equivalents) VALUES
    (2012, 413.26, 385.69, 40.5, 0.0, 27.57, 383.22, 357.54, 30.04, 7.27, 273.98, 150.37, 424.35, -394.31, -95.41, -0.4, 0.0, -396.21, 0.0, -396.21, -266.0, -206.0, -239.2, 418.0, -505.2, 201.0),
    (2013, 2013.5, 1940.47, 194.4, 0.0, 73.03, 1557.24, 1496.88, 456.26, 22.66, 231.98, 285.6, 517.58, -61.32, -3.05, -32.93, 0.0, -73.54, 0.0, -74.01, 258.0, -249.0, -264.2, 635.0, -6.2, 846.0),
    (2014, 3198.36, 3006.84, 216.3, 0.0, 191.52, 2316.69, 2185.34, 881.67, 27.57, 464.7, 603.67, 1068.37, -186.7, -5.84, -100.89, 0.0, -284.59, 0.0, -294.04, -57.3, -990.0, -969.9, 2143.0, -1027.2, 1906.0),
    (2015, 4046.03, 3740.97, 168.7, 14.48, 290.58, 3122.52, 2823.31, 923.51, 22.83, 717.9, 922.23, 1640.13, -716.62, -17.71, -118.85, 0.0, -875.58, 0.0, -888.66, -524.5, -1673.7, -1634.9, 1524.0, -2159.4, 1197.0),
    (2016, 7000.13, 6352.56, 302.3, 181.39, 466.18, 5400.88, 4778.0, 1599.25, 22.85, 834.41, 1432.19, 2266.6, -667.35, -9.53, -198.81, 74.7, -746.34, 26.7, -674.91, -123.8, -1416.3, -1284.7, 3744.0, -1408.5, 3393.0),
    (2017, 11758.75, 10211.6, 360.3, 1116.27, 787.48, 9536.26, 8438.0, 2222.49, 18.9, 1378.07, 2476.5, 3854.57, -1632.08, -13.88, -471.26, 28.7, -2051.64, 31.55, -1961.4, -60.6, -4418.9, -3414.8, 4415.0, -3475.4, 3368.0),
    (2018, 21461.27, 18506.0, 418.6, 1555.0, 1391.0, 17419.0, 14640.0, 4042.27, 18.83, 1460.0, 2834.0, 4294.0, -251.73, -1.17, -663.0, -42.0, -1005.0, 58.0, -976.0, 2097.8, -2337.0, -2100.7, 574.0, -2.9, 3686.0),
    (2019, 24578.0, 20872.0, 594.0, 1531.0, 2226.0, 20509.0, 16984.0, 4069.0, 16.56, 1343.0, 2646.0, 3989.0, -69.0, -0.28, -685.0, 45.0, -767.0, 110.0, -862.0, 2405.0, -1437.0, -1327.0, 1529.0, 1078.0, 6268.0),
    (2020, 31536.0, 27238.0, 1580.0, 1994.0, 2306.0, 24906.0, 20288.0, 6630.0, 21.02, 1491.0, 3145.0, 4636.0, 1994.0, 6.32, -748.0, -85.0, 1154.0, 292.0, 690.0, 5943.0, -3132.0, -3157.0, 9973.0, 2786.0, 19384.0);

CREATE TABLE tesla_peer_snapshot (
    company TEXT NOT NULL, ticker TEXT PRIMARY KEY, market_cap REAL,
    revenue REAL, ebitda REAL, net_margin_pct REAL, ev_to_revenue REAL,
    ev_to_ebitda REAL, pe REAL
);
-- Supplied December 2020 snapshot; accounting and period definitions are not standardized.
INSERT INTO tesla_peer_snapshot (company, ticker, market_cap, revenue, ebitda, net_margin_pct, ev_to_revenue, ev_to_ebitda, pe) VALUES
    ('Tesla', 'TSLA', 668900.0, 31536.0, 4270.0, 2.19, 21.5, 157.2, 1102.0),
    ('Toyota', 'TM', 215200.0, 249500.0, 29400.0, 7.1, 1.4, 9.2, 10.5),
    ('Volkswagen', 'VOW3', 102400.0, 254100.0, 24800.0, 4.1, 1.1, 8.9, 11.2),
    ('General Motors', 'GM', 59400.0, 122485.0, 14100.0, 5.25, 1.2, 13.3, 12.1),
    ('Ford', 'F', 34900.0, 127144.0, 7200.0, -1.0, 1.2, 36.9, NULL),
    ('NIO', 'NIO', 75200.0, 2492.0, -780.0, -33.1, 29.7, NULL, NULL);

CREATE TABLE tesla_compute_budget (
    subsystem TEXT PRIMARY KEY, share_pct REAL NOT NULL CHECK(share_pct BETWEEN 0 AND 100),
    annual_low REAL NOT NULL, annual_high REAL NOT NULL CHECK(annual_high >= annual_low)
);
-- Shares are supplied percentages, not percentages derived from cost-range midpoints.
INSERT INTO tesla_compute_budget (subsystem, share_pct, annual_low, annual_high) VALUES
    ('Accelerators (GPU / Dojo)', 58.5, 2200, 3800),
    ('Power infrastructure & shell', 13.8, 500, 900),
    ('Liquid cooling', 12.3, 400, 800),
    ('NVMe storage', 8.5, 250, 550),
    ('Optical interconnect', 6.9, 150, 450);

CREATE TABLE tesla_hardware_costs (
    generation TEXT PRIMARY KEY, low_usd REAL NOT NULL, high_usd REAL NOT NULL,
    CHECK(high_usd >= low_usd)
);
-- Unverified illustrative source estimates; USD per vehicle, not USD millions.
INSERT INTO tesla_hardware_costs (generation, low_usd, high_usd) VALUES
    ('AI3', 670, 830),
    ('AI4', 1080, 1280),
    ('AI5', 2380, 3210);

CREATE TABLE tesla_hardware_specs (
    attribute TEXT PRIMARY KEY, ai3 TEXT, ai4 TEXT, ai5 TEXT
);
INSERT INTO tesla_hardware_specs (attribute, ai3, ai4, ai5) VALUES
    ('Foundry process', '14nm FinFET (Samsung)', '7nm / 5nm (Samsung / TSMC)', '3nm / 4nm (TSMC / Samsung)'),
    ('Transistor footprint', '~6 billion', '~15 billion', '~50+ billion'),
    ('SoC dies', 'Dual custom FSD SoCs', 'Dual larger custom SoCs', 'Dual multi-die CoWoS modules'),
    ('Raw AI inference', '~144 TOPS (INT8)', '~450 TOPS (INT8)', '~2,000-4,000 TOPS'),
    ('Memory', '8 × 2GB LPDDR4 (128-bit)', '16 × LPDDR5 / GDDR6', 'High-density LPDDR5X pools'),
    ('Power draw', '~72 W under load', '~120 W under load', '~600-800 W peak'),
    ('Cooling', 'Shared liquid-loop plate', 'Integrated liquid manifold', 'Dedicated high-flow cold plate'),
    ('Standalone computer cost', '$350-420', '$620-710', '$1,800-2,500'),
    ('Camera sensor suite', '8 × 1.2 MP AR0136', '8 × 5.0 MP Sony IMX', '8-10 ultra-high-res / coatings'),
    ('Optics & housings', '$180-220', '$280-340', '$350-420'),
    ('FAKRA / automotive wiring', '$90-120', '$120-150', '$150-180'),
    ('Redundant low-voltage wiring', '$50-70', '$60-80', '$80-110'),
    ('Total autonomy suite BOM', '$670-830', '$1,080-1,280', '$2,380-3,210');

CREATE TABLE tesla_scenarios (
    scenario_id INTEGER PRIMARY KEY, scenario_name TEXT NOT NULL,
    base_year_revenue REAL NOT NULL CHECK(base_year_revenue > 0),
    tax_rate REAL NOT NULL CHECK(tax_rate BETWEEN 0 AND 1),
    da_rate REAL NOT NULL CHECK(da_rate >= 0), nwc_rate REAL NOT NULL CHECK(nwc_rate >= 0),
    wacc REAL NOT NULL, terminal_growth REAL NOT NULL CHECK(terminal_growth > -1),
    cash REAL NOT NULL, debt REAL NOT NULL, shares REAL NOT NULL CHECK(shares > 0),
    CHECK(wacc > terminal_growth)
);
-- Baseline follows CapEx implied by source numeric forecast rows; case 3 follows
-- the source's flat 7.5% label. Source WACC 11.45% is used, not CAPM-implied 11.42845%.
INSERT INTO tesla_scenarios (scenario_id, scenario_name, base_year_revenue, tax_rate, da_rate, nwc_rate, wacc, terminal_growth, cash, debt, shares) VALUES
    (1, 'Baseline: implied CapEx taper', 96491.22807017545, 0.21, 0.048, 0.03, 0.1145, 0.025, 33650.0, 5750.0, 3180.0),
    (2, 'Bear case', 96153.84615384616, 0.21, 0.048, 0.03, 0.1145, 0.02, 33650.0, 5750.0, 3180.0),
    (3, 'Baseline: flat 7.5% CapEx', 96491.22807017545, 0.21, 0.048, 0.03, 0.1145, 0.025, 33650.0, 5750.0, 3180.0);

CREATE TABLE tesla_forecast_assumptions (
    scenario_id INTEGER NOT NULL REFERENCES tesla_scenarios(scenario_id),
    forecast_year INTEGER NOT NULL CHECK(forecast_year BETWEEN 1 AND 5),
    revenue_growth REAL NOT NULL CHECK(revenue_growth > -1), ebit_margin REAL NOT NULL,
    capex_rate REAL NOT NULL CHECK(capex_rate >= 0),
    PRIMARY KEY (scenario_id, forecast_year)
);
INSERT INTO tesla_forecast_assumptions (scenario_id, forecast_year, revenue_growth, ebit_margin, capex_rate) VALUES
    (1, 1, 0.14, 0.095, 0.075),
    (1, 2, 0.15, 0.105, 0.075),
    (1, 3, 0.14, 0.115, 0.0725),
    (1, 4, 0.13, 0.125, 0.07),
    (1, 5, 0.12, 0.135, 0.0675),
    (2, 1, 0.04, 0.06, 0.065),
    (2, 2, 0.05, 0.06, 0.065),
    (2, 3, 0.04, 0.06, 0.065),
    (2, 4, 0.03, 0.06, 0.065),
    (2, 5, 0.02, 0.06, 0.065),
    (3, 1, 0.14, 0.095, 0.075),
    (3, 2, 0.15, 0.105, 0.075),
    (3, 3, 0.14, 0.115, 0.075),
    (3, 4, 0.13, 0.125, 0.075),
    (3, 5, 0.12, 0.135, 0.075);

CREATE TABLE tesla_software_assumptions (
    model_id INTEGER PRIMARY KEY CHECK(model_id = 1), fleet_millions REAL NOT NULL,
    ufcf_conversion REAL NOT NULL, ev_to_year5_ufcf REAL NOT NULL,
    target_price REAL NOT NULL, annual_compute REAL NOT NULL,
    paying_adoption REAL NOT NULL, monthly_fee REAL NOT NULL,
    robotaxi_fleet_millions REAL NOT NULL, annual_miles REAL NOT NULL,
    vehicle_cogs_usd REAL NOT NULL
);
INSERT INTO tesla_software_assumptions VALUES (1,18,0.52,10.44,200,4500,0.30,99,2,45000,36000);

CREATE VIEW tesla_historical_metrics AS
WITH prior_period AS (
    SELECT f.*, LAG(revenue) OVER (ORDER BY year) AS prior_revenue,
           LAG(year) OVER (ORDER BY year) AS prior_year
    FROM tesla_financials AS f
)
SELECT p.*,
       CASE WHEN year = prior_year + 1 THEN 100.0*(revenue/prior_revenue-1) END AS revenue_yoy_pct,
       100.0*gross_profit/NULLIF(revenue,0) AS gross_margin_pct,
       100.0*operating_income/NULLIF(revenue,0) AS operating_margin_pct,
       100.0*net_income/NULLIF(revenue,0) AS net_margin_pct,
       -capex_outflow AS capex_spend,
       operating_cash_flow + capex_outflow AS calculated_free_cash_flow,
       100.0*(operating_cash_flow+capex_outflow)/NULLIF(revenue,0) AS fcf_margin_pct,
       operating_income-regulatory_credits AS ebit_less_credits,
       100.0*(operating_income-regulatory_credits)/NULLIF(revenue-regulatory_credits,0) AS ex_credit_operating_margin_pct
FROM prior_period AS p;
-- Ex-credit EBIT is a simple all-other-costs-constant adjustment, not restated GAAP earnings.

CREATE VIEW tesla_source_reconciliation AS
SELECT year,
       revenue-cost_of_revenue-gross_profit AS gross_profit_difference,
       gross_profit-operating_expenses-operating_income AS operating_income_difference,
       revenue-automotive_sales-energy_revenue-services_revenue AS revenue_components_difference,
       operating_cash_flow+capex_outflow-reported_free_cash_flow AS fcf_difference
FROM tesla_financials;
-- A nonzero difference identifies an inconsistency in supplied figures. Do not force a tie.

CREATE VIEW tesla_dcf_forecast AS
WITH RECURSIVE revenue_schedule(scenario_id, forecast_year, prior_revenue, revenue) AS (
    SELECT scenario_id, 0, base_year_revenue, base_year_revenue FROM tesla_scenarios
    UNION ALL
    SELECT r.scenario_id, a.forecast_year, r.revenue, r.revenue*(1+a.revenue_growth)
    FROM revenue_schedule AS r
    JOIN tesla_forecast_assumptions AS a
      ON a.scenario_id=r.scenario_id AND a.forecast_year=r.forecast_year+1
), operating AS (
    SELECT r.*, s.scenario_name, s.wacc, s.tax_rate,
           r.revenue*a.ebit_margin AS ebit,
           r.revenue*s.da_rate AS depreciation,
           r.revenue*a.capex_rate AS capex,
           (r.revenue-r.prior_revenue)*s.nwc_rate AS change_nwc
    FROM revenue_schedule AS r
    JOIN tesla_scenarios AS s USING (scenario_id)
    JOIN tesla_forecast_assumptions AS a USING (scenario_id,forecast_year)
), cash_flow AS (
    SELECT *, MAX(ebit,0)*tax_rate AS cash_taxes,
           ebit-MAX(ebit,0)*tax_rate AS nopat,
           ebit-MAX(ebit,0)*tax_rate+depreciation-capex-change_nwc AS ufcf
    FROM operating
)
SELECT *, forecast_year-0.5 AS discount_period,
       ufcf/POWER(1+wacc,forecast_year-0.5) AS pv_ufcf
FROM cash_flow;

CREATE VIEW tesla_dcf_valuation AS
WITH explicit_period AS (
    SELECT scenario_id, COUNT(*) AS forecast_years, SUM(pv_ufcf) AS pv_explicit_cash_flow
    FROM tesla_dcf_forecast GROUP BY scenario_id
), terminal AS (
    SELECT s.*, e.forecast_years, e.pv_explicit_cash_flow,
           f.ufcf*(1+s.terminal_growth) AS terminal_cash_flow,
           f.ufcf*(1+s.terminal_growth)/(s.wacc-s.terminal_growth) AS terminal_value
    FROM tesla_scenarios AS s
    JOIN explicit_period AS e USING(scenario_id)
    JOIN tesla_dcf_forecast AS f ON f.scenario_id=s.scenario_id AND f.forecast_year=5
    WHERE e.forecast_years=5
), discounted AS (
    SELECT *, terminal_value/POWER(1+wacc,5) AS pv_terminal_value FROM terminal
), bridge AS (
    SELECT *, pv_explicit_cash_flow+pv_terminal_value AS enterprise_value,
           cash-debt AS net_cash
    FROM discounted
)
SELECT *, enterprise_value+net_cash AS equity_value,
       (enterprise_value+net_cash)/shares AS value_per_share,
       100.0*pv_terminal_value/NULLIF(enterprise_value,0) AS terminal_share_ev_pct
FROM bridge;
-- UFCF uses mid-year discounting; terminal value uses end-of-Year-5 discounting.

COMMIT;

-- 1. Annual revenue, profitability and free cash flow. NULL means unavailable.
SELECT year, revenue, ROUND(revenue_yoy_pct,2) AS revenue_yoy_pct,
       ROUND(gross_margin_pct,2) AS gross_margin_pct,
       ROUND(operating_margin_pct,2) AS operating_margin_pct,
       ROUND(net_margin_pct,2) AS net_margin_pct, calculated_free_cash_flow
FROM tesla_historical_metrics ORDER BY year;

-- 2. Revenue CAGR uses elapsed years (2020-2012 = 8), not nine observations.
WITH endpoints AS (
    SELECT MIN(year) AS first_year, MAX(year) AS last_year FROM tesla_financials
)
SELECT e.first_year, e.last_year,
       ROUND(100*(POWER(z.revenue/a.revenue,1.0/(e.last_year-e.first_year))-1),2) AS revenue_cagr_pct
FROM endpoints AS e
JOIN tesla_financials AS a ON a.year=e.first_year
JOIN tesla_financials AS z ON z.year=e.last_year;

-- 3. Credit contribution, with consistent EBIT and revenue adjustments.
SELECT year, regulatory_credits, operating_income, ebit_less_credits,
       ROUND(ex_credit_operating_margin_pct,2) AS ex_credit_operating_margin_pct
FROM tesla_historical_metrics WHERE year>=2016 ORDER BY year;

-- 4. Peer ranking excludes unavailable multiples instead of replacing them with zero.
SELECT company, ticker, ev_to_ebitda,
       DENSE_RANK() OVER (ORDER BY ev_to_ebitda DESC) AS multiple_rank_desc
FROM tesla_peer_snapshot WHERE ev_to_ebitda IS NOT NULL ORDER BY multiple_rank_desc;

-- 5. All scenario valuations. Edit tesla_scenarios / tesla_forecast_assumptions to explore.
SELECT scenario_id, scenario_name, ROUND(enterprise_value,2) AS enterprise_value,
       net_cash, ROUND(equity_value,2) AS equity_value,
       ROUND(value_per_share,2) AS value_per_share,
       ROUND(terminal_share_ev_pct,2) AS terminal_share_ev_pct
FROM tesla_dcf_valuation ORDER BY scenario_id;

-- 6. Detailed baseline forecast. Change scenario_id to 2 or 3 for another case.
SELECT forecast_year, ROUND(revenue,2) AS revenue, ROUND(ebit,2) AS ebit,
       ROUND(cash_taxes,2) AS cash_taxes, ROUND(depreciation,2) AS depreciation,
       ROUND(capex,2) AS capex, ROUND(change_nwc,2) AS change_nwc,
       ROUND(ufcf,2) AS ufcf, ROUND(pv_ufcf,2) AS pv_ufcf
FROM tesla_dcf_forecast WHERE scenario_id=1 ORDER BY forecast_year;

-- 7. Compute pie-chart data and allocation check.
SELECT subsystem, share_pct, annual_low, annual_high FROM tesla_compute_budget ORDER BY share_pct DESC;
SELECT SUM(share_pct) AS total_share_pct FROM tesla_compute_budget;

-- 8. Hardware midpoint and share of assumed vehicle COGS.
SELECT generation, low_usd, high_usd, (low_usd+high_usd)/2.0 AS midpoint_usd,
       ROUND(100.0*(low_usd+high_usd)/2.0/p.vehicle_cogs_usd,2) AS vehicle_cogs_pct
FROM tesla_hardware_costs CROSS JOIN tesla_software_assumptions AS p;

-- 9. Exploratory software grid, baseline plus fully incremental software value.
-- The supplied 10.44x multiple is an input, not a separately forecast software DCF.
-- A full sum-of-the-parts valuation must remove software earnings already in baseline.
WITH arpu(monthly_usd) AS (VALUES(99),(200),(350),(500),(750),(1000)),
     adoption(rate) AS (VALUES(0.15),(0.30),(0.50),(0.70),(0.90))
SELECT a.monthly_usd, b.rate AS adoption_rate,
       ROUND(v.value_per_share+p.fleet_millions*a.monthly_usd*12*b.rate*p.ufcf_conversion*p.ev_to_year5_ufcf/v.shares,2) AS total_value_per_share
FROM arpu AS a CROSS JOIN adoption AS b CROSS JOIN tesla_software_assumptions AS p
JOIN tesla_dcf_valuation AS v ON v.scenario_id=1 ORDER BY a.monthly_usd,b.rate;

-- 10. Compute allocation is not a full software profit margin.
SELECT annual_compute/fleet_millions AS annual_compute_per_vehicle,
       annual_compute/fleet_millions/12 AS monthly_compute_per_vehicle,
       annual_compute/fleet_millions/paying_adoption/12 AS monthly_compute_per_paying_subscriber,
       annual_compute/robotaxi_fleet_millions/annual_miles AS compute_cost_per_robotaxi_mile
FROM tesla_software_assumptions;

-- 11. Show source discrepancies above rounding tolerance, preserving original figures.
SELECT * FROM tesla_source_reconciliation
WHERE ABS(gross_profit_difference)>0.02 OR ABS(operating_income_difference)>0.02
   OR ABS(revenue_components_difference)>0.02 OR ABS(fcf_difference)>0.02 ORDER BY year;

-- 12. Confirm each scenario has five consecutive forecast rows.
SELECT s.scenario_name, COUNT(a.forecast_year) AS years_present,
       MIN(a.forecast_year) AS first_year, MAX(a.forecast_year) AS last_year
FROM tesla_scenarios AS s LEFT JOIN tesla_forecast_assumptions AS a USING(scenario_id)
GROUP BY s.scenario_id ORDER BY s.scenario_id;
