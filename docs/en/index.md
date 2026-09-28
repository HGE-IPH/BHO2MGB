---
title: BHO2MGB Application Manual
lang: en-US
author: Large-Scale Hydrology Research Group (HGE/UFRGS)
date: May 2022
---

# 1. Overview

This manual describes how to use BHO2MGB, a plugin for QGIS. The tool prepares input data for the MGB hydrological model using the Ottocoded Hydrographic Base (BHO) provided by Brazil's National Water and Sanitation Agency (ANA).

**Authors**

- Rafael Barbedo
- Gabriel Matte Rios Fernandez
- Rafaela Cristina de Oliveira
- Leonardo Laipelt
- Fernando Fan
- Walter Collischonn

**Repository:** [github.com/hge-admin/BHO2MGB](https://github.com/hge-admin/BHO2MGB)

# 2. Introduction

The Large Basin Model (MGB; Collischonn et al., 2007) is a hydrological and hydrodynamic simulation model with an interface integrated into QGIS. It can simulate streamflow, evapotranspiration, and flooded areas, among other outputs.

During MGB preprocessing, a river basin is divided into smaller units called mini-catchments. Since 2016, the QGIS plugin IPH-Hydro Tools has provided a way to delineate these units from a digital elevation model (DEM) and collect the information required for simulation (Siqueira et al., 2016). This was traditionally the only way to preprocess an MGB model.

BHO2MGB provides another approach. It uses the existing information in the BHO, which represents Brazil's hydrographic network and is used by official agencies, including ANA. In the BHO, each river reach is associated with a drainage area called an *ottobacia*, which has a basin code based on the Otto Pfafstetter system.

The BHO2MGB plugin delineates mini-catchments from BHO reaches and polygons, so the IPH-Hydro Tools preprocessing step is unnecessary. BHO attributes already contain nearly all the information needed for MGB's main input file. Using ANA's official hydrographic network also makes it easier to transfer model results to that network for water resources management. In addition, delineating a basin from BHO data is much faster than processing a DEM with IPH-Hydro Tools.

This manual follows the BHO-based workflow from downloading input data through viewing simulation results, using Brazil's Carinhanha River basin as an example.

# 3. Download and installation

Download the plugin from the HGE releases page:

- https://github.com/HGE-IPH/BHO2MGB/releases

Open QGIS (latest tested version: 3.44). To install the plugin, open the **Plugins** menu and select **Manage and Install Plugins**, as shown in Figure 1.

![Plugins menu](../assets/figura-01.png)

**Figure 1. Plugins menu.**

Under **Install from ZIP**, select the downloaded `.zip` file in **ZIP file** and click **Install Plugin** (Figure 2).

![Plugin installation window](../assets/figura-02.png)

**Figure 2. Plugin installation window.**

Figure 3 shows the BHO2MGB icon in the QGIS toolbar after installation.

![BHO2MGB icon in the QGIS toolbar after installation](../assets/figura-03.jpg)

**Figure 3. BHO2MGB icon in the QGIS toolbar after installation.**

# 4. Application to the Carinhanha River basin

The following example applies BHO2MGB to the Carinhanha River basin, located between the Brazilian states of Minas Gerais and Bahia. It covers input data acquisition through MGB simulation.

Section 4.1.1 uses a WebGIS application backed by Google Earth Engine (GEE) to obtain the input data. Section 4.1.2 describes alternative sources, including ANA's metadata portal. Section 4.2 covers BHO preprocessing with the BHO2MGB plugin, and Section 4.3 uses the resulting files in MGB.

## 4.1. Obtaining input data

BHO2MGB requires BHO vector files (reaches and drainage areas), a DEM, and a map of hydrological response units (HRUs). A WebGIS application developed for BHO2MGB uses GEE as a data repository and makes it easier to extract these files for a selected basin.

The application can download all required input files and some auxiliary files for a basin selected by its BHO outlet. This is the recommended way to obtain the files. Alternative sources are also described below.

### 4.1.1. Using the Google Earth Engine (GEE) tool

GEE is a cloud computing platform that provides access to remote sensing datasets and tools for extracting and processing them.

Table 1 lists two ways to use GEE to extract BHO data for an MGB application. Both provide the same data and perform the same processing. The Code Editor can extract data for basins of any size. The Earth Engine App is simpler to use but is limited to basins with drainage areas of approximately 10,000–50,000 km² or less. The exact limit depends on basin shape and the resolution of the selected DEM.

**Table 1. Ways to extract BHO data for an MGB application using GEE.**

| Name | Link | Description | Characteristics |
|---|---|---|---|
| Code Editor | [Google Earth Engine](https://code.earthengine.google.com/65dd79c065e8a77cc49d148a426adfa3) | GEE code editor | More complex; supports larger basins. |
| Earth Engine App | [GEE application](https://bho2mgb.users.earthengine.app/view/mgbbhotoolkit) | GEE application without code access | Simpler; unsuitable for very large basins. |

The Code Editor version runs as code in GEE and exports downloads to the user's Google Drive account. The Earth Engine App hides the processing code and downloads files directly to the user's computer, usually faster, subject to its basin size limit.

In either version, the user identifies the basin outlet. The tool can extract:

- Vector files from ANA's Ottocoded Hydrographic Base;
- DEM rasters;
- Precipitation time series from gridded data; and
- Rasters of vegetation, slope, landscape units, and hydrological response classes.

Users can choose among several BHO versions, a selection of DEM products, and daily precipitation products (Table 2).

**Table 2. Products available through the GEE data extraction tool.**

| Data | Dataset | Version | Availability | Spatial resolution | Reference |
|---|---|---:|---|---|---|
| Precipitation estimates | GPM IMERG | 6 | 2000–present | 0.1° | Huffman et al., 2019 |
| Precipitation estimates | CHIRPS | 1 | 1981–present | 0.05° | Funk et al., 2015 |
| Precipitation estimates | GLDAS | 2.1 | 2000–present | 0.25° | Rodell et al., 2004 |
| Precipitation estimates | PERSIANN | 1 | 1983–present | 0.25° | Sorooshian et al., 2015 |
| Precipitation estimates | ERA5 | — | 1981–present | 0.1° | Hersbach et al., 2020 |
| Digital elevation models | MERIT | 1 | — | 3 arcseconds | Yamazaki et al., 2017 |
| Digital elevation models | SRTM | 4 | — | 3 arcseconds | Jarvis et al., 2008 |
| Digital elevation models | SRTM | 3 | — | 1 arcsecond | Farr et al., 2007 |
| Digital elevation models | NASADEM | 1 | — | 1 arcsecond | NASA JPL, 2020 |

The tool was developed in JavaScript in the GEE Code Editor. No programming knowledge is required: even the Code Editor version provides a graphical interface. Figure 4 shows its main menu.

![Main menu of the MGB-BHO Tool Kit](../assets/figura-04.png)

**Figure 4. Main menu of the MGB-BHO Tool Kit.**

First, select a BHO dataset. The selection panel offers the 50k, 5k, and 250 versions (Figure 5). This example uses BHO 250.

![Selecting the BHO dataset scale](../assets/figura-05.png)

**Figure 5. Selecting the BHO dataset scale.**

Next, select the basin outlet. Use **Map selection** to select its location on the map, or **Code selection** to enter the BHO Pfafstetter code (the `cobacia` attribute) of the outlet's BHO catchment. Figure 6 shows both options. The tool selects all BHO reaches and drainage areas upstream of that catchment. For the Carinhanha River basin, enter code `67658111`.

![Selecting the outlet by BHO code (left) or on the map (right)](../assets/figura-06.png)

**Figure 6. Selecting the outlet by BHO code (left) or on the map (right).**

In the second panel, choose a DEM from the available products. This example uses NASADEM 30 m (Figure 7).

![Selecting the DEM](../assets/figura-07.png)

**Figure 7. Selecting the DEM.**

In the third panel, select a precipitation product and the period to extract (Figure 8). This example uses CHIRPS data from 2000-01-01 through 2020-12-31.

![Selecting the precipitation product and period](../assets/figura-08.png)

**Figure 8. Selecting the precipitation product and period.**

Precipitation processing produces a `.csv` table containing a time series for each product grid cell within the basin. After further preprocessing, these data can be used as MGB input.

Finally, set the parameters for processing the hydrological landscape classes (HLCs). These are the year of the land-use classification map, a slope threshold for terrain classes, and a HAND height threshold for wetland classification. The fourth panel contains these settings (Figure 9). This example uses their default values.

![Parameters for processing hydrological landscape classes](../assets/figura-09.png)

**Figure 9. Parameters for processing hydrological landscape classes.**

After setting all inputs, click **Generate Watershed Delineation** to delineate the basin from BHO data, generate the precipitation grid, and process the HLCs (Figure 10).

![Tool output for the Carinhanha River basin](../assets/figura-10.jpg)

**Figure 10. Tool output for the Carinhanha River basin.**

The tool then displays buttons for its output and intermediate files (Figure 11). Click a file's button to display it on the GEE map.

![Buttons for viewing and downloading the generated data](../assets/figura-11.png)

**Figure 11. Buttons for viewing and downloading the generated data.**

In the Earth Engine App, clicking a button also creates a **Download** link beside it. Click the link to download the file directly to your computer.

In the Code Editor version, clicking **Download** creates a task under **Tasks**. Click **Run** there to start the export (Figure 12). The following steps use the BHO Area, BHO Stream, Precipitation GRID, DEM, and Hydrological Landscape Classes files.

![Downloading files from the Code Editor version](../assets/figura-12.png)

**Figure 12. Downloading files from the Code Editor version.**

### 4.1.2. Alternative sources for input data

BHO vector files are also available from ANA's Geospatial Metadata Portal: [BHO250](https://metadados.snirh.gov.br/geonetwork/srv/api/records/0f57c8a0-6a0f-4283-8ce3-114ba904b9fe), [BHO5k](https://metadados.snirh.gov.br/geonetwork/srv/api/records/f7b1fc91-f5bc-4d0d-9f4f-f4e5061e5d8f), [BHO50k](https://metadados.snirh.gov.br/geonetwork/srv/api/records/4fd91f0d-f34f-4fca-a961-c2dcb3e0446e), [multiscale BHO](https://metadados.snirh.gov.br/geonetwork/srv/api/records/0c698205-6b59-48dc-8b5e-a58a5dfcc989), and the [Atlas-Studies Hydrographic Base (BHAE)](https://metadados.snirh.gov.br/geonetwork/srv/por/catalog.search#/metadata/8ad07d33-1677-481d-bc61-ed5ca204926f). A DEM can come from another source if it covers the study area.

HRUs can be generated by any suitable method. For example, combine a DEM, soil maps, and land-cover maps to represent differences in terrain, soils, and land use. The resulting raster must use consecutive integer class values from 1 to N, which will later be incorporated into MGB.

## 4.2. Building the MGB input files

Click the BHO2MGB plugin icon to open its three tabs: **Step 1**, **Step 2**, and **Step 3** (Figure 13). Step 1 defines subbasins within the study area. You can skip this step if you do not need to divide the area into subbasins.

For Step 1, load the files obtained in Section 4.1. Under **BHO Area file**, select the vector file containing the basin's BHO catchment areas. Under **BHO Stretch file**, select the vector file containing drainage reaches. Under **Digital Elevation Model**, select the basin DEM raster. In **Outlet code ("cobacia")**, enter the `cobacia` codes of the subbasin outlets. This example uses four subbasins with outlet codes `67658111`, `6765823391`, `6765841331`, and `6765859`. Select an **Output Directory**, click **Run**, and wait for processing to reach 100%.

![Step 1 of the BHO2MGB tool](../assets/figura-13.png)

**Figure 13. Step 1 of the BHO2MGB tool.**

Step 1 creates `roi_areas.shp` and `roi_trecs.shp` in an `output` folder within the working directory. Load them in QGIS to check the subbasins. To display each subbasin separately, categorize the areas layer by its `sub` column (Figure 14).

![Step 1 output files](../assets/figura-14.jpg)

**Figure 14. Step 1 output files.**

Step 2 modifies the original BHO catchments for MGB simulation by merging adjacent ones until they meet a minimum reach length (`Lmin`) and minimum upstream drainage area (`Amin`). After Step 1, the Step 2 window is populated with the paths to the area and reach files (Figure 15). You can change **Minimum contributing area** (`Amin`) and **Minimum stream length** (`Lmin`). Smaller values preserve more of the original BHO delineation but make simulation slower. The defaults, 30 km² for `Amin` and 6 km for `Lmin`, provide a useful balance. Click **Run** to process Step 2.

![Step 2 of the BHO2MGB tool](../assets/figura-15.png)

**Figure 15. Step 2 of the BHO2MGB tool.**

Step 2 produces `mareas.shp` and `mtrecs.shp`, the area and reach files for the merged mini-catchments. Load them in QGIS to inspect the result (Figure 16). There are fewer mini-catchments, and their sizes are more uniform than in the original BHO data (Figure 14), making MGB simulation easier.

![Step 2 output files](../assets/figura-16.jpg)

**Figure 16. Step 2 output files.**

Step 3 writes the MGB input files `MINI.gtp` and `COTA_AREA.flp` (labeled COTA-AREA in the plugin interface). The files from earlier steps are already loaded; also select the HRU raster `hlc.tif` obtained in Section 4.1 (Figure 17). Set the hydraulic and geomorphological parameters used to describe the mini-catchments. Under **River Hydraulic Options**, set the maximum and minimum reach slopes and **Manning's coefficient**. This example keeps the defaults. Under **Bankfull Geomorphic Relationships**, specify how channel width and depth depend on drainage area. This example uses the values shown in Figure 17: `a = 0.19`, `b = 0.52`, `c = 0.33`, and `d = 0.66`. Click **Run**; this final preprocessing step may take some time.

![Step 3 of the BHO2MGB tool](../assets/figura-17.png)

**Figure 17. Step 3 of the BHO2MGB tool.**

Step 3 creates several files in `output`. The rasters `hand.tif` (Figure 18) and `ltnd.tif` (Figure 19) show, respectively, height above and distance to the nearest drainage channel. BHO2MGB uses them internally, but they are also useful for understanding basin hydrology. The file `MINI.gtp` contains the attributes in Table 3; `COTA_AREA.flp` contains flooded area by elevation increment for each mini-catchment. The latter two files are MGB inputs.

![HAND raster for the Carinhanha River basin](../assets/figura-18.jpg)

**Figure 18. HAND raster for the Carinhanha River basin.**

![LTND raster for the Carinhanha River basin](../assets/figura-19.jpg)

**Figure 19. LTND raster for the Carinhanha River basin.**

**Table 3. Attributes in `MINI.gtp`.**

| Attribute | Description |
|---|---|
| `CatID` | Original mini-catchment code. |
| `MINI` | Mini-catchment number in topological order, from headwaters to the basin outlet. |
| `Xcen` and `Ycen` | Centroid coordinates. |
| `Sub` | Subbasin containing the mini-catchment. |
| `Area` | Mini-catchment drainage area, in km². |
| `AreaM` | Total upstream drainage area, in km². |
| `Ltr` | Length of the main river crossing the mini-catchment. |
| `Str` | Slope of the main river within the mini-catchment. |
| `Lrl` | Length of the longest tributary within the mini-catchment. |
| `Srl` | Slope of the longest tributary within the mini-catchment. |
| `MiniJus` | Number of the immediately downstream mini-catchment. |
| `Ordem` | Stream order of the mini-catchment. |
| `Hdr` | Flag used in earlier model versions to enable the hydrodynamic model in mini-catchments. |
| `Width` | Reach width estimated from the geomorphological relationship. |
| `Depth` | Reach depth estimated from the geomorphological relationship. |
| `Manning` | Manning roughness coefficient. |
| `BLC_X` | Percentage of mini-catchment area occupied by each HRU; X ranges from 1 to the number of HRUs. |

## 4.3. Running an MGB simulation

The files generated above can be used to run MGB through its QGIS interface. To follow these steps, install QGIS version 3 or later from the [QGIS download page](https://qgis.org/en/site/forusers/download.html) and the [MGB interface](https://www.ufrgs.br/hge/mgb/downloads/mgb-4-6-2/) from HGE.

### 4.3.1. Describing hydrological response classes

First, use **HRCs Description** in the MGB interface to describe the hydrological response units (HRUs). The **HRC** column holds abbreviated class codes; **Description** explains each code. This example uses the HLC file obtained in Section 4.1.1 as the HRU map. Fill in the table as shown in Figure 20 and save it as `HRC_descrip.hrc`.

![Descriptions of hydrological response classes](../assets/figura-20.png)

**Figure 20. Descriptions of hydrological response classes.**

### 4.3.2. Precipitation

The **ANA data acquisition** tool can automatically download precipitation and streamflow records from stations in a region of interest. The MGB interface manual (Alvez et al., 2020) explains how to obtain precipitation data with this tool. This example instead uses CHIRPS precipitation data (Funk et al., 2015) extracted with the MGB-BHO Tool Kit in Section 4.1.1.

MGB precipitation data must be interpolated and aggregated to mini-catchments. First, preprocess the downloaded `.csv` file into one `.txt` time series per grid point and update the MGB interface's internal databases. Open **GEE_Precipitation** under **Tools** (Figure 21). Select the precipitation grid `.csv` from Section 4.1.1 as the input and a folder for the resulting `.txt` files as the output. Click **Run** and wait for confirmation.

![Using GEE Precipitation](../assets/figura-21.png)

**Figure 21. Using GEE Precipitation.**

Processing may take some time. You can monitor the output folder as files are created. This example produces 720 `.txt` files, one for each grid point (Figure 22).

![Example GEE Precipitation output file](../assets/figura-22.png)

**Figure 22. Example GEE Precipitation output file. Columns contain day, month, year, and daily precipitation.**

Next, interpolate precipitation to the mini-catchments. Although these data do not come from ANA, **Using ANA Data (Brazil)** can read and interpolate the files prepared above. Open the tool under **Precipitation** (Figure 23). Click **Load data** and select all files generated by **GEE Precipitation**. Load the `MINI.gtp` file from Section 4.2 in the upper-right panel. Check that the interpolation dates fall within the available data period, then choose an output folder. In this example, the output file is named `PRECIP`.

![Tool for interpolating precipitation data](../assets/figura-23.png)

**Figure 23. Tool for interpolating precipitation data.**

You can also create a shapefile of the grid points to inspect their locations in the basin. Click **Create stations shapefile**. Figure 24 shows the precipitation grid used here.

![Precipitation grid used for interpolation](../assets/figura-24.png)

**Figure 24. Precipitation grid used for interpolation.**

After interpolation, return to **GEE Precipitation** and click **Reset** to restore the MGB interface's internal database.

### 4.3.3. Observed streamflow

Use **ANA data acquisition** to download observed streamflow for MGB calibration. Select **Discharge** at the top and enter the same period used for precipitation. Prepare a station-code text file like Figure 25 and save it as `gauges.txt`.

![Codes of streamflow stations selected for calibration](../assets/figura-25.png)

**Figure 25. Codes of streamflow stations selected for calibration.**

Select **Gauges** as the input type, load `gauges.txt`, choose a **Destination folder** for the station time series, and click **Download Data** (Figure 26).

![ANA data acquisition tool for downloading observed streamflow](../assets/figura-26.png)

**Figure 26. ANA data acquisition tool for downloading observed streamflow.**

To compare simulated and observed streamflow, create an observed-discharge input file using **Discharge** in the MGB menu. Each station's data must be in its own column-formatted text file. This example uses the files just downloaded from ANA.

Check the time coverage of the stations. The observed streamflow period must exactly match the interpolated precipitation period, here 2000-01-01 through 2020-12-31. Each station must also be assigned a mini-catchment number. Click **Generate shapefile** to create a station shapefile for locating the gauges.

**Automatically Suggest Catchment** can propose mini-catchments for the stations. When prompted, load the previously generated `MINI.gtp`. Check every proposed assignment: ANA station coordinates are approximate, and the BHO data also have uncertainties. One way to check is to compare the proposed mini-catchment's drainage area with the station drainage area reported in ANA's Hidroweb. Add the station shapefile to QGIS, label the mini-catchment centroid layer with its `Mini` field, and zoom in on each station. Figure 27 shows a location check; Figure 28 shows the assignments used here. Save the observed-discharge file as `QOBS.qob`, click **Create observed Discharge file**, and close the window.

![Checking the mini-catchment assigned to a streamflow station](../assets/figura-27.jpg)

**Figure 27. Checking the mini-catchment assigned to a streamflow station.**

![Observed-discharge tool with station and mini-catchment assignments](../assets/figura-28.png)

**Figure 28. Observed-discharge tool with station and mini-catchment assignments.**

### 4.3.4. Climate data

MGB calculates evapotranspiration from air temperature, relative humidity, wind speed, atmospheric pressure, and sunshine duration (hours per day). The MGB interface offers three climate data input methods. This example uses its internal database of 1960–1990 climatological normals calculated by INMET for Brazil.

Available climatological stations appear in the table on the left. Select a station and click **>>** to move it to the table on the right. To find nearby stations, click **Create Shapefile of Climatological Stations from MGB database**, add the shapefile to QGIS, and inspect their locations (Figure 29). This example uses the stations shown in Figure 30.

![Climatological stations near the Carinhanha River basin](../assets/figura-29.jpg)

**Figure 29. Climatological stations near the Carinhanha River basin.**

![MGB internal climate database interface](../assets/figura-30.png)

**Figure 30. MGB internal climate database interface.**

Once the desired stations appear under **Selected stations**, click **Create Average Climatological file** to create the climatological normals file.

### 4.3.5. Setting vegetation parameters

Open **Vegetation Parameters** in the MGB menu (Figure 31), then click **New vegetation parameters file**. When asked whether to use a response-class file, select **Yes** and load the `.hrc` file created earlier.

The tool displays suggested parameter values. Enter the values used for the Carinhanha River basin in Table 4. For simplicity, the example uses the same values in every month.

![Vegetation parameter editor](../assets/figura-31.png)

**Figure 31. Vegetation parameter editor.**

**Table 4. Vegetation parameters for each hydrological response class in the Carinhanha River basin.**

| HRC | Albedo | Leaf Area Index | Average Vegetation Height | Surface Resistance |
|---|---:|---:|---:|---:|
| `Wet_For` | 0.14 | 6.00 | 20.00 | 100.00 |
| `Wet_Sav` | 0.16 | 3.00 | 8.00 | 80.00 |
| `Wet_Far` | 0.20 | 2.00 | 1.20 | 70.00 |
| `Hil_For` | 0.14 | 6.00 | 20.00 | 100.00 |
| `Hil_Sav` | 0.16 | 3.00 | 8.00 | 80.00 |
| `Hil_Far` | 0.20 | 2.00 | 1.20 | 70.00 |
| `Pla_For` | 0.14 | 6.00 | 20.00 | 100.00 |
| `Pla_Sav` | 0.16 | 3.00 | 8.00 | 80.00 |
| `Pla_Far` | 0.20 | 2.00 | 1.20 | 70.00 |
| `Sem_Per` | 0.15 | 1.00 | 0.50 | 70.00 |
| `Wat_Bod` | 0.08 | 1.00 | 0.10 | 0.00 |

Click **Save vegetation parameters file**. This example saves the file as `PARFIX.FIX` in the root of the MGB working folder.

### 4.3.6. Setting soil parameters

Soil parameters are associated with HRUs and are commonly adjusted during calibration. Open **Soil Parameters**, load the response-class file and `MINI.gtp`, then click **New soil parameters file**. Figure 32 shows the completed window; Table 5 gives the values for each class.

![Soil parameter editor](../assets/figura-32.png)

**Figure 32. Soil parameter editor.**

**Table 5. Soil parameters used for the Carinhanha River basin.**

| HRC | Wm | b | Kbas | Kint | XL | CAP | Wc |
|---|---:|---:|---:|---:|---:|---:|---:|
| `Wet_For` | 1600.00 | 0.34 | 2.90 | 0.80 | 0.67 | 0.00 | 0.10 |
| `Wet_Sav` | 1660.00 | 0.34 | 2.30 | 1.20 | 0.67 | 0.00 | 0.10 |
| `Wet_Far` | 1350.00 | 0.42 | 1.90 | 0.70 | 0.67 | 0.00 | 0.10 |
| `Hil_For` | 5000.00 | 0.33 | 2.50 | 1.10 | 0.67 | 0.00 | 0.10 |
| `Hil_Sav` | 5100.00 | 0.11 | 1.50 | 1.10 | 0.67 | 0.00 | 0.10 |
| `Hil_Far` | 4400.00 | 0.37 | 1.80 | 0.80 | 0.67 | 0.00 | 0.10 |
| `Pla_For` | 5300.00 | 0.31 | 2.10 | 1.10 | 0.67 | 0.00 | 0.10 |
| `Pla_Sav` | 5300.00 | 0.07 | 1.60 | 1.00 | 0.67 | 0.00 | 0.10 |
| `Pla_Far` | 5300.00 | 0.16 | 2.40 | 0.80 | 0.67 | 0.00 | 0.10 |
| `Sem_Per` | 1400.00 | 0.20 | 2.90 | 1.30 | 0.67 | 0.00 | 0.10 |
| `Wat_Bod` | 1000.00 | 0.11 | 2.10 | 1.00 | 0.67 | 0.00 | 0.10 |

Also enter `CS = 50`, `CI = 130`, `CB = 8400`, and `QB = 0.01` for this example.

When all values are entered, click **Save soil parameters file** and save the file as `PARCAL.CAL`.

### 4.3.7. Creating a simulation project

The simulation project collects the files prepared above. Click **Create/Edit Simulation Project** in the MGB menu (Figure 33). Avoid special characters in file and folder names to prevent simulation errors.

![Simulation project editor](../assets/figura-33.png)

**Figure 33. Simulation project editor.**

Enter a project name in **Project**; this example uses `projeto_carinhanha`. Under **Geometry**, load `MINI.gtp` from Section 4.2. Under **Hydrologic response classes**, load `HRC_descrip.hrc` from Section 4.3.1.

On the **Hydrological** tab, load `PRECIP` from Section 4.3.2 under **Interpolated Precipitation** and `QOBS.qob` from Section 4.3.3 under **Observed Discharge**. Leave **Replaced Discharge** empty. On the **Climatological** tab, load the `CLIMATE.cln` file from Section 4.3.4 under **Climatological Averages**, and leave **Daily climate data** unchecked. On the **Parameters** tab, load `PARFIX.FIX` and `PARCAL.CAL` into the vegetation and soil parameter fields, respectively.

For Muskingum–Cunge routing, click **Save Project**. To use the inertial model, first load the `COTA_AREA.flp` file generated in Section 4.2 on the **Inertial Module** tab, then click **Save Project**.

### 4.3.8. Running the simulation

Open **Run Simulation** from the MGB main menu and select the project file. For this example, select `projeto_carinhanha.mgb` (Figure 34).

![MGB simulation window with the project loaded](../assets/figura-34.png)

**Figure 34. MGB simulation window with the project loaded.**

MGB automatically identifies the simulation period, mini-catchments with observed streamflow, and output location for comparing simulated and observed data. To save streamflow results elsewhere in the basin, append the corresponding mini-catchment numbers to the list.

**Flood Routing Method** shows **Muskingum-Cunge** if that option was used when creating the project. If the inundation area file was included, MGB selects **Inertial** automatically.

Keep the other settings, including **Save results on memory**, at their defaults. Saving results in memory enables the graphical result-viewing tools.

For inertial simulation, **Alpha** affects the time step: a larger value increases the time step and can speed up a run, but may cause numerical instability. If a run is unstable, reduce Alpha; simulation will be slower but may become more stable.

Click **Simulate** to launch the MGB Fortran executable. A large basin with many mini-catchments or HRUs, or an inertial simulation, may take a long time. The inertial run for the Carinhanha basin is slow.

The console may prompt you to press Enter during the run. A success message appears when simulation finishes. MGB saves the results in the folder containing the project file.

## 4.4. Viewing results

Use the tools in MGB's **Results** menu to view simulation results.

### 4.4.1. Comparing simulated and observed hydrographs

Select **Compare observed and calculated hydrographs**. In QGIS, the `mini` layer must be visible and selected; the tool displays a reminder. The map selection tool then becomes active. Click a mini-catchment with observed data to display its hydrographs. Figure 35 shows the Juvenília station (`45260000`), and Figure 36 shows São Gonçalo (`45131000`).

![Simulated and observed hydrographs at station 45260000](../assets/figura-35.png)

**Figure 35. Simulated and observed hydrographs at station 45260000.**

![Simulated and observed hydrographs at station 45131000](../assets/figura-36.png)

**Figure 36. Simulated and observed hydrographs at station 45131000.**

### 4.4.2. Comparing simulated and observed flow duration curves

Use **Compare flow duration curves** under **Results** to plot flow duration curves for a mini-catchment. Figure 37 shows the Juvenília station (`45260000`) on the Carinhanha River. Its simulated low flows are below the observed low flows; model parameter calibration may improve the fit.

![Simulated and observed flow duration curves at station 45260000](../assets/figura-37.png)

**Figure 37. Simulated and observed flow duration curves at station 45260000.**

### 4.4.3. Viewing a simulated hydrograph

Select **Visualize calculated hydrographs only** under **Results** to view a simulated hydrograph without an observed series. You can add a mini-catchment without observed streamflow to the simulation window, then view its hydrograph here.

### 4.4.4. Viewing a simulated flow duration curve

Select **Visualize flow duration curves only** under **Results** to view the simulated curve without an observed comparison.

### 4.4.5. Viewing simulated water depth over time

For an inertial simulation, select **Visualize water depth time series** under **Results**. Figure 38 shows simulated water depths for the Carinhanha River.

![Simulated water depth time series for the Carinhanha River](../assets/figura-38.png)

**Figure 38. Simulated water depth time series for the Carinhanha River.**

### 4.4.6. Viewing simulated flooded area over time

The inertial model also provides flooded-area results for the basin. Select **Visualize flooded area time series** under **Results** to display them (Figure 39).

![Simulated flooded-area time series for the Carinhanha River](../assets/figura-39.png)

**Figure 39. Simulated flooded-area time series for the Carinhanha River.**

# 5. References

- **Alvez, M. E., Oliveira, A. M., Fan, F. M. & Paiva. (2020).** *Manual de aplicação do modelo MGB utilizando IPH-Hydro Tools* (in Portuguese). [PDF](https://drive.google.com/file/d/1YxrNHQhDZsBl0G_e39L7zLNF7ppArNYo/view).
- **Collischonn, W., Allasia, D., da Silva, B. C. & Tucci, C. E. M. (2007).** The MGB-IPH model for large-scale rainfall–runoff modelling. *Hydrological Sciences Journal, 52*(5), 878–895. Taylor & Francis. [doi:10.1623/hysj.52.5.878](https://doi.org/10.1623/hysj.52.5.878).
- **Fan, F. M., Buarque, D. C. & Pontes, P. R. M. (2015).** *Um mapa de unidades de resposta hidrológia para a América do Sul 8* (in Portuguese).
- **Farr, T. G., Rosen, P. A., Caro, E., Crippen, R., Duren, R., Hensley, S., Kobrick, M., et al. (2007).** The Shuttle Radar Topography Mission. *Reviews of Geophysics, 45*(2). [doi:10.1029/2005RG000183](https://doi.org/10.1029/2005RG000183).
- **Funk, C., Peterson, P., Landsfeld, M., Pedreros, D., Verdin, J., Shukla, S., Husak, G., et al. (2015).** The climate hazards infrared precipitation with stations—a new environmental record for monitoring extremes. *Sci Data, 2*(1), 150066. Nature Publishing Group. [doi:10.1038/sdata.2015.66](https://doi.org/10.1038/sdata.2015.66).
- **Hersbach, H., Bell, B., Berrisford, P., Hirahara, S., Horányi, A., Muñoz-Sabater, J., Nicolas, J., et al. (2020).** The ERA5 global reanalysis. *Quarterly Journal of the Royal Meteorological Society, 146*(730), 1999–2049. [doi:10.1002/qj.3803](https://doi.org/10.1002/qj.3803).
- **Huffman, G. J., Stocker, D. T. & Bolvin, E. J. (2019).** GES DISC Dataset: GPM IMERG Final Precipitation L3 Half Hourly 0.1 degree x 0.1 degree V06 (GPM_3IMERGHH 06). Retrieved May 24, 2022, from [NASA GES DISC](https://disc.gsfc.nasa.gov/datasets/GPM_3IMERGHH_06/summary).
- **Jarvis, A., Reuter, H. I., Nelson, A. & Guevara, E. (2008).** CGIAR-CSI SRTM – SRTM 90m DEM Digital Elevation Database. Retrieved May 24, 2022, from [CGIAR-CSI](https://srtm.csi.cgiar.org/).
- **NASA JPL. (2020).** NASADEM Merged DEM Global 1 arc second V001. NASA EOSDIS Land Processes DAAC. [doi:10.5067/MEASURES/NASADEM/NASADEM_HGT.001](https://doi.org/10.5067/MEASURES/NASADEM/NASADEM_HGT.001).
- **Rodell, M., Houser, P. R., Jambor, U., Gottschalck, J., Mitchell, K., Meng, C.-J., Arsenault, K., et al. (2004).** The Global Land Data Assimilation System. *Bulletin of the American Meteorological Society, 85*(3), 381–394. American Meteorological Society. [doi:10.1175/BAMS-85-3-381](https://doi.org/10.1175/BAMS-85-3-381).
- **Siqueira, V. A., Fleischmann, A., Jardim, P. F., Fan, F. M. & Collischonn, W. (2016).** IPH-Hydro Tools: uma ferramenta open source para determinação de informações topológicas em bacias hidrográficas integrada a um ambiente SIG (in Portuguese). *RBRH, 21*, 274–287. Associação Brasileira de Recursos Hídricos. [doi:10.21168/rbrh.v21n1.p274-287](https://doi.org/10.21168/rbrh.v21n1.p274-287).
- **Sorooshian, S., Hsu, K.-L., Braithwaite, D. K., Ashouri, H. & NOAA CDR Program. (2015).** PERSIANN-CDR: Daily Precipitation Climate Data Record from Multisatellite Observations for Hydrological and Climate Studies. *Bulletin of the American Meteorological Society, 96*(1), 69–83. [doi:10.1175/BAMS-D-13-00068.1](https://doi.org/10.1175/BAMS-D-13-00068.1).
- **Yamazaki, D., Ikeshima, D., Tawatari, R., Yamaguchi, T., O’Loughlin, F., Neal, J. C., Sampson, C. C., et al. (2017).** A high-accuracy map of global terrain elevations. *Geophysical Research Letters, 44*(11), 5844–5853. [doi:10.1002/2017GL072874](https://doi.org/10.1002/2017GL072874).
