
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidytable <img src="man/figures/logo.png" align="right" width="16%" height="16%" />

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/tidytable)](https://cran.r-project.org/package=tidytable)
[![](https://img.shields.io/badge/dev%20-0.4.1.9-green.svg)](https://github.com/markfairbanks/tidytable)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![CRAN RStudio mirror
downloads](https://cranlogs.r-pkg.org/badges/last-month/tidytable?color=grey)](https://markfairbanks.github.io/tidytable/)
<!-- badges: end -->

The goal of `tidytable` is to be a tidy interface to `data.table`.

#### Why `tidytable`?

  - `tidyverse`-like syntax with `data.table` speed
  - `rlang` compatibility - [See
    here](https://markfairbanks.github.io/tidytable/#rlang-compatibility)
  - Includes functions that
    [`dtplyr`](https://github.com/tidyverse/dtplyr) is missing,
    including many `tidyr` functions

Note: `tidytable` functions do not use `data.table`’s
modify-by-reference, and instead use the copy-on-modify principles
followed by the `tidyverse` and base R.

## Installation

Install the released version from [CRAN](https://CRAN.R-project.org)
with:

``` r
install.packages("tidytable")
```

Or install the development version from [GitHub](https://github.com/)
with:

``` r
# install.packages("devtools")
devtools::install_github("markfairbanks/tidytable")
```

## tidytable functions

### tidytable helpers

  - `dt()`: Pipeable `data.table` syntax. [See
    here](https://markfairbanks.github.io/tidytable/#dt-helper)
  - `get_dummies.()`
  - `%notin%`

### dplyr

##### Core verbs

  - `arrange.()`
  - `filter.()`
  - `mutate.()` & `mutate_across.()`
      - The `_across.()` helper is new and can replace the
        `_if.()`/`_at.()`/`_all.()` helpers [See
        here](https://markfairbanks.github.io/tidytable/#new-variant-dt_mutate_across)
  - `select.()`
  - `summarize.()`: Group by specifications called inside. [See
    here](https://markfairbanks.github.io/tidytable/#using-group-by)

##### Other dplyr functions

  - `bind_cols.()` & `bind_rows.()`
  - `case.()`: Similar to `dplyr::case_when()`. See `?case.` for syntax
  - `count.()`
  - `distinct.()`
  - `ifelse.()`
  - Joins:
      - `left_join.()`, `inner_join.()`, `right_join.()`,
        `full_join.()`, & `anti_join.()`
  - `pull.()`
  - `relocate.()`
  - `rename.()` & `rename_with.()`
  - `row_number.()`
  - `slice.()`: `_head.()`/`_tail.()`/`_max.()`/`_min.()`
      - The `slice_*()` helpers are like `top_n.()`, but are a bit
        easier to use
  - `top_n.()`
  - `transmute.()`

### tidyr

  - `drop_na.()`
  - `fill.()`: Works on character/factor/logical types
    (`data.table::nafill()` does not)
  - `group_split.()`
  - Nesting: `nest_by.()` & `unnest.()`
  - `pivot_longer.()` & `pivot_wider.()`
  - `replace_na.()`
  - `separate.()`
  - `unite.()`

### purrr

  - `map.()`, `map2.()`, `map_*.()` variants, & `map2_*.()` variants

## General syntax

`tidytable` uses `verb.()` syntax to replicate `tidyverse` functions:

``` r
library(data.table)
library(tidytable)

test_df <- data.table(x = c(1,2,3), y = c(4,5,6), z = c("a","a","b"))

test_df %>%
  select.(x, y, z) %>%
  filter.(x < 4, y > 1) %>%
  arrange.(x, y) %>%
  mutate.(double_x = x * 2,
          double_y = y * 2)
#>        x     y     z double_x double_y
#>    <dbl> <dbl> <chr>    <dbl>    <dbl>
#> 1:     1     4     a        2        8
#> 2:     2     5     a        4       10
#> 3:     3     6     b        6       12
```

## Using “group by”

Group by calls are done from inside any function that has group by
functionality (such as `summarize.()` & `mutate.()`)

  - A single column can be passed with `by = z`
  - Multiple columns can be passed with `by = c(y, z)`
  - [`tidyselect`](https://tidyselect.r-lib.org) can also be used,
    including using predicates:
      - Single predicate: `by = is.character`
      - Multiple predicates: `by = c(is.character, is.factor)`
      - A combination of predicates and column names: `by =
        c(is.character, y)`

<!-- end list -->

``` r
test_df %>%
  summarize.(avg_x = mean(x),
             count = n.(),
             by = z)
#>        z avg_x count
#>    <chr> <dbl> <int>
#> 1:     a   1.5     2
#> 2:     b   3.0     1
```

## `tidyselect` support

`tidyselect` allows you to select columns just like you would in the
tidyverse.

Normal selection can be mixed with:

  - Predicates: `is.numeric`, `is.character`, etc.
  - Select helpers: `everything()`, `starts_with()`, `ends_with()`,
    `contains()`, `any_of()`, etc.

<!-- end list -->

``` r
test_df <- data.table(a = c(1,2,3),
                      b = c(4,5,6),
                      c = c("a","a","b"),
                      d = c("a","b","c"))

test_df %>%
  select.(is.numeric, d)
#>        a     b     d
#>    <dbl> <dbl> <chr>
#> 1:     1     4     a
#> 2:     2     5     b
#> 3:     3     6     c
```

You can also use this format to drop columns:

``` r
test_df %>%
  select.(-is.numeric)
#>        c     d
#>    <chr> <chr>
#> 1:     a     a
#> 2:     a     b
#> 3:     b     c
```

These same ideas can be used whenever selecting columns in `tidytable`
functions - for example when using `count.()`, `drop_na.()`,
`pivot_longer.()`, `pivot_wider()`, etc.

#### New helper: `mutate_across.()`

`tidyselect` allows the user to replace `mutate_if.()`, `mutate_at.()`,
and `mutate_all.()` with one helper - `mutate_across.()`.

Using `_across.()` instead of `_if.()`:

``` r
test_df <- data.table(a = c(1,1,1),
                      b = c(1,1,1),
                      c = c("a","a","b"),
                      d = c("a","b","c"))

test_df %>%
  mutate_across.(is.numeric, as.character)
#>        a     b     c     d
#>    <chr> <chr> <chr> <chr>
#> 1:     1     1     a     a
#> 2:     1     1     a     b
#> 3:     1     1     b     c
```

Using `_across.()` instead of `_at.()`:

``` r
test_df %>%
  mutate_across.(c(a, b), ~ .x + 1)
#>        a     b     c     d
#>    <dbl> <dbl> <chr> <chr>
#> 1:     2     2     a     a
#> 2:     2     2     a     b
#> 3:     2     2     b     c
```

Using `_across.()` instead of `_all.()`:

``` r
test_df %>%
  mutate_across.(everything(), as.factor)
#>        a     b     c     d
#>    <fct> <fct> <fct> <fct>
#> 1:     1     1     a     a
#> 2:     1     1     a     b
#> 3:     1     1     b     c
```

## `rlang` compatibility

`rlang` quoting/unquoting can be used to write custom functions with
`tidytable` functions.

Note that quosures are not compatible with `data.table`, so `enexpr()`
must be used instead of `enquo()`.

##### Custom function with `mutate.()`

``` r
library(rlang)

df <- data.table(x = c(1,1,1), y = c(1,1,1), z = c("a","a","b"))

add_one <- function(.data, add_col) {
  add_col <- enexpr(add_col)
  
  .data %>%
    mutate.(new_col = !!add_col + 1)
}

df %>%
  add_one(x)
#>        x     y     z new_col
#>    <dbl> <dbl> <chr>   <dbl>
#> 1:     1     1     a       2
#> 2:     1     1     a       2
#> 3:     1     1     b       2
```

##### Custom function with `summarize.()`

``` r
df <- data.table(x = 1:10, y = c(rep("a", 6), rep("b", 4)), z = c(rep("a", 6), rep("b", 4)))

find_mean <- function(.data, grouping_cols, col) {
  grouping_cols <- enexpr(grouping_cols)
  col <- enexpr(col)
  
  .data %>%
    summarize.(avg = mean(!!col),
               by = !!grouping_cols)
}

df %>%
  find_mean(grouping_cols = c(y, z), col = x)
#>        y     z   avg
#>    <chr> <chr> <dbl>
#> 1:     a     a   3.5
#> 2:     b     b   8.5
```

## `dt()` helper

The `dt()` function makes regular `data.table` syntax pipeable, so you
can easily mix `tidytable` syntax with `data.table` syntax:

``` r
df <- data.table(x = c(1,2,3), y = c(4,5,6), z = c("a", "a", "b"))

df %>%
  dt(, list(x, y, z)) %>%
  dt(x < 4 & y > 1) %>%
  dt(order(x, y)) %>%
  dt(, ':='(double_x = x * 2,
            double_y = y * 2)) %>%
  dt(, list(avg_x = mean(x)), by = z)
#>        z avg_x
#>    <chr> <dbl>
#> 1:     a   1.5
#> 2:     b   3.0
```

### Speed Comparisons

Below are some speed comparisons of various functions. More functions
will get added to the speed comps over time.

A few notes:

  - Comparing times from separate functions won’t be very useful. For
    example - the `summarize()` tests were performed on a different
    dataset from `case_when()`.
  - `setDTthreads(4)` was used for `data.table` & `tidytable` timings.
  - Modify-by-reference was used in `data.table` when being compared to
    `mutate.()` & `dplyr::mutate()`
  - `fill.()` & `tidyr::fill()` both work with character/factor/logical
    columns, whereas `data.table::nafill()` does not. Testing only
    included numeric columns due to this constraint.
  - Currently `data.table` doesn’t have its own `case_when()`
    translation, so a multiple nested `fifelse()` was used.
  - All tests can be found in the source code of the README.
  - `pandas` comparisons are in the process of being added - more will
    be added soon.
  - Lastly I’d like to mention that these tests were not rigorously
    created to cover all angles equally. They are just meant to be used
    as general insight into the performance of these packages.

<!-- end list -->

``` r
all_marks
#> # A tibble: 13 x 6
#>    function_tested data.table tidytable tidyverse pandas tidytable_vs_tidyverse
#>    <chr>           <chr>      <chr>     <chr>     <chr>  <chr>                 
#>  1 arrange         75.3ms     75.81ms   549.93ms  297ms  13.8%                 
#>  2 case_when       71.76ms    93.47ms   442.74ms  307ms  21.1%                 
#>  3 distinct        41.64ms    48.98ms   109.64ms  287ms  44.7%                 
#>  4 fill            44.42ms    49ms      119.1ms   146ms  41.1%                 
#>  5 filter          260ms      295.16ms  344.72ms  656ms  85.6%                 
#>  6 inner_join      97.19ms    103.07ms  90.94ms   <NA>   113.3%                
#>  7 left_join       62.49ms    91.95ms   98.82ms   <NA>   93.0%                 
#>  8 mutate          55.43ms    79.5ms    61.02ms   85.2ms 130.3%                
#>  9 nest            18.24ms    18.1ms    38.04ms   <NA>   47.6%                 
#> 10 pivot_longer    13.61ms    15.65ms   51.23ms   <NA>   30.5%                 
#> 11 pivot_wider     121.61ms   113.36ms  148ms     <NA>   76.6%                 
#> 12 summarize       291.33ms   185.92ms  524.59ms  780ms  35.4%                 
#> 13 unnest          5.35ms     22.09ms   965.43ms  <NA>   2.3%
```
