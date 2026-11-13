## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(weasel)
long_data <- generate_weasel_dummy_data(
  n_ids = 400,
  n_times = 12,
  seed = 7
)

## -----------------------------------------------------------------------------
my_scenarios <- data.frame(
  scenario          = c("complete_case", "one_gap_ok", "very_lenient"),
  require_endpoints = c(TRUE, TRUE, FALSE),
  max_missing       = c(0, 2, 4),
  n_gap_max         = c(0, 1, 4),
  max_gap_len       = c(0, 2, 4)
)

plan_custom <- weasel_plan(
  long_data,
  id = "id",
  wave = "time",
  span = "core",
  core_len = 8,
  scenarios = my_scenarios
)

weasel_print_table(
  weasel_compare_scenarios(plan_custom),
  title = "Custom scenarios", digits = 3
)

## -----------------------------------------------------------------------------
size_first <- weasel_compare_scenarios(
  plan_custom,
  weights = c(size = 3, coverage = 1)
)
size_first$scenario[size_first$recommended]

## -----------------------------------------------------------------------------
biennial <- generate_weasel_dummy_data(
  n_ids = 200,
  waves = seq(2008, 2022, by = 2),
  seed = 11
)
sort(unique(biennial$time))

## -----------------------------------------------------------------------------
p_wrong <- weasel_plan(biennial, "id", "time", span = "full")
weasel_compare_scenarios(p_wrong)$n_ids

## -----------------------------------------------------------------------------
p_biennial <- weasel_plan(biennial, "id", "time",
                          span = "full", grid = "observed")
p_biennial

## -----------------------------------------------------------------------------
sens <- weasel_sensitivity(
  plan_custom,
  require_endpoints = c(TRUE, FALSE),
  max_missing = 0:2,
  n_gap_max = 0:1,
  max_gap_len = 0:2
)
weasel_print_table(sens, title = "Tolerance sweep", n = 10)

## -----------------------------------------------------------------------------
sel <- weasel_selectivity(plan_custom, "one_gap_ok")
weasel_print_table(sel, title = "Retained vs excluded", digits = 3)

## -----------------------------------------------------------------------------
p_light <- weasel_plan(long_data, "id", "time",
                       span = "full", keep_data = FALSE)
nrow(weasel_apply(p_light, "lenient", data = long_data))

## -----------------------------------------------------------------------------
d_other <- long_data[-(1:10), ]
msg <- tryCatch(
  weasel_apply(p_light, "lenient", data = d_other),
  warning = function(w) conditionMessage(w)
)
substr(msg, 1, 78)

## -----------------------------------------------------------------------------
plan_full <- weasel_plan(long_data, "id", "time", span = "full")
c(lower = plan_full$lower, upper = plan_full$upper)

## -----------------------------------------------------------------------------
plan_fixed <- weasel_plan(long_data, "id", "time", lower = 3, upper = 10)
plan_fixed$span_reason

## -----------------------------------------------------------------------------
weasel_print_table(plan_custom$span_candidates, digits = 0)

## -----------------------------------------------------------------------------
cmp_audit <- weasel_compare_scenarios(plan_custom)
attr(cmp_audit, "weights")
weasel_print_table(attr(cmp_audit, "score_components"), digits = 3)
cmp_audit[c("scenario", "score", "recommended", "near_tie")]

## -----------------------------------------------------------------------------
plan_custom$population

## -----------------------------------------------------------------------------
m <- plan_custom$id_metrics
weasel_print_table(head(m, 8), title = "Per-respondent metrics")

# distribution of interior gap counts
table(m$n_gap)

## -----------------------------------------------------------------------------
set_weasel_scope(
  long_data,
  id = "id", wave = "time",
  lower = 2, upper = 11,
  min_present = 6,   # at least 6 observed waves within the span
  max_gap_len = 1,   # no interior gap longer than 1 wave
  n_gap_max = 2      # at most 2 interior gaps
)
evaluate_weasel_scope()
weasel_reshape_to_wide()
weasel_summarize_waves()
weasel_print_table(weasel_filter_wave_summary(),
                   title = "Constrained patterns", n = 8)
weasel_clear_scope()

## -----------------------------------------------------------------------------
cat(weasel_justify_subset(plan_custom, "one_gap_ok", style = "concise"),
    "\n")

## -----------------------------------------------------------------------------
cat(weasel_justify_subset(plan_custom, "one_gap_ok"), "\n\n")
cat(weasel_justify_subset(plan_custom, "one_gap_ok", style = "methods",
                          author = "van den Bosch", year = "2026"),
    "\n")

## -----------------------------------------------------------------------------
cat(weasel_justify_subset(plan_custom, "one_gap_ok", style = "extended"),
    "\n")

## -----------------------------------------------------------------------------
options(weasel.verbose = FALSE)
p_quiet <- weasel_plan(long_data, "id", "time", span = "full")
options(weasel.verbose = TRUE)

## -----------------------------------------------------------------------------
set.seed(99)
before <- rnorm(2)

set.seed(99)
tmp <- generate_weasel_dummy_data(n_ids = 20, n_times = 5, seed = 1)
after <- rnorm(2)

identical(before, after)

