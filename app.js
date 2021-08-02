console.log('Is this working?');

let viz;

//Add Share Link to Tableau Public in here
const url = "https://explore.dot.gov/views/ISSRMonthlyCellHoursPOST/6-HourPeriodISSRPlanesCellHoursbyARTCC?:embed=y&:isGuestRedirectFromVizportal=y&:display_count=n&:showAppBanner=false&:origin=viz_share_link&:showVizHome=n";
const url2 = "https://explore.dot.gov/views/ISSRMonthlyCellHoursPOST/MonthlyISSRCell-HoursbyARTCC?%3Aembed=y&%3AisGuestRedirectFromVizportal=y&%3Adisplay_count=n&%3AshowAppBanner=false&%3Aorigin=viz_share_link&%3AshowVizHome=n"
const vizContainer = document.getElementById('vizContainer');
const vizContainer2 = document.getElementById('vizContainer2')
const options = {
    hideTabs: true,
    height: 1000,
    width: 1200,
    onFirstInteraction: function() {
        workbook = viz.getWorkbook();
        activeSheet = workbook.getActiveSheet();
        console.log("My dashboard is interactive");
    }
};

//create a function to generate the viz element
function initViz() {
    console.log('Executing the initViz function!');
    viz = new tableau.Viz(vizContainer, url, options);
    viz2 = new tableau.Viz(vizContainer2, url2, options);
}

// run the initViz function when the page loads
document.addEventListener("DOMContentLoaded", initViz);

const exportPDF = document.getElementById('exportPDF');
const exportImage = document.getElementById('exportImage');


//click on the pdf button to generate pdf of dashboard
function generatePDF() {
    viz.showExportPDFDialog(),
    viz2.showExportImageDialog()
}

exportPDF.addEventListener("click", function () {
    generatePDF();
  });

//click on image to generate image of dashboard
function generateImage() {
    viz.showExportImageDialog(),
    viz2.showExportImageDialog()
}

exportImage.addEventListener("click", function () {
    generateImage();
  });