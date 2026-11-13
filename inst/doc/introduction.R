## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(weasel)

## -----------------------------------------------------------------------------
long_data <- generate_weasel_dummy_data(
  n_ids = 300,
  n_times = 12,
  seed = 2026
)
str(long_data)

## -----------------------------------------------------------------------------
nrow(long_data)
300 * 12

## -----------------------------------------------------------------------------
set_weasel_scope(
  long_data,
  id = "id",
  wave = "time",
  lower = 2,
  upper = 11
)
evaluate_weasel_scope()
weasel_reshape_to_wide()
weasel_summarize_waves()

## -----------------------------------------------------------------------------
weasel_scope_info()

## -----------------------------------------------------------------------------
weasel_print_table(weasel_filter_wave_summary(),
                   title = "Wave patterns", n = 10)

## -----------------------------------------------------------------------------
weasel_print_table(
  weasel_filter_wave_summary(n_range = c(9, 10), ids_range = c(5, Inf)),
  title = "Dense, common patterns"
)

## -----------------------------------------------------------------------------
subset_row1 <- weasel_get_data_by_row(1)
weasel_print_table(head(subset_row1, 8), title = "Most common pattern, data")

## -----------------------------------------------------------------------------
set_weasel_scope(long_data, "id", "time", max_gap_len = 1, n_gap_max = 1)
evaluate_weasel_scope()
weasel_reshape_to_wide()
weasel_summarize_waves()
weasel_print_table(weasel_filter_wave_summary(),
                   title = "Gap-constrained", n = 5)

## -----------------------------------------------------------------------------
weasel_clear_scope()

## -----------------------------------------------------------------------------
plan_obj <- weasel_plan(long_data, id = "id", wave = "time", span = "core")
plan_obj

## -----------------------------------------------------------------------------
comparison <- weasel_compare_scenarios(plan_obj)
weasel_print_table(comparison, title = "Scenario comparison", digits = 3)

## -----------------------------------------------------------------------------
cat(weasel_compare_to_sentence(comparison), "\n")

## -----------------------------------------------------------------------------
s <- weasel_summarize_subset(plan_obj, "anchored_balanced")
weasel_print_table(s$headline, title = "Headline", digits = 3)
weasel_print_table(s$per_wave_coverage, title = "Per-wave coverage")
cat(weasel_subset_to_sentence(s), "\n")

## -----------------------------------------------------------------------------
analysis_data <- weasel_apply(plan_obj, "anchored_balanced")
dim(analysis_data)

## -----------------------------------------------------------------------------
cat(weasel_justify_subset(plan_obj, "anchored_balanced"), "\n")

