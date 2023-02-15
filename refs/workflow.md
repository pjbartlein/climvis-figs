## Workflow for making an animation ##

Example:  Make animations of skin temperature (T<sub>s</sub>) and of 2-m air temperature - skin temperature (T2m - T<sub>s</sub>)

Basic layout of files and folders:

1. A big data folder(s) for storing downloaded data and calculated values like long-term means and anomalies.  This folder will be too large to sync at GitHub.
2. A working folder with processed data files, NCL scripts, other scripts and so on, including a folder for completed maps.  This folder should be a GitHub repository (e.g. `climvis-figs`)
3. A working folder with the Markdown, R Markdown and various other files and folders that make up the web page (e.g. the Bootstrap `/site-libs` folder and the HAniS support files.  This should also be a GitHub repository (e.g. `climvis.org`) and is copied to `http://pages.uoregon.edu/clivis/` (`climvis.org`)

Overall steps:

1. download data (monthly time series).
2. calculate new variables (e.g. T2m - T<sub>s</sub>), if necessary.
3. calculate long-term means and anomalies (Anomaly calculation isn't really necessary, but it's efficient to do at this stage).
4. copy the resulting long-term means to `/climvis-figs/data/ERA5-Atm/ltm_monthly/`
5. edit and run an ncl script to make the maps
6. use the ImageMagick `mogrify` command-line tool to trim whitespace from the maps.  (NCL always writes to a square page.)
7. edit the three HAniS support files: `varname.html`, `varname_config.txt`, and `varname_files.txt'.
8. copy the `/png` folder and HAniS support files to `sftp.uoregon.edu/climvis/public_html/content/anim/ltm/globe/varname/` using FileZilla or by mounting the folder on the server (user: `climvis` password: `GCA_2023_Sedge`)
9. test by loading `https://climvis.org/global/varname/varname.html`

### Download data ###

Before downloading data, you'll need to get an account.  The first time through, the web page should prompt you to set one up.

Here's the URL for the ERA5 monthly-averaged data on single levels:  [[https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-single-levels-monthly-means?tab=overview]](https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-single-levels-monthly-means?tab=overview).

Click on the `Download Data` tab, and make the following selections:

- Product type:  `Monthly averaged reanalysis`
- Variable:  `Skin temperature`
- Year:  `Select all` (or just through 2020, to match the existing data).
- Month:  `Select all`
- Time:  `00:00` (the only possible selection for Monthly averaged reanalysis data)
- Geographical area: `Whole available region`
- Format:  `NetCDF`

Click on the green button.  When the data are ready, you'll see a Download data button.  The file will have a cryptic name, but you can discover the name of the variable, `skt` in this case, using Panoply or `ncdump`.  Rename the file to, for example, `ERA5_skt_monthly_197901-202012.nc`.  Move the file to the "big data" folder(s).

### Get long-term means and anomalies ###

Getting the long-term means, 1991-2020, for example, is easy to do with a combination of CDO and NCO command-line commands.  Open a terminal window in the folder with the downloaded data, and paste in the following:

	cdo selyear,1991/2020 ERA5_skt_monthly_197901-202012.nc ERA5_skt_monthly_199101-202012.nc
	cdo ymonmean ERA5_skt_monthly_199101-202012.nc ERA5_skt_monthly_199101-202012_ltm.nc
	cdo -b F64 sub ERA5_skt_monthly_197901-202012.nc ERA5_skt_monthly_199101-202012_ltm.nc ERA5_skt_monthly_197901-202012_anm1991-2020.nc 
	ncpdq -O ERA5_skt_monthly_197901-202012_anm1991-2020.nc ERA5_skt_monthly_197901-202012_anm1991-2020.nc 

The first line grabs a subset of years (1991-2020) from the downloaded file, the second line gets the long-term means for that subset, the third line gets the anomalies, and the fourth line repacks the anomalies (to "short" netCDF variables).  There are more scripts in the file `/climvis-figs/scripts/cdo-and-nco/cdo_ltm&anm_ERA5-Atm.txt` Move the long-term mean file `ERA5_skt_monthly_199101-202012_ltm.nc` to the `/climvis-figs/data/ERA5-Atm/ltm_monthly` folder.

### Calculate a new variable ###

Get a new variable, in this case the 2m air temperature minus the skin temperature.  This can be done in NCL, but is easy to do in CDO and NCO:

	cdo -b F64 sub ERA5_t2m_monthly_197901-202012.nc ERA5_skt_monthly_197901-202012.nc ERA5_t2m-skt_monthly_197901-202012.nc 
	ncpdq -O ERA5_t2m-skt_monthly_197901-202012.nc ERA5_t2m-skt_monthly_197901-202012.nc 
	ncrename -v t2m,t2m-skt ERA5_t2m-skt_monthly_197901-202012.nc
	ncatted -a long_name,t2m-skt,o,c,"2m Air Temp - Skin Temp" ERA5_t2m-skt_monthly_197901-202012.nc
	ncatted -a standard_name,t2m-skt,o,c,"T2m-TS" ERA5_t2m-skt_monthly_197901-202012.nc

The first line subtracts `skt` from `t2m`, the second line repacks the difference, the third line renames `t2m` which got propagated to the difference file to `t2m-skt`, and the fourth and fifth lines add new long and standard names.  Next, get the long-term means and anomalies of `t2m-skt` as above.


