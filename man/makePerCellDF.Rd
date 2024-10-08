% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/makePerCellDF.R
\name{makePerCellDF}
\alias{makePerCellDF}
\alias{makePerCellDF.SummarizedExperiment}
\alias{makePerCellDF.SingleCellExperiment}
\alias{makePerCellDF.ExpressionSet}
\alias{makePerCellDF.Seurat}
\title{Create a per-cell data.frame}
\usage{
makePerCellDF(x, ...)

\method{makePerCellDF}{SummarizedExperiment}(
  x,
  features = TRUE,
  assay = NULL,
  swap_rownames = NULL,
  use_coldata = TRUE,
  ...,
  melt = FALSE,
  keep_rownames = FALSE,
  make_unique = FALSE
)

\method{makePerCellDF}{SingleCellExperiment}(
  x,
  features = TRUE,
  assay = NULL,
  swap_rownames = NULL,
  use_coldata = TRUE,
  ...,
  use_altexps = TRUE,
  prefix_altexps = FALSE,
  melt = FALSE,
  keep_rownames = FALSE,
  make_unique = FALSE
)

\method{makePerCellDF}{ExpressionSet}(
  x,
  features = TRUE,
  assay = NULL,
  swap_rownames = NULL,
  use_coldata = TRUE,
  ...,
  melt = FALSE,
  keep_rownames = FALSE,
  make_unique = FALSE
)

\method{makePerCellDF}{Seurat}(
  x,
  features = TRUE,
  assay = NULL,
  layer = NULL,
  swap_rownames = NULL,
  use_coldata = TRUE,
  ...,
  melt = FALSE,
  keep_rownames = FALSE,
  make_unique = FALSE
)
}
\arguments{
\item{x}{A
\link[SummarizedExperiment:RangedSummarizedExperiment-class]{SummarizedExperiment},
\link[SingleCellExperiment:SingleCellExperiment]{SingleCellExperiment},
\link[Biobase:class.ExpressionSet]{ExpressionSet} or
\link[SeuratObject:Seurat-class]{Seurat} object.}

\item{...}{Not used currently.}

\item{features}{Logical scalar indicating whether feature assay data of \code{x}
should be included. Alternatively, Character or integer vector specifying the
features for which to extract expression profiles across samples.}

\item{assay}{String or integer scalar indicating the assay to use to obtain
expression values. Must refer to a matrix-like object with integer or numeric
values. If \code{NULL}, the default assay will be used:
\itemize{
\item \link[SummarizedExperiment:RangedSummarizedExperiment-class]{SummarizedExperiment}: the
\verb{1st} assay
\item \link[Biobase:class.ExpressionSet]{ExpressionSet}: assay from
\link[Biobase:exprs]{exprs}
\item \link[SeuratObject:Seurat-class]{Seurat}:
assay from \link[SeuratObject:DefaultAssay]{DefaultAssay}
}}

\item{swap_rownames}{String or integer specifying the feature metadata column
containing the features names. If \code{NULL}, \code{rownames(x)} will be used.}

\item{use_coldata}{Logical scalar indicating whether column metadata of \code{x}
should be included. Alternatively, a character or integer vector specifying
the column metadata fields to use.}

\item{melt}{A single boolean value indicates whether the \code{features} should be
reshaped into long-format. A column named \code{".features"} will contain all
feature names and a column named \code{".assay"} will contain all feature assay
values. You can also specify a string indicates the column \code{".assay"} or a
character with length 2 indicates the column names of \code{".features"} and
\code{".assay"}.}

\item{keep_rownames}{If \code{melt} is not \code{NULL}, the rownames will be omitted,
this argument retains the data.frame's row names under a new column \code{".id"},
You can also specify a string to names the column of the rownames.}

\item{make_unique}{A boolean value indicating whether column names of the
output should be made unique.}

\item{use_altexps}{A boolean value indicating whether (meta)data should be
extracted for \link[SingleCellExperiment:altExps]{alternative} experiments in
\code{x}.}

\item{prefix_altexps}{A boolean value indicating whether
\link[SingleCellExperiment:altExps]{altExp}-derived fields should be prefixed
with the name of the alternative Experiment.}

\item{layer}{A string indicates the layer to get.}
}
\value{
A \link{data.frame}.
}
\description{
Create a per-cell data.frame (i.e., where each row represents a sample /
cell) from a \code{x}.
}
\examples{
# SummarizedExperiment method
mocked_se <- mockSE(5, 10)
makePerCellDF(mocked_se)
makePerCellDF(mocked_se, melt = TRUE)
makePerCellDF(mocked_se, melt = TRUE, keep_rownames = TRUE)
makePerCellDF(mocked_se, features = FALSE, use_coldata = FALSE)

# SingleCellExperiment method
mocked_sce <- mockSCE(5, 10)
makePerCellDF(mocked_sce)
makePerCellDF(mocked_sce, melt = TRUE)
makePerCellDF(mocked_sce, melt = TRUE, keep_rownames = TRUE)
makePerCellDF(mocked_sce, features = FALSE, use_coldata = FALSE)

# ExpressionSet method
mocked_es <- mockES(5, 10)
makePerCellDF(mocked_es)
makePerCellDF(mocked_es, melt = TRUE)
makePerCellDF(mocked_es, melt = TRUE, keep_rownames = TRUE)
makePerCellDF(mocked_es, features = FALSE, use_coldata = FALSE)

# Seurat method
mocked_seurat <- mockSeurat(5, 10)
makePerCellDF(mocked_seurat)
makePerCellDF(mocked_seurat, layer = "counts", melt = TRUE)
makePerCellDF(mocked_seurat,
    layer = "counts", melt = TRUE, keep_rownames = TRUE
)
makePerCellDF(mocked_seurat,
    layer = "counts", features = FALSE,
    use_coldata = FALSE
)
}
