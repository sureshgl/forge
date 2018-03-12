package com.forge.parser;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ParseTree;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.stringtemplate.v4.ST;
import org.stringtemplate.v4.STGroupFile;

import com.forge.fex.verilogprime.ext.AbstractBaseExt;
import com.forge.parser.IR.IField;
import com.forge.parser.IR.IHashTable;
import com.forge.parser.IR.IMemogenCut;
import com.forge.parser.IR.IMemory;
import com.forge.parser.IR.IRegister;
import com.forge.parser.data.Field;
import com.forge.parser.data.HashTable;
import com.forge.parser.data.MemInstance;
import com.forge.parser.data.Memory;
import com.forge.parser.data.RegInstance;
import com.forge.parser.data.Register;
import com.forge.parser.gen.ForgeParser.StartContext;

import lombok.Getter;
import lombok.Setter;

public class ForgeUtils {

	private static final Logger L = LoggerFactory.getLogger(ForgeUtils.class);
	@Setter @Getter
	static private File st;
	@Setter @Getter
	static private String forgeSpecName;
	@Setter @Getter
	static private boolean shouldStitch = true;
	

	public static String getAlgo(String portCap){		
		InputStream is = ForgeUtils.class.getResourceAsStream("/resources/data/algos.txt");
		BufferedReader br = new BufferedReader(new InputStreamReader(is));
		StringBuilder sb = new StringBuilder();
		String line;
		try {
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		ObjectMapper mapper = new ObjectMapper();
		Map<String,String> algos = null;
		try {
			algos = mapper.readValue(sb.toString(), new TypeReference<Map<String, String>>(){});
		} catch (IOException e) {
			throw new RuntimeException("Could not read the alogs file from resources");
		}
		return algos.get(portCap);
	}
	
	private static com.forge.fex.verilogprime.utils.ExtendedContextVisitor verilogExtendedContextVisitor = new com.forge.fex.verilogprime.utils.ExtendedContextVisitor();

	public static AbstractBaseExt getVerilogExtendedContext(ParseTree context) {
		if (context != null) {
			return verilogExtendedContextVisitor.visit(context);
		} else {
			L.warn("Returning Null for extendedContext");
			return null;
		}
	}

	
	public static Map<String,String> evaluateParameters(Map<String,ParserRuleContext> parameters){
		Map<String,String> symbolTable = new HashMap<String,String>();
		for(String key : parameters.keySet()){
			symbolTable.put(key, getVerilogExtendedContext(parameters.get(key)).getFormattedText());
		}
		EvaluateVisitor evaluateVisitor = new EvaluateVisitor(symbolTable);
		while(!parametersProcessingCompleted(evaluateVisitor.getSymbolTable())){
			Map<String,String> symbolTableTemp = new HashMap<String,String>();
			for(String key : parameters.keySet()){
				String ret = evaluateVisitor.visit(parameters.get(key));
				symbolTableTemp.put(key, ret);
			}
			if(symbolTableTemp.equals(evaluateVisitor.getSymbolTable())){
				throw new RuntimeException("Cannot Evaluate some of the parameters from Top module");
			} else {
				evaluateVisitor.setSymbolTable(symbolTableTemp);
			}
		}
		return evaluateVisitor.getSymbolTable();
	}

	private static boolean parametersProcessingCompleted(Map<String, String> symbolTable) {
		for(String key : symbolTable.keySet()){
			try{
				Integer.parseInt(symbolTable.get(key));
			} catch(NumberFormatException n){
				return false;
			}
		}
		return true;
	}

	public static Map<String,String> getConnections(String first, String second) {
		Map<String,String> connections = new LinkedHashMap<String,String>();
		connections.put("u_req_valid_"+first,"d_req_valid_"+second);
		connections.put("u_req_intr_"+first,"d_req_intr_"+second);
		connections.put("u_req_type_"+first,"d_req_type_"+second);
		connections.put("u_req_attr_"+first,"d_req_attr_"+second);
		connections.put("u_req_size_"+first,"d_req_size_"+second);
		connections.put("u_req_data_"+first,"d_req_data_"+second);
		connections.put("u_req_stall_"+first,"d_req_stall_"+second);
		return connections;
	}

	public static List<Register> getRegisters(StartContext startContext) {
		List<Register> registers = new ArrayList<>();
		for (IRegister iRegister : startContext.extendedContext.getRegisters()) {
			List<RegInstance> instances = new ArrayList<>();
			for (int i = 0; i < iRegister.getArraySize(); i++) {
				List<Field> fields = new ArrayList<>();
				for (IField iField : iRegister.getFields()) {
					fields.add(new Field(iField));
				}
				instances.add(new RegInstance(iRegister, i, fields));
			}
			registers.add(new Register(instances, iRegister.getName()));
		}
		return registers;
	}

	public static List<Memory> getMemories(StartContext startContext) {
		List<Memory> memories = new ArrayList<>();
		for (IMemory memory : startContext.extendedContext.getMemories()) {
			List<MemInstance> instances = new ArrayList<>();
			for (int i = 0; i < memory.getArraySize(); i++) {
				List<Field> fields = new ArrayList<>();
				for (IField iField : memory.getFields()) {
					fields.add(new Field(iField));
				}
				//instances.add(new MemInstance(memory, i,fields));
				//fields not a part of memory yet!
				instances.add(new MemInstance(memory, i));
			}
			memories.add(new Memory(instances,memory.getName()));
		}
		return memories;
	}
	
	public static List<IMemogenCut> getMemogenCuts(StartContext startContext){
		return startContext.extendedContext.getMemogenCuts();
	}

	public static List<HashTable> getHashTables(StartContext sc) {
		List<HashTable> hashTables = new ArrayList<HashTable>();
		for(IHashTable hashTable : sc.extendedContext.getHashTables()){
			hashTables.add(new HashTable(hashTable));
		}
		return hashTables;
	}

	private static STGroupFile getTemplate(String name) {
		String filename = ForgeUtils.st.toString() + "/" + name;
		File f = new File(filename);
		if (!f.exists()) {
			throw new RuntimeException(name + " file missing in the String tempaltes Directory");
		}
		STGroupFile st = new STGroupFile(filename);
		return st;
	}

	public static ST getMemoryStringTemplate() {
		STGroupFile stg = ForgeUtils.getTemplate("memory.stg");
		return stg.getInstanceOf("memory");
	}

	public static ST getMemoryWithoutMemogenStringTemplate() {
		STGroupFile stg = ForgeUtils.getTemplate("memory_withoutMemogen.stg");
		return stg.getInstanceOf("memory_withoutMemogen");
	}

	public static ST getMemoryWrapStringTemplate() {
		STGroupFile stg = ForgeUtils.getTemplate("memory_wrap.stg");
		return stg.getInstanceOf("memory_wrap");
	}

	public static ST getRnaxiSlvTopStringTemplate() {
		STGroupFile stg = ForgeUtils.getTemplate("rnaxi_slv_top.stg");
		return stg.getInstanceOf("rnaxi_slv_top");
	}

	public static ST getRnaxiRegWrapStringTemplate() {
		STGroupFile stg = ForgeUtils.getTemplate("rnaxi_reg_wrap.stg");
		return stg.getInstanceOf("rnaxi_reg_wrap");
	}

	public static ST getRnaxiMemWrapStringTemplate() {
		STGroupFile stg = ForgeUtils.getTemplate("rnaxi_mem_wrap.stg");
		return stg.getInstanceOf("rnaxi_mem_wrap");
	}

	public static ST getRnaxiSlvAddrDecoderStringTemplate() {
		STGroupFile stg = ForgeUtils.getTemplate("rnaxi_slv_addr_decoder.stg");
		return stg.getInstanceOf("rnaxi_slv_addr_decoder");
	}

	public static ST getHtmlStringTemplate() {
		STGroupFile stg = ForgeUtils.getTemplate("html.stg");
		return stg.getInstanceOf("html");
	}


}
