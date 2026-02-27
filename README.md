# Reproducible code for: *Natural history societies as stewards of biodiversity data: lessons from arachnology for improving quality, access and trust*

This repository provides the data and R code required to **reproduce the citation trend figure** presented in the article:

**Natural history societies as stewards of biodiversity data: lessons from arachnology for improving quality, access and trust**

Specifically, the workflow generates a two-panel figure comparing yearly citation counts for:
- **AraGes Atlas** citations
- **ARAMOB** citations (derived from GBIF)

Running the script will recreate the exported publication-ready graphic.

---

## Repository contents

├── atlas_citations.csv
├── gbif_aramob_citations.csv
├── citation_trends.R
└── README.md


### Input data
- `atlas_citations.csv`  
  Citation records for the AraGes Atlas.

- `gbif_aramob_citations.csv`  
  Citation records for ARAMOB derived from GBIF metadata.
  
### Output
- `plot_scale3_300dpi.png`  
  Two-panel citation trend figure exported at **300 dpi**.

---

## Requirements

R (tested with a recent R version) and the following packages:
- `here`
- `dplyr`
- `ggplot2`
- `patchwork`
- `scales`

Install dependencies in R:

```r
install.packages(c("here", "dplyr", "ggplot2", "patchwork", "scales"))
