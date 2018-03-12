package com.forge.fex.verilogprime.ext;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.misc.Interval;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.forge.fex.verilogprime.gen.VerilogPrimeLexer;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ExpressionContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_identifierContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Net_declarationContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Param_expressionContext;
import com.forge.fex.verilogprime.interfaces.GetFormattedText;
import com.forge.fex.verilogprime.utils.ExtendedContextVisitor;

import lombok.AccessLevel;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Setter;

@Data
@EqualsAndHashCode(callSuper = false)
public abstract class AbstractBaseExt extends GetFormattedText {
	protected static final Logger L = LoggerFactory.getLogger(AbstractBaseExt.class);
	// variables
	private ExtendedContextVisitor extendedContextVisitor;

	@Setter(AccessLevel.NONE)
	protected List<ParserRuleContext> contexts;
	protected ParserRuleContext parent;

	// abstract methods
	@Override
	abstract public ParserRuleContext getContext();

	abstract public ParserRuleContext getContext(String str);

	abstract public void setContext(ParserRuleContext ctx);

	// constructor
	public AbstractBaseExt() {
		extendedContextVisitor = new ExtendedContextVisitor();
		contexts = new ArrayList<>();
	}

	// This method is not exposed outside.
	public VerilogPrimeParser getPrimeParser(String str) {
		VerilogPrimeLexer lexer = new VerilogPrimeLexer(new ANTLRInputStream(str));
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		return new VerilogPrimeParser(tokens);
	}

	protected void addToContexts(ParserRuleContext context) {
		contexts.add(context);
		AbstractBaseExt extCtx = getExtendedContext(context);
		if (extCtx != null) {
			extCtx.contexts = contexts;
			extCtx.parent = parent;
		}
	}

	@Override
	public AbstractBaseExt getExtendedContext(ParseTree context) {
		if (context != null) {
			return extendedContextVisitor.visit(context);
		} else {
			AbstractBaseExt.L.warn("Returning Null for extendedContext");
			return null;
		}
	}

