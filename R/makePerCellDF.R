#' Create a per-cell data.frame
#'
#' Create a per-cell data.frame (i.e., where each row represents a sample /
#' cell) from a `x`.
#'
#' @param x A
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment],
#' [SingleCellExperiment][SingleCellExperiment::SingleCellExperiment],
#' [ExpressionSet][Biobase::ExpressionSet] or
#' [Seurat][SeuratObject::Seurat-class] object.
#' @param features Logical scalar indicating whether feature assay data of `x`
#' should be included. Alternatively, Character or integer vector specifying the
#' features for which to extract expression profiles across samples.
#' @param assay String or integer scalar indicating the assay to use to obtain
#' expression values. Must refer to a matrix-like object with integer or numeric
#' values. If `NULL`, the default assay will be used:
#'   - [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment]: the
#'         `1st` assay
#'   - [ExpressionSet][Biobase::ExpressionSet]: assay from
#'         [exprs][Biobase::exprs]
#'   - [Seurat][SeuratObject::Seurat-class]:
#'         assay from [DefaultAssay][SeuratObject::DefaultAssay]
#' @param swap_rownames String or integer specifying the feature metadata column
#' containing the features names. If `NULL`, `rownames(x)` will be used.
#' @param use_coldata Logical scalar indicating whether column metadata of `x`
#' should be included. Alternatively, a character or integer vector specifying
#' the column metadata fields to use.
#' @param ... Not used currently.
#' @param melt A single boolean value indicates whether the `features` should be
#' reshaped into long-format. A column named `".features"` will contain all
#' feature names and a column named `".assay"` will contain all feature assay
#' values. You can also specify a string indicates the column `".assay"` or a
#' character with length 2 indicates the column names of `".features"` and
#' `".assay"`.
#' @param keep_rownames If `melt` is not `NULL`, the rownames will be omitted,
#' this argument retains the data.frame's row names under a new column `".id"`,
#' You can also specify a string to names the column of the rownames.
#' @param make_unique A boolean value indicating whether column names of the
#' output should be made unique.
#' @return A [data.frame][data.frame].
#' @export
makePerCellDF <- function(x, ...) UseMethod("makePerCellDF")

#' @examples
#' # SummarizedExperiment method
#' mocked_se <- mockSE()
#' makePerCellDF(mocked_se)
#' makePerCellDF(mocked_se, melt = TRUE)
#' makePerCellDF(mocked_se, melt = TRUE, keep_rownames = TRUE)
#' makePerCellDF(mocked_se, features = FALSE, use_coldata = FALSE)
#'
#' @rdname makePerCellDF
#' @export
makePerCellDF.SummarizedExperiment <- function(x,
                                               features = TRUE,
                                               assay = NULL,
                                               swap_rownames = NULL,
                                               use_coldata = TRUE,
                                               ...,
                                               melt = FALSE,
                                               keep_rownames = FALSE,
                                               make_unique = FALSE) {
    rlang::check_dots_empty()
    assert_bool(make_unique)
    out <- harvest_by_extra_data(
        assay_data = SummarizedExperiment::assay(x, assay %||% 1L),
        use_features = features,
        swap_rownames = swap_rownames,
        feature_meta = SummarizedExperiment::rowData(x),
        extra_data = data_frame0(SummarizedExperiment::colData(x)),
        use_extra_data = use_coldata,
        melt = melt, transpose = TRUE, keep_rownames = keep_rownames
    )
    if (make_unique) {
        colnames(out) <- make.unique(colnames(out))
    }
    out
}

#' @param use_altexps A boolean value indicating whether (meta)data should be
#' extracted for [alternative][SingleCellExperiment::altExps] experiments in
#' `x`.
#' @param prefix_altexps A boolean value indicating whether
#' [altExp][SingleCellExperiment::altExps]-derived fields should be prefixed
#' with the name of the alternative Experiment.
#' @examples
#' # SingleCellExperiment method
#' mocked_sce <- mockSCE()
#' makePerCellDF(mocked_sce)
#' makePerCellDF(mocked_sce, melt = TRUE)
#' makePerCellDF(mocked_sce, melt = TRUE, keep_rownames = TRUE)
#' makePerCellDF(mocked_sce, features = FALSE, use_coldata = FALSE)
#'
#' @rdname makePerCellDF
#' @export
makePerCellDF.SingleCellExperiment <- function(x,
                                               features = TRUE,
                                               assay = NULL,
                                               swap_rownames = NULL,
                                               use_coldata = TRUE,
                                               ...,
                                               use_altexps = TRUE,
                                               prefix_altexps = FALSE,
                                               melt = FALSE,
                                               keep_rownames = FALSE,
                                               make_unique = FALSE) {
    rlang::check_dots_empty()
    assert_bool(make_unique)
    data <- sce_assays(x, assay, use_altexps, prefix_altexps)
    out <- harvest_by_extra_data(
        assay_data = .subset2(data, 1L),
        use_features = features,
        swap_rownames = swap_rownames,
        feature_meta = .subset2(data, 2L),
        extra_data = data_frame0(SummarizedExperiment::colData(x)),
        use_extra_data = use_coldata,
        melt = melt, transpose = TRUE,
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
#' makePerCellDF(mocked_es)
#' makePerCellDF(mocked_es, melt = TRUE)
#' makePerCellDF(mocked_es, melt = TRUE, keep_rownames = TRUE)
#' makePerCellDF(mocked_es, features = FALSE, use_coldata = FALSE)
#'
#' @rdname makePerCellDF
#' @export
makePerCellDF.ExpressionSet <- function(x,
                                        features = TRUE,
                                        assay = NULL,
                                        swap_rownames = NULL,
                                        use_coldata = TRUE,
                                        ...,
                                        melt = FALSE,
                                        keep_rownames = FALSE,
                                        make_unique = FALSE) {
    rlang::check_dots_empty()
    assert_bool(make_unique)
    out <- harvest_by_extra_data(
        assay_data = Biobase::assayData(x)[[assay %||% "exprs"]],
        use_features = features,
        swap_rownames = swap_rownames,
        feature_meta = Biobase::fData(x),
        extra_data = data_frame0(Biobase::pData(x)),
        use_extra_data = use_coldata,
        melt = melt, transpose = TRUE,
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
#' makePerCellDF(mocked_seurat)
#' makePerCellDF(mocked_seurat, layer = "counts", melt = TRUE)
#' makePerCellDF(mocked_seurat,
#'     layer = "counts", melt = TRUE, keep_rownames = TRUE
#' )
#' makePerCellDF(mocked_seurat,
#'     layer = "counts", features = FALSE,
#'     use_coldata = FALSE
#' )
#' @param layer A string indicates the layer to get.
#' @rdname makePerCellDF
#' @export
makePerCellDF.Seurat <- function(x,
                                 features = TRUE,
                                 assay = NULL, layer = NULL,
                                 swap_rownames = NULL,
                                 use_coldata = TRUE,
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
        use_extra_data = use_coldata,
        extra_data = x@meta.data,
        melt = melt, transpose = TRUE,
        keep_rownames = keep_rownames
    )
    if (make_unique) {
        colnames(out) <- make.unique(colnames(out))
    }
    out
}
