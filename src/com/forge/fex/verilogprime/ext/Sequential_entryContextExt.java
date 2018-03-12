package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Sequential_entryContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Sequential_entryContextExt extends AbstractBaseExt {

	public Sequential_entryContextExt(Sequential_entryContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Sequential_entryContext getContext() {
		return (Sequential_entryContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).sequential_entry());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Sequential_entryContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Sequential_entryContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}