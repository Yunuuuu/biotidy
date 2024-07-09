#' Create a per-cell data.frame
#'
#' Create a per-cell data.frame (i.e., where each row represents a sample /
#' cell) from a `x`, most typically for creating custom ggplot2 plots.
#'
#' @param x A
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment],
#' [SingleCellExperiment][SingleCellExperiment::SingleCellExperiment],
#' [ExpressionSet][Biobase::ExpressionSet] or
#' [Seurat][SeuratObject::Seurat-class] object.
#' @param ... Not used currently
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
#' @param use_coldata Logical scalar indicating whether column metadata of `x`
#' should be included. Alternatively, a character or integer vector specifying
#' the column metadata fields to use.
#' @param swap_rownames String or integer specifying the feature metadata column
#' containing the features names. If `NULL`, `rownames(x)` will be used.
#' @param check_names A boolean value indicating whether column names of the
#' output should be made syntactically valid and unique.
#' @return A [data.frame][data.frame].
#' @export
makePerCellDF <- function(x, ...) UseMethod("makePerCellDF")

#' @rdname makePerCellDF
#' @export
makePerCellDF.SummarizedExperiment <- function(x,
                                               features = TRUE,
                                               assay = NULL,
                                               swap_rownames = NULL,
                                               use_coldata = TRUE,
                                               ...,
                                               check_names = FALSE) {
    rlang::check_dots_empty()
    assert_bool(check_names)
    out <- harvest_by_extra_data(x,
        features = features,
        use_extra_data = use_coldata,
        swap_rownames = swap_rownames,
        assay_data = SummarizedExperiment::assay(x, assay %||% 1L),
        rowdata = SummarizedExperiment::rowData(x),
        extra_data = SummarizedExperiment::colData(x),
        transpose = TRUE
    )
    if (check_names) {
        colnames(out) <- make.names(colnames(out), unique = TRUE)
    }
    out
}

#' @param use_altexps A boolean value indicating whether (meta)data should be
#' extracted for [alternative][SingleCellExperiment::altExps] experiments in
#' `x`.
#' @param prefix_altexps A boolean value indicating whether
#' [altExp][SingleCellExperiment::altExps]-derived fields should be prefixed
#' with the name of the alternative Experiment.
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
                                               check_names = FALSE) {
    rlang::check_dots_empty()
    assert_bool(check_names)
    assert_bool(prefix_altexps)
    use_altexps <- use_integer_indices(
        use_altexps,
        names = SingleCellExperiment::altExpNames(x),
    )
    assay <- assay %||% 1L
    out <- harvest_by_extra_data(x,
        features = features,
        use_extra_data = use_coldata,
        swap_rownames = swap_rownames,
        assay_data = SummarizedExperiment::assay(x, assay),
        rowdata = SummarizedExperiment::rowData(x),
        extra_data = SummarizedExperiment::colData(x),
        transpose = TRUE
    )
    if (length(use_altexps)) {
        all_alts <- SingleCellExperiment::altExps(x)[use_altexps]
        alt_vals <- vector("list", length(all_alts))

        for (i in seq_along(alt_vals)) {
            curalt <- makePerCellDF(
                all_alts[[i]],
                features = features,
                assay = assay,
                use_coldata = use_coldata,
                swap_rownames = swap_rownames,
                check_names = FALSE
            )
            if (prefix_altexps) {
                colnames(curalt) <- sprintf(
                    "%s.%s", names(all_alts)[i], colnames(curalt)
                )
            }
            alt_vals[[i]] <- curalt
        }
        alt_vals <- do.call(cbind, alt_vals)
        out <- cbind(out, alt_vals)
    }
    if (check_names) {
        colnames(out) <- make.names(colnames(out), unique = TRUE)
    }
    out
}

#' @rdname makePerCellDF
#' @export
makePerCellDF.ExpressionSet <- function(x,
                                        features = TRUE,
                                        assay = NULL,
                                        swap_rownames = NULL,
                                        use_coldata = TRUE,
                                        ...,
                                        check_names = FALSE) {
    rlang::check_dots_empty()
    assert_bool(check_names)
    out <- harvest_by_extra_data(x,
        features = features,
        use_extra_data = use_coldata,
        swap_rownames = swap_rownames,
        assay_data = Biobase::assayData(x)[[assay %||% "exprs"]],
        rowdata = Biobase::fData(x),
        extra_data = Biobase::pData(x),
        transpose = TRUE
    )
    if (check_names) {
        colnames(out) <- make.names(colnames(out), unique = TRUE)
    }
    out
}

#' @param layer A string indicates the layer to get.
#' @rdname makePerCellDF
#' @export
makePerCellDF.Seurat <- function(x,
                                 features = TRUE,
                                 assay = NULL, layer = NULL,
                                 swap_rownames = NULL,
                                 use_coldata = TRUE,
                                 ...,
                                 check_names = FALSE) {
    rlang::check_dots_empty()
    assert_string(layer, empty_ok = FALSE, null_ok = TRUE)
    assert_bool(check_names)
    assay <- assay %||% SeuratObject::DefaultAssay(x)
    assay <- x[[assay]]
    assay_data <- SeuratObject::GetAssayData(assay, layer = layer)
    out <- harvest_by_extra_data(x,
        features = features,
        use_extra_data = use_coldata,
        swap_rownames = swap_rownames,
        assay_data = assay_data,
        rowdata = assay@meta.features,
        extra_data = x@meta.data,
        transpose = TRUE
    )
    if (check_names) {
        colnames(out) <- make.names(colnames(out), unique = TRUE)
    }
    out
}
