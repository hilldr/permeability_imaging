
args = split(getArgument(), " ");
filename = args[0];
minthresh = args[1];

function fitc(filename) {
    open(filename);
    run("16-bit");
    setThreshold(minthresh, 65535);
    run("Set Measurements...",
	 "area mean min median limit display redirect=None decimal=9");
    run("Measure");
}

fitc(filename);
exit();
run("Close");
run("Quit");
eval("script", "System.exit(0);");