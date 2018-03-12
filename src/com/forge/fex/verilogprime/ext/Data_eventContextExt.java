package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Data_eventContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Data_eventContextExt extends AbstractBaseExt {

	public Data_eventContextExt(Data_eventContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Data_eventContext getContext() {
		return (Data_eventContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).data_event());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Data_eventContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Data_eventContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}