# Welcome

In this folder you will find the code of a webtool, developed by [AIA](http://aia.es/) within the [EU FP7 RAIN project](http://rain-project.eu/), that is the first version of a **risk assessment tool**. The tool allows a reproducible workflow that integrates weather threats and physical context to estimate the social impact described by specific markers, useful for decision support (in planning and operation) and the analysis of what-if scenarios. It focuses on the impact of **extreme weather events** (EWE) on the **electrical, telecommunications, and land transportation networks**.

A demo video of the usage of an earlier version of the tool is available on [Youtube](https://youtu.be/gM6Ugu0Fjo8?list=PLPBl6rsXvRsCxbg-QMYoYsAdlrya92joZ).

The tool, implemented in [shiny](https://shiny.rstudio.com/) and using [shinydashboard](https://rstudio.github.io/shinydashboard/) package, is split in different tabs:

- **Initialization**: tab with basic description of the tool.
- **Electrical Analysis**: page of the tool where the region studied and its geographical context is presented. The electrical elements of the region are displyed and described. Weather conditions (properties of the extreme weather event) are chosen, and the probabilities of blackout and its consequences are analysed. Also, investment in protection measures is considered.
- **Land Transportation**: tab equivalent to the Electrical Analysis one but for analysis of the vulnerability of the land transportation networks (roads and railway).
- **Configuration**: page where different properties of the analysis can be tuned. In the current version of the webtool, landslide probability model and historical data of landslides are displayed and can be modified. Engineering measures to be considered in Electrical Analysis and Land Transportation tabs are shown, and new measures can be uploaded to the system.
- **Weather**: meteorological and climate data related to the EWEs analysed are displayed.
- **Technical details**: a description of the analyses performed is provided. Also, information on the required data to adapt the webtool to another region and/or infrastructure is given.
- **About**: the tab shows information on the webtool and its creators, and of the credits and references of the different inputs used.


Authors: 

* X. Clotet (clotetx@aia.es) [\@xclotet](https://github.com/xclotet)
* M. Halat  (halatm@aia.es)


# Installation

To install and use the webtool, [R](https://www.r-project.org/) installation and a working [PostgreSQL database](https://www.postgresql.org/download/) are required. 

R version in which the tool was developed is 3.3.0. The list of packages and their version can be found at `packrat` folder on the [repository main page](https://github.com/grupoaia/rain-fp7). If you restore that packrat snapshot ([more info](http://rstudio.github.io/packrat/walkthrough.html)), the tool should work.

1. Download the `global.R`, `server.R`, and `ui.R` files and the `data`, `scripts`, and `www` folders in a dedicated folder (e.g. `rain_webtool`). 
2. Create the Alpine schema and required tables, and insert the data using the database dump (`RAIN_Alpine_database.sql`) available at `data` folder. ([For more information check postgresql documentation ](https://www.postgresql.org/docs/8.1/static/backup.html#BACKUP-DUMP-RESTORE).)
3. 


----------
*RAIN project has received funding from the European Union's Seventh Programme for research, technological development and demonstration under grant agreement N. 608166.*