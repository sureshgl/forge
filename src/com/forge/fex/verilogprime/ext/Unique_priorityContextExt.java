package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Unique_priorityContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Unique_priorityContextExt extends AbstractBaseExt {

	public Unique_priorityContextExt(Unique_priorityContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Unique_priorityContext getContext() {
		return (Unique_priorityContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).unique_priority());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Unique_priorityContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Unique_priorityContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}