#!/router/bin/python

import sys, os
import argparse
from collections import defaultdict
sys.path.append('/auto/dae5/users/krajoli/python_packages/xlwt/lib/python')

import xlwt
ezxf = xlwt.easyxf

## Global variables
book = xlwt.Workbook()

def area (bb_area):
	if bb_area == "-":
		return 0
	else:
		return bb_area

def write_xls(file_name, sheet_name, headings, data, heading_xf, data_xfs):
    #book = xlwt.Workbook()
    sheet = book.add_sheet(sheet_name)
    rowx = 0
    for colx, value in enumerate(headings):
        sheet.write(rowx, colx, value, heading_xf)
    sheet.set_panes_frozen(True) # frozen headings instead of split panes
    sheet.set_horz_split_pos(rowx+1) # in general, freeze after last heading row
    sheet.set_remove_splits(True) # if user does unfreeze, don't leave a split there
    for row in data:
        rowx += 1
        for colx, value in enumerate(row):
            sheet.write(rowx, colx, value, data_xfs[colx])
    #book.save(file_name)

def parse_phy_summary(file_str):
	setup_str = """SETUP 
********************************************************************************"""
	phy_constr_str = """PHYSICAL CONSTRAINTS 
--------------------"""
	area_str = """AREA 
----"""
	timing_str = """TIMING 
------"""
	congestion_str = """CONGESTION 
----------"""
	delimiter_str = "********************************************************************************"
	
	###### SETUP parsing 
	
	start_setup = file_str.find(setup_str) + len(setup_str)
	end_setup = file_str.find(phy_constr_str)
	
	design = file_str[start_setup : end_setup].strip().split("\n")[0].split(":")[1].strip()
	
	###### AREA Parsing 
	
	start_area = file_str.find(area_str) + len(area_str)
	end_area = file_str.find(timing_str)
	
	core_insts = file_str[start_area : end_area].strip().split("\n")[0].split(":")[1].strip().split()[0].strip()
	core_insts_area = file_str[start_area : end_area].strip().split("\n")[0].split(":")[1].strip().split()[1].strip()
	core_insts_percent = file_str[start_area : end_area].strip().split("\n")[0].split(":")[1].strip().split()[3].strip("(").strip(")")
	
	hm_insts = file_str[start_area : end_area].strip().split("\n")[1].split(":")[1].split()[0]
	
	if hm_insts != "0": 
	    hm_insts_area = file_str[start_area : end_area].strip().split("\n")[1].split(":")[1].split()[1]
	    hm_insts_percent = file_str[start_area : end_area].strip().split("\n")[1].split(":")[1].split()[3].strip("(").strip(")")
	else:
	     hm_insts_area = "0"
	     hm_insts_percent = "0"
	
	bb_insts = file_str[start_area : end_area].strip().split("\n")[2].split(":")[1].split()[0]
	
	if bb_insts != "0": 
	    bb_insts_area = file_str[start_area : end_area].strip().split("\n")[2].split(":")[1].split()[1]
	    bb_insts_percent = file_str[start_area : end_area].strip().split("\n")[2].split(":")[1].split()[3].strip("(").strip(")")
	else:
	     bb_insts_area = "0"
	     bb_insts_percent = "0"
	
	##### TIMING Parsing
	
	start_timing = file_str.find(timing_str) + len(timing_str)
	end_timing = file_str.find(congestion_str)
	
	wns = file_str[start_timing : end_timing].strip().split("\n")[1].split(":")[1].strip().split()[0]
	tns = file_str[start_timing : end_timing].strip().split("\n")[2].split(":")[1].strip().split()[0]
	io_wns = file_str[start_timing : end_timing].strip().split("\n")[5].split(":")[1].strip().split()[0]
	io_tns = file_str[start_timing : end_timing].strip().split("\n")[6].split(":")[1].strip().split()[0]
	
	##### Congestion Parsing
	
	start_cong = file_str.find(congestion_str) + len(congestion_str)
	end_cong = file_str.find(delimiter_str, start_cong)
	
	cong_str = file_str[start_cong : end_cong].strip().split(":")
	
	if len(cong_str) == 1:
	    cong_mods = "0"
	else:
	    cong_mods = cong_str[1].strip()
	
	result = {}
	result["name"] = design
	result["insts"] = core_insts
	result["insts_area"] = core_insts_area
	result["insts_percent"] = core_insts_percent
	result["hm"] = hm_insts
	result["hm_area"] = hm_insts_area
	result["hm_percent"] = hm_insts_percent
	result["bb"] = bb_insts
	result["bb_area"] = area(bb_insts_area)
	result["bb_percent"] = bb_insts_percent
	result["wns"] = area(wns)
	result["tns"] = area(tns)
	result["io_wns"] = area(io_wns)
	result["io_tns"] = area(io_tns)
        result["cong"] = cong_mods
	return result


