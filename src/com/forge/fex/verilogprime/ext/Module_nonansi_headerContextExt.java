package com.forge.fex.verilogprime.ext;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_nonansi_headerContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Net_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Module_nonansi_headerContextExt extends AbstractBaseExt {

	public Module_nonansi_headerContextExt(Module_nonansi_headerContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Module_nonansi_headerContext getContext() {
		return (Module_nonansi_headerContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).module_nonansi_header());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Module_nonansi_headerContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Module_nonansi_headerContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected Boolean isPortDeclared(String portName) {
		return false;
	}

	@Override
	protected void getWrapperString(AbstractBaseExt topExt, Map<String, ParserRuleContext> addedLogics,
			Map<String, Net_declarationContext> addedWires, Map<String, String> addedParameters,
			Map<String, String> table, Params params) {
		super.getWrapperString(topExt, addedLogics, addedWires, addedParameters, table, params);
		StringBuilder sb = new StringBuilder();
		List<String> alreadyDeclaredPorts = new ArrayList<>();
		List<String> alreadyDeclaredParameters = new ArrayList<>();
		List<String> alreadyDeclaredWires = new ArrayList<>();
		topExt.collectDeclaredPortsParametersWires(alreadyDeclaredPorts, alreadyDeclaredParameters,
				alreadyDeclaredWires);
		sb.append("\n\n");

		for (String str : alreadyDeclaredParameters) {
			sb.append(str + "\n");
		}
		sb.append("\n");
		if (addedParameters.size() > 0) {
			sb.append("//parameters from fex\n");
		}
		for (String key : addedParameters.keySet()) {
			sb.append("\nparameter " + key + " = " + addedParameters.get(key) + ";");
		}
		sb.append("\n\n");

		for (String str : alreadyDeclaredPorts) {
			sb.append(str + "\n");
		}
		sb.append("\n");
		if (addedLogics.size() > 0) {
			sb.append("//ports from fex\n");
		}
		for (String key : addedLogics.keySet()) {
			ParserRuleContext parserRuleContext = addedLogics.get(key);
			sb.append("\n" + getExtendedContext(parserRuleContext).getFormattedText());
		}
		sb.append("\n\n");

		for (String str : alreadyDeclaredWires) {
			sb.append(str + "\n");
		}
		sb.append("\n");
		if (addedWires.size() > 0) {
			sb.append("//wires from fex\n");
		}
		for (String key : addedWires.keySet()) {
			ParserRuleContext parserRuleContext = addedWires.get(key);
			sb.append("\n" + getExtendedContext(parserRuleContext).getFormattedText());
		}
		sb.append("\n\n");
		params.getStringBuilder().append(sb.toString());
	}

}