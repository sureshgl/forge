package com.forge.fex.verilogprime.ext;

import java.util.List;
import java.util.Map;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Net_declarationContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Non_port_module_itemContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Non_port_module_itemContextExt extends AbstractBaseExt {

	public Non_port_module_itemContextExt(Non_port_module_itemContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Non_port_module_itemContext getContext() {
		return (Non_port_module_itemContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).non_port_module_item());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Non_port_module_itemContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Non_port_module_itemContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected void collectDeclaredPortsParametersWires(List<String> alreadyDeclaredPorts,
			List<String> alreadyDeclaredParameters, List<String> alreadyDeclaredWires) {
		if (getFormattedText().startsWith("input") || getFormattedText().startsWith("output")) {
			alreadyDeclaredPorts.add(getFormattedText());
		} else if (getFormattedText().startsWith("parameter")) {
			alreadyDeclaredParameters.add(getFormattedText());
		} else if (getFormattedText().startsWith("wire")) {
			alreadyDeclaredWires.add(getFormattedText());
		} else if (getFormattedText().startsWith("localparam")) {
			alreadyDeclaredParameters.add(getFormattedText());
		}
	}

	@Override
	protected void getWrapperString(AbstractBaseExt topExt, Map<String, ParserRuleContext> addedLogics,
			Map<String, Net_declarationContext> addedWires, Map<String, String> addedParameters,
			Map<String, String> table, Params params) {
		Non_port_module_itemContext ctx = getContext();
		if (getFormattedText().startsWith("input") || getFormattedText().startsWith("output")
				|| getFormattedText().startsWith("parameter") || getFormattedText().startsWith("wire")
				|| getFormattedText().startsWith("localparam")) {
			params.setBeginingOfAlignemtText(ctx.stop.getStopIndex() + 1);
		} else {
			super.getWrapperString(topExt, addedLogics, addedWires, addedParameters, table, params);
		}
	}
}