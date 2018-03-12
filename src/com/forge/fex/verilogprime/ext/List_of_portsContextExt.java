package com.forge.fex.verilogprime.ext;

import java.util.Map;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.misc.Interval;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.List_of_portsContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Net_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class List_of_portsContextExt extends AbstractBaseExt {

	public List_of_portsContextExt(List_of_portsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public List_of_portsContext getContext() {
		return (List_of_portsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).list_of_ports());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof List_of_portsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + List_of_portsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected void getWrapperString(AbstractBaseExt topExt, Map<String, ParserRuleContext> addedLogics,
			Map<String, Net_declarationContext> addedWires, Map<String, String> addedParameters,
			Map<String, String> table, Params params) {
		List_of_portsContext ctx = getContext();
		String text = ctx.extendedContext.getFormattedText();
		String prefix = null;
		if (text.equals("()")) {
			prefix = "";
		} else {
			prefix = ",";
		}
		StringBuilder sb = new StringBuilder();
		for (String name : addedLogics.keySet()) {
			ParserRuleContext parserRuleContext = addedLogics.get(name);
			String var_name = getExtendedContext(parserRuleContext).getVariableName();
			if (var_name != null) {
				sb.append(prefix);
				sb.append(var_name);
			}
			prefix = ",\n";
		}
		// hack
		text = text.replace(")", sb.toString() + ")");

		CharStream input = ctx.start.getInputStream();
		Interval alignmentTextInterval = new Interval(params.getBeginingOfAlignemtText(),
				ctx.start.getStartIndex() - 1);
		String alignmentText = input.getText(alignmentTextInterval);
		params.getStringBuilder().append(alignmentText);
		params.getStringBuilder().append(text);
		params.setBeginingOfAlignemtText(ctx.stop.getStopIndex() + 1);
	}
}