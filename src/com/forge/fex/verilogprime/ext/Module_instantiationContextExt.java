package com.forge.fex.verilogprime.ext;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Data_declarationContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ExpressionContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_declarationContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_identifierContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_instantiationContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Net_declarationContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Param_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;
import com.forge.fex.verilogprime.utils.SingletonModuleUtility;
import com.forge.parser.ForgeUtils;

public class Module_instantiationContextExt extends AbstractBaseExt {

	public Module_instantiationContextExt(Module_instantiationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Module_instantiationContext getContext() {
		return (Module_instantiationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).module_instantiation());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Module_instantiationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Module_instantiationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public List<Module_identifierContext> getModuleInstantiations() {
		List<Module_identifierContext> instantiations = new ArrayList<>();
		Module_instantiationContext ctx = getContext();
		instantiations.add(ctx.module_identifier());
		return instantiations;
	}

	@Override
	public void stitchOnlySlvTop(String module_name, Map<String, String> addedParameters,
			Map<String, ParserRuleContext> addedLogics, Map<String, Net_declarationContext> addedWires) {
		Module_instantiationContext ctx = getContext();
		String instantiated_module_name = ctx.module_identifier().extendedContext.getFormattedText();
		if (instantiated_module_name.contains("rnaxi_slv_top")) { // this is a hack from krishna
			stitch(module_name, addedParameters, addedLogics, addedWires);
		}
	}

	@Override
	public void stitchOnly(List<String> modules,String module_name, Map<String, String> addedParameters,
			Map<String, ParserRuleContext> addedLogics, Map<String, Net_declarationContext> addedWires) {
		Module_instantiationContext ctx = getContext();
		String instantiated_module_name = ctx.module_identifier().extendedContext.getFormattedText();
		if (modules.contains(instantiated_module_name)) { 
			stitch(module_name, addedParameters, addedLogics, addedWires);
		}
	}

	@Override
	public void stitch(String module_name, Map<String, String> addedParameters,
			Map<String, ParserRuleContext> addedLogics, Map<String, Net_declarationContext> addedWires) {

		Module_declarationContext module_declarationContext = SingletonModuleUtility.getInstance()
				.getModule(module_name);
		Map<String, String> parametersInThis = new LinkedHashMap<>();
		module_declarationContext.extendedContext.populateAllParameters(parametersInThis);

		Module_instantiationContext ctx = getContext();
		if (ctx.hierarchical_instance().size() > 1) {
			AbstractBaseExt.L.error("Multiple instances encounted at module instantiation. Not Supported Yet.");
		}
		String instantiated_module_name = ctx.module_identifier().extendedContext.getFormattedText();
		String instance_name = getInstanceName();
		Module_declarationContext instantiatedModuleContext = SingletonModuleUtility.getInstance()
				.getModule(instantiated_module_name);
		List<Data_declarationContext> addedLogicsForInstantiatedModule = SingletonModuleUtility.getInstance()
				.getAddedLogics(instantiated_module_name);

		Map<String, ExpressionContext> portConnectionsDeclared = new LinkedHashMap<>();
		collectDeclaredPortConnections(portConnectionsDeclared);
		Map<String, Param_expressionContext> parameterConnectionsDeclared = new LinkedHashMap<>();
		collectDeclaredParameterConnections(parameterConnectionsDeclared);

		Map<String, ParserRuleContext> portConnectionsDefault = new LinkedHashMap<>();
		instantiatedModuleContext.extendedContext.populatePorts(portConnectionsDefault);
		populatedAddedPorts(portConnectionsDefault, addedLogicsForInstantiatedModule);
		Map<String, String> parameterConnectionsDefault = new LinkedHashMap<>();
		instantiatedModuleContext.extendedContext.populateParameters(parameterConnectionsDefault);

		Map<String, String> parameterConnections = getParameterConnections(module_name, instantiated_module_name,
				instance_name, parametersInThis, addedParameters, parameterConnectionsDeclared,
				parameterConnectionsDefault);
		Map<String, String> portConnections = null;
		if(instantiated_module_name.contains("_ram_")){
			portConnections = getPortConnectionsForMemogen(portConnectionsDeclared,portConnectionsDefault,instantiated_module_name);
		} else {
			portConnections = getPortConnections(portConnectionsDeclared, portConnectionsDefault);
		}

		String completed_miString = getMiString(instantiated_module_name, instance_name, parameterConnections,
				portConnections);

		Module_instantiationContext modifiedContext = (Module_instantiationContext) getContext(completed_miString);
		checkPortDeclarations(modifiedContext, module_name, parameterConnections, portConnectionsDefault, addedLogics,
				addedWires);
		addToContexts(modifiedContext);
	}

	private void checkPortDeclarations(Module_instantiationContext modifiedContext, String module_name,
			Map<String, String> parameterConnections, Map<String, ParserRuleContext> portConnectionsDefault,
			Map<String, ParserRuleContext> addedLogics, Map<String, Net_declarationContext> addedWires) {
		Module_declarationContext moduleContext = SingletonModuleUtility.getInstance().getModule(module_name);

		Map<String, ExpressionContext> portConnectionsDeclared = new LinkedHashMap<>();
		modifiedContext.extendedContext.collectDeclaredPortConnections(portConnectionsDeclared);

		Map<String, String> portsToDeclare = new LinkedHashMap<>();

		for (String port_name : portConnectionsDeclared.keySet()) {
			ExpressionContext expressionContext = portConnectionsDeclared.get(port_name);
			if (expressionContext != null) {
				List<String> variablesInExpressions = expressionContext.extendedContext.getVariables();
				if (variablesInExpressions.size() == 1) {
					if (!moduleContext.extendedContext.isPortDeclared(variablesInExpressions.get(0))) {
						portsToDeclare.put(port_name, variablesInExpressions.get(0));
					}
				}
			}
		}
		declarePorts(portsToDeclare, parameterConnections, portConnectionsDefault, addedLogics, addedWires);
	}

	private void declarePorts(Map<String, String> portsToDeclare, Map<String, String> parameterConnections,
			Map<String, ParserRuleContext> portConnectionsDefault, Map<String, ParserRuleContext> addedLogics,
			Map<String, Net_declarationContext> addedWires) {

		PopulateExtendedContextVisitor populateExtendedContextVisitor = new PopulateExtendedContextVisitor();
		for (String port_name : portsToDeclare.keySet()) {
			ParserRuleContext declarationContext = portConnectionsDefault.get(port_name);
			if (addedLogics.containsKey(portsToDeclare.get(port_name))) {
				ParserRuleContext parserRuleContext = addedLogics.get(portsToDeclare.get(port_name));
				if (getExtendedContext(declarationContext).isInput() && getExtendedContext(parserRuleContext).isOutput()
						|| getExtendedContext(declarationContext).isOutput()
						&& getExtendedContext(parserRuleContext).isInput()) {
					addedLogics.remove(portsToDeclare.get(port_name));
					Map<String, String> table = new LinkedHashMap<>();
					table.putAll(parameterConnections);
					table.put(port_name, portsToDeclare.get(port_name));
					table.put("input", "wire");
					table.put("output", "wire");
					table.put("reg", "");
					String declaration = getExtendedContext(declarationContext)
							.getAlteredStringForWireDeclaration(port_name, table);
					// hack
					if (!declaration.endsWith(";")) {
						declaration += ";";
					}
					Net_declarationContext net_declarationContext = (Net_declarationContext) populateExtendedContextVisitor
							.visit(getPrimeParser(declaration).net_declaration());
					addedWires.put(portsToDeclare.get(port_name), net_declarationContext);
				}
			} else {
				Map<String, String> table = new LinkedHashMap<>();
				table.putAll(parameterConnections);
				table.put(port_name, portsToDeclare.get(port_name));
				String declaration = getExtendedContext(declarationContext)
						.getAlteredStringForWireDeclaration(port_name, table);
				// hack
				if (!declaration.endsWith(";")) {
					declaration += ";";
				}
				ParserRuleContext parserRuleContext = populateExtendedContextVisitor
						.visit(getPrimeParser(declaration).module_item());
				addedLogics.put(portsToDeclare.get(port_name), parserRuleContext);
			}
		}
	}

	private void populatedAddedPorts(Map<String, ParserRuleContext> portConnectionsDefault,
			List<Data_declarationContext> addedLogicsForInstantiatedModule) {
		for (Data_declarationContext data_declarationContext : addedLogicsForInstantiatedModule) {
			String name = data_declarationContext.extendedContext.getVariableName();
			portConnectionsDefault.put(name, data_declarationContext);
		}
	}

	private Map<String, String> getParameterConnections(String module_name, String instantiated_module_name,
			String instance_name, Map<String, String> parametersInThis, Map<String, String> addedParameters,
			Map<String, Param_expressionContext> parameterConnectionsDeclared,
			Map<String, String> parameterConnectionsDefault) {

		Map<String, String> parameterConnections = new LinkedHashMap<>();

		for (String parameter : parameterConnectionsDefault.keySet()) {
			if (!parameterConnectionsDeclared.containsKey(parameter)) {
				parameterConnections.put(parameter, parameter);
				if (!parametersInThis.containsKey(parameter) && !addedParameters.containsKey(parameter)) {
					addedParameters.put(parameter, parameterConnectionsDefault.get(parameter));
				}
			} else {
				parameterConnections.put(parameter,
						parameterConnectionsDeclared.get(parameter).extendedContext.getFormattedText());
				List<String> variablesInExpressions = parameterConnectionsDeclared.get(parameter).extendedContext
						.getVariables();
				for (String variable : variablesInExpressions) {
					if (!parametersInThis.containsKey(variable) && !addedParameters.containsKey(variable)) {
						addedParameters.put(parameter, parameterConnectionsDefault.get(parameter));
					}
				}
			}
		}
		return parameterConnections;
	}

	private Map<String, String> getPortConnectionsForMemogen(Map<String, ExpressionContext> portConnectionsDeclared,
			Map<String, ParserRuleContext> portConnectionsDefault, String instantiated_module_name) {
		String instance_name = getInstanceName();
		Map<String, String> portConnections = new LinkedHashMap<>();
		for (String portName : portConnectionsDefault.keySet()) {
			if (portConnectionsDeclared.containsKey(portName)) {
				if (portConnectionsDeclared.get(portName) == null) {
					portConnections.put(portName, "");
				} else {
					String value = portConnectionsDeclared.get(portName).extendedContext.getFormattedText();
					portConnections.put(portName, value);
				}
			}
			else {
				String temp = portName;
				if(portName.startsWith("read_vld_") || portName.startsWith("read_serr_") || portName.startsWith("read_derr_")){
					temp = ForgeUtils.getForgeSpecName()+"_"+instance_name+"_"+portName;
				}
				if(portName.contains("read_padr_")){
					portConnections.put(portName, "");
				} else {
					Pattern p = Pattern.compile("(.*)?(_)([0-9]+)");
					Matcher m = p.matcher(temp);
					if(m.matches()){
						portConnections.put(portName, m.group(1)+"["+m.group(3)+"]");
					}  else {
						portConnections.put(portName, temp);
					}
				}
			}
		}
		return portConnections;
	}

	private Map<String, String> getPortConnections(Map<String, ExpressionContext> portConnectionsDeclared,
			Map<String, ParserRuleContext> portConnectionsDefault) {
		Map<String, String> portConnections = new LinkedHashMap<>();
		for (String portName : portConnectionsDefault.keySet()) {
			if (portConnectionsDeclared.containsKey(portName)) {
				if (portConnectionsDeclared.get(portName) == null) {
					portConnections.put(portName, "");
				} else {
					String value = portConnectionsDeclared.get(portName).extendedContext.getFormattedText();
					portConnections.put(portName, value);
				}
			} else {
				portConnections.put(portName, portName);
			}
		}
		return portConnections;
	}

	private String getMiString(String module_instantiated, String instance_name,
			Map<String, String> parameterConnections, Map<String, String> portConnections) {
		StringBuilder sb = new StringBuilder();
		sb.append("\n\n");
		sb.append(module_instantiated + "# (");
		String prefix = "";
		for (String parameter : parameterConnections.keySet()) {
			sb.append(prefix + "." + parameter + "(" + parameterConnections.get(parameter) + ")");
			prefix = ",\n\t";
		}
		sb.append(") \n" + instance_name + " (");
		prefix = "";
		for (String port : portConnections.keySet()) {
			sb.append(prefix + "." + port + "(" + portConnections.get(port) + ")");
			prefix = ",\n\t";
		}
		sb.append(");\n");
		return sb.toString();
	}

	@Override
	protected Boolean isPortDeclared(String portName) {
		return false;
	}

	@Override
	public void checkConnections(String module_name) {
		Module_instantiationContext ctx = getContext();
		if (ctx.hierarchical_instance().size() > 1) {
			AbstractBaseExt.L.error("Multiple instances encounted at module instantiation. Not Supported Yet.");
		}

		String instantiated_module_name = ctx.module_identifier().extendedContext.getFormattedText();
		String instance_name = getInstanceName();
		Module_declarationContext instantiatedModuleContext = SingletonModuleUtility.getInstance()
				.getModule(instantiated_module_name);
		if(instantiatedModuleContext != null){

			Map<String, ExpressionContext> portConnectionsDeclared = new LinkedHashMap<>();
			collectDeclaredPortConnections(portConnectionsDeclared);
			Map<String, Param_expressionContext> parameterConnectionsDeclared = new LinkedHashMap<>();
			collectDeclaredParameterConnections(parameterConnectionsDeclared);

			Map<String, ParserRuleContext> portConnectionsDefault = new LinkedHashMap<>();
			instantiatedModuleContext.extendedContext.populatePorts(portConnectionsDefault);
			Map<String, String> parameterConnectionsDefault = new LinkedHashMap<>();
			instantiatedModuleContext.extendedContext.populateParameters(parameterConnectionsDefault);

			for (String parameter : parameterConnectionsDefault.keySet()) {
				if (!parameterConnectionsDeclared.keySet().contains(parameter)) {
					AbstractBaseExt.L.warn("Parameter " + parameter + " is not connected in instance " + instance_name
							+ " in module " + module_name);
				}
			}

			for (String port : portConnectionsDefault.keySet()) {
				if (!portConnectionsDeclared.keySet().contains(port)) {
					AbstractBaseExt.L.warn("Port " + port + " is not connected in instance " + instance_name + " in module "
							+ module_name);
				}
			}
		}
		else {
			L.warn("module "+instantiated_module_name +" is not provided. Skipping port connection checks");
		}
	}

	@Override
	public void appendRnaxiPorts(List<String> chain){
		Module_instantiationContext ctx = getContext();
		if (ctx.hierarchical_instance().size() > 1) {
			AbstractBaseExt.L.error("Multiple instances encounted at module instantiation. Not Supported Yet.");
		}
		String instantiated_module_name = ctx.module_identifier().extendedContext.getFormattedText();
		String instance_name = getInstanceName();
		if(chain.contains(instantiated_module_name)){
			Integer i = chain.indexOf(instantiated_module_name);
			Integer j = null;
			if(i == 0){
				j = chain.size()-1;
			} else {
				j = i-1;
			}
			StringBuilder sb = new StringBuilder();
			sb.append(instantiated_module_name +" ");
			if(ctx.parameter_value_assignment() != null)
				sb.append(ctx.parameter_value_assignment().extendedContext.getFormattedText());
			sb.append("\n");
			sb.append(instance_name+" (");

			Map<String, ExpressionContext> portConnectionsDeclared = new LinkedHashMap<>();
			collectDeclaredPortConnections(portConnectionsDeclared);

			String suffix_i = "";
			Module_declarationContext instantiatedModuleContext = SingletonModuleUtility.getInstance()
					.getModule(instantiated_module_name);
			Map<String, ParserRuleContext> portConnectionsDefault = new LinkedHashMap<>();
			instantiatedModuleContext.extendedContext.populatePorts(portConnectionsDefault);
			for(String key : portConnectionsDefault.keySet()){
				if(key.contains("u_req_valid")){
					suffix_i = key.replace("u_req_valid", "");
					if(!suffix_i.equals("") && suffix_i.charAt(0) == '_'){
						suffix_i = suffix_i.substring(1);
					}
					break;
				}
			}
			String suffix_j = "";
			instantiatedModuleContext = SingletonModuleUtility.getInstance()
					.getModule(chain.get(j));
			portConnectionsDefault = new LinkedHashMap<>();
			instantiatedModuleContext.extendedContext.populatePorts(portConnectionsDefault);
			for(String key : portConnectionsDefault.keySet()){
				if(key.contains("u_req_valid")){
					suffix_j = key.replace("u_req_valid", "");
					if(!suffix_j.equals("") && suffix_j.charAt(0) == '_'){
						suffix_j = suffix_j.substring(1);
					}
					break;
				}
			}

			Map<String,String> rnaxiConnections = ForgeUtils.getConnections(suffix_i, suffix_j);

			String prefix = "";
			for(String port : rnaxiConnections.keySet()){
				sb.append(prefix);
				sb.append("\n."+port+"("+rnaxiConnections.get(port)+")");
				prefix = ",";
			}
			for(String port : portConnectionsDeclared.keySet()){
				if(!rnaxiConnections.containsKey(port)){
					sb.append(prefix);
					if(portConnectionsDeclared.get(port) == null){
						sb.append("\n."+port+"()");
					} else {
						sb.append("\n."+port+"("+portConnectionsDeclared.get(port).extendedContext.getFormattedText()+")");
					}
				}
				prefix = ",";
			}
			sb.append("\n);");
			addToContexts(getContext(sb.toString()));
		}
	}
}
