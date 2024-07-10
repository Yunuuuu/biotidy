`%||%` <- function(x, y) if (is.null(x)) y else x

is_scalar <- function(x) length(x) == 1L

# purrr-like function -------------------------------
map2 <- function(.x, .y, .f, ..., USE.NAMES = FALSE) {
    mapply(.f, .x, .y, MoreArgs = list(...), # styler: off
        SIMPLIFY = FALSE, USE.NAMES = USE.NAMES
    )
}

imap <- function(.x, .f, ..., USE.NAMES = FALSE) {
    map2(.x, names(.x) %||% seq_along(.x), .f, ..., USE.NAMES = USE.NAMES)
}

transpose <- function(.l) {
    if (!length(.l)) return(.l) # styler: off

    inner_names <- names(.l[[1]])
    if (is.null(inner_names)) {
        fields <- seq_along(.l[[1]])
    } else {
        fields <- inner_names
        names(fields) <- fields
        .l <- lapply(.l, function(x) {
            if (is.null(names(x))) names(x) <- inner_names # styler: off
            x
        })
    }

    # This way missing fields are subsetted as `NULL` instead of causing
    # an error
    .l <- lapply(.l, as.list)

    lapply(fields, function(i) lapply(.l, .subset2, i))
}

data_frame0 <- function(...) {
    data.frame(...,
        check.names = FALSE,
        fix.empty.names = FALSE, stringsAsFactors = FALSE
    )
}

use_columns <- function(data, use, columns = names(data),
                        arg = rlang::caller_arg(use),
                        call = rlang::caller_env()) {
    use <- use_integer_indices(columns, use, arg = arg, call = call)
    if (length(use)) {
        data[use]
    } else {
        data_frame0(row.names = rownames(data))
    }
}

use_integer_indices <- function(all, use,
                                arg = rlang::caller_arg(use),
                                call = rlang::caller_env()) {
    force(arg)
    if (anyNA(use)) {
        rlang::abort(
            sprintf("%s cannot contain %s", style_arg(arg), style_code("NA")),
            call = call
        )
    }
    if (is.logical(use)) {
        if (isTRUE(use)) {
            use <- seq_along(all)
        } else if (isFALSE(use)) {
            use <- integer(0L)
        } else {
            rlang::abort(sprintf(
                "%s must be a single boolean value", style_arg(arg)
            ), call = call)
        }
    } else if (is.character(use)) {
        index <- match(use, all)
        if (anyNA(index)) {
            rlang::abort(sprintf(
                "%s contains invalid values: %s",
                style_arg(arg), style_val(use[is.na(index)])
            ), call = call)
        }
        use <- index
    } else if (is.numeric(use)) {
        if (any(use < 1L) || any(use > length(all))) {
            rlang::abort(sprintf(
                "%s contains out-of-bounds indices", style_arg(arg)
            ), call = call)
        }
    } else {
        rlang::abort(sprintf(
            "%s must be %s", style_arg(arg),
            "a single boolean value or an atomic numeric/character"
        ), call = call)
    }
    use
}
