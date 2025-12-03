# Oceanic Carbonate Modeling

A Solely Satellite-Based Approach to Monitoring the Oceanic Carbonate System

## Overview

This project presents a machine learning-based approach to predict key oceanic carbonate system (OCS) parameters—**pH**, **Total Alkalinity (TA)**, **Dissolved Inorganic Carbon (DIC)**, and **Partial Pressure of CO₂ (pCO₂)**—using **solely satellite-derived data**. This research demonstrates the feasibility of monitoring ocean acidification and carbonate chemistry globally without relying on expensive and environmentally impactful in situ sampling methods.

## Key Findings

- **Random Forest (RF)** identified as the best-performing machine learning model across all OCS parameters
- Achieved high predictive accuracy when validated against multiple in situ datasets:
  - **DIC**: R² = 0.95, RMSE = 11.7 μmol kg⁻¹ (GLODAPv2)
  - **TA**: R² = 0.87, RMSE = 16.8 μmol kg⁻¹ (GLODAPv2)
  - **pH**: R² = 0.68, RMSE = 0.025 (GLODAPv2)
  - **pCO₂**: R² = 0.70, RMSE = 18.6 μatm (LDEO)
- Performance comparable to or better than existing in situ-based modeling approaches
- Provides a cost-effective, environmentally friendly alternative to traditional ocean monitoring

## Background

Ocean acidification (OA) poses a significant threat to marine ecosystems, particularly calcifying organisms like corals and mollusks. Traditional monitoring methods rely on expensive ship-based sampling or autonomous sensors, which have limitations including:

- High deployment and operational costs
- Low spatiotemporal resolution
- Environmental impact (CO₂ emissions from research vessels)
- Sparse geographic coverage

This project addresses these limitations by developing a solely satellite-based monitoring approach using machine learning.

## Repository Structure

```
oceanic-carbonate-modeling/
├── dataset-processing/          # Data preprocessing and construction
│   ├── DatasetConstruction.ipynb      # Building training datasets
│   ├── DatasetPreprocessing.ipynb     # Preprocessing satellite data
│   └── SatelliteDataAggregation.ipynb # Aggregating multi-source satellite data
├── model-training/              # Machine learning model training
│   ├── DICTraining.ipynb             # Dissolved Inorganic Carbon model
│   ├── pCO2Training.ipynb            # Partial pressure of CO₂ model
│   ├── pHTraining.ipynb              # pH model
│   └── TATraining.ipynb              # Total Alkalinity model
├── utils/                       # Utility scripts for data processing
│   ├── clean_nc.sh                   # NetCDF file cleaning
│   ├── remap_1440720.sh              # Spatial remapping utilities
│   ├── remap_files.sh                # Batch remapping script
│   └── resample_nc.sh                # Temporal resampling
├── research-paper/              # Published research paper
│   └── Oceanic Carbonate Modeling Research Paper.pdf
└── README.md
```

## Data Sources

### Satellite Data (2011-2024)

Satellite observations were obtained from multiple missions with monthly temporal resolution:

- **AQUA-MODIS**: Sea Surface Temperature (SST), Chlorophyll-a (Chla), Particulate Inorganic Carbon (PIC), Particulate Organic Carbon (POC)
- **METOP-ASCAT** (METOP-A/B/C): Wind speed components (u-wind, v-wind)
- **OISSS** (Aquarius/SAC-D, SMAP, SMOS): Sea Surface Salinity (SSS)

All data resampled to 0.25° × 0.25° spatial resolution using bilinear interpolation.

### Target Data

OCS parameters obtained from:
- **CMEMS** (Copernicus Marine Environment Monitoring Service) Global Ocean Surface Carbon Product
  - Gridded product: 0.25° × 0.25° resolution
  - Monthly temporal resolution
  - Parameters: pH, TA, DIC, pCO₂

### Validation Datasets

In situ validation performed against multiple high-quality datasets:

| Dataset | Parameters | Description |
|---------|-----------|-------------|
| **GLODAPv2** | TA, DIC, pH | Global ocean data with high spatial distribution |
| **HOT** | TA, DIC | Hawaiian Ocean Time-series (22.57°N, 158°W) |
| **BATS** | TA, DIC | Bermuda Atlantic Time-series (32°N, 64°W) |
| **LDEO** | pCO₂ | Global surface pCO₂ measurements |
| **SOCAT** | pCO₂ | Surface Ocean CO₂ Atlas |
| **SOCCOM** | pH | Southern Ocean autonomous float measurements |

## Methodology

