//ImageJ Macro exports the first timepoint from VSI file to TIF

dir = getArgument;

function vsi2baseline(dir, filename) {
    print(filename+" [Exporting to tif...]");
    run("Bio-Formats Importer",
     	"open="+dir+filename+" color_mode=Grayscale rois_import=[ROI manager] specify_range view=Hyperstack stack_order=XYCZT series_1 c_begin_1=1 c_end_1=2 c_step_1=1 t_begin_1=1 t_end_1=1 t_step_1=1");
    run("Bio-Formats Exporter",
     	   "save="+dir+filename+".tif write_each_timepoint write_each_channel export compression=Uncompressed");
    close();
    print(filename+" [DONE]");
}

setBatchMode(true);

list = getFileList(dir);
for (i = 0; i < list.length; i++)
    if (endsWith(list[i], ".vsi")) {
	vsi2baseline(dir, list[i]);
    }
exit();
run("Close");
run("Quit");
eval("script", "System.exit(0);");


