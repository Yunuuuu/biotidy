`%||%` <- function(x, y) if (is.null(x)) y else x

#' @param assay_data A data.frame of assay data
#' @param rowdata A data.frame of feature data, used to define the features.
#' Only used when `swap_rownames` is not `NULL`.
#' @param extra_data A data.frame of extra data to be added into the output.
#' @noRd
harvest_by_extra_data <- function(x, features,
                                  use_extra_data = TRUE,
                                  swap_rownames = NULL,
                                  transpose, assay_data, rowdata, extra_data, call = rlang::caller_env()) {
    assay_data <- make_assay_df(
        x = x, features = features,
        swap_rownames = swap_rownames,
        assay_data = assay_data,
        rowdata = rowdata,
        transpose = transpose,
        call = call
    )
    use_extra_data <- use_integer_indices(
        use_extra_data,
        names = colnames(extra_data),
        call = call
    )
    if (length(use_extra_data)) {
        extra_data <- data.frame(extra_data,
            check.names = FALSE, fix.empty.names = FALSE
        )
        extra_data <- extra_data[, use_extra_data, drop = FALSE]
        cbind(assay_data, extra_data)
    } else {
        assay_data
    }
}

make_assay_df <- function(x, features, swap_rownames,
                          assay_data, rowdata, transpose,
                          call = rlang::caller_env()) {
    arg1 <- rlang::caller_arg(swap_rownames)
    arg2 <- rlang::caller_arg(features)
    assert_(swap_rownames, function(x) {
        length(x) == 1L && (is.character(x) || is.numeric(x))
    }, "a single string or integer", null_ok = TRUE, call = call)

    # Collecting feature data from assay
    if (is.null(swap_rownames)) {
        all_features <- rownames(x)
    } else {
        swap_rownames <- use_integer_indices(
            swap_rownames, colnames(rowdata),
            arg = arg1, call = call
        )
        all_features <- rowdata[[swap_rownames]]
    }
    features <- use_integer_indices(
        features, all_features,
        arg = arg2, call = call
    )
    if (length(features)) {
        assay_data <- assay_data[features, , drop = FALSE]
        if (transpose) assay_data <- t(assay_data)
        assay_data <- data.frame(as.matrix(assay_data),
            check.names = FALSE, fix.empty.names = FALSE
        )
        if (transpose) {
            rownames(assay_data) <- colnames(x)
            colnames(assay_data) <- all_features[features]
        } else {
            rownames(assay_data) <- all_features[features]
            colnames(assay_data) <- colnames(x)
        }
    } else {
        assay_data <- NULL
    }
    assay_data
}

use_integer_indices <- function(use, names, bool_ok = TRUE,
                                arg = rlang::caller_arg(use),
                                call = rlang::caller_env()) {
    force(arg)
    if (anyNA(use)) {
        rlang::abort(
            sprintf("%s cannot contain `NA`", style_arg(arg)),
            call = call
        )
    }
    if (is.logical(use)) {
        if (bool_ok) {
            if (isTRUE(use)) {
                use <- seq_along(names)
            } else if (isFALSE(use)) {
                use <- integer(0L)
            } else {
                rlang::abort(sprintf(
                    "%s must be a single boolean value", style_arg(arg)
                ), call = call)
            }
        } else {
            rlang::abort(sprintf(
                "%s must be an atomic numeric/character",
                style_arg(arg)
            ), call = call)
        }
    } else if (is.character(use)) {
        index <- match(use, names)
        if (anyNA(index)) {
            rlang::abort(sprintf(
                "%s contains invalid values (%s)",
                style_arg(arg), style_val(use[is.na(index)])
            ), call = call)
        }
        use <- index
    } else if (is.numeric(use)) {
        if (any(use < 1L) || any(use > length(names))) {
            rlang::abort(sprintf(
                "%s contains out-of-bounds indices", style_arg(arg)
            ), call = call)
        }
    } else {
        rlang::abort(sprintf(
            "%s must be %s", style_arg(arg),
            if (bool_ok) {
                "a single boolean value or an atomic numeric/character"
            } else {
                "an atomic numeric/character"
            }
        ), call = call)
    }
    use
}