### Machine Learning Models Evaluated

Five models were systematically tested and compared:

1. **Random Forest (RF)** ✓ Best performance
2. **XGBoost (XGB)** - Second best
3. **K-Nearest Neighbors (KNN)**
4. **Feed-forward Neural Networks (FFNN)**
5. **Linear Regression (LR)**

### Feature Engineering

Selected features varied by parameter but included:
- Geographic coordinates (latitude, longitude, trigonometric transformations)
- Sea surface temperature (SST)
- Sea surface salinity (SSS)
- Chlorophyll-a concentration (Chla, log-transformed)
- Wind speed and direction
- Particulate carbon ratios (PIC:POC)
- Temporal features (month, with sinusoidal encoding)

### Model Training

- **Training data**: 2011-2018 (~40M data points)
- **Validation data**: 2019-2020 (~10M data points)
- **Testing data**: 2021-2022 (~10M data points)
- Temporal split used to prevent information leakage and reduce autocorrelation
- Feature selection via importance analysis and correlation analysis
- Hyperparameter tuning via grid search

### Evaluation Metrics

- **R²** (Coefficient of Determination): Variance explained by model
- **RMSE** (Root Mean Square Error): Average prediction error magnitude
- **MB** (Mean Bias): Average prediction offset

## Results Summary

### Model Performance Comparison (Testing Set)

| Parameter | RF R² | RF RMSE | Best Alternative | Alt. R² |
|-----------|-------|---------|------------------|---------|
| **TA** | 0.94 | 11.5 μmol kg⁻¹ | XGBoost | 0.94 |
| **DIC** | 0.97 | 9.8 μmol kg⁻¹ | XGBoost | 0.96 |
| **pH** | 0.75 | 0.022 | XGBoost | 0.74 |
| **pCO₂** | 0.74 | 16.2 μatm | XGBoost | 0.73 |

### Regional Performance

Performance varied across ocean basins:
- **Strongest**: Atlantic, Pacific, and Indian Oceans
- **Weakest**: Arctic Ocean (limited data, ice cover complexity)
- **Moderate**: Southern Ocean (for pH/pCO₂ due to sea ice-air interactions)

### In Situ Validation Highlights

Random Forest achieved validation results comparable to or exceeding current state-of-the-art in situ-based methods:

- **DIC (GLODAPv2)**: Outperformed GRaCER (R² 0.95 vs 0.93) and NNGv2 (R² 0.95 vs 0.82)
- **pCO₂ (LDEO)**: Significantly better than GRaCER (R² 0.70 vs 0.45) and LIAR+FFNN (R² 0.70 vs 0.44)
- **TA and pH**: Competitive with or exceeding existing methods

## Applications

This satellite-based approach enables:

- **Global ocean acidification monitoring** at high spatiotemporal resolution
- **Long-term trend analysis** of oceanic carbon chemistry
- **Cost-effective alternative** to expensive in situ campaigns
- **Environmentally friendly** monitoring (no ship-based emissions)
- **Data gap filling** in undersampled ocean regions
- **Climate change impact assessment** on marine ecosystems

## Limitations and Future Work

### Current Limitations

1. **Training data**: Relies on modeled carbonate data rather than pure in situ measurements
2. **Temporal resolution**: Monthly averages may miss short-term variability
3. **Regional challenges**: Lower accuracy in Arctic and Southern Oceans
4. **Temporal coverage**: 8-year training period may limit multi-year trend learning

### Future Directions

- Incorporate higher temporal resolution data (weekly/daily)
- Expand training dataset temporal range
- Test additional machine learning architectures (e.g., deep learning, ensemble methods)
- Implement spatiotemporal cross-validation
- Integrate additional satellite-derived features
- Develop real-time monitoring products

## Acknowledgments

This research utilized data from:
- NASA AQUA-MODIS mission
- EUMETSAT METOP-ASCAT program
- NASA Aquarius/SAC-D, SMAP missions
- ESA SMOS mission
- Copernicus Marine Environment Monitoring Service (CMEMS)
- Global Ocean Data Analysis Project (GLODAP)
- Lamont-Doherty Earth Observatory (LDEO)
- Hawaiian Ocean Time-series (HOT) and Bermuda Atlantic Time-series (BATS)
- Southern Ocean Carbon and Climate Observations and Modeling (SOCCOM)
- Surface Ocean CO₂ Atlas (SOCAT)

## Contact

William Feng - william.feng@yale.edu, 984-244-4085

## References

See the full research paper in `research-paper/` for complete references and methodology details.
