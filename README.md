# Forecasting Aircraft Induced Clouds (AIC) Hot Spots <img src= "https://github.com/rina635/partly_cloudy/blob/main/images/2601_cloud.png">

## By Christopher Chang, Rina Lidder, Charlotte Petsche, Andrew So, and Haoming Tang.

Aircraft have a two-fold impact on climate change in that they create contrails or Aircraft-Induced Clouds (AICs) that block heat from being released into space whilst releasing greenhouse gases into the atmosphere. Heat is absorbed by greenhouse gases in the Earth’s atmosphere, causing a warming effect known as global warming. AICs are formed when an aircraft flies through certain atmospheric conditions, known as Ice Supersaturated Regions (ISSRs). The formation of AICs could be lessened if flight planners and operators were able to predict when and where ISSRs would occur. This information would then be used to construct new flight paths that would avoid those areas. The objective of this project is to assist the aviation industry in reducing its contribution to global warming by predicting the presence of ISSRs and the areas in which AICs are most likely to form within the contiguous United States (CONUS).  Three datasets were utilized for this project: National Oceanic and Atmospheric Administration (NOAA) Rapid Refresh (RAP), Automatic Dependent Surveillance Broadcast (ADS-B), and Air Traffic Control Centers (ARTCC) Boundaries. Machine learning methodologies were utilized in developing and implementing predictive models. Predictions were separated by the ARTCC in which they occur and combined into 6-hour increments. Our findings include visualizations of ISSRs, flight patterns, and flights traversing ISSR locations. 

This project was completed in partnership with Dr. Lance Sherry, from the George Mason University Center for Air Transportation Systems Research (CATSR), and Mr. Yuan Ho, a software developer from Unidata.  



Aviation contributes approximately 4% of anthropogenic global warmining and the effects are immediate compared to CO<sub>2</sub> emissions.
- 60% of that is attributed to Aircraft Induced Clouds (AICs) or contrails.
- 40% comes from their fuel emissions.

<img src= "images/contrail.png" width="300">
<em>Image of Contrails in the sky. Source: https://www.researchgate.net/figure/Line-shaped-contrails-and-contrail-cirrus-forming-in-aircraft-engine-exhaust_fig2_225024463</em>


### Where does that 60% come from?

- AICs form as a result of aircraft emissions (water vapor and soot) passing through **Ice Super Saturdated Regions (ISSRs)** where humidity is 100% and ≤ -60 ℃. These emissions create crysallized ice clouds.
- AICs trap and reflect 33% of Earth's thermal radiation back into the atmosphere, creating a greenhouse effect that causes the atmosphere to heat up.

<img src= "images/RF.png" width="650" >
<em>An example of how Radiative Forcing occurs. Source: https://climate.mit.edu/explainers/radiative-forcing</em>
 

### What is Partly Cloudy doing about it?

The objective of this project is to assist the aviation industry in reducing its contribution to global warming by predicting the presence of ISSRs and the areas in which **AICs** are most likely to form within the **Contiguous United States (CONUS)**.  We will also analyze flight data, so that we can forecast where aircraft are most likely to traverse through the predicted **ISSRs**, to identify these hot spots.

You can explore the AIC hotspots here: [Tableau Dashboard](https://explore.dot.gov/views/ISSRMonthlyCellHoursPOST/MonthlyISSRCell-HoursbyARTCC?%3AshowAppBanner=false&%3Adisplay_count=n&%3AshowVizHome=n&%3Aorigin=viz_share_link&%3AisGuestRedirectFromVizportal=y&%3Aembed=y)

To find out more about our project head to our [Github Page](https://rina635.github.io/partly_cloudy)
