
- [biotidy](#biotidy)
- [Introduction](#introduction)
- [makePerCellDF](#makepercelldf)
- [makePerFeatureDF](#makeperfeaturedf)
- [Session information](#session-information)

<!-- README.md is generated from README.Rmd. Please edit that file -->

# biotidy

<!-- badges: start -->

[![R-CMD-check](https://github.com/Yunuuuu/biotidy/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Yunuuuu/biotidy/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# Introduction

`biotidy` package offers useful utilities for integrating Bioinformatic
objects such as SummarizedExperiment and Seurat into the tidy(verse)
framework.

It is important to note that `biotidy` serves a different purpose
compared to `[tidyomics](https://github.com/tidyomics)`, which primarily
utilizes a pipe-based workflow for managing bioinformatic objects.
Specifically, “biotidy” provides a method for extracting a data frame
from bioinformatic objects, similar to how the “broom::tidy” function
operates on statistical model objects. The inspiration for `biotidy`
came from the functionality of the `scuttle::makePerCellDF` and
`scuttle::makePerFeatureDF` functions on the `SingleCellExperiment`
object. The `biotidy` package extends these functions to work with other
bioinformatic objects, such as `SummarizedExperiment`, `ExpressionSet`,
and `Seurat`.

``` r
library(biotidy)
mocked_se <- mockSE()
mocked_sce <- mockSCE()
mocked_es <- mockES()
mocked_seurat <- mockSeurat()
```

# makePerCellDF

`makePerCellDF` creates a per-cell data.frame (i.e., where each row
represents a sample / cell) from the Bioinformatic objects.

``` r
# SummarizedExperiment method
makePerCellDF(mocked_se)[1:5, 1:5]
#>         Gene0001 Gene0002 Gene0003 Gene0004 Gene0005
#> Cell001        4      586      460        1      468
#> Cell002        0       96       41       17      397
#> Cell003        0      904      286        1      221
#> Cell004        2        0      398       61      225
#> Cell005        0      626      136        0      622
```

``` r
makePerCellDF(mocked_se, melt = TRUE)[1:5, 1:5]
#>   Mutation_Status Cell_Cycle Treatment .features .assay
#> 1        positive         G0    treat2  Gene0001      4
#> 2        negative          S    treat2  Gene0001      0
#> 3        negative         G1    treat1  Gene0001      0
#> 4        positive         G1    treat1  Gene0001      2
#> 5        positive         G0    treat2  Gene0001      0
```

``` r
makePerCellDF(mocked_se, melt = TRUE, keep_rownames = TRUE)[1:5, 1:5]
#>       .id Mutation_Status Cell_Cycle Treatment .features
#> 1 Cell001        positive         G0    treat2  Gene0001
#> 2 Cell002        negative          S    treat2  Gene0001
#> 3 Cell003        negative         G1    treat1  Gene0001
#> 4 Cell004        positive         G1    treat1  Gene0001
#> 5 Cell005        positive         G0    treat2  Gene0001
```

``` r
makePerCellDF(mocked_se, features = FALSE, use_coldata = FALSE)
#> data frame with 0 columns and 200 rows
```

``` r
# SingleCellExperiment method
makePerCellDF(mocked_sce)[1:5, 1:5]
#>         Gene0001 Gene0002 Gene0003 Gene0004 Gene0005
#> Cell001        0        0       15        1      326
#> Cell002        4       51      225        0      142
#> Cell003        1        0      152       22      163
#> Cell004       62        0       15        0      361
#> Cell005       31        0       62      223     1182
```

``` r
makePerCellDF(mocked_sce, melt = TRUE)[1:5, 1:5]
#>   Mutation_Status Cell_Cycle Treatment .features .assay
#> 1        negative         G1    treat1  Gene0001      0
#> 2        negative        G2M    treat1  Gene0001      4
#> 3        positive        G2M    treat2  Gene0001      1
#> 4        negative          S    treat1  Gene0001     62
#> 5        negative          S    treat2  Gene0001     31
```

``` r
makePerCellDF(mocked_sce, melt = TRUE, keep_rownames = TRUE)[1:5, 1:5]
#>       .id Mutation_Status Cell_Cycle Treatment .features
#> 1 Cell001        negative         G1    treat1  Gene0001
#> 2 Cell002        negative        G2M    treat1  Gene0001
#> 3 Cell003        positive        G2M    treat2  Gene0001
#> 4 Cell004        negative          S    treat1  Gene0001
#> 5 Cell005        negative          S    treat2  Gene0001
```

``` r
makePerCellDF(mocked_sce, features = FALSE, use_coldata = FALSE)
#> data frame with 0 columns and 200 rows
```

``` r
# ExpressionSet method
makePerCellDF(mocked_es)[1:5, 1:5]
#>         Gene0001 Gene0002 Gene0003 Gene0004 Gene0005
#> Cell001       12      257        1        0      164
#> Cell002        0      342        0       38      133
#> Cell003        0     1028        0      120       66
#> Cell004        0      144       52        4       82
#> Cell005        0       29        0       91      703
```

``` r
makePerCellDF(mocked_es, melt = TRUE)[1:5, 1:5]
#>   Mutation_Status Cell_Cycle Treatment .features .assay
#> 1        negative         G1    treat2  Gene0001     12
#> 2        positive         G1    treat2  Gene0001      0
#> 3        negative          S    treat2  Gene0001      0
#> 4        negative         G0    treat1  Gene0001      0
#> 5        positive        G2M    treat1  Gene0001      0
```

``` r
makePerCellDF(mocked_es, melt = TRUE, keep_rownames = TRUE)[1:5, 1:5]
#>       .id Mutation_Status Cell_Cycle Treatment .features
#> 1 Cell001        negative         G1    treat2  Gene0001
#> 2 Cell002        positive         G1    treat2  Gene0001
#> 3 Cell003        negative          S    treat2  Gene0001
#> 4 Cell004        negative         G0    treat1  Gene0001
#> 5 Cell005        positive        G2M    treat1  Gene0001
```

``` r
makePerCellDF(mocked_es, features = FALSE, use_coldata = FALSE)
#> data frame with 0 columns and 200 rows
```

``` r
# Seurat method
makePerCellDF(mocked_seurat, layer = "counts")[1:5, 1:5]
#>         Gene0001 Gene0002 Gene0003 Gene0004 Gene0005
#> Cell001        0      260        0        0      208
#> Cell002        0      183        0        0      257
#> Cell003        0       25        0        0       29
#> Cell004        0      330       22        0        1
#> Cell005        0       21        0       24       61
```

``` r
makePerCellDF(mocked_seurat, layer = "counts", melt = TRUE)[1:5, 1:5]
#>      orig.ident nCount_RNA nFeature_RNA Mutation_Status Cell_Cycle
#> 1 SeuratProject     377119         1486        negative        G2M
#> 2 SeuratProject     377903         1453        positive         G0
#> 3 SeuratProject     391038         1492        negative         G1
#> 4 SeuratProject     381896         1486        positive          S
#> 5 SeuratProject     386165         1513        positive        G2M
```

``` r
makePerCellDF(mocked_seurat,
  layer = "counts", melt = TRUE, keep_rownames = TRUE
)[1:5, 1:5]
#>       .id    orig.ident nCount_RNA nFeature_RNA Mutation_Status
#> 1 Cell001 SeuratProject     377119         1486        negative
#> 2 Cell002 SeuratProject     377903         1453        positive
#> 3 Cell003 SeuratProject     391038         1492        negative
#> 4 Cell004 SeuratProject     381896         1486        positive
#> 5 Cell005 SeuratProject     386165         1513        positive
```

``` r
makePerCellDF(mocked_seurat,
  layer = "counts", features = FALSE, use_coldata =
    FALSE
)
#> data frame with 0 columns and 200 rows
```

# makePerFeatureDF

`makePerFeatureDF` Create a per-feature data.frame (i.e., where each row
represents a feature / gene).

``` r
# SummarizedExperiment method
makePerFeatureDF(mocked_se)[1:5, 1:5]
#>          Cell001 Cell002 Cell003 Cell004 Cell005
#> Gene0001       4       0       0       2       0
#> Gene0002     586      96     904       0     626
#> Gene0003     460      41     286     398     136
#> Gene0004       1      17       1      61       0
#> Gene0005     468     397     221     225     622
```

``` r
makePerFeatureDF(mocked_se, melt = TRUE)[1:5, ]
#>    .cells .assay
#> 1 Cell001      4
#> 2 Cell001    586
#> 3 Cell001    460
#> 4 Cell001      1
#> 5 Cell001    468
```

``` r
makePerFeatureDF(mocked_se, melt = TRUE, keep_rownames = TRUE)[1:5, ]
#>        .id  .cells .assay
#> 1 Gene0001 Cell001      4
#> 2 Gene0002 Cell001    586
#> 3 Gene0003 Cell001    460
#> 4 Gene0004 Cell001      1
#> 5 Gene0005 Cell001    468
```

``` r
makePerFeatureDF(mocked_se, features = FALSE, use_rowdata = FALSE)
#>   [1] Cell001 Cell002 Cell003 Cell004 Cell005 Cell006 Cell007 Cell008 Cell009
#>  [10] Cell010 Cell011 Cell012 Cell013 Cell014 Cell015 Cell016 Cell017 Cell018
#>  [19] Cell019 Cell020 Cell021 Cell022 Cell023 Cell024 Cell025 Cell026 Cell027
#>  [28] Cell028 Cell029 Cell030 Cell031 Cell032 Cell033 Cell034 Cell035 Cell036
#>  [37] Cell037 Cell038 Cell039 Cell040 Cell041 Cell042 Cell043 Cell044 Cell045
#>  [46] Cell046 Cell047 Cell048 Cell049 Cell050 Cell051 Cell052 Cell053 Cell054
#>  [55] Cell055 Cell056 Cell057 Cell058 Cell059 Cell060 Cell061 Cell062 Cell063
#>  [64] Cell064 Cell065 Cell066 Cell067 Cell068 Cell069 Cell070 Cell071 Cell072
#>  [73] Cell073 Cell074 Cell075 Cell076 Cell077 Cell078 Cell079 Cell080 Cell081
#>  [82] Cell082 Cell083 Cell084 Cell085 Cell086 Cell087 Cell088 Cell089 Cell090
#>  [91] Cell091 Cell092 Cell093 Cell094 Cell095 Cell096 Cell097 Cell098 Cell099
#> [100] Cell100 Cell101 Cell102 Cell103 Cell104 Cell105 Cell106 Cell107 Cell108
#> [109] Cell109 Cell110 Cell111 Cell112 Cell113 Cell114 Cell115 Cell116 Cell117
#> [118] Cell118 Cell119 Cell120 Cell121 Cell122 Cell123 Cell124 Cell125 Cell126
#> [127] Cell127 Cell128 Cell129 Cell130 Cell131 Cell132 Cell133 Cell134 Cell135
#> [136] Cell136 Cell137 Cell138 Cell139 Cell140 Cell141 Cell142 Cell143 Cell144
#> [145] Cell145 Cell146 Cell147 Cell148 Cell149 Cell150 Cell151 Cell152 Cell153
#> [154] Cell154 Cell155 Cell156 Cell157 Cell158 Cell159 Cell160 Cell161 Cell162
#> [163] Cell163 Cell164 Cell165 Cell166 Cell167 Cell168 Cell169 Cell170 Cell171
#> [172] Cell172 Cell173 Cell174 Cell175 Cell176 Cell177 Cell178 Cell179 Cell180
#> [181] Cell181 Cell182 Cell183 Cell184 Cell185 Cell186 Cell187 Cell188 Cell189
#> [190] Cell190 Cell191 Cell192 Cell193 Cell194 Cell195 Cell196 Cell197 Cell198
#> [199] Cell199 Cell200
#> <0 rows> (or 0-length row.names)
```

``` r
# SingleCellExperiment method
makePerFeatureDF(mocked_sce)[1:5, 1:5]
#>          Cell001 Cell002 Cell003 Cell004 Cell005
#> Gene0001       0       4       1      62      31
#> Gene0002       0      51       0       0       0
#> Gene0003      15     225     152      15      62
#> Gene0004       1       0      22       0     223
#> Gene0005     326     142     163     361    1182
```

``` r
makePerFeatureDF(mocked_sce, melt = TRUE)[1:5, ]
#>    .cells .assay
#> 1 Cell001      0
#> 2 Cell001      0
#> 3 Cell001     15
#> 4 Cell001      1
#> 5 Cell001    326
```

``` r
makePerFeatureDF(mocked_sce, melt = TRUE, keep_rownames = TRUE)[1:5, ]
#>        .id  .cells .assay
#> 1 Gene0001 Cell001      0
#> 2 Gene0002 Cell001      0
#> 3 Gene0003 Cell001     15
#> 4 Gene0004 Cell001      1
#> 5 Gene0005 Cell001    326
```

``` r
makePerFeatureDF(mocked_sce, features = FALSE, use_rowdata = FALSE)
#>   [1] Cell001 Cell002 Cell003 Cell004 Cell005 Cell006 Cell007 Cell008 Cell009
#>  [10] Cell010 Cell011 Cell012 Cell013 Cell014 Cell015 Cell016 Cell017 Cell018
#>  [19] Cell019 Cell020 Cell021 Cell022 Cell023 Cell024 Cell025 Cell026 Cell027
#>  [28] Cell028 Cell029 Cell030 Cell031 Cell032 Cell033 Cell034 Cell035 Cell036
#>  [37] Cell037 Cell038 Cell039 Cell040 Cell041 Cell042 Cell043 Cell044 Cell045
#>  [46] Cell046 Cell047 Cell048 Cell049 Cell050 Cell051 Cell052 Cell053 Cell054
#>  [55] Cell055 Cell056 Cell057 Cell058 Cell059 Cell060 Cell061 Cell062 Cell063
#>  [64] Cell064 Cell065 Cell066 Cell067 Cell068 Cell069 Cell070 Cell071 Cell072
#>  [73] Cell073 Cell074 Cell075 Cell076 Cell077 Cell078 Cell079 Cell080 Cell081
#>  [82] Cell082 Cell083 Cell084 Cell085 Cell086 Cell087 Cell088 Cell089 Cell090
#>  [91] Cell091 Cell092 Cell093 Cell094 Cell095 Cell096 Cell097 Cell098 Cell099
#> [100] Cell100 Cell101 Cell102 Cell103 Cell104 Cell105 Cell106 Cell107 Cell108
#> [109] Cell109 Cell110 Cell111 Cell112 Cell113 Cell114 Cell115 Cell116 Cell117
#> [118] Cell118 Cell119 Cell120 Cell121 Cell122 Cell123 Cell124 Cell125 Cell126
#> [127] Cell127 Cell128 Cell129 Cell130 Cell131 Cell132 Cell133 Cell134 Cell135
#> [136] Cell136 Cell137 Cell138 Cell139 Cell140 Cell141 Cell142 Cell143 Cell144
#> [145] Cell145 Cell146 Cell147 Cell148 Cell149 Cell150 Cell151 Cell152 Cell153
#> [154] Cell154 Cell155 Cell156 Cell157 Cell158 Cell159 Cell160 Cell161 Cell162
#> [163] Cell163 Cell164 Cell165 Cell166 Cell167 Cell168 Cell169 Cell170 Cell171
#> [172] Cell172 Cell173 Cell174 Cell175 Cell176 Cell177 Cell178 Cell179 Cell180
#> [181] Cell181 Cell182 Cell183 Cell184 Cell185 Cell186 Cell187 Cell188 Cell189
#> [190] Cell190 Cell191 Cell192 Cell193 Cell194 Cell195 Cell196 Cell197 Cell198
#> [199] Cell199 Cell200
#> <0 rows> (or 0-length row.names)
```

``` r
# ExpressionSet method
makePerFeatureDF(mocked_es)[1:5, 1:5]
#>          Cell001 Cell002 Cell003 Cell004 Cell005
#> Gene0001      12       0       0       0       0
#> Gene0002     257     342    1028     144      29
#> Gene0003       1       0       0      52       0
#> Gene0004       0      38     120       4      91
#> Gene0005     164     133      66      82     703
```

``` r
makePerFeatureDF(mocked_es, melt = TRUE)[1:5, ]
#>    .cells .assay
#> 1 Cell001     12
#> 2 Cell001    257
#> 3 Cell001      1
#> 4 Cell001      0
#> 5 Cell001    164
```

``` r
makePerFeatureDF(mocked_es, melt = TRUE, keep_rownames = TRUE)[1:5, ]
#>        .id  .cells .assay
#> 1 Gene0001 Cell001     12
#> 2 Gene0002 Cell001    257
#> 3 Gene0003 Cell001      1
#> 4 Gene0004 Cell001      0
#> 5 Gene0005 Cell001    164
```

``` r
makePerFeatureDF(mocked_es, features = FALSE, use_rowdata = FALSE)
#>   [1] Cell001 Cell002 Cell003 Cell004 Cell005 Cell006 Cell007 Cell008 Cell009
#>  [10] Cell010 Cell011 Cell012 Cell013 Cell014 Cell015 Cell016 Cell017 Cell018
#>  [19] Cell019 Cell020 Cell021 Cell022 Cell023 Cell024 Cell025 Cell026 Cell027
#>  [28] Cell028 Cell029 Cell030 Cell031 Cell032 Cell033 Cell034 Cell035 Cell036
#>  [37] Cell037 Cell038 Cell039 Cell040 Cell041 Cell042 Cell043 Cell044 Cell045
#>  [46] Cell046 Cell047 Cell048 Cell049 Cell050 Cell051 Cell052 Cell053 Cell054
#>  [55] Cell055 Cell056 Cell057 Cell058 Cell059 Cell060 Cell061 Cell062 Cell063
#>  [64] Cell064 Cell065 Cell066 Cell067 Cell068 Cell069 Cell070 Cell071 Cell072
#>  [73] Cell073 Cell074 Cell075 Cell076 Cell077 Cell078 Cell079 Cell080 Cell081
#>  [82] Cell082 Cell083 Cell084 Cell085 Cell086 Cell087 Cell088 Cell089 Cell090
#>  [91] Cell091 Cell092 Cell093 Cell094 Cell095 Cell096 Cell097 Cell098 Cell099
#> [100] Cell100 Cell101 Cell102 Cell103 Cell104 Cell105 Cell106 Cell107 Cell108
#> [109] Cell109 Cell110 Cell111 Cell112 Cell113 Cell114 Cell115 Cell116 Cell117
#> [118] Cell118 Cell119 Cell120 Cell121 Cell122 Cell123 Cell124 Cell125 Cell126
#> [127] Cell127 Cell128 Cell129 Cell130 Cell131 Cell132 Cell133 Cell134 Cell135
#> [136] Cell136 Cell137 Cell138 Cell139 Cell140 Cell141 Cell142 Cell143 Cell144
#> [145] Cell145 Cell146 Cell147 Cell148 Cell149 Cell150 Cell151 Cell152 Cell153
#> [154] Cell154 Cell155 Cell156 Cell157 Cell158 Cell159 Cell160 Cell161 Cell162
#> [163] Cell163 Cell164 Cell165 Cell166 Cell167 Cell168 Cell169 Cell170 Cell171
#> [172] Cell172 Cell173 Cell174 Cell175 Cell176 Cell177 Cell178 Cell179 Cell180
#> [181] Cell181 Cell182 Cell183 Cell184 Cell185 Cell186 Cell187 Cell188 Cell189
#> [190] Cell190 Cell191 Cell192 Cell193 Cell194 Cell195 Cell196 Cell197 Cell198
#> [199] Cell199 Cell200
#> <0 rows> (or 0-length row.names)
```

``` r
# Seurat method
makePerFeatureDF(mocked_seurat, layer = "counts")[1:5, 1:5]
#>          Cell001 Cell002 Cell003 Cell004 Cell005
#> Gene0001       0       0       0       0       0
#> Gene0002     260     183      25     330      21
#> Gene0003       0       0       0      22       0
#> Gene0004       0       0       0       0      24
#> Gene0005     208     257      29       1      61
```

``` r
makePerFeatureDF(mocked_seurat, layer = "counts", melt = TRUE)[1:5, ]
#>    .cells .assay
#> 1 Cell001      0
#> 2 Cell001    260
#> 3 Cell001      0
#> 4 Cell001      0
#> 5 Cell001    208
```

``` r
makePerFeatureDF(mocked_seurat,
  layer = "counts", melt = TRUE, keep_rownames = TRUE
)[1:5, ]
#>        .id  .cells .assay
#> 1 Gene0001 Cell001      0
#> 2 Gene0002 Cell001    260
#> 3 Gene0003 Cell001      0
#> 4 Gene0004 Cell001      0
#> 5 Gene0005 Cell001    208
```

``` r
makePerFeatureDF(mocked_seurat,
  layer = "counts", features = FALSE,
  use_rowdata = FALSE
)
#>   [1] Cell001 Cell002 Cell003 Cell004 Cell005 Cell006 Cell007 Cell008 Cell009
#>  [10] Cell010 Cell011 Cell012 Cell013 Cell014 Cell015 Cell016 Cell017 Cell018
#>  [19] Cell019 Cell020 Cell021 Cell022 Cell023 Cell024 Cell025 Cell026 Cell027
#>  [28] Cell028 Cell029 Cell030 Cell031 Cell032 Cell033 Cell034 Cell035 Cell036
#>  [37] Cell037 Cell038 Cell039 Cell040 Cell041 Cell042 Cell043 Cell044 Cell045
#>  [46] Cell046 Cell047 Cell048 Cell049 Cell050 Cell051 Cell052 Cell053 Cell054
#>  [55] Cell055 Cell056 Cell057 Cell058 Cell059 Cell060 Cell061 Cell062 Cell063
#>  [64] Cell064 Cell065 Cell066 Cell067 Cell068 Cell069 Cell070 Cell071 Cell072
#>  [73] Cell073 Cell074 Cell075 Cell076 Cell077 Cell078 Cell079 Cell080 Cell081
#>  [82] Cell082 Cell083 Cell084 Cell085 Cell086 Cell087 Cell088 Cell089 Cell090
#>  [91] Cell091 Cell092 Cell093 Cell094 Cell095 Cell096 Cell097 Cell098 Cell099
#> [100] Cell100 Cell101 Cell102 Cell103 Cell104 Cell105 Cell106 Cell107 Cell108
#> [109] Cell109 Cell110 Cell111 Cell112 Cell113 Cell114 Cell115 Cell116 Cell117
#> [118] Cell118 Cell119 Cell120 Cell121 Cell122 Cell123 Cell124 Cell125 Cell126
#> [127] Cell127 Cell128 Cell129 Cell130 Cell131 Cell132 Cell133 Cell134 Cell135
#> [136] Cell136 Cell137 Cell138 Cell139 Cell140 Cell141 Cell142 Cell143 Cell144
#> [145] Cell145 Cell146 Cell147 Cell148 Cell149 Cell150 Cell151 Cell152 Cell153
#> [154] Cell154 Cell155 Cell156 Cell157 Cell158 Cell159 Cell160 Cell161 Cell162
#> [163] Cell163 Cell164 Cell165 Cell166 Cell167 Cell168 Cell169 Cell170 Cell171
#> [172] Cell172 Cell173 Cell174 Cell175 Cell176 Cell177 Cell178 Cell179 Cell180
#> [181] Cell181 Cell182 Cell183 Cell184 Cell185 Cell186 Cell187 Cell188 Cell189
#> [190] Cell190 Cell191 Cell192 Cell193 Cell194 Cell195 Cell196 Cell197 Cell198
#> [199] Cell199 Cell200
#> <0 rows> (or 0-length row.names)
```

# Session information

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
