package com.forge.parser.data;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import com.forge.parser.ForgeUtils;
import com.forge.parser.IR.IMemogenCut;

public class MemogenCut {

	public MemogenCut(IMemogenCut cutData,File out){
		this.cutData = cutData;
		this.out = out;
	}

	private File out;
	private IMemogenCut cutData;

	public String getWords() {
		return cutData.getWords();
	}

	public String getBits() {
		return cutData.getBits();
	}

	public String getName() {
		return cutData.getNameForMemogen()+"_ram_"+getWords()+"X"+getBits();
	}

	public String getDir() {
		return out.toString()+"/memogen";
	}

	public String getAlgo() {
		return ForgeUtils.getAlgo(cutData.getReadPortValue()+"r"+cutData.getWritePortValue()+"w");
	}

	public String toString(){
		return String.join(" ", getOptionsAsList());
	}

	public String[] getOptionsAsArray(){
		List<String> options = getOptionsAsList();
		String[] ret = new String[options.size()];
		ret = options.toArray(ret);
		return ret;
	}

	public List<String> getOptionsAsList(){
		List<String> options = new ArrayList<String>();
		options.add("-a");
		options.add(getAlgo());
		options.add("-w");
		options.add(getWords());
		options.add("-b");
		options.add(getBits());
		options.add("-name");
		options.add(getName());
		options.add("-dir");
		options.add(getDir());
		String cmdLine = cutData.getMemogenCmdLine();
		if(cmdLine == null){
			throw new RuntimeException("Command line hint missing in memory.");
		} else {
			options.addAll(optionsFromString(cmdLine));
		}
		return options;
	}

	private List<String> optionsFromString(String memogenCmdLine) {
		List<String> options = new ArrayList<String>();
		StringTokenizer tk = new StringTokenizer(memogenCmdLine, " ");
		while (tk.hasMoreTokens()) {
			String token = tk.nextToken();
			if( token.startsWith("\"") ){
				while( tk.hasMoreTokens() && !token.endsWith("\"") ) {
					// append our token with the next one.  Don't forget to retain commas!
					token += " " + tk.nextToken();
				}

				if( !token.endsWith("\"") ) {
					// open quote found but no close quote.  Error out.
					throw new RuntimeException("Incomplete string:" + token);
				}
			}
			options.add(token);
		}
		return options;
	}
}