	public void collectModules() {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					getExtendedContext(childCtx).collectModules();
				}
			}
		}
	}

	public void checkConnections(String module_name) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					getExtendedContext(childCtx).checkConnections(module_name);
				}
			}
		}
	}

	public void stitch(String module_name, Map<String, String> addedParameters,
			Map<String, ParserRuleContext> addedLogics, Map<String, Net_declarationContext> addedWires) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					getExtendedContext(childCtx).stitch(module_name, addedParameters, addedLogics, addedWires);
				}
			}
		}
	}
	
	public void stitchOnly(List<String> modueles,String module_name, Map<String, String> addedParameters,
			Map<String, ParserRuleContext> addedLogics, Map<String, Net_declarationContext> addedWires) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					getExtendedContext(childCtx).stitchOnly(modueles,module_name, addedParameters, addedLogics, addedWires);
				}
			}
		}
	}

	public void stitchOnlySlvTop(String module_name, Map<String, String> addedParameters,
			Map<String, ParserRuleContext> addedLogics, Map<String, Net_declarationContext> addedWires) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					getExtendedContext(childCtx).stitchOnlySlvTop(module_name, addedParameters, addedLogics,
							addedWires);
				}
			}
		}
	}

	public void populateParameters(Map<String, String> parameterMap) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					getExtendedContext(childCtx).populateParameters(parameterMap);
				}
			}
		}
	}
	
	public void populateParametersForForgeEvaluation(Map<String, ParserRuleContext> parameterMap) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					getExtendedContext(childCtx).populateParametersForForgeEvaluation(parameterMap);
				}
			}
		}
	}
	
	protected void populateAllParameters(Map<String, String> parameterMap) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					getExtendedContext(childCtx).populateAllParameters(parameterMap);
				}
			}
		}
	}

	public void populatePorts(Map<String, ParserRuleContext> portsMap) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					getExtendedContext(childCtx).populatePorts(portsMap);
				}
			}
		}
	}

	protected void getPorts(List<String> ports) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					getExtendedContext(childCtx).getPorts(ports);
				}
			}
		}
	}

	protected void collectDeclaredParameterConnections(Map<String, Param_expressionContext> parameters) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					getExtendedContext(childCtx).collectDeclaredParameterConnections(parameters);
				}
			}
		}
	}

	protected void collectDeclaredPortConnections(Map<String, ExpressionContext> ports) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					getExtendedContext(childCtx).collectDeclaredPortConnections(ports);
				}
			}
		}
	}

	protected void collectDeclaredPortsParametersWires(List<String> alreadyDeclaredPorts,
			List<String> alreadyDeclaredParameters, List<String> alreadyDeclaredWires) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					getExtendedContext(childCtx).collectDeclaredPortsParametersWires(alreadyDeclaredPorts,
							alreadyDeclaredParameters, alreadyDeclaredWires);
				}
			}
		}
	}

	protected String getVariableName() {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					String out = getExtendedContext(childCtx).getVariableName();
					if (out != null) {
						return out;
					}
				}
			}
		}
		return null;
	}

	protected List<String> getVariables() {
		List<String> ret = new ArrayList<>();
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					List<String> childVariables = getExtendedContext(childCtx).getVariables();
					ret.addAll(childVariables);
				}
			}
		}
		return ret;
	}

	protected Boolean isPortDeclared(String portName) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					Boolean out = getExtendedContext(childCtx).isPortDeclared(portName);
					if (out) {
						return out;
					}
				}
			}
		}
		return false;
	}

	protected Boolean isInput() {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					Boolean out = getExtendedContext(childCtx).isInput();
					if (out) {
						return out;
					}
				}
			}
		}
		return false;
	}

	protected Boolean isOutput() {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					Boolean out = getExtendedContext(childCtx).isOutput();
					if (out) {
						return out;
					}
				}
			}
		}
		return false;
	}

	public String getWrapperString(AbstractBaseExt topExt, Map<String, ParserRuleContext> addedLogics,
			Map<String, Net_declarationContext> addedWires, Map<String, String> addedParameters,
			Map<String, String> table) {
		StringBuilder sb = new StringBuilder();
		Params params = new Params(getContext(), sb);
		params.setBeginingOfAlignemtText(getContext().start.getStartIndex());
		getWrapperString(topExt, addedLogics, addedWires, addedParameters, table, params);
		return sb.toString().trim();
	}

	protected void getWrapperString(AbstractBaseExt topExt, Map<String, ParserRuleContext> addedLogics,
			Map<String, Net_declarationContext> addedWires, Map<String, String> addedParameters,
			Map<String, String> table, Params params) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (childCtx instanceof TerminalNode) {
					printTerminalNodeForWrapperString((TerminalNode) childCtx, params, table);
				} else if (childCtx.getText().length() > 0) {
					params.setContext((ParserRuleContext) childCtx);
					Params thisCtxParams = getExtendedContext(childCtx).getUpdatedParams(params);
					getExtendedContext(childCtx).getWrapperString(topExt, addedLogics, addedWires, addedParameters,
							table, thisCtxParams);
				}
			}
		}
	}

	private void printTerminalNodeForWrapperString(TerminalNode node, Params params, Map<String, String> table) {
		CharStream input = params.getContext().start.getInputStream();
		if (node.getText().equals("<EOF>")) {
			String end = input.getText(new Interval(params.getBeginingOfAlignemtText(), input.size()));
			params.getStringBuilder().append(end);
		} else {
			if (params.getBeginingOfAlignemtText() < node.getSymbol().getStartIndex()) {
				Interval alignmentTextInterval = new Interval(params.getBeginingOfAlignemtText(),
						node.getSymbol().getStartIndex() - 1);
				String alignmentText = input.getText(alignmentTextInterval);
				params.getStringBuilder().append(alignmentText);
			}
			if (table.containsKey(node.getText())) {
				params.getStringBuilder().append(table.get(node.getText()));
			} else {
				params.getStringBuilder().append(node.getText());
			}
			params.setBeginingOfAlignemtText(node.getSymbol().getStopIndex() + 1);
		}
	}

	protected String getAlteredStringForWireDeclaration(String port_name, Map<String, String> table) {
		StringBuilder sb = new StringBuilder();
		Params params = new Params(getContext(), sb);
		params.setBeginingOfAlignemtText(getContext().start.getStartIndex());
		getAlteredStringForWireDeclaration(port_name, table, params);
		return sb.toString().trim();
	}

	protected void getAlteredStringForWireDeclaration(String port_name, Map<String, String> table, Params params) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (childCtx instanceof TerminalNode) {
					printTerminalNodeForWireDeclaration((TerminalNode) childCtx, params, table);
				} else if (childCtx.getText().length() > 0) {
					params.setContext((ParserRuleContext) childCtx);
					Params thisCtxParams = getExtendedContext(childCtx).getUpdatedParams(params);
					getExtendedContext(childCtx).getAlteredStringForWireDeclaration(port_name, table, thisCtxParams);
				}
			}
		}
	}

	private void printTerminalNodeForWireDeclaration(TerminalNode node, Params params, Map<String, String> table) {
		CharStream input = params.getContext().start.getInputStream();
		if (node.getText().equals("<EOF>")) {
			String end = input.getText(new Interval(params.getBeginingOfAlignemtText(), input.size()));
			params.getStringBuilder().append(end);
		} else {
			if (params.getBeginingOfAlignemtText() < node.getSymbol().getStartIndex()) {
				Interval alignmentTextInterval = new Interval(params.getBeginingOfAlignemtText(),
						node.getSymbol().getStartIndex() - 1);
				String alignmentText = input.getText(alignmentTextInterval);
				params.getStringBuilder().append(alignmentText);
			}
			if (table.containsKey(node.getText())) {
				params.getStringBuilder().append(table.get(node.getText()));
			} else {
				params.getStringBuilder().append(node.getText());
			}
			params.setBeginingOfAlignemtText(node.getSymbol().getStopIndex() + 1);
		}
	}

	protected String getInstanceName() {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					String out = getExtendedContext(childCtx).getInstanceName();
					if (out != null) {
						return out;
					}
				}
			}
		}
		return null;
	}

	public String getModuleName() {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					String out = getExtendedContext(childCtx).getModuleName();
					if (out != null) {
						return out;
					}
				}
			}
		}
		return null;
	}

	public List<Module_identifierContext> getModuleInstantiations() {
		List<Module_identifierContext> instantiations = new ArrayList<>();
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					List<Module_identifierContext> inner_instantiations = getExtendedContext(childCtx)
							.getModuleInstantiations();
					instantiations.addAll(inner_instantiations);
				}
			}
		}
		return instantiations;
	}
	
	public void appendRnaxiPorts(List<String> chain){
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode)) {
					getExtendedContext(childCtx).appendRnaxiPorts(chain);
				}
			}
		}
	}
}
