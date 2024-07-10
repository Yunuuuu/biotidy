#' Create a per-feature data.frame
#'
#' Create a per-feature data.frame (i.e., where each row represents a feature /
#' gene) from a `x`.
#' 
#' @inheritParams makePerCellDF
#' @param use_rowdata Logical scalar indicating whether feature metadata of `x`
#' should be included. Alternatively, a character or integer vector specifying
#' the feature metadata fields to use.
#' @inherit makePerCellDF return
#' @name makePerFeatureDF
#' @export
makePerFeatureDF <- function(x, ...) UseMethod("makePerFeatureDF")

#' @examples
#' # SummarizedExperiment method
#' mocked_se <- mockSE()
#' makePerFeatureDF(mocked_se)
#' makePerFeatureDF(mocked_se, melt = TRUE)
#' makePerFeatureDF(mocked_se, melt = TRUE, keep_rownames = TRUE)
#' makePerFeatureDF(mocked_se, features = FALSE, use_rowdata = FALSE)
#'
#' @rdname makePerFeatureDF
#' @export
makePerFeatureDF.SummarizedExperiment <- function(x,
                                                  features = TRUE,
                                                  assay = NULL,
                                                  swap_rownames = NULL,
                                                  use_rowdata = TRUE,
                                                  ...,
                                                  melt = FALSE,
                                                  keep_rownames = FALSE,
                                                  make_unique = FALSE) {
    rlang::check_dots_empty()
    assert_bool(make_unique)
    rowdata <- SummarizedExperiment::rowData(x)
    out <- harvest_by_extra_data(
        assay_data = SummarizedExperiment::assay(x, assay %||% 1L),
        use_features = features,
        swap_rownames = swap_rownames,
        feature_meta = rowdata,
        extra_data = data_frame0(rowdata),
        use_extra_data = use_rowdata,
        melt = melt, transpose = FALSE,
        keep_rownames = keep_rownames
    )
    if (make_unique) {
        colnames(out) <- make.unique(colnames(out))
    }
    out
}

#' @examples
#' # SingleCellExperiment method
#' mocked_sce <- mockSCE()
#' makePerFeatureDF(mocked_se)
#' makePerFeatureDF(mocked_se, melt = TRUE)
#' makePerFeatureDF(mocked_se, melt = TRUE, keep_rownames = TRUE)
#' makePerFeatureDF(mocked_se, features = FALSE, use_rowdata = FALSE)
#'
#' @rdname makePerFeatureDF
#' @export
makePerFeatureDF.SingleCellExperiment <- function(x,
                                                  features = TRUE,
                                                  assay = NULL,
                                                  swap_rownames = NULL,
                                                  use_rowdata = TRUE,
                                                  ...,
                                                  use_altexps = TRUE,
                                                  prefix_altexps = FALSE,
                                                  melt = FALSE,
                                                  keep_rownames = FALSE,
                                                  make_unique = FALSE) {
    rlang::check_dots_empty()
    assert_bool(make_unique)
    data <- sce_assays(x, assay, use_altexps, prefix_altexps)
    extra_data <- data.table::rbindlist(
        lapply(.subset2(data, 2L), data_frame0),
        use.names = TRUE, fill = TRUE
    )
    out <- harvest_by_extra_data(
        assay_data = .subset2(data, 1L),
        use_features = features,
        swap_rownames = swap_rownames,
        feature_meta = .subset2(data, 2L),
        extra_data = extra_data,
        use_extra_data = use_rowdata,
        melt = melt, transpose = FALSE,
        keep_rownames = keep_rownames
    )
    if (make_unique) {
        colnames(out) <- make.unique(colnames(out))
    }
    out
}

#' @examples
#' # ExpressionSet method
#' mocked_es <- mockES()
#' makePerFeatureDF(mocked_se)
#' makePerFeatureDF(mocked_se, melt = TRUE)
#' makePerFeatureDF(mocked_se, melt = TRUE, keep_rownames = TRUE)
#' makePerFeatureDF(mocked_se, features = FALSE, use_rowdata = FALSE)
#'
#' @rdname makePerFeatureDF
#' @export
makePerFeatureDF.ExpressionSet <- function(x,
                                           features = TRUE,
                                           assay = NULL,
                                           swap_rownames = NULL,
                                           use_rowdata = TRUE,
                                           ...,
                                           melt = FALSE,
                                           keep_rownames = FALSE,
                                           make_unique = FALSE) {
    rlang::check_dots_empty()
    assert_bool(make_unique)
    fdata <- Biobase::fData(x)
    out <- harvest_by_extra_data(
        assay_data = Biobase::assayData(x)[[assay %||% "exprs"]],
        use_features = features,
        swap_rownames = swap_rownames,
        feature_meta = fdata,
        extra_data = data_frame0(fdata),
        use_extra_data = use_rowdata,
        melt = melt, transpose = FALSE,
        keep_rownames = keep_rownames
    )
    if (make_unique) {
        colnames(out) <- make.unique(colnames(out))
    }
    out
}

#' @examples
#' # Seurat method
#' mocked_seurat <- mockSeurat()
#' makePerFeatureDF(mocked_seurat)
#' makePerFeatureDF(mocked_seurat, layer = "counts", melt = TRUE)
#' makePerFeatureDF(mocked_seurat,
#'     layer = "counts", melt = TRUE, keep_rownames = TRUE
#' )
#' makePerFeatureDF(mocked_seurat,
#'     layer = "counts", features = FALSE,
#'     use_rowdata = FALSE
#' )
#' @rdname makePerFeatureDF
#' @export
makePerFeatureDF.Seurat <- function(x,
                                    features = TRUE,
                                    assay = NULL, layer = NULL,
                                    swap_rownames = NULL,
                                    use_rowdata = TRUE,
                                    ...,
                                    melt = FALSE,
                                    keep_rownames = FALSE,
                                    make_unique = FALSE) {
    rlang::check_dots_empty()
    assert_string(layer, empty_ok = FALSE, null_ok = TRUE)
    assert_bool(make_unique)
    assay <- assay %||% SeuratObject::DefaultAssay(x)
    assay <- x[[assay]]
    assay_data <- SeuratObject::GetAssayData(assay, layer = layer)
    if (methods::is(assay, "Assay5")) {
        feature_meta <- assay@meta.data
    } else {
        feature_meta <- assay@meta.features
    }
    out <- harvest_by_extra_data(
        assay_data = assay_data,
        use_features = features,
        swap_rownames = swap_rownames,
        feature_meta = feature_meta,
        use_extra_data = use_rowdata,
        extra_data = feature_meta,
        melt = melt, transpose = FALSE,
        keep_rownames = keep_rownames
    )
    if (make_unique) {
        colnames(out) <- make.unique(colnames(out))
    }
    out
}
