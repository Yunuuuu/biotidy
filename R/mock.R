#' Mock up sequencing counts data
#'
#' Mock up a [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment],
#' [SingleCellExperiment][SingleCellExperiment::SingleCellExperiment],
#' [ExpressionSet][Biobase::ExpressionSet] or
#' [Seurat][SeuratObject::Seurat-class] object containing simulated data.
#'
#' @param ncells An integer scalar, number of cells to simulate.
#' @param ngenes An integer scalar, number of genes to simulate.
#' @param nspikes An integer scalar, number of spike-in transcripts to simulate.
#' If `NULL`, no spike data will be added.
#' @name mock
NULL

#' @return
#' - `mockES`: A [ExpressionSet][Biobase::ExpressionSet] object.
#' @rdname mock
#' @export
mockES <- function(ncells = 200, ngenes = 2000) {
    data <- mock_data(ncells, ngenes, NULL)
    Biobase::ExpressionSet(
        .subset2(data, "counts"),
        phenoData = Biobase::AnnotatedDataFrame(.subset2(data, "metadata"))
    )
}

#' @return
#' - `mockSE`: A
#'   [SummarizedExperiment][SummarizedExperiment::SummarizedExperiment] object.
#' @rdname mock
#' @export
mockSE <- function(ncells = 200, ngenes = 2000) {
    data <- mock_data(ncells, ngenes, NULL)
    SummarizedExperiment::SummarizedExperiment(
        list(counts = .subset2(data, "counts")),
        colData = .subset2(data, "metadata")
    )
}

#' @return
#' - `mockSCE`: A
#'   [SingleCellExperiment][SingleCellExperiment::SingleCellExperiment] object.
#' @rdname mock
#' @export
mockSCE <- function(ncells = 200, ngenes = 2000, nspikes = 100) {
    data <- mock_data(ncells, ngenes, nspikes)
    out <- SingleCellExperiment::SingleCellExperiment(
        list(counts = .subset2(data, "counts")),
        colData = .subset2(data, "metadata")
    )
    if (!is.null(nspikes)) {
        SingleCellExperiment::altExp(out, "Spikes") <- SingleCellExperiment::SingleCellExperiment(
            list(counts = .subset2(data, "spike"))
        )
    }
    out
}

#' @return
#' - `mockSeurat`: A [Seurat][SeuratObject::Seurat-class] object.
#' @rdname mock
#' @export
mockSeurat <- function(ncells = 200, ngenes = 2000) {
    data <- mock_data(ncells, ngenes, NULL)
    SeuratObject::CreateSeuratObject(
        methods::as(.subset2(data, "counts"), "dgCMatrix"),
        meta.data = .subset2(data, "metadata")
    )
}

mock_data <- function(ncells = 200, ngenes = 2000, nspikes = 100) {
    cell_means <- 2^stats::runif(ngenes, 2, 10)
    cell_disp <- 100 / cell_means + 0.5
    cell_data <- matrix(
        stats::rnbinom(ngenes * ncells,
            mu = cell_means,
            size = 1 / cell_disp
        ),
        ncol = ncells
    )
    rownames(cell_data) <- sprintf(
        "Gene%s",
        formatC(seq_len(ngenes), width = 4, flag = 0)
    )
    colnames(cell_data) <- sprintf(
        "Cell%s",
        formatC(seq_len(ncells), width = 3, flag = 0)
    )
    metadata <- data.frame(
        Mutation_Status = sample(
            c("positive", "negative"), ncells,
            replace = TRUE
        ),
        Cell_Cycle = sample(
            c("S", "G0", "G1", "G2M"), ncells,
            replace = TRUE
        ),
        Treatment = sample(
            c("treat1", "treat2"), ncells,
            replace = TRUE
        ),
        row.names = colnames(cell_data)
    )
    out <- list(counts = cell_data, metadata = metadata)
    if (!is.null(nspikes)) {
        spike_means <- 2^stats::runif(nspikes, 3, 8)
        spike_disp <- 100 / spike_means + 0.5
        spike_data <- matrix(
            stats::rnbinom(nspikes * ncells,
                mu = spike_means,
                size = 1 / spike_disp
            ),
            ncol = ncells
        )
        rownames(spike_data) <- sprintf(
            "Spike_%s",
            formatC(seq_len(nspikes), width = 4, flag = 0)
        )
        colnames(spike_data) <- colnames(cell_data)
        out <- c(out, list(spike = spike_data))
    }
    out
}
