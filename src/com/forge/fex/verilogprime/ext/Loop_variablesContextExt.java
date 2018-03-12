package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Loop_variablesContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Loop_variablesContextExt extends AbstractBaseExt {

	public Loop_variablesContextExt(Loop_variablesContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Loop_variablesContext getContext() {
		return (Loop_variablesContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).loop_variables());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Loop_variablesContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Loop_variablesContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}