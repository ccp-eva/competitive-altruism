# Chimpanzees engage in competitive altruism in a triadic Ultimatum Game

This repository contains all the raw data, the statistical analysis code
and the plotting code used in authoring the paper "Chimpanzees engage in
competitive altruism in a triadic Ultimatum Game" by Sánchez-Amaro et al.  By
cloning the repository you can reproduce all the figures and essential
statistical numbers found in the paper.

The data and code are both licensed under the Creative Commons Attribution
copyright license, like the paper itself.  See the `LICENSE.md` file for
details.

## Replication quickstart guide:

After cloning the repository, the various `.R` scripts in the `analysis/` folder
should be run in the following order.  Note that all scripts expect to be run
with the `analysis/` folder as the working directory.

1. Run `data_reformat.R`.  This will produce a number of intermediary data files
   in the `data/` folder, all derived from the single raw data file
   `data/competitive_altruism_dataset.csv`.
2. Run each of the `fit_*.R` scripts.  They can be run in any order.  Each will
   fit one or more `brms` models and save the fitted models as `.rds` files.
   All further scripts require that these `.rds` to exist and will fail with
   errors if they do not.
3. Run the `knit_summary.R` script.  This will load all the saved model files
   from the previous step and produce a matching Markdown file
   (`model_summaries.knit.md`) and PDF file (`model_summaries.pdf`).  The model
   summaries included in the paper's Electronic Supplementary Material are
   precisely this PDF file.  The Markdown file produced from the model fits used
   for the published paper was committed to the repository prior to initial
   submission of the manuscript.  This means that if you re-fit the models, you
   can use `git diff` to easily confirm that your new numbers do not differ
   substantially from those seen in the paper.
4. Run each of the `plot_*.R` scripts.  They can be run in any order.  Each will
   save one or more figures in the `plots/` folder.  All figures used in the
   paper will be reproduced, plus some extras.  Minor differences may be visible
   between your reproduced figures and those in the paper, due to variations in
   MCMC model fits.

