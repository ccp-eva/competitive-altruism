#!/usr/bin/Rscript
library(rmarkdown)
rmarkdown::render("model_summaries.Rmd", "pdf_document", clean=FALSE)
