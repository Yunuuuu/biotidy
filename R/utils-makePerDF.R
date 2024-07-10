#' @param assay_data A data.frame of assay data
#' @param feature_meta A data.frame of feature data, used to define the
#' features. Only used when `swap_rownames` is not `NULL`.
#' @param extra_data A data.frame of extra data to be added into the output.
#' @return A data.frame.
#' @noRd
harvest_by_extra_data <- function(assay_data, use_features,
                                  swap_rownames, feature_meta,
                                  extra_data, use_extra_data,
                                  transpose, melt,
                                  keep_rownames = NULL,
                                  call = rlang::caller_env()) {
    if (!is.list(assay_data)) assay_data <- list(assay_data)
    if (!is.list(feature_meta)) feature_meta <- list(feature_meta)
    all_features <- get_feature_names(
        assay_data, swap_rownames, feature_meta,
        arg = rlang::caller_arg(swap_rownames),
        call = call
    )
    melt <- make_melt_names(melt, transpose, call = call)
    use_features <- use_integer_indices(
        all_features, use_features,
        arg = rlang::caller_arg(use_features),
        call = call
    )
    assay_data <- use_assay_data(assay_data, use_features, transpose)
    extra_data <- use_columns(
        extra_data,
        use = use_extra_data,
        arg = rlang::caller_arg(use_extra_data),
        call = call
    )
    if (!transpose) extra_data <- extra_data[use_features, , drop = FALSE]
    out <- cbind(assay_data, extra_data)
    if (!is.null(melt) && nrow(out) && ncol(assay_data)) {
        keep_rownames <- keep_rownames %||% FALSE
        if (isTRUE(keep_rownames)) keep_rownames <- ".id"
        data.table::setDT(out, keep.rownames = keep_rownames)
        out <- data.table::melt(out,
            measure.vars = colnames(assay_data),
            variable.name = .subset(melt, 1L),
            value.name = .subset(melt, 2L)
        )
        data.table::setDF(out)
    }
    out
}

sce_assays <- function(x, assay, use_altexps, prefix_altexps,
                       arg = rlang::caller_arg(use_altexps),
                       call = rlang::caller_env()) {
    assert_bool(prefix_altexps,
        arg = rlang::caller_arg(prefix_altexps), call = call
    )
    use_altexps <- use_integer_indices(
        SingleCellExperiment::altExpNames(x),
        use_altexps,
        arg = arg, call = call
    )
    assay <- assay %||% 1L
    assay_data <- SummarizedExperiment::assay(x, assay)
    feature_meta <- SummarizedExperiment::rowData(x)
    if (length(use_altexps)) {
        all_alts <- SingleCellExperiment::altExps(x)[use_altexps]
        alt_vals <- imap(all_alts, function(curalt, nm) {
            cur_assay_data <- SummarizedExperiment::assay(curalt, assay)
            if (prefix_altexps) {
                rownames(cur_assay_data) <- sprintf(
                    "%s.%s", nm, rownames(cur_assay_data)
                )
            }
            list(cur_assay_data, SummarizedExperiment::rowData(curalt))
        })
        alt_vals <- transpose(alt_vals)
        assay_data <- c(list(assay_data), .subset2(alt_vals, 1L))
        feature_meta <- c(list(feature_meta), .subset2(alt_vals, 2L))
    }
    list(assay_data, feature_meta)
}

make_melt_names <- function(melt, transpose, arg = rlang::caller_arg(melt),
                            call = rlang::caller_env()) {
    if (anyNA(melt)) {
        rlang::abort(sprintf(
            "%s cannot be %s", style_arg(arg), style_code("NA")
        ), call = call)
    }
    if (isTRUE(melt)) {
        melt <- ".assay"
    } else if (isFALSE(melt)) {
        melt <- NULL
    }
    if (is_scalar(melt)) {
        if (transpose) {
            melt <- c(".features", as.character(melt))
        } else {
            melt <- c(".cells", as.character(melt))
        }
    } else if (length(melt) == 2L) {
        melt <- as.character(melt)
    } else if (!is.null(melt)) {
        rlang::abort(sprintf(
            "%s must be a single boolean value or a character of length %s",
            style_arg(arg), "less than 3"
        ), call = call)
    }
    melt
}

use_assay_data <- function(assay_data, use_features, transpose) {
    if (length(assay_data) == 1L) {
        assay_data <- .subset2(assay_data, 1L)
    } else {
        assay_data <- do.call(rbind, assay_data)
    }
    # dimnames(assay_data) <- list(features, colnames(x))
    assay_data <- as.matrix(assay_data[use_features, , drop = FALSE])
    if (transpose) assay_data <- t(assay_data)
    data_frame0(assay_data)
}

get_feature_names <- function(assay_data, swap_rownames, feature_meta,
                              arg = rlang::caller_arg(swap_rownames),
                              call = rlang::caller_env()) {
    if (is.null(swap_rownames)) {
        out <- lapply(assay_data, rownames)
    } else {
        if (is_scalar(swap_rownames)) {
            swap_rownames <- rep_len(swap_rownames, length(assay_data))
        } else if (length(swap_rownames) != length(assay_data)) {
            rlang::abort(sprintf(
                "%s must be of length 1 or of the same length of %s",
                style_arg(arg), "all assays (including alternative experiment)"
            ), call = call)
        }
        out <- .mapply(function(x, y) {
            use_single_column(x, y,
                "feature metadata",
                arg = arg, call = call
            )
        }, list(feature_meta, swap_rownames), NULL)
    }
    unlist(out, FALSE, FALSE)
}

use_single_column <- function(data, use, source,
                              arg = rlang::caller_arg(use),
                              call = rlang::caller_env()) {
    assert_(use, function(x) is_scalar(x) && (is.character(x) || is.numeric(x)),
        "a single string or numeric",
        arg = arg, call = call
    )
    if (is.na(use)) {
        rlang::abort(sprintf(
            "%s cannot be %s", style_arg(arg), style_code("NA")
        ), call = call)
    }
    if (is.null(out <- .subset2(data, use))) {
        rlang::abort(c(
            sprintf("Cannot find %s in %s", style_val(use), source),
            i = sprintf("%s contains out-of-bounds index", style_arg(arg))
        ), call = call)
    }
    out
}
