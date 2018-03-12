import re
import sys
import os.path
import json
import fnmatch
import shutil
from pprint import pprint

modules_list = {} 
class ModuleIndexer():
    def __init__(self, moduleName=None, startLine=None,endLine=None,file_name=None):
        self.moduleName = moduleName
        self.startLine = startLine
        self.endLine = endLine
        self.file_name = file_name
      
    def get_module_from_file(self,module_name,output_filename,cut_name):
        with open(self.file, 'r+') as f:
            lines = f.readlines()
            line = re.sub(self.moduleName,self.moduleName+"_"+cut_name, lines[self.startLine-1])
            module_content = line
            
            for i in range(self.startLine+1,self.endLine+1):
                module_content = module_content+lines[i-1]
        
        return module_content
    
class FileNotFoundError(OSError):
    pass

def main(argv):
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('-name',required=True,dest='cut_name',default=[],help='reads the json with name from cutinfo')
    parser.add_argument('-nosva',dest='nosva',help='if given sva is run else nosva is treated as default',action='store_false')
    args = parser.parse_args()
    run(args)
    
def index_modules(file_name):
    patternStart = re.compile('\s*(module|macromodule)\s*(\w*)\s*.*');
    patternEnd = re.compile("\s*endmodule\s*.*");
    with open(file_name, 'r+') as f:
        line_count = 1
        for line in f:
            matches = patternStart.match(line)
            if(matches):
                module_name =  matches.group(2).rstrip()
                moduleIndexer = ModuleIndexer()
                if modules_list.get(module_name):
                    print "already exists in modules_list"
                    raise ValueError("already exists in modules_list")
                else :
                    moduleIndexer.moduleName = module_name
                    moduleIndexer.startLine = line_count
                    moduleIndexer.file = file_name
                    
            matches_end = patternEnd.match(line)
            if(matches_end):
                moduleIndexer.endLine = line_count
                if not modules_list.has_key(module_name):
                    modules_list[module_name] = moduleIndexer
            line_count = line_count+1
            
def replace_moduleInstantiations(unroll_dir,output_filename,modules_list,cut_name,extension):
    with open("staging/"+output_filename+".v", 'rw+') as f:
        lines = f.read()
        for module in modules_list.keys():
            lines = lines.replace(module+" ", module+"_"+cut_name+" ")
        f= open(os.path.join(unroll_dir,cut_name+extension),"w")
        f.write(lines) 
        f.close()

def write_smurfFiles(unroll_dir,output_filename,cut_name,ip_dir):
    smurf_rtlFiles = [ip_dir+"flop_array/rtl/rtl.f",ip_dir+"/smurf/rtl/rtl.f", ip_dir+"flop_array/async/rtl/rtl.f"]
    fileList = getRtlFileList(smurf_rtlFiles)
    with open(os.path.join(unroll_dir,cut_name+"_core.v"), 'a') as f:
        for file_in_smurfList in fileList:
            with open(file_in_smurfList, 'r') as f_read:
                lines = f_read.read()
                f.write(lines)
                f_read.close()
    f.close()
    
            
def getRtlFileList(dotFFiles):
    rtl_files_list = []
    for dotFFile in dotFFiles:
        rtlDirName = os.path.dirname(dotFFile)
        with open(dotFFile, 'r+') as f:
            for line in f:
                line = line.rstrip()
                if line :
                    fileName = rtlDirName+"/"+line
                    if os.path.isfile(fileName) :
                        rtl_files_list.append(fileName)
                    else:
                        raise FileNotFoundError(fileName)
    return  rtl_files_list
                
def get_rtlDotFFile(algo_name,ip_rtl_dir):
    result = []
    for root, directories, filenames in os.walk(ip_rtl_dir):
        
        for filename in filenames: 
            if (fnmatch.fnmatch(filename, 'rtl.f') or fnmatch.fnmatch(filename, 'formal.f')):
                result.append(os.path.join(root, filename))
    return result
    
def get_cut_core_file(cut_name,ip_rtl_dir):
    with open(ip_rtl_dir+cut_name+"_core.v", 'r+') as f:
            lines = f.read()
    return lines

def write_svaFile(input_core_sva,ip_rtl_dir,algo_name,output_sva_file,cut_name):
    sva_file_in_ip_dir = ip_rtl_dir+"/algo_"+algo_name+"_sva_wrap.v"
    sva_file_content = ''
    sva_file_content = '//synopsys translate_off\n'
    with open(input_core_sva, 'r+') as f:
            lines = f.read()
            sva_file_content = sva_file_content+lines
            f.close()
    with open(sva_file_in_ip_dir, 'r+') as ip_sva_f:
            lines = ip_sva_f.read()
            sva_file_content = sva_file_content+lines
            ip_sva_f.close()
    sva_file_content = sva_file_content+'\n//synopsys translate_on'
    with open(output_sva_file, 'w+') as op_wr:
        for module_name in modules_list.keys():
            sva_file_content = re.sub(module_name,module_name+"_"+cut_name,sva_file_content)
        op_wr.write(sva_file_content)
        op_wr.close()
    cmd = "ncverilog -sysv_ext .sv -sysv_ext .v +sv +define+ASSERT_ON "+output_sva_file
    os.system(cmd)

def run(args):
    json_data=open("cutinfo/"+args.cut_name+".json")
    cutinfo =json.load(json_data)
    algo_name =  cutinfo['algo']
    cut_name = cutinfo['cutName']
    binary_path = cutinfo['binaryPath']
    ip_dir = binary_path+"/../verilogparser/ip/"
    ip_rtl_dir = ip_dir+algo_name+"/rtl"
    rtl_dir = "./../rtl/"
    external_dotF = ip_rtl_dir+"/external.f"
    
    dotFFiles = get_rtlDotFFile(algo_name,ip_rtl_dir)
    fileList = getRtlFileList(dotFFiles)
    staging_dir = "staging"
    output_filename = cut_name+"_core"
    unroll_dir = "./../rtl_pkg"
    output_sva_file = unroll_dir+"/"+cut_name+"_core_sva.v"
    
    if os.path.exists(staging_dir):
        shutil.rmtree(staging_dir)
    os.mkdir(staging_dir)
    if os.path.exists(unroll_dir):
        if os.path.islink(unroll_dir):
            os.unlink(unroll_dir)
        else:
            shutil.rmtree(unroll_dir)
    os.mkdir(unroll_dir)

    for file_name in fileList:
        index_modules(file_name)
    
    shutil.copy2(rtl_dir+cut_name+".v", staging_dir+"/") 
    replace_moduleInstantiations(unroll_dir,cut_name,modules_list,cut_name,".v")
    if args.nosva:
        write_svaFile(rtl_dir+cut_name+"_core_sva.v",ip_rtl_dir,algo_name,output_sva_file,cut_name) 
    with open(staging_dir+"/"+output_filename+".v","a+") as f:
        f.write(get_cut_core_file(cut_name,rtl_dir))
        for module_name in modules_list.keys():
            if not module_name == "algo_"+algo_name+"_sva_wrap":
                f.write(ModuleIndexer.get_module_from_file(modules_list[module_name], module_name,output_filename,cut_name))
    replace_moduleInstantiations(unroll_dir,output_filename,modules_list,cut_name,"_core.v")
    cmd = "ncverilog -sysv_ext .sv -sysv_ext .v +sv +define+ASSERT_ON "+unroll_dir+"/"+output_filename+".v "
    if os.path.exists(external_dotF):
        cmd = cmd+" -F "+external_dotF
    os.system(cmd)
    print "all done"    
    
if __name__ == '__main__':
    main(sys.argv[1:])