if __name__ == '__main__':

	parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description='Script to generate SGP summary', epilog='Examples:\n  create_sgp_summary.py <project_root>/f4 --> generate summary for all the chiplets\n  create_sgp_summary.py <project_root>/f4/<chiplet>/spyglass --> generate summary for <chiplet>')
	parser.add_argument("search_dir", help="Path to the directory where SGP results are located. To limit the search to a particular chiplet, specify the path till project_root/f4/chiplet/spyglass")
	args = parser.parse_args()
	final_rslt = defaultdict(dict)
	for r,d,f in os.walk(args.search_dir):
	    for files in f:
	        if files == "Physical_Summary.rpt":
	            full_file_path = os.path.join(r, files)
	            if "spyglass_reports" in full_file_path:
	                print "reading:", full_file_path
	                sfile = open(full_file_path, 'r')
	                sss = sfile.read()
	                rslt = parse_phy_summary(sss)
	                final_rslt[rslt["name"]].update(rslt)
		if files == "t_FaninCone.csv":
			full_file_path = os.path.join(r, files)
			if "reports-detail" in full_file_path:
				print "Reading: ",full_file_path
				mod_name = full_file_path.split('RESULTS/')[1].split('/')[0]
				final_rslt[mod_name]["Fanin_Viols"] = 0
				for line in open(full_file_path):
					final_rslt[mod_name]["Fanin_Viols"] += 1
				final_rslt[mod_name]["Fanin_Viols"] -= 1
		if files == "t_FanoutCone.csv":
			full_file_path = os.path.join(r, files)
			if "reports-detail" in full_file_path:
				print "Reading: ",full_file_path
				mod_name = full_file_path.split('RESULTS/')[1].split('/')[0]
				final_rslt[mod_name]["Fanout_Viols"] = 0
				for line in open(full_file_path):
					final_rslt[mod_name]["Fanout_Viols"] += 1
				final_rslt[mod_name]["Fanout_Viols"] -= 1
		if files.startswith("SGP_module_summary_"):
			full_file_path = os.path.join(r, files)
			mod_name = full_file_path.split('RESULTS/')[1].split('/')[0]
			if files == "SGP_module_summary_"+mod_name+".rpt":
				for line in open(full_file_path):
					if "Average Pins per Net" in line:
						final_rslt[mod_name]["Avg_pins_pet_net"] = float(line.split()[5])
					elif "Average Pins per Instance" in line:
						final_rslt[mod_name]["Avg_pins_pet_inst"] = float(line.split()[5])
		if files == "SGP_logical_congestion.rpt":
			full_file_path = os.path.join(r, files)
			print "Reading: ", full_file_path
			mod_name = full_file_path.split('RESULTS/')[1].split('/')[0]
			final_rslt[mod_name]["PHY_CongModules"] = open(full_file_path).read()

	
	hdgns = ['Subchip','Num of Instances', 'Instances Area (in mm2)','Instances percent','Num of Hard Macros','Hard Macros Area (in mm2)','Hard Macro Area Percent','Num of Blackboxes','Blackboxes Area (in mm2)','Blackboxes Area percent','WNS (ps)','TNS (ps)','IO WNS (ps)','IO TNS (ps)','Number of congested modules','Fanin Violations (threshold: 4000)','Fanout Violations (threshold: 4000)','Average Pins Per Net','Average Pins Per Instance', 'PHY_CongModules']
	kinds = 'text int float percent int float percent int float percent float float float float int int int float float link'.split()
	heading_xf = ezxf('font: bold on; align: wrap on, vert centre, horiz center')
	kind_to_xf_map = {
		'text': ezxf(),
		'int' : ezxf(num_format_str='#,##0'),
		'float' : ezxf(num_format_str='#,##0.00'),
		'percent' : ezxf(num_format_str='#,##0.00'),
		'link' : ezxf('font: color blue,underline 1')
		}
	data_xfs = [kind_to_xf_map[k] for k in kinds]
	f4_bri = []
	f4_de = []
	f4_mec = []
	f4_prt = []
	f4_voq = []
	additional_tabs = {}
	for key in sorted(final_rslt.keys()):
            if "PHY_CongModules" in final_rslt[key]:
		    additional_tabs[key+'_cong_mods'] = final_rslt[mod_name]["PHY_CongModules"]
            try:
		    col = [final_rslt[key]["name"],int(final_rslt[key]["insts"]),float(final_rslt[key]["insts_area"]),int(final_rslt[key]["insts_percent"].split("%")[0]),int(final_rslt[key]["hm"]),float(final_rslt[key]["hm_area"]),int(final_rslt[key]["hm_percent"].split("%")[0]),int(final_rslt[key]["bb"]), float(final_rslt[key]["bb_area"]),int(final_rslt[key]["bb_percent"].split("%")[0]),float(final_rslt[key]["wns"]),float(final_rslt[key]["tns"]),float(final_rslt[key]["io_wns"]),float(final_rslt[key]["io_tns"]),float(final_rslt[key]["cong"]),int(final_rslt[key]["Fanin_Viols"]),int(final_rslt[key]["Fanout_Viols"]),final_rslt[key]["Avg_pins_pet_net"],final_rslt[key]["Avg_pins_pet_inst"], xlwt.Formula('HYPERLINK("#'+key+'_cong_mods!A1", "Details")')]
	    except KeyError:
		    print "Warning:", key, "run is not complete"
		    col = [final_rslt[key]["name"],int(final_rslt[key]["insts"]),float(final_rslt[key]["insts_area"]),int(final_rslt[key]["insts_percent"].split("%")[0]),int(final_rslt[key]["hm"]),float(final_rslt[key]["hm_area"]),int(final_rslt[key]["hm_percent"].split("%")[0]),int(final_rslt[key]["bb"]), float(final_rslt[key]["bb_area"]),int(final_rslt[key]["bb_percent"].split("%")[0]),float(final_rslt[key]["wns"]),float(final_rslt[key]["tns"]),float(final_rslt[key]["io_wns"]),float(final_rslt[key]["io_tns"]),float(final_rslt[key]["cong"]),0,0,0.0,0.0]
		    
            if "f4_p" in key:
		    f4_prt.append(col)
	    elif "f4_b" in key:
		    f4_bri.append(col)
	    elif "f4_m" in key:
		    f4_mec.append(col)
	    elif "f4_d" in key:
		    f4_de.append(col)
	    else:
		    f4_voq.append(col)

	if (len(f4_bri) > 0):
		write_xls('SGP_summary.xls', 'f4_bri', hdgns, f4_bri, heading_xf, data_xfs)
	if (len(f4_de) > 0):
		write_xls('SGP_summary.xls', 'f4_de', hdgns, f4_de, heading_xf, data_xfs)
	if (len(f4_mec) > 0):
		write_xls('SGP_summary.xls', 'f4_mec', hdgns, f4_mec, heading_xf, data_xfs)
	if (len(f4_prt) > 0):
		write_xls('SGP_summary.xls', 'f4_prt', hdgns, f4_prt, heading_xf, data_xfs)
	if (len(f4_voq) > 0):
		write_xls('SGP_summary.xls', 'f4_voq', hdgns, f4_voq, heading_xf, data_xfs)
	for k in additional_tabs:
		sheet = book.add_sheet(k)
		first_col = sheet.col(0)
		first_col.width = 256 * 160
		sheet.write(0, 0, additional_tabs[k], ezxf('align: wrap 1'))
	book.save('SGP_summary.xls')


