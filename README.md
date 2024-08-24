
- [biotidy](#biotidy)
  - [Introduction](#introduction)
  - [Prepare data](#prepare-data)
  - [makePerCellDF](#makepercelldf)
  - [makePerFeatureDF](#makeperfeaturedf)
  - [Session information](#session-information)

<!-- README.md is generated from README.Rmd. Please edit that file -->

# biotidy

<!-- badges: start -->

[![R-CMD-check](https://github.com/Yunuuuu/biotidy/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Yunuuuu/biotidy/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Introduction

`biotidy` package offers useful utilities for integrating Bioinformatic
objects such as SummarizedExperiment and Seurat into the tidy(verse)
framework.

It is important to note that `biotidy` serves a different purpose
compared to [tidyomics](https://github.com/tidyomics), which primarily
utilizes a pipe-based workflow for managing bioinformatic objects.
Specifically, `biotidy` provides a method for extracting a data frame
from bioinformatic objects, similar to how the `broom::tidy` function
operates on statistical model objects. The inspiration for `biotidy`
came from the functionality of the `scuttle::makePerCellDF` and
`scuttle::makePerFeatureDF` functions on the `SingleCellExperiment`
object. The `biotidy` package extends these functions to work with other
bioinformatic objects, such as `SummarizedExperiment`, `ExpressionSet`,
and `Seurat`.

## Prepare data

``` r
library(biotidy)
mocked_se <- mockSE(50, 100)
mocked_sce <- mockSCE(50, 100)
mocked_es <- mockES(50, 100)
mocked_seurat <- mockSeurat(50, 100)
```

## makePerCellDF

`makePerCellDF` creates a per-cell data.frame (i.e., where each row
represents a sample / cell) from the Bioinformatic objects.

``` r
# SummarizedExperiment method
makePerCellDF(mocked_se)[1:5, 1:5]
#>         Gene0001 Gene0002 Gene0003 Gene0004 Gene0005
#> Cell001      119      169        7      935        0
#> Cell002      106       21        0      749        0
#> Cell003      416       52       12     1186        0
#> Cell004      113       24        1      586        0
#> Cell005       25      386        1      468      137
```

``` r
makePerCellDF(mocked_se, melt = TRUE)[1:5, 1:5]
#>   Mutation_Status Cell_Cycle Treatment .features .assay
#> 1        negative          S    treat1  Gene0001    119
#> 2        negative        G2M    treat1  Gene0001    106
#> 3        negative         G0    treat2  Gene0001    416
#> 4        positive        G2M    treat2  Gene0001    113
#> 5        negative         G1    treat2  Gene0001     25
```

``` r
makePerCellDF(mocked_se, melt = TRUE, keep_rownames = TRUE)[1:5, 1:5]
#>       .id Mutation_Status Cell_Cycle Treatment .features
#> 1 Cell001        negative          S    treat1  Gene0001
#> 2 Cell002        negative        G2M    treat1  Gene0001
#> 3 Cell003        negative         G0    treat2  Gene0001
#> 4 Cell004        positive        G2M    treat2  Gene0001
#> 5 Cell005        negative         G1    treat2  Gene0001
```

``` r
makePerCellDF(mocked_se, features = FALSE, use_coldata = FALSE)
#> data frame with 0 columns and 50 rows
```

``` r
# SingleCellExperiment method
makePerCellDF(mocked_sce)[1:5, 1:5]
#>         Gene0001 Gene0002 Gene0003 Gene0004 Gene0005
#> Cell001      270     1229        0       62      206
#> Cell002      773     1413        1       88      216
#> Cell003      583     1386        0       16      432
#> Cell004      389     2198        0        0       13
#> Cell005      808     1651        0       93       21
```

``` r
makePerCellDF(mocked_sce, melt = TRUE)[1:5, 1:5]
#>   Mutation_Status Cell_Cycle Treatment .features .assay
#> 1        positive         G1    treat1  Gene0001    270
#> 2        negative        G2M    treat2  Gene0001    773
#> 3        positive        G2M    treat2  Gene0001    583
#> 4        negative        G2M    treat1  Gene0001    389
#> 5        negative        G2M    treat1  Gene0001    808
```

``` r
makePerCellDF(mocked_sce, melt = TRUE, keep_rownames = TRUE)[1:5, 1:5]
#>       .id Mutation_Status Cell_Cycle Treatment .features
#> 1 Cell001        positive         G1    treat1  Gene0001
#> 2 Cell002        negative        G2M    treat2  Gene0001
#> 3 Cell003        positive        G2M    treat2  Gene0001
#> 4 Cell004        negative        G2M    treat1  Gene0001
#> 5 Cell005        negative        G2M    treat1  Gene0001
```

``` r
makePerCellDF(mocked_sce, features = FALSE, use_coldata = FALSE)
#> data frame with 0 columns and 50 rows
```

``` r
# ExpressionSet method
makePerCellDF(mocked_es)[1:5, 1:5]
#>         Gene0001 Gene0002 Gene0003 Gene0004 Gene0005
#> Cell001      213        0        1      149       20
#> Cell002      678        3        0      372        0
#> Cell003       25       12       61      728        7
#> Cell004      707       14        0      556        0
#> Cell005      469       19        0       65       23
```

``` r
makePerCellDF(mocked_es, melt = TRUE)[1:5, 1:5]
#>   Mutation_Status Cell_Cycle Treatment .features .assay
#> 1        negative          S    treat1  Gene0001    213
#> 2        positive         G0    treat2  Gene0001    678
#> 3        negative        G2M    treat2  Gene0001     25
#> 4        negative         G1    treat1  Gene0001    707
#> 5        positive        G2M    treat1  Gene0001    469
```

``` r
makePerCellDF(mocked_es, melt = TRUE, keep_rownames = TRUE)[1:5, 1:5]
#>       .id Mutation_Status Cell_Cycle Treatment .features
#> 1 Cell001        negative          S    treat1  Gene0001
#> 2 Cell002        positive         G0    treat2  Gene0001
#> 3 Cell003        negative        G2M    treat2  Gene0001
#> 4 Cell004        negative         G1    treat1  Gene0001
#> 5 Cell005        positive        G2M    treat1  Gene0001
```

``` r
makePerCellDF(mocked_es, features = FALSE, use_coldata = FALSE)
#> data frame with 0 columns and 50 rows
```

``` r
# Seurat method
makePerCellDF(mocked_seurat, layer = "counts")[1:5, 1:5]
#>         Gene0001 Gene0002 Gene0003 Gene0004 Gene0005
#> Cell001        0      438        0      162      201
#> Cell002        1      299        0        0      499
#> Cell003        0      325        0       55      496
#> Cell004       15      442        0        0      304
#> Cell005        3     1536        1        0      427
```

``` r
makePerCellDF(mocked_seurat, layer = "counts", melt = TRUE)[1:5, 1:5]
#>      orig.ident nCount_RNA nFeature_RNA Mutation_Status Cell_Cycle
#> 1 SeuratProject      24500           76        negative          S
#> 2 SeuratProject      18808           80        negative          S
#> 3 SeuratProject      22796           81        negative        G2M
#> 4 SeuratProject      21535           74        positive          S
#> 5 SeuratProject      22934           73        positive        G2M
```

``` r
makePerCellDF(mocked_seurat,
  layer = "counts", melt = TRUE, keep_rownames = TRUE
)[1:5, 1:5]
#>       .id    orig.ident nCount_RNA nFeature_RNA Mutation_Status
#> 1 Cell001 SeuratProject      24500           76        negative
#> 2 Cell002 SeuratProject      18808           80        negative
#> 3 Cell003 SeuratProject      22796           81        negative
#> 4 Cell004 SeuratProject      21535           74        positive
#> 5 Cell005 SeuratProject      22934           73        positive
```

``` r
makePerCellDF(mocked_seurat,
  layer = "counts", features = FALSE,
  use_coldata = FALSE
)
#> data frame with 0 columns and 50 rows
```

## makePerFeatureDF

`makePerFeatureDF` Create a per-feature data.frame (i.e., where each row
represents a feature / gene).

``` r
# SummarizedExperiment method
makePerFeatureDF(mocked_se)[1:5, 1:5]
#>          Cell001 Cell002 Cell003 Cell004 Cell005
#> Gene0001     119     106     416     113      25
#> Gene0002     169      21      52      24     386
#> Gene0003       7       0      12       1       1
#> Gene0004     935     749    1186     586     468
#> Gene0005       0       0       0       0     137
```

``` r
makePerFeatureDF(mocked_se, melt = TRUE)[1:5, ]
#>    .cells .assay
#> 1 Cell001    119
#> 2 Cell001    169
#> 3 Cell001      7
#> 4 Cell001    935
#> 5 Cell001      0
```

``` r
makePerFeatureDF(mocked_se, melt = TRUE, keep_rownames = TRUE)[1:5, ]
#>        .id  .cells .assay
#> 1 Gene0001 Cell001    119
#> 2 Gene0002 Cell001    169
#> 3 Gene0003 Cell001      7
#> 4 Gene0004 Cell001    935
#> 5 Gene0005 Cell001      0
```

``` r
makePerFeatureDF(mocked_se, features = FALSE, use_rowdata = FALSE)
#>  [1] Cell001 Cell002 Cell003 Cell004 Cell005 Cell006 Cell007 Cell008 Cell009
#> [10] Cell010 Cell011 Cell012 Cell013 Cell014 Cell015 Cell016 Cell017 Cell018
#> [19] Cell019 Cell020 Cell021 Cell022 Cell023 Cell024 Cell025 Cell026 Cell027
#> [28] Cell028 Cell029 Cell030 Cell031 Cell032 Cell033 Cell034 Cell035 Cell036
#> [37] Cell037 Cell038 Cell039 Cell040 Cell041 Cell042 Cell043 Cell044 Cell045
#> [46] Cell046 Cell047 Cell048 Cell049 Cell050
#> <0 rows> (or 0-length row.names)
```

``` r
# SingleCellExperiment method
makePerFeatureDF(mocked_sce)[1:5, 1:5]
#>          Cell001 Cell002 Cell003 Cell004 Cell005
#> Gene0001     270     773     583     389     808
#> Gene0002    1229    1413    1386    2198    1651
#> Gene0003       0       1       0       0       0
#> Gene0004      62      88      16       0      93
#> Gene0005     206     216     432      13      21
```

``` r
makePerFeatureDF(mocked_sce, melt = TRUE)[1:5, ]
#>    .cells .assay
#> 1 Cell001    270
#> 2 Cell001   1229
#> 3 Cell001      0
#> 4 Cell001     62
#> 5 Cell001    206
```

``` r
makePerFeatureDF(mocked_sce, melt = TRUE, keep_rownames = TRUE)[1:5, ]
#>        .id  .cells .assay
#> 1 Gene0001 Cell001    270
#> 2 Gene0002 Cell001   1229
#> 3 Gene0003 Cell001      0
#> 4 Gene0004 Cell001     62
#> 5 Gene0005 Cell001    206
```

``` r
makePerFeatureDF(mocked_sce, features = FALSE, use_rowdata = FALSE)
#>  [1] Cell001 Cell002 Cell003 Cell004 Cell005 Cell006 Cell007 Cell008 Cell009
#> [10] Cell010 Cell011 Cell012 Cell013 Cell014 Cell015 Cell016 Cell017 Cell018
#> [19] Cell019 Cell020 Cell021 Cell022 Cell023 Cell024 Cell025 Cell026 Cell027
#> [28] Cell028 Cell029 Cell030 Cell031 Cell032 Cell033 Cell034 Cell035 Cell036
#> [37] Cell037 Cell038 Cell039 Cell040 Cell041 Cell042 Cell043 Cell044 Cell045
#> [46] Cell046 Cell047 Cell048 Cell049 Cell050
#> <0 rows> (or 0-length row.names)
```

``` r
# ExpressionSet method
makePerFeatureDF(mocked_es)[1:5, 1:5]
#>          Cell001 Cell002 Cell003 Cell004 Cell005
#> Gene0001     213     678      25     707     469
#> Gene0002       0       3      12      14      19
#> Gene0003       1       0      61       0       0
#> Gene0004     149     372     728     556      65
#> Gene0005      20       0       7       0      23
```

``` r
makePerFeatureDF(mocked_es, melt = TRUE)[1:5, ]
#>    .cells .assay
#> 1 Cell001    213
#> 2 Cell001      0
#> 3 Cell001      1
#> 4 Cell001    149
#> 5 Cell001     20
```

``` r
makePerFeatureDF(mocked_es, melt = TRUE, keep_rownames = TRUE)[1:5, ]
#>        .id  .cells .assay
#> 1 Gene0001 Cell001    213
#> 2 Gene0002 Cell001      0
#> 3 Gene0003 Cell001      1
#> 4 Gene0004 Cell001    149
#> 5 Gene0005 Cell001     20
```

``` r
makePerFeatureDF(mocked_es, features = FALSE, use_rowdata = FALSE)
#>  [1] Cell001 Cell002 Cell003 Cell004 Cell005 Cell006 Cell007 Cell008 Cell009
#> [10] Cell010 Cell011 Cell012 Cell013 Cell014 Cell015 Cell016 Cell017 Cell018
#> [19] Cell019 Cell020 Cell021 Cell022 Cell023 Cell024 Cell025 Cell026 Cell027
#> [28] Cell028 Cell029 Cell030 Cell031 Cell032 Cell033 Cell034 Cell035 Cell036
#> [37] Cell037 Cell038 Cell039 Cell040 Cell041 Cell042 Cell043 Cell044 Cell045
#> [46] Cell046 Cell047 Cell048 Cell049 Cell050
#> <0 rows> (or 0-length row.names)
```

``` r
# Seurat method
makePerFeatureDF(mocked_seurat, layer = "counts")[1:5, 1:5]
#>          Cell001 Cell002 Cell003 Cell004 Cell005
#> Gene0001       0       1       0      15       3
#> Gene0002     438     299     325     442    1536
#> Gene0003       0       0       0       0       1
#> Gene0004     162       0      55       0       0
#> Gene0005     201     499     496     304     427
```

``` r
makePerFeatureDF(mocked_seurat, layer = "counts", melt = TRUE)[1:5, ]
#>    .cells .assay
#> 1 Cell001      0
#> 2 Cell001    438
#> 3 Cell001      0
#> 4 Cell001    162
#> 5 Cell001    201
```

``` r
makePerFeatureDF(mocked_seurat,
  layer = "counts", melt = TRUE, keep_rownames = TRUE
)[1:5, ]
#>        .id  .cells .assay
#> 1 Gene0001 Cell001      0
#> 2 Gene0002 Cell001    438
#> 3 Gene0003 Cell001      0
#> 4 Gene0004 Cell001    162
#> 5 Gene0005 Cell001    201
```

``` r
makePerFeatureDF(mocked_seurat,
  layer = "counts", features = FALSE,
  use_rowdata = FALSE
)
#>  [1] Cell001 Cell002 Cell003 Cell004 Cell005 Cell006 Cell007 Cell008 Cell009
#> [10] Cell010 Cell011 Cell012 Cell013 Cell014 Cell015 Cell016 Cell017 Cell018
#> [19] Cell019 Cell020 Cell021 Cell022 Cell023 Cell024 Cell025 Cell026 Cell027
#> [28] Cell028 Cell029 Cell030 Cell031 Cell032 Cell033 Cell034 Cell035 Cell036
#> [37] Cell037 Cell038 Cell039 Cell040 Cell041 Cell042 Cell043 Cell044 Cell045
#> [46] Cell046 Cell047 Cell048 Cell049 Cell050
#> <0 rows> (or 0-length row.names)
```

## Session information

``` r
sessionInfo()
#> R version 4.4.0 (2024-04-24)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 24.04 LTS
#> 
#> Matrix products: default
#> BLAS/LAPACK: /usr/lib/x86_64-linux-gnu/libmkl_rt.so;  LAPACK version 3.8.0
#> 
#> locale:
#>  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
#>  [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
#>  [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
#> [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
#> 
#> time zone: Asia/Shanghai
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] biotidy_0.99.0
#> 
#> loaded via a namespace (and not attached):
#>  [1] Matrix_1.7-0                future.apply_1.11.2        
#>  [3] jsonlite_1.8.8              compiler_4.4.0             
#>  [5] crayon_1.5.3                Rcpp_1.0.12                
#>  [7] SeuratObject_5.0.2          SummarizedExperiment_1.34.0
#>  [9] Biobase_2.64.0              GenomicRanges_1.56.1       
#> [11] parallel_4.4.0              globals_0.16.3             
#> [13] IRanges_2.38.0              yaml_2.3.8                 
#> [15] fastmap_1.2.0               lattice_0.22-6             
#> [17] R6_2.5.1                    XVector_0.44.0             
#> [19] generics_0.1.3              S4Arrays_1.4.1             
#> [21] GenomeInfoDb_1.40.1         knitr_1.47                 
#> [23] BiocGenerics_0.50.0         dotCall64_1.1-1            
#> [25] future_1.33.2               DelayedArray_0.30.1        
#> [27] MatrixGenerics_1.16.0       GenomeInfoDbData_1.2.12    
#> [29] rlang_1.1.4                 sp_2.1-4                   
#> [31] xfun_0.45                   SparseArray_1.4.8          
#> [33] cli_3.6.3                   progressr_0.14.0           
#> [35] zlibbioc_1.50.0             digest_0.6.36              
#> [37] grid_4.4.0                  spam_2.10-0                
#> [39] lifecycle_1.0.4             S4Vectors_0.42.0           
#> [41] SingleCellExperiment_1.26.0 data.table_1.15.4          
#> [43] evaluate_0.24.0             listenv_0.9.1              
#> [45] codetools_0.2-20            abind_1.4-5                
#> [47] stats4_4.4.0                parallelly_1.37.1          
#> [49] rmarkdown_2.27              httr_1.4.7                 
#> [51] matrixStats_1.3.0           tools_4.4.0                
#> [53] htmltools_0.5.8.1           UCSC.utils_1.0.0
```
