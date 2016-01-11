// A Script that quantifies cell and nuclei statistics, given an original DAPI channel with nuclei of interest
// Language: ImageJ Macro
// Authors: Ahmed Fetit
// Advanced Imaging Resource, HGU, IGMM.
// Updated: 19/11/2015/

imagename = getTitle();
//Select DAPI channel
//Threshold and Apply to create a binary mask of nuclei of interest
waitForUser("Select DAPI");
run("Duplicate...", " ");
run("Threshold...");
setAutoThreshold("RenyiEntropy dark");
waitForUser("threshold DAPI-> Apply. Then press OK");
run("Invert");

waitForUser("Select DAPI");
run("Close");

//TCarry out RELB transparentZero Mask to extract the corresponding nuclei on the RELB channel
waitForUser("In calculator, choose RELB transparentZero Mask");
run("Image Calculator...");

//Select RELB to extract borders of cells through Analyse Particles (ROI manager)
waitForUser("Select RELB");

run("Threshold...");
setAutoThreshold("RenyiEntropy dark");
waitForUser("threshold RELB-> Set. Then press OK");

//Define measurements of interest
run("Set Measurements...", "area mean integrated limit add redirect=None decimal=2");
run("Analyze Particles...", "size=100-Infinity add");


for (i=0 ; i<roiManager("count"); i++) 
{
	roiManager("select", i); //select cell from manager
    run("Measure"); // get measurements e.g. area
}

selectWindow("Results"); 
saveAs("Text", "\\\\cmvm.datastore.ed.ac.uk\\cmvm\\smgphs\\users\\afetit\\Win7\\Desktop\\"+imagename+"cellStats.csv");



waitForUser("Select nuclei image");
roiManager("Show None");
roiManager("Show All");
run("Threshold...");

waitForUser("threshold nuclei-> Set. Then press OK");

run("Clear Results");

for (i=0 ; i<roiManager("count"); i++) 
{
	roiManager("select", i); //select cell from manager
    run("Measure"); // get measurements e.g. area
}


selectWindow("Results"); 
saveAs("Text", "\\\\cmvm.datastore.ed.ac.uk\\cmvm\\smgphs\\users\\afetit\\Win7\\Desktop\\"+imagename+"NucleiStats.csv");


waitForUser("Close ROI Manager?");
if (isOpen("ROI Manager"))
{
     selectWindow("ROI Manager");
     run("Close");
}

waitForUser("Close Windows?");
while (nImages>0) 
{ 
     selectImage(nImages); 
     close(); 
} 
