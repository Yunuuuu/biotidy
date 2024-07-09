#' Create a per-feature data.frame
#'
#' Create a per-feature data.frame (i.e., where each row represents a feature /
#' gene) from a
#' [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment], most
#' typically for creating custom ggplot2 plots.
#' @inheritParams makePerCellDF
#' @param use_rowdata Logical scalar indicating whether feature metadata of `x`
#' should be included. Alternatively, a character or integer vector specifying
#' the feature metadata fields to use.
#' @inherit makePerCellDF return
#' @name makePerFeatureDF
#' @export
makePerFeatureDF <- function(x, ...) UseMethod("makePerFeatureDF")

#' @rdname makePerFeatureDF
#' @export
makePerFeatureDF.SummarizedExperiment <- function(x,
                                                  features = TRUE,
                                                  assay = NULL,
                                                  swap_rownames = NULL,
                                                  use_rowdata = TRUE,
                                                  ...,
                                                  check_names = FALSE) {
    rlang::check_dots_empty()
    assert_bool(check_names)
    rowdata <- SummarizedExperiment::rowData(x)
    out <- harvest_by_extra_data(x,
        features = features,
        use_extra_data = use_rowdata,
        swap_rownames = swap_rownames,
        assay_data = SummarizedExperiment::assay(x, assay %||% 1L),
        rowdata = rowdata, extra_data = rowdata,
        transpose = FALSE
    )
    if (check_names) {
        colnames(out) <- make.names(colnames(out), unique = TRUE)
    }
    out
}

#' @rdname makePerFeatureDF
#' @export
makePerFeatureDF.SingleCellExperiment <- function(x,
                                                  features = TRUE,
                                                  assay = NULL,
                                                  swap_rownames = NULL,
                                                  use_rowdata = TRUE,
                                                  ...,
                                                  use_altexps = FALSE,
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
    rowdata <- SummarizedExperiment::rowData(x)
    out <- harvest_by_extra_data(x,
        features = features,
        use_extra_data = use_rowdata,
        swap_rownames = swap_rownames,
        assay_data = SummarizedExperiment::assay(x, assay),
        rowdata = rowdata,
        extra_data = rowdata,
        transpose = FALSE
    )
    if (length(use_altexps)) {
        all_alts <- SingleCellExperiment::altExps(x)[use_altexps]
        alt_vals <- vector("list", length(all_alts))

        for (i in seq_along(alt_vals)) {
            curalt <- makePerFeatureDF(
                # if this is a `SingleCellExperiment`
                # we have make `use_altexps` to default `FALSE`
                # so we can re-call this function directly
                # in this way, `altExps` in alternative experiment won't be used
                all_alts[[i]],
                features = features,
                assay = assay,
                swap_rownames = swap_rownames,
                use_rowdata = use_rowdata,
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

#' @rdname makePerFeatureDF
#' @export
makePerFeatureDF.ExpressionSet <- function(x,
                                           features = TRUE,
                                           assay = NULL,
                                           swap_rownames = NULL,
                                           use_rowdata = TRUE,
                                           ...,
                                           check_names = FALSE) {
    rlang::check_dots_empty()
    assert_bool(check_names)
    rowdata <- Biobase::fData(x)
    out <- harvest_by_extra_data(x,
        features = features,
        use_extra_data = use_rowdata,
        swap_rownames = swap_rownames,
        assay_data = Biobase::assayData(x)[[assay %||% "exprs"]],
        rowdata = rowdata,
        extra_data = rowdata,
        transpose = FALSE
    )
    if (check_names) {
        colnames(out) <- make.names(colnames(out), unique = TRUE)
    }
    out
}

#' @rdname makePerFeatureDF
#' @export
makePerFeatureDF.Seurat <- function(x,
                                    features = TRUE,
                                    assay = NULL, layer = NULL,
                                    swap_rownames = NULL,
                                    use_rowdata = TRUE,
                                    ...,
                                    check_names = FALSE) {
    rlang::check_dots_empty()
    assert_string(layer, empty_ok = FALSE, null_ok = TRUE)
    assert_bool(check_names)
    assay <- assay %||% SeuratObject::DefaultAssay(x)
    assay <- x[[assay]]
    assay_data <- SeuratObject::GetAssayData(assay, layer = layer)
    rowdata <- assay@meta.features
    out <- harvest_by_extra_data(x,
        features = features,
        use_extra_data = use_rowdata,
        swap_rownames = swap_rownames,
        assay_data = assay_data,
        rowdata = rowdata,
        extra_data = rowdata,
        transpose = TRUE
    )
    if (check_names) {
        colnames(out) <- make.names(colnames(out), unique = TRUE)
    }
    out
}
