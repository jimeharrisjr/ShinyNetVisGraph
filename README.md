
<!-- README.md is generated from README.Rmd. Please edit that file -->
ShinyNetVisGraph : a simple example tool for visualizing live packet capture data
=================================================================================

This is a simple tool using the visnetwork package (<https://datastorm-open.github.io/visNetwork/>) to with Shiny and Shinydashboard to visualize live packet capture data from a network interface using **Rtins**

The **Rtins** package provides tools for analysing network captures in R on top of [`libtins`](http://libtins.github.io), a high-level, multiplatform C++ network packet decoding and crafting library.

Installation
------------

This example program requires the data.table R package for accelerated handling of large data sets. (<https://cran.r-project.org/web/packages/data.table/index.html>) It uses Rstudio's [`Shiny`](http://shiny.rstudio.com/) and [`Shinydashboard`](https://rstudio.github.io/shinydashboard/) libraries, as well as [`igraph`](https://igraph.org/r/) and [`visNetwork`](https://datastorm-open.github.io/visNetwork/).

You need to install the [`libtins`](http://libtins.github.io) library first. And as a minimum requirement, `libtins` needs the development package of `libpcap` (or `WinPcap` for Windows). On Linux,

``` bash
# install libpcap-devel, openssl-devel is also recommended
git clone https://github.com/mfontanini/libtins.git
mkdir libtins/build
cd libtins/build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
make
sudo make install
```

Please, refer to the `libtins` documentation for the installation in other platforms. Then, `Rtins` can be installed using `devtools`:

``` r
devtools::install_github("jimeharrisjr/Rtins")
```

Finally, install the other dependencies:

``` r
install.packages(c('shiny','shinydashboard','visNetwork','data.table','igraph'))
```

Configuration
-------------

Rtins does not yet have a method for determining the available network interfaces (maybe soon, when I have some time), so you will need to manually set your desired interface in the server.R script. Look for the lines:

``` r
    isolate({ if (rv$run) { 
# Configure this section for your machine      
      pcapinput <- sniff_pcap('en0', num = 10) # NOTE: this is for a Mac - on Linux or Windows, it would be something like "wlan0" for WiFi or "eth0" for ethernet 
      rv$pcapinput<-rbind(rv$pcapinput, pcapinput, fill=TRUE)
      rv$pcapinput<-rv$pcapinput[!duplicated(rv$pcapinput)]
      } })
```

Change "en0" to whatever interface you wish to use. If you are unsure of the interfaces available, you can go to a terminal (Mac, Linux) and type "ifconfig" or a Command Prompt (Windows) and type "ipconfig"

Usage
-----

For Rstudio users, open server.R and click "Run App"

for command-line R, set your working directory (setwd) to wherever you downloaded the files, and type:

``` r
shiny::runApp()
```

You will be presented with a dashboard with two tabs on the left, "Visualize"" and "Data" From "Visualize," click the "Go" button. After a short time, you should see a graph being drawn. Hit "Stop" to interrupt the collection, and "Reset" to clear the collection and start again.

You can click on a network node to highlight it and its nearest neighbors. You can also click and hold to drag nodes arround to rearrange them.

From the "Data" tab, you can see the capured data in tabular format. The table is interactive: you can sort columns from the top of the table, and search them from the bottom of each column. There is an all-fields search at the top of the table frame.
